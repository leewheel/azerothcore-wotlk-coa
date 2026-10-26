# mod-coa-challenges

AzerothCore (WotLK) module that reimplements the Conquest of Azeroth
**challenges/trials** system server-side: the client's `C_Challenge` UI is
driven entirely by data already present in the game client patch, while this
module supplies the **authority** (activation gates, auras, lives, rules,
objectives, completions, rewards and the Gamemodes state).

> Status: functional and validated live for activation, death/fail, auras,
> lives, shared fate, hunger/fatigue, rules, activation conditions, criteria
> banners, leaderboard, trial creator and reward delivery. See *Scope* below.

## Requirements

- AzerothCore WotLK, branch `coa-challenge-defs` (or `main`) of the CoA fork.
- **Companion core opcode entries** in `src/server/game/Server/Protocol/Opcodes.h`
  (the "CoA extension range" block) — the module uses custom opcodes.
- The **CoA server component** (opcode pass-through).
- The game client patch that ships the `Challenge*.dbc` files and the challenges
  UI addon (definitions + UI live there, not here).
- For achievements: the client `Achievement.dbc` installed in the server
  `Data/dbc` (custom achievement ids exceed the stock range;
  `Achievement_Criteria.dbc` / `Achievement_Category.dbc` stay stock). Because
  the ids exceed `uint16`, the core `AchievementMgr::LoadFromDB` must read
  `character_achievement.achievement` as `uint32` (the module widens the column;
  see the CoA fork), otherwise completions are dropped on relog.

## Layout

```
mod-coa-challenges.cmake          registers helper headers + unit tests
conf/
  mod-coa-challenges.conf.dist    tunables (see "Configuration")
data/sql/
  db-characters/                  character-side schema (versioned)
  db-world/                       challenge definitions schema (versioned)
src/
  CoA.Challenges.*.cpp / Review.h     implementation, split by area
  CoAChallengeParse.h                 pure parsing/matching (host-testable)
  CoAChallengeInternal.h              GM/test-only declarations
  CoAChallengeTests.cpp               in-game e2e/GM harness
tests/
  CoAChallengeParseTest.cpp           host unit tests (core `unit_tests`)
```

## Installation

1. Place the module at `modules/mod-coa-challenges`.
2. Apply the companion core opcode block (see *Requirements*).
3. Reconfigure and build AzerothCore.
4. Copy/keep `conf/*.conf.dist` as `.conf` and tune as needed.

The character and world tables are created by the versioned SQL under `data/sql/`
(applied automatically by the AzerothCore DB updater). On a dev box without the
updater, set `CoAChallenges.AutoCreateSchema = 1` to create them at runtime.

## Data flow

- **Definitions** (rules, conditions, objectives, auras, lives, rewards) originate
  from an **export of the game client** and are imported into the **world
  database** (`coa_challenge_definition`, `coa_challenge_spell`,
  `coa_challenge_reward`) via the generated SQL
  (`coa-analyze-export.ps1 -EmitSql`). The world DB is the single source of
  truth; the module reads it into a memory cache at startup and on
  `.coa challenges reload`.
- **Rewards** are delivered **by mail** on completion. The client only *displays*
  the reward definition; it never sends a "claim". See the Rewards notes in
  `conf/mod-coa-challenges.conf.dist`.
- The **Challenges Store** tab (Trial Masters / Build Masters) is a separate,
  100% server-side Custom Store system and is **out of scope** for this module.

## Configuration

All options are documented inline in `conf/mod-coa-challenges.conf.dist`,
grouped by area: UI tabs, game modes, lifecycle, rewards, announcements/client
state, grouping, hunger/thirst, fatigue, professions and testing.

Any key omitted from a customized `.conf` falls back to the code default; new
keys are appended automatically on deploy.

## GM / admin commands

```
.coa <trial|challenge> <unlock|check> <id> [player]
.coa e2e <player> <id> [intervalMs]
.coa reward <id> [level] [player]
.coa challenges reload
.coa reset [all] <player>
```

