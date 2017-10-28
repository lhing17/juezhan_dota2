---
--- Created by Administrator.
--- DateTime: 2017/9/5 0005 22:08
--- 刷怪系统
---

Creature = class({})

function Creature:new(location_entity, creep_name, respawn_time)
    local creature = Creature()
    creature.location_entity = location_entity;
    creature.creep_name = creep_name;
    creature.respawn_time = respawn_time;
    return creature;
end

Attacker = class({})
function Attacker:new(creep_name)
    local attacker = Attacker()
    attacker.creep_name = creep_name;
    return attacker;
end

creatures = {} --野怪表
attackers={} --进攻怪表


udg_boshu = 1
------------------------
--  刷 怪 函 数 （包括进攻怪和野怪）
------------------------
function GameMode:SpawnAttackersAndCreatures()
    self:SpawnAttackers()
    self:SpawnCreatures()
end

------------------------
--  刷 进 攻 怪 函 数
------------------------
function GameMode:SpawnAttackers()
    -- 记录开始刷兵时间
    self.__spawn_start_time = GameRules:GetGameTime()

    -- 记录小兵升级
    self.__creature_levelup = 0

    -- 寻找刷怪点
    self:CollectSpawners()

    -- 使用计时器刷怪
    GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("spawn_attackers"),  -- DoUniqueString用于生成一个本局内唯一的字符串
    function()
        self:Spawn(udg_boshu)
        udg_boshu = udg_boshu + 1
        if udg_boshu <= MAX_WAVE then -- 如果未到最大波数，则每30秒刷一波兵
            return INTERVAL_PER_WAVE
        else
            return nil
        end
    end,
    0)


end
------------------------
--  刷 野 怪 函 数
------------------------
function GameMode:SpawnCreatures()
    for k, v in pairs(creatures) do
--[[
        print(k)
        print(v)

        local entity = Entities:FindByName(nil, 'lang1')
        print(entity)]]
        --刷creatures表中所有的怪
        v.creep = self:DoSpawn(v.location_entity, v.creep_name, DOTA_TEAM_NEUTRALS)
    end
end


------------------------
--  查 找 刷 怪 点 实 体
------------------------
-- 循环在地图上查找刷怪位置实体
function GameMode:CollectSpawners()
    self.__spawners = { }

    local spawner_left_spawn = Entities:FindByName(nil, 'left_spawn')
    local spawner_mid_spawn = Entities:FindByName(nil, 'mid_spawn')
    local spawner_right_spawn = Entities:FindByName(nil, 'right_spawn')

    if spawner_left_spawn then
        self.__spawners["left_spawn"] = spawner_left_spawn
    else
        print("SPAWNER LEFT NOT FOUND!!!!!!!!!!!!!")
    end
    if spawner_mid_spawn then
        self.__spawners["mid_spawn"] = spawner_mid_spawn
    else
        print("SPAWNER MID NOT FOUND!!!!!!!!!!!!!")
    end
    if spawner_right_spawn then
        self.__spawners["right_spawn"] = spawner_right_spawn
    else
        print("SPAWNER RIGHT NOT FOUND!!!!!!!!!!!!!")
    end

end


----------------------------------
--  从 三 个 点 刷 进 攻 怪 函 数
----------------------------------
function GameMode:Spawn(boshu)
    print(boshu, attackers[boshu].creep_name)
    local i = 0
    GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("shua_bing"),
    function()
        -- 确保游戏正在进行中（游戏结束后在面板不再刷怪）
        if GameRules:State_Get() >= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS and i<ATTACKER_AMOUNT_PER_WAVE then
            self:DoSpawn(self.__spawners["left_spawn"], attackers[boshu].creep_name, DOTA_TEAM_BADGUYS)
            self:DoSpawn(self.__spawners["mid_spawn"], attackers[boshu].creep_name, DOTA_TEAM_BADGUYS)
            self:DoSpawn(self.__spawners["right_spawn"], attackers[boshu].creep_name, DOTA_TEAM_BADGUYS)
        end

        -- 如果游戏正在进行中，则每2秒刷一次怪，共刷50次
        if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS and i<ATTACKER_AMOUNT_PER_WAVE then
            i = i + 1
            -- print(i)
            return 2
        else
            CustomGameEventManager:Send_ServerToAllClients("display_timer", {msg="下一波", duration=50, mode=0, endfade=false, position=2, warning=5, paused=false, sound=true} )
            --CustomGameEventManager:Send_ServerToAllClients("pause_timer", {pause=true}
            return nil
        end
    end ,
    0)
end

------------------------
--  执 行 刷 怪 动 作
------------------------
-- [Comment]
-- 刷一个小兵的函数，在其他地方也可以调用
-- spawn_location: 刷怪地点
-- unit_name: 刷怪名称
-- initial_target: 初始目标
-- team: 队伍
-- level: 等级，要升级为几级，就设置为几级
function GameMode:DoSpawn(spawn_location_entity, unit_name, team)
    local creep = CreateUnitByName(unit_name, spawn_location_entity:GetOrigin() + RandomVector(30), true, nil, nil, team)

    creep:SetMustReachEachGoalEntity(true)
    creep:SetInitialGoalEntity(spawn_location_entity)
    creep:AddNewModifier(nil, nil, "modifier_phased", { duration = 0.1 })
    return creep
end