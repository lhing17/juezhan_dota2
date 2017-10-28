---
--- Created by Administrator.
--- DateTime: 2017/9/2 0002 8:11
---

modifier_shaolin_weituogunfa = class({})

function modifier_shaolin_weituogunfa:OnCreated(keys)
--[[    for k, v in pairs(keys) do
        Msg(k .. "=" .. v)
    end
    print(keys)]]
end


function modifier_shaolin_weituogunfa:DeclareFunctions()
    Msg("success")
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK,
    }
    return funcs
end

function modifier_shaolin_weituogunfa:IsHidden()
    return true
end

-- 韦陀棍法攻击事件
function modifier_shaolin_weituogunfa:OnAttack(params)
    local attacker = params.attacker;
    if (attacker == self:GetParent()) then
        local damageUnits = GetEnemyUnitsInRadius(attacker, attacker:GetAbsOrigin(), 500)
        if (RollPercentage(15)) then
            for k, v in pairs(damageUnits) do
                local damageTable = {
                    victim = v,
                    attacker = attacker,
                    damage = 500,
                    damage_type = DAMAGE_TYPE_PURE,
                    --[[            damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
                                ability = playerHero:GetAbilityByIndex(0), --Optional.]]
                }
                ApplyDamage(damageTable)
                CreateParticle("particles/units/heroes/hero_queenofpain/queen_scream_of_pain_owner.vpcf", PATTACH_ABSORIGIN_FOLLOW, v, 1.0)
            end
        end
    end
--[[
    for k, v in pairs(params) do
        print("key:" .. k)
        print("value:" .. v)
    end
    Msg("I'm attacking");]]
end