## Multi-language (i18n)

Every string the player can read lives in the world database, the same way
mod-transmog, mod-worldforged-upgrades and mod-coa-mythic-plus do it:

| layer | where | what |
|---|---|---|
| id | `ChallengeStrings` enum in `src/CoA.Challenges.Review.h` | a plain `uint32`, e.g. `STR_RULE_NO_MAIL = 2` |
| English | `module_string` row `('mod-coa-challenges', 2, '...')` | the fallback for every locale |
| translations | `module_string_locale` rows `('mod-coa-challenges', 2, 'zhCN', '...')` | one row per locale |

At runtime `ChatHandler::PSendModuleSysMessage` asks `WorldSession` for the
string, and the session answers with the row for **the player's own client
locale** (`GetSessionDbLocaleIndex`). Helpers in `CoA.Challenges.Review.h`:

* `MLStr(id, locale)` / `MLStrFmt(id, locale, args...)` — one row, `{}`
  placeholders filled in.
* `BroadcastModuleSysMessage(prefix, id, args...)` — realm-wide trial
  announcements (completion / failure). One packet is built **per distinct
  session locale**, because a single pre-built packet would freeze every
  client on the same language; the failure broadcast's killer link carries a
  localized death-cause label, so it assembles its body per locale.

Supported locales (same set as the core): `koKR frFR deDE zhCN zhTW esES
esMX ruRU`, with `enUS` as the base. A missing row logs a `sql.sql` error and
shows the literal `error`, so the SQL migration must be applied.

Two things deliberately do **not** go through this system:

* `ChallengeResponseString` (`CHALLENGE_START_*`) and the trial/sync response
  strings — the client compares them against fixed English text, so
  translating them would break the protocol.
* The in-game E2E harness scaffolding (`CoAChallengeTests.cpp`
  `SendTestLine` / `BroadcastTestLine` bodies) — developer-facing test
  output, kept in English like the module's `LOG_INFO` lines.

### Adding a string

1. Append a new enumerator to `ChallengeStrings` — never reorder, the ids are
   rows in the database.
2. Use it: `ChatHandler(session).PSendModuleSysMessage(MODULE_NAME, id)` or,
   when the text needs arguments, pass the `{}` arguments after the id.
3. Add the rows to `data/sql/db-world/` as a new dated migration, English in
   `module_string` and each translation in `module_string_locale`.

### Death causes and condition messages

Mechanic / environment death causes (Starved, Fell Asleep, Falling, ...) and
the activation-condition messages (group size, inventory slots, professions,
OUTSIDE_INTERACTION facets) are module string ids too: `SetDeathCause` takes
an optional string id next to the literal name, and
`EvaluateConditionsFor` builds its messages in the player's session locale.
Creature and player killer names keep coming from the core locale tables
(`creature_template_locale`).

## Scope / limitations

- GroupRewards (`ChallengeGroupRewards.dbc`) — semantics not confirmed.
- Custom Store (Trial Masters tab) — separate system, not implemented here.
- Some rules/objectives/conditions are still being mapped; the module applies
  the subset described in `conf/mod-coa-challenges.conf.dist`.

## Reducing Adventure Mode difficulty

Players can use `.coa adventure <level>` to lower an active Adventure Mode or Prestige Adventure Mode run.
The level must be between 1 and the current level minus one. The run keeps its start time, deaths and objective
progress; its auras, displayed quest XP and completion rewards switch to the selected lower tier. The normal
challenge-start request also accepts a lower tier for an already-active Adventure Mode run.

Changes are refused while the player, a party member or their controlled units are fighting, during an active
instance encounter, or while the player is dead, flying, charmed or teleporting. Start, stop, group-sync and
custom-trial requests enforce the same restriction. Custom trials cannot be downscaled, and an already-completed
tier cannot be selected. Tier changes cannot raise the difficulty again within the same run.

## License

GNU General Public License v2.0 — see [LICENSE](LICENSE).
