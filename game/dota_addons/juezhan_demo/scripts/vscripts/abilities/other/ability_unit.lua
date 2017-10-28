---
--- Created by Administrator.
--- DateTime: 2017/10/21 0021 19:35
---

-- 在NPC头上添加惊叹号
function AddExclamationOverHead( t )
    local caster = t.caster
    Timers:CreateTimer(10,function ()
        local p1 = CreateParticle("particles/map/quest.vpcf",PATTACH_OVERHEAD_FOLLOW,caster)
        ParticleManager:SetParticleControlEnt(p1, 0, caster, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
    end)
end