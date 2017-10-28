---
--- Created by Administrator.
--- DateTime: 2017/9/26 0026 21:08
---

-------------------
--化功大法
-------------------
function Huagongdafa(t)
    local caster = t.caster
    local particleName = t.particle
    local radius = 400
    local casterOrigin = caster:GetAbsOrigin()
    local enemies = GetEnemyUnitsInRadius(caster, casterOrigin, radius)
    for k, v in pairs(enemies) do
        local particleId = CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster, 1.5, true)
        ParticleManager:SetParticleControlEnt(particleId, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(particleId, 1, v, PATTACH_POINT_FOLLOW, "attach_hitloc", v:GetAbsOrigin(), true)
        CreateSound("Hero_Lion.ManaDrain", caster, 1.5, nil)
    end
end


