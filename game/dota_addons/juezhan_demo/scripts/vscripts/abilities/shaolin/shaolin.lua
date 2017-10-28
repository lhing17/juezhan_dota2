---
--- Created by Administrator.
--- DateTime: 2017/9/25 0025 19:59
---
-- 达摩剑法
function Damojianfa(t)

    local caster = t.caster
    local ability = t.ability
    local particleName = t.particle
    local point = t.target_points[1]
    local radius = t.radius
    local distance = t.distance
    local speed = t.speed
    local casterOrigin = caster:GetAbsOrigin()
    ability.castPosition = casterOrigin
    local lengthx = point.x - casterOrigin.x
    local lengthy = point.y - casterOrigin.y
    local angle = 0
    if lengthx < 0 then
        angle = math.atan(lengthy / lengthx) + 180 * (3.141 / 180.0)
    else
        angle = math.atan(lengthy / lengthx)
    end
    local targetDirection = {}
    local origin = {}
    for i = 1, 5 do
        uprightAngle = angle - 90 * 3.141 / 180.0
        local x = casterOrigin.x + (600 - 200 * i) * math.cos(uprightAngle)
        local y = casterOrigin.y + (600 - 200 * i) * math.sin(uprightAngle)
        origin[i] = Vector(x, y, 0)
        targetDirection[i] = ( Vector(math.cos(angle) * 900, math.sin(angle) * 900, 0) ):Normalized()
    end
    for i = 1, 5 do
        CreateLinearProjectile( caster, ability, particleName, origin[i], radius, distance, targetDirection[i], speed, false )
    end
--[[    Timers:CreateTimer(0.4, function()
        if RollPercentage(60) == true then
            DoubleMultipleShoot( t )
            ability.damageType = DAMAGE_TYPE_MAGICAL
        end
    end)
    Timers:CreateTimer(function(  )
        if time < duration then
            time = time + interval
            point = caster_location + speed * direction
            caster:SetAbsOrigin(point)
            return interval
        else
            print("time=" .. time)
        end
    end)]]
end

function Damojianfa_damage(keys)

end

