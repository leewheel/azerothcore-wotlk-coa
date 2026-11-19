-- 2026.11.20 patch-WB1 把这两张血帆海图与命令下面的两个木箱换成了西部荒野的桌子，桌面高度是 2.955，
-- 所以把两件物件抬到桌面上。上游 #12829 议题 #6332。// By leewheel 20261120
UPDATE `gameobject` SET `position_z` = 2.9555 WHERE `guid` = 12165 AND `id` = 2086 AND `map` = 0 AND `position_z` > 4;
UPDATE `gameobject` SET `position_z` = 2.9555 WHERE `guid` = 12156 AND `id` = 2087 AND `map` = 0 AND `position_z` > 4;
