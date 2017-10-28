---
--- Created by Administrator.
--- DateTime: 2017/9/27 0027 21:16
---

function Qishangquan(t)
    local attacker = t.attacker;
    local particleName = t.particle
    local radius = 400
    local totalDamage = 500
    local damageUnits = GetEnemyUnitsInRadius(attacker, attacker:GetAbsOrigin(), radius)
    if (RollPercentage(15)) then
        for k, v in pairs(damageUnits) do
            local damageTable = {
                victim = v,
                attacker = attacker,
                damage = totalDamage,
                damage_type = DAMAGE_TYPE_PURE,
                --[[            damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
                            ability = playerHero:GetAbilityByIndex(0), --Optional.]]
            }
            ApplyDamage(damageTable)
            print(particleName)
            local particleId = CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, v, 1.0)
            print(k .. ", particleId: " .. particleId)
            ParticleManager:SetParticleControl(particleId, 0, Vector(0, 0, 0))
            ParticleManager:SetParticleControl(particleId, 1, Vector(0, 0, 0))
            ParticleManager:SetParticleControl(particleId, 3, Vector(0, 0, 0))
        end
    end
end