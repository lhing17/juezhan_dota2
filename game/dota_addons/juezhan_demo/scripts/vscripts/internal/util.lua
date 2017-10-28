function DebugPrint(...)
  local spew = Convars:GetInt('barebones_spew') or -1
  if spew == -1 and BAREBONES_DEBUG_SPEW then
    spew = 1
  end

  if spew == 1 then
    print(...)
  end
end

function DebugPrintTable(...)
  local spew = Convars:GetInt('barebones_spew') or -1
  if spew == -1 and BAREBONES_DEBUG_SPEW then
    spew = 1
  end

  if spew == 1 then
    PrintTable(...)
  end
end

function PrintTable(t, indent, done)
  --print ( string.format ('PrintTable type %s', type(keys)) )
  if type(t) ~= "table" then return end

  done = done or {}
  done[t] = true
  indent = indent or 0

  local l = {}
  for k, v in pairs(t) do
    table.insert(l, k)
  end

  table.sort(l)
  for k, v in ipairs(l) do
    -- Ignore FDesc
    if v ~= 'FDesc' then
      local value = t[v]

      if type(value) == "table" and not done[value] then
        done [value] = true
        print(string.rep ("\t", indent)..tostring(v)..":")
        PrintTable (value, indent + 2, done)
      elseif type(value) == "userdata" and not done[value] then
        done [value] = true
        print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
        PrintTable ((getmetatable(value) and getmetatable(value).__index) or getmetatable(value), indent + 2, done)
      else
        if t.FDesc and t.FDesc[v] then
          print(string.rep ("\t", indent)..tostring(t.FDesc[v]))
        else
          print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
        end
      end
    end
  end
end

-- Colors
COLOR_NONE = '\x06'
COLOR_GRAY = '\x06'
COLOR_GREY = '\x06'
COLOR_GREEN = '\x0C'
COLOR_DPURPLE = '\x0D'
COLOR_SPINK = '\x0E'
COLOR_DYELLOW = '\x10'
COLOR_PINK = '\x11'
COLOR_RED = '\x12'
COLOR_LGREEN = '\x15'
COLOR_BLUE = '\x16'
COLOR_DGREEN = '\x18'
COLOR_SBLUE = '\x19'
COLOR_PURPLE = '\x1A'
COLOR_ORANGE = '\x1B'
COLOR_LRED = '\x1C'
COLOR_GOLD = '\x1D'


function DebugAllCalls()
    if not GameRules.DebugCalls then
        print("Starting DebugCalls")
        GameRules.DebugCalls = true

        debug.sethook(function(...)
            local info = debug.getinfo(2)
            local src = tostring(info.short_src)
            local name = tostring(info.name)
            if name ~= "__index" then
                print("Call: ".. src .. " -- " .. name .. " -- " .. info.currentline)
            end
        end, "c")
    else
        print("Stopped DebugCalls")
        GameRules.DebugCalls = false
        debug.sethook(nil, "c")
    end
end




--[[Author: Noya
  Date: 09.08.2015.
  Hides all dem hats
]]
function HideWearables( unit )
  unit.hiddenWearables = {} -- Keep every wearable handle in a table to show them later
    local model = unit:FirstMoveChild()
    while model ~= nil do
        if model:GetClassname() == "dota_item_wearable" then
            model:AddEffects(EF_NODRAW) -- Set model hidden
            table.insert(unit.hiddenWearables, model)
        end
        model = model:NextMovePeer()
    end
end

function ShowWearables( unit )

  for i,v in pairs(unit.hiddenWearables) do
    v:RemoveEffects(EF_NODRAW)
  end
end

--[[
	CauseDamage                         attacker,victim,damage,damageType,ability,criticalChance,criticalDamage
	Heal                                caster,heal,mana,show
	PropertySystem
	AddModifierStackCount
	CreateParticle
	CreateNumberEffect
	CreateTrackingProjectile
	CreateLinearProjectile
	CreateSound
	GetUnitsInRadius
	GetUnitsInLine
	GetUnitsInSector
	GetRandomPoint
	GetRotationPoint
	DropItem
	RollDrops
	IsFullSolt
	ItemTypeCheck
	KnockBack
	SetCamera
	SetRegionLimit
	PrintTable
	string.split
]]
-- 造成伤害
-- 填写ability会判定为技能伤害
-- 暴击率以百分比计算
function CauseDamage( ... )
    local attacker,victim,damage,damageType,ability,criticalChance,criticalDamage = ...
    if attacker:IsNull() or victim:IsAlive() == false then
        return
    end
    if criticalChance then
        if RollPercentage(criticalChance) then
            damage = damage * criticalDamage * 0.01
            CreateNumberEffect(victim,damage,1,MSG_ORIT ,"red",4)
        end
    end
    local damageTable = {victim = victim,attacker = attacker,damage = damage,damage_type = damageType,ability = ability}
    ApplyDamage(damageTable)
end
-- 恢复生命与魔法
function Heal( ... )
    local caster,heal,mana,show = ...
    if show == nil then
        show = true
    end
    if caster:IsAlive()~=true then
        return nil
    end
    if heal and heal ~= 0 then
        if show then
            CreateNumberEffect(caster,heal,1,MSG_HEAL,'green',0)
        end
        caster:Heal(heal, nil)
    end
    if mana and mana ~=0 then
        if show then
            CreateNumberEffect(caster,mana,1,MSG_HEAL,{0,128,255},0)
        end
        caster:GiveMana(mana)
    end
end
-- 基础属性值系统
function PropertySystem( ... )
    local caster,property,count,duration = ...
    if property == 0 then
        caster:ModifyStrength(count)
    elseif property == 1 then
        caster:ModifyAgility(count)
    elseif property == 2 then
        caster:ModifyIntellect(count)
    elseif property == 3 then
        caster:ModifyStrength(count)
        caster:ModifyAgility(count)
        caster:ModifyIntellect(count)
    end
    if duration then
        Timers:CreateTimer(duration,function ()
            if property == 0 then
                caster:ModifyStrength(-count)
            elseif property == 1 then
                caster:ModifyAgility(-count)
            elseif property == 2 then
                caster:ModifyIntellect(-count)
            elseif property == 3 then
                caster:ModifyStrength(-count)
                caster:ModifyAgility(-count)
                caster:ModifyIntellect(-count)
            end
        end)
    end
end
-- 增加modifier叠加数量
function AddModifierStackCount( ... )
    local caster,target,ability,modiferName,count,duration,independent = ...
    if not target:IsAlive() or target:IsMagicImmune() then
        return
    end
    local durationTable = {Duration=duration}
    if duration == nil then
        durationTable = {}
    end
    if count == nil then
        count = 1
    end
    if independent then
        if target:HasModifier(modiferName) then
            local stackcount = target:GetModifierStackCount(modiferName, caster)
            ability:ApplyDataDrivenModifier(caster, target, modiferName, {})
            target:SetModifierStackCount(modiferName, caster, stackcount + count)
        else
            ability:ApplyDataDrivenModifier(caster, target, modiferName, {})
            target:SetModifierStackCount(modiferName, caster, count)
        end
        Timers:CreateTimer(duration,function ()
            if not target:IsNull() then
                local stackcount = target:GetModifierStackCount(modiferName, ability)
                if count >= stackcount then
                    target:RemoveModifierByName(modiferName)
                else
                    target:SetModifierStackCount(modiferName, caster, stackcount - count)
                end
            end
        end)
    else
        if target:HasModifier(modiferName) then
            local stackcount = target:GetModifierStackCount(modiferName, caster)
            ability:ApplyDataDrivenModifier(caster, target, modiferName, durationTable)
            target:SetModifierStackCount(modiferName, caster, stackcount + count)
        else
            ability:ApplyDataDrivenModifier(caster, target, modiferName, durationTable)
            target:SetModifierStackCount(modiferName, caster, count)
        end
    end
end
--创建带有计时器的特效，计时器结束删除特效
function CreateParticle(...)
    local particleName,particleAttach,owningEntity,duration,immediately = ...
    if immediately == nil then
        immediately = false
    end
    local pID = ParticleManager:CreateParticle(particleName,particleAttach,owningEntity)
    if duration then
        Timers:CreateTimer(duration,function ()
            ParticleManager:DestroyParticle(pID,immediately)
            ParticleManager:ReleaseParticleIndex(pID)
        end)
    end
    return pID
end
-- 创建跟踪投射物
function CreateTrackingProjectile( ... )
    local caster,target,ability,particleName,speed,dodgeable,vision,visionRadius,attach = ...
    if dodgeable == nil then
        dodgeable = true
    end
    if vision == nil then
        vision = false
    end
    if visionRadius == nil then
        visionRadius = 0
    end
    if attach == nil then
        attach = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
    end
    local info = {
        Target = target,
        Source = caster,
        Ability = ability,
        EffectName = particleName,
        bDodgeable = dodgeable,
        bProvidesVision = vision,
        iMoveSpeed = speed,
        iVisionRadius = visionRadius,
        iVisionTeamNumber = caster:GetTeamNumber(),
        iSourceAttachment = attach
    }
    if target:IsAlive() then
        ProjectileManager:CreateTrackingProjectile( info )
    end
end
-- 创建跟踪投射物
function CreateLinearProjectile( ... )
    local caster,ability,particleName,spawnOrigin,radius,distance,direction,speed,deleteOnHit = ...
    local projID = ProjectileManager:CreateLinearProjectile( {
        Ability             = ability,
        EffectName          = particleName,
        vSpawnOrigin        = spawnOrigin,
        fDistance           = distance,
        fStartRadius        = radius,
        fEndRadius          = radius,
        Source              = caster,
        iUnitTargetTeam     = ability:GetAbilityTargetTeam(),
        iUnitTargetFlags    = ability:GetAbilityTargetFlags(),
        iUnitTargetType     = ability:GetAbilityTargetType(),
        fExpireTime         = GameRules:GetGameTime() + distance / speed,
        bDeleteOnHit        = deleteOnHit,
        vVelocity           = direction * speed,
        bProvidesVision     = false,
    } )
    return projID
end
-- 寻找圆形范围单位
function GetUnitsInRadius( ... )
    local caster,ability,point,radius = ...
    local teamNumber = caster:GetTeamNumber()
    local targetTeam = ability:GetAbilityTargetTeam()
    local targetType = ability:GetAbilityTargetType()
    local targetFlag = ability:GetAbilityTargetFlags()
    local unitGroup = FindUnitsInRadius(teamNumber, point, caster, radius, targetTeam, targetType, targetFlag, 0, false)
    return unitGroup
end
function GetEnemyUnitsInRadius( ... )
    local caster, point,radius = ...
    local teamNumber = caster:GetTeamNumber()
    local targetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
    local targetType = DOTA_UNIT_TARGET_ALL
    local targetFlag = DOTA_UNIT_TARGET_FLAG_NONE
    local unitGroup = FindUnitsInRadius(teamNumber, point, caster, radius, targetTeam, targetType, targetFlag, 0, false)
    return unitGroup
end


-- 创建物品给单位
function GiveItem( ... )
    local caster,itemName,itemOwner = ...
    if itemOwner == nil then
        itemOwner = caster
    end
    if IsFullSolt( caster, 12, true ) == false then
        local newItem = CreateItem(itemName, itemOwner, itemOwner)
        caster:AddItem(newItem)
        return newItem
    else
        return false
    end
end
-- 寻找直线范围单位
function GetUnitsInLine( ... )
    local caster,ability,start_point,end_point,width = ...
    local teamNumber = caster:GetTeamNumber()
    local targetTeam = ability:GetAbilityTargetTeam()
    local targetType = ability:GetAbilityTargetType()
    local targetFlag = ability:GetAbilityTargetFlags()
    local unitGroup = FindUnitsInLine( teamNumber, start_point, end_point, caster, width, targetTeam, targetType, targetFlag)
    return unitGroup
end
-- 寻找扇形单位
function GetUnitsInSector( ... )
    local cacheUnit,ability,position,forwardVector,angle,radius = ...
    local teamNumber = cacheUnit:GetTeamNumber()
    local teamFilter = ability:GetAbilityTargetTeam()
    local typeFilter = ability:GetAbilityTargetType()
    local flagFilter = ability:GetAbilityTargetFlags()
    local unitGroup = FindUnitsInRadius( teamNumber, position, cacheUnit, radius, teamFilter, typeFilter, flagFilter, 0, false )
    local returnGroup = {}
    for k, v in pairs( unitGroup ) do
        local unitPosition = v:GetAbsOrigin()
        local unitVector = unitPosition - position
        local nan = math.floor(unitVector:Dot(forwardVector) / math.sqrt((unitVector.x ^ 2 + unitVector.y ^ 2) * (forwardVector.x ^ 2 + forwardVector.y ^ 2)))
        --print("nan:"..nan)
        if nan == 1 then
            table.insert( returnGroup, v )
            --print("nan")
        else
            local unitAngle = math.abs(math.deg(math.acos( unitVector:Dot(forwardVector) / math.sqrt((unitVector.x ^ 2 + unitVector.y ^ 2) * (forwardVector.x ^ 2 + forwardVector.y ^ 2)))))
            --print("angle:"..unitAngle)
            --print("dot:"..unitVector:Dot(forwardVector))
            --print("acos"..( unitVector:Dot(forwardVector) / math.sqrt((unitVector.x ^ 2 + unitVector.y ^ 2) * (forwardVector.x ^ 2 + forwardVector.y ^ 2))))
            local deleteAngle = angle * 0.5
            if unitAngle < deleteAngle then
                table.insert( returnGroup, v )
                --print("units:"..#returnGroup)
            end
        end
    end
    return returnGroup
end
-- 丢弃物品
function DropItem( item, hero )
    -- Error Sound
    EmitSoundOnClient("General.CastFail_InvalidTarget_Hero", hero:GetPlayerOwner())
    -- Create a new empty item
    local newItem = CreateItem( item:GetName(), nil, nil )
    newItem:SetPurchaseTime(item:GetPurchaseTime())
    newItem:SetCurrentCharges( item:GetCurrentCharges() )
    -- Make a new item and launch it near the hero
    local spawnPoint = Vector( 0, 0, 0 )
    spawnPoint = hero:GetAbsOrigin()
    local drop = CreateItemOnPositionSync( spawnPoint, newItem )
    newItem:LaunchLoot( false, 200, 0.75, spawnPoint + RandomVector( RandomFloat( 50, 150 ) ) )
    --finally, remove the item
    hero:RemoveItem(item)
    return newItem
end
-- 随机掉落物品
function RollDrops(unit)
    local DropInfo = GameRules.DropTable[unit:GetUnitName()]
    if DropInfo then
        --print("Rolling Drops for "..unit:GetUnitName())
        for k,ItemTable in pairs(DropInfo) do
            local item_name
            if ItemTable.ItemSets then
                local count = 0
                for i,v in pairs(ItemTable.ItemSets) do
                    count = count+1
                end
                local random_i = RandomInt(1,count)
                item_name = ItemTable.ItemSets[tostring(random_i)]
            else
                item_name = ItemTable.Item
            end
            local chance = ItemTable.Chance or 100
            -- 修改宝石掉率
            if string.find(item_name, "baoshi") then
                local Players = PlayerResource:GetPlayerCountForTeam( DOTA_TEAM_GOODGUYS )
                chance = chance + Players * 15
            end
            local max_drops = ItemTable.Multiple or 1
            for i=1,max_drops do
                if RollPercentage(chance) then
                    local item = CreateItem(item_name, nil, nil)
                    item:SetPurchaseTime(GameRules:GetGameTime())
                    local pos = unit:GetAbsOrigin()
                    local drop = CreateItemOnPositionSync( pos, item )
                    local pos_launch = pos+RandomVector(RandomFloat(0,50))
                    item:LaunchLoot(false, 200, 0.75, pos_launch)
                end
            end
        end
    end
end
-- 创建音效
function CreateSound( ... )
    local soundName,caster,location,duration,delay = ...
    if location then
        if type(location) == "userdata" then
            if delay == nil then
                delay = 0
            end
            Timers:CreateTimer(delay,function (  )
                EmitSoundOnLocationWithCaster(location,soundName,caster)
            end)
        elseif type(location) == "number" then
            delay = duration or 0
            duration = location
            Timers:CreateTimer(delay,function (  )
                EmitSoundOn(soundName,caster)
            end)
        end
    else
        EmitSoundOn(soundName,caster)
    end
    if duration then
        Timers:CreateTimer(duration,function (  )
            StopSoundOn(soundName,caster)
        end)
    end
end
-- 选取范围内随机点
function GetRandomPoint( ... )
    local originPoint, minRadius, maxRadius = ...
    local minDistance = minRadius
    local maxDistance = maxRadius
    local castDistance = RandomInt( minDistance, maxDistance )
    local angle = RandomInt( 0, 90 )
    local dy = castDistance * math.sin( angle )
    local dx = castDistance * math.cos( angle )
    local attackPoint = Vector( 0, 0, 0 )
    attackPoint = Vector( originPoint.x - dx, originPoint.y + dy, originPoint.z )
    return attackPoint
end
-- 获取旋转后的点
function GetRotationPoint( ... )
    local originPoint, radius, angle = ...
    local radAngle = math.rad(angle)
    local x = math.cos(radAngle) * radius + originPoint.x
    local y = math.sin(radAngle) * radius + originPoint.y
    local position = Vector(x, y, originPoint.z)
    return position
end
function SetRegionLimit( ... )
    local caster,regionEntity = ...
    local regionPos = regionEntity:GetAbsOrigin()
    local boundingMax = regionEntity:GetBoundingMaxs()
    local boundingMin = regionEntity:GetBoundingMins()
    local width = boundingMax.x - boundingMin.x
    local height = boundingMax.y - boundingMin.y
    local limitRegion = {}
    limitRegion.Top = regionPos.y + height / 2
    limitRegion.bottom = regionPos.y - height / 2
    limitRegion.left = regionPos.x - width / 2
    limitRegion.right = regionPos.x + width / 2
    caster.limitRegion = limitRegion
end
function SetUnitPosition( ... )
    local caster,position,setPos = ...
    if caster.limitRegion then
        local limitRegion = caster.limitRegion
        if position.x > limitRegion.right then
            position.x = limitRegion.right
        elseif position.x < limitRegion.left then
            position.x = limitRegion.left
        end
        if position.y > limitRegion.Top then
            position.y = limitRegion.Top
        elseif position.y < limitRegion.bottom then
            position.y = limitRegion.bottom
        end
    end
    if setPos then
        caster:SetAbsOrigin(position)
    else
        FindClearSpaceForUnit(caster, position, false)
    end
end
-- 打印表
--[[function PrintTable( keys )
    print("----------------------------------")
    for k, v in pairs( keys ) do
        print( k, v )
    end
    print("----------------------------------")
end]]
-- 满格
function IsFullSolt( ... )
    local caster,bagType,tip = ...
    if bagType == nil then
        bagType = 6
    end
    local itemCount = 0
    for i=1,bagType do
        local itemSolt = caster:GetItemInSlot(i-1)
        if itemSolt then
            itemCount = itemCount + 1
        end
    end
    if itemCount == bagType then
        if tip then
            local unit = caster
            if not unit:IsRealHero() then
                unit = caster.currentHero
            end
            local playerid = unit:GetPlayerOwnerID()
            Notifications:Bottom(playerid, {text="物品栏已满", style={color="red"}, duration=1, continue = false})
            EmitSoundOnClient("General.CastFail_InvalidTarget_Hero", unit:GetPlayerOwner())
        end
        return true
    else
        return false
    end
end
-- 同类装备检查
function ItemTypeCheck( ... )
    local caster,item = ...
    local currentItemInfo = GameRules.ItemInfoKV[item:GetAbilityName()]
    local currentItemType = "currentItemType"
    for i=0,11 do
        local bagItem = caster:GetItemInSlot(i)
        if bagItem then
            local bagItemInfo = GameRules.ItemInfoKV[bagItem:GetAbilityName()]
            local bagItemType = "bagItemType"
            if bagItemInfo then
                bagItemType = bagItemInfo.itemType
            end
            if currentItemType == bagItemType then
                DropItem(item, caster)
                Notifications:Bottom(caster:GetPlayerID(), {text="你已经拥有一个同类装备", style={color="red"}, duration=2, continue = false})
                return true
            end
        end
    end
    return false
end
-- 设置镜头位置
function SetCamera( ... )
    local playerID,arg = ...
    if type(arg) == "table" then
        PlayerResource:SetCameraTarget(playerID, arg)
    elseif type(arg) == "userdata" then
        PrecacheUnitByNameAsync("majia",function()
            local target = CreateUnitByName("majia", arg, true, nil, nil, DOTA_TEAM_BADGUYS )
            PlayerResource:SetCameraTarget(playerID, target)
            target:ForceKill(false)
        end)
    end
    Timers:CreateTimer(0.1,function()
        PlayerResource:SetCameraTarget(playerID, nil)
    end)
end
-- 简易击退
function KnockBack( ... )
    local caster,direction,distance,duration = ...
    local caster_location = caster:GetAbsOrigin()
    local interval = 0.02
    local time = 0
    local point
    local speed = distance / duration * interval
    caster:AddNewModifier(nil, nil, "modifier_phased", {duration=duration})
    caster:AddNewModifier(nil, nil, "modifier_stunned", {duration=duration})
    Timers:CreateTimer(function (  )
        if time < duration then
            time = time + interval
            point = caster_location + speed * direction
            caster:SetAbsOrigin(point)
            return interval
        else
            print("time="..time)
        end
    end)
end
--颜色
local __msg_type = {}
local __color = {
    red 	={255,0,0},
    orange	={255,127,0},
    yellow	={255,255,0},
    green 	={0,255,0},
    blue 	={0,0,255},
    indigo 	={0,255,255},
    purple 	={255,0,255},
}

--定义常量
MSG_BLOCK 		= "particles/msg_fx/msg_block.vpcf"
MSG_ORIT 		= "particles/msg_fx/msg_crit.vpcf"
MSG_DAMAGE 		= "particles/msg_fx/msg_damage.vpcf"
MSG_EVADE 		= "particles/msg_fx/msg_evade.vpcf"
MSG_GOLD 		= "particles/msg_fx/msg_gold.vpcf"
MSG_HEAL 		= "particles/msg_fx/msg_heal.vpcf"
MSG_MANA_ADD 	= "particles/msg_fx/msg_mana_add.vpcf"
MSG_MANA_LOSS 	= "particles/msg_fx/msg_mana_loss.vpcf"
MSG_MISS 		= "particles/msg_fx/msg_miss.vpcf"
MSG_POISION 	= "particles/msg_fx/msg_poison.vpcf"
MSG_SPELL 		= "particles/msg_fx/msg_spell.vpcf"
MSG_XP 			= "particles/msg_fx/msg_xp.vpcf"

table.insert(__msg_type,MSG_BLOCK)
table.insert(__msg_type,MSG_ORIT)
table.insert(__msg_type,MSG_DAMAGE)
table.insert(__msg_type,MSG_EVADE)
table.insert(__msg_type,MSG_GOLD)
table.insert(__msg_type,MSG_HEAL)
table.insert(__msg_type,MSG_MANA_ADD)
table.insert(__msg_type,MSG_MANA_LOSS)
table.insert(__msg_type,MSG_MISS)
table.insert(__msg_type,MSG_POISION)
table.insert(__msg_type,MSG_SPELL)
table.insert(__msg_type,MSG_XP)

--显示数字特效，可指定颜色，符号
function CreateNumberEffect( ... )
    local entity,number,duration,msg_type,color,icon_type = ...
    --判断实体
    if entity:IsAlive()==nil then
        return
    end
    icon_type = icon_type or 9

    --对采用的特效进行判断
    local is_msg_type = false
    for k,v in pairs(__msg_type) do
        if msg_type == v then
            is_msg_type = true;
            break;
        end
    end

    --判断颜色
    if type(color)=="string" then
        color = __color[color] or {255,255,255}
    else
        if #color ~=3 then
        end
    end
    local color_r = tonumber(color[1]) or 255;
    local color_g = tonumber(color[2]) or 255;
    local color_b = tonumber(color[3]) or 255;
    local color_vec = Vector(color_r,color_g,color_b);

    --处理数字
    number = math.floor(number)
    local number_count = #tostring(number) + 1

    --创建特效
    local particle = CreateParticle(msg_type,PATTACH_CUSTOMORIGIN_FOLLOW,entity,duration)
    ParticleManager:SetParticleControlEnt(particle,0,entity,5,"attach_hitloc",entity:GetOrigin(),true)
    ParticleManager:SetParticleControl(particle,1,Vector(10,number,icon_type))
    ParticleManager:SetParticleControl(particle,2,Vector(duration,number_count,0))
    ParticleManager:SetParticleControl(particle,3,color_vec)
end
function string.split(input, delimiter)
    input = tostring(input)
    delimiter = tostring(delimiter)
    if (delimiter=='') then return false end
    local pos,arr = 0, {}
    -- for each divider found
    for st,sp in function() return string.find(input, delimiter, pos, true) end do
        table.insert(arr, string.sub(input, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(input, pos))
    return arr
end

------------------------
-- 英 雄 学 习 技 能
------------------------
function HeroLearnSkill(...)
    local hero, abilityName, abilityLevel = ...
    for i = 1, 12 do
        local emptyAbilityName = "barebones_empty" .. i
        local ability = hero:FindAbilityByName(emptyAbilityName)
        if ability then
            new_ability = hero:AddAbility(abilityName)
            abilityLevel = abilityLevel or 1
            new_ability:SetLevel(abilityLevel)
            hero:SwapAbilities(ability:GetAbilityName(), new_ability:GetAbilityName(), false, true)
            hero:RemoveAbility(emptyAbilityName)
            break
        end
    end
end