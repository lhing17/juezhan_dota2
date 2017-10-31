---
--- Created by Administrator.
--- DateTime: 2017/10/30 0030 21:33
---


--------------------------
-- 富可敌国令:增加金钱获得率
--------------------------
function FuKeDiGuo(keys)
    PrintTable(keys)
    local caster = keys.caster
    caster.gold_rate = caster.gold_rate + 20
end
