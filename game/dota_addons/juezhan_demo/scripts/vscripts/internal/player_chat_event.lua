---
--- Created by lhing17.
--- DateTime: 2017/8/16 21:19
---


-- This function is called whenever any player sends a chat message to team or All
function GameMode:OnPlayerChat(keys)
    --local teamonly = keys.teamonly
    --local userID = keys.userid
    --local playerID = self.vUserIds[userID]:GetPlayerID()
    --local text = keys.text
    --print("[GuardingAthena] On Player Chat")
    --DeepPrintTable(keys)
    --teamonly ( bool ): true if team only chat
    --userid( short ): chatting player
    --text( string ): chat text
    local playerid = keys.userid - 1
    local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
    local text = keys.text
    Cheats = {
        "-lvlup",
        "-levelbots",
        "-gold",
        "-item",
        "-givebots",
        "-refresh",
        "-respawn",
        "-startgame",
        "-spawncreeps",
        "-spawnneutrals",
        "-disablecreepspawn",
        "-enablecreepspawn",
        "-spawnrune",
        "-killwards",
        "-createhero",
        "-dumpbots",
        "-wtf",
        "-unwtf",
        "-allvision",
        "-normalvision",
    }
    for k, cheat in pairs(Cheats) do
        if string.match(text, cheat) then
            self.is_cheat = true
        end
    end
    if text == "hg" then
        local basePoint = Vector(5618,-3727,128)
        SetUnitPosition(hero, basePoint)
        PlayerResource:SetCameraTarget(playerid, hero) --锁定并移动镜头
        GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("camera_later"), function() PlayerResource:SetCameraTarget(playerid, nil)  end, 1)--1秒后解锁
    end
    if text == "fb1" then
        local basePoint = Vector(-10745, 7563, 165)
        SetUnitPosition(hero, basePoint)
        PlayerResource:SetCameraTarget(playerid, hero) --锁定并移动镜头
        GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("camera_later"), function() PlayerResource:SetCameraTarget(playerid, nil)  end, 1)--1秒后解锁
    end

    --[[    --设置波数
        if string.sub(text,0,6) == "waveto" then
            local wave = tonumber(string.sub(text,7,string.len(text)))
            if wave >= 0 then
                Spawner.gameRound = wave - 1
            end
        end
        if string.sub(text,0,5) == "troll" then
            local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
            PrecacheUnitByNameAsync(text,function()
                local nature = CreateUnitByName(text, hero:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS )
            end)
        end
        if text == "point" then
            local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
            hero.def_point = 10000
        end
        if text == "printtbl" then
            printtbl()
        end
        if text == "getlocation" then
            print(tostring(PlayerResource:GetPlayer(playerid):GetAssignedHero():GetAbsOrigin()))
        end
        if text == "getdisobb" then
            local dis = CalcDistanceBetweenEntityOBB(PlayerResource:GetPlayer(playerid):GetAssignedHero(), Entities:FindByName(nil, "boss_sandking_reborn"))
            print(dis)
        end
        if text == "getscore" then
            updateScore(function()
                print("haha")
                print(getPlayerScore(0))
            end)
        end
        if text == "givescore" then
            if self.is_cheat == false then
                giveScore()
            end
        end
        if text == "allring" then
            local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
            hero:AddNewModifier(hero, nil, "ring_0_1", nil)
            hero:AddNewModifier(hero, nil, "ring_0_2", nil)
            hero:AddNewModifier(hero, nil, "ring_0_3", nil)
            hero:AddNewModifier(hero, nil, "ring_0_4", nil)
            hero:AddNewModifier(hero, nil, "ring_0_5", nil)
            hero:AddNewModifier(hero, nil, "ring_0_6", nil)
            hero:AddNewModifier(hero, nil, "ring_1_2", nil)
            hero:AddNewModifier(hero, nil, "ring_1_3", nil)
            hero:AddNewModifier(hero, nil, "ring_1_4", nil)
            hero:AddNewModifier(hero, nil, "ring_1_5", nil)
            hero:AddNewModifier(hero, nil, "ring_1_6", nil)
            hero:AddNewModifier(hero, nil, "ring_2_3", nil)
            hero:AddNewModifier(hero, nil, "ring_2_4", nil)
            hero:AddNewModifier(hero, nil, "ring_2_5", nil)
            hero:AddNewModifier(hero, nil, "ring_2_6", nil)
            hero:AddNewModifier(hero, nil, "ring_3_4", nil)
            hero:AddNewModifier(hero, nil, "ring_3_5", nil)
            hero:AddNewModifier(hero, nil, "ring_3_6", nil)
            hero:AddNewModifier(hero, nil, "ring_4_5", nil)
            hero:AddNewModifier(hero, nil, "ring_4_6", nil)
            hero:AddNewModifier(hero, nil, "ring_5_6", nil)
        end
        --测试模式
        if text == "test" then
            PlayerResource:SetGold( playerid, 999999, false )
            self.player_gold_save[playerid + 1] = 99999999
            local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
            for i=1,99 do
                hero:HeroLevelUp(false)
            end
            hero:SetAbilityPoints(0)
            local skill_1 = hero:GetAbilityByIndex(1)
            local skill_2 = hero:GetAbilityByIndex(2)
            local skill_3 = hero:GetAbilityByIndex(3)
            local skill_4 = hero:GetAbilityByIndex(4)
            skill_1:SetLevel(20)
            skill_2:SetLevel(20)
            skill_3:SetLevel(20)
            skill_4:SetLevel(8)
            hero:AddItem(CreateItem("item_ring_world_3_6", hero, hero))
            hero:AddItem(CreateItem("item_dun_5", hero, hero))
            hero:AddItem(CreateItem("item_jian_9", hero, hero))
            hero:AddItem(CreateItem("item_npc_dota_hero_omniknight1", hero, hero))
        end
        if string.sub(text,0,9) == "autospawn" then
            local location = PlayerResource:GetPlayer(playerid):GetAssignedHero():GetAbsOrigin()
            local name = string.sub(text,10,string.len(text))
            self.timer = Timers:CreateTimer(function (  )
                PrecacheUnitByNameAsync(name,function()
                    local nature = CreateUnitByName(name, location, true, nil, nil, DOTA_TEAM_BADGUYS )
                end)
                return 1
            end)
        end
        if string.sub(text,0,5) == "spawn" then
            local location = PlayerResource:GetPlayer(playerid):GetAssignedHero():GetAbsOrigin()
            local name = string.sub(text,6,string.len(text))
            PrecacheUnitByNameAsync(name,function()
                local nature = CreateUnitByName(name, location, true, nil, nil, DOTA_TEAM_BADGUYS )
                nature:AddNewModifier(nature, nil, "modifier_kill", {duration=60})
                if name == "testunit" then
                    self.testunit = nature
                end
            end)
        end]]
    if string.sub(text, 0, 8) == "addskill" then
        local unit = self.testunit
        unit:AddAbility(string.sub(text, 9, string.len(text)))
    end
    if string.sub(text, 0, 10) == "addability" then
        local abilityName = string.sub(text, 11, string.len(text))
        hero:AddAbility(abilityName)
        hero:FindAbilityByName(abilityName):SetLevel(1)
    end
    --[[if text == "endautospawn" then
        Timers:RemoveTimer(self.timer)
    end
    if text == "pause" then
        Spawner:PauseSpawn(30)
    end]]
    if text == "testmode" then
        --GameRules:SetGameWinner( DOTA_TEAM_BADGUYS )
        --local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
        --HeroState:SendFinallyData()
        CustomUI:DynamicHud_Create(-1, "HeroSelectionBackground", "file://{resources}/layout/custom_game/pick_hero.xml", nil)
        --self.testmode = true
    end
    if text == "testskill" then
        local ability = hero:FindAbilityByName("barebones_empty1")
        if ability then
            new_ability = hero:AddAbility("example_ability")
            new_ability:SetLevel(1)
            hero:SwapAbilities(ability:GetAbilityName(), new_ability:GetAbilityName(), false, true)
            hero:RemoveAbility("barebones_empty1")
        end
    end
    --[[   --取消测试
       if text == "untest" then
           SPAWN_COUNT = 20
           SPAWN_INTERVAL = 120
       end
       if text == "getabsorigin" then
           local heroabs = PlayerResource:GetPlayer(playerid):GetAssignedHero():GetAbsOrigin()
           local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero():GetOrigin()
           print(tostring(heroabs))
           print(tostring(hero))
       end
       --设置攻击穿透
       if string.sub(text,0,10) == "-setdamage" then
           local attack = tonumber(string.sub(text,11,string.len(text)))
           local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
           hero.bonus_physical_damage = hero.bonus_physical_damage + attack
       end
       --设置攻击力
       if string.sub(text,0,10) == "-setattack" then
           local attack = tonumber(string.sub(text,11,string.len(text)))
           if attack >= 0 then
               local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
               hero:SetBaseDamageMax(attack)
               hero:SetBaseDamageMin(attack)
           end
       end
       --设置攻击间隔
       if string.sub(text,0,13) == "setattackrate" then
           local attackrate = tonumber(string.sub(text,14,string.len(text)))
           if attackrate >= 0 then
               local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
               hero:SetBaseAttackTime(attackrate)
           end
       end
       --设置移动
       if string.sub(text,0,7) == "setmove" then
           local move = tonumber(string.sub(text,8,string.len(text)))
           if move >= 0 then
               local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
               hero:SetBaseMoveSpeed(move)
           end
       end
       --设置移动
       if string.sub(text,0,6) == "setint" then
           local move = tonumber(string.sub(text,7,string.len(text)))
           if move >= 0 then
               local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
               hero:SetBaseIntellect(move)
           end
       end
       --设置最大生命
       if string.sub(text,0,8) == "setmaxhp" then
           local hp = tonumber(string.sub(text,9,string.len(text)))
           if hp >= 0 then
               local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
               hero:SetBaseMaxHealth(hp)
           end
       end
       --设置生命
       if string.sub(text,0,5) == "sethp" then
           local hp = tonumber(string.sub(text,6,string.len(text)))
           if hp >= 0 then
               local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
               hero:SetBaseMaxHealth(hp)
               hero:SetMaxHealth(hp)
               hero:SetHealth(hp)
               Spawner:CheckErrorSpawn()
           end
       end
       if string.sub(text,0,4) == "time" then
           local wave = string.sub(text,5,string.len(text))
           CustomGameEventManager:Send_ServerToAllClients("time_remaining", {wave=wave})
       end
       --设置生命回复
       if string.sub(text,0,10) == "sethpregen" then
           local hpregen = tonumber(string.sub(text,11,string.len(text)))
           if hpregen >= 0 then
               local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
               hero:SetBaseHealthRegen(hpregen)
           end
       end
       --设置魔法回复
       if string.sub(text,0,10) == "setmpregen" then
           local mpregen = tonumber(string.sub(text,11,string.len(text)))
           if mpregen >= 0 then
               local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
               hero:SetBaseManaRegen(mpregen)
           end
       end
       --设置护甲
       if string.sub(text,0,8) == "setarmor" then
           local armor = tonumber(string.sub(text,9,string.len(text)))
           if armor >= 0 then
               local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
               hero:SetPhysicalArmorBaseValue(armor)
           end
       end
       --设置魔抗
       if string.sub(text,0,8) == "setmagic" then
           local magic = tonumber(string.sub(text,9,string.len(text)))
           if magic >= 0 then
               local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
               hero:SetBaseMagicalResistanceValue(magic)
           end
       end
       --设置胜利
       if string.sub(text,0,7) == "victory" then
           --GameRules:SetGameWinner( DOTA_TEAM_GOODGUYS )
           HeroState:SendFinallyData()
           CustomUI:DynamicHud_Create(-1,"EndScreenPanel","file://{resources}/layout/custom_game/end_screen.xml",nil)
       end
       --设置模型
       if text == "modeldemon" then
           local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
           hero:SetOriginalModel("models/items/warlock/golem/hellsworn_golem/hellsworn_golem.vmdl")
       end
       if text == "modelpa" then
           local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
           hero:SetOriginalModel("models/heroes/phantom_assassin/phantom_assassin.vmdl")
       end
       if text == "modelpa2" then
           local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
           hero:SetOriginalModel("models/heroes/phantom_assassin/pa_arcana.vmdl")
       end
       if text == "modelomni" then
           local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
           hero:SetOriginalModel("models/heroes/omniknight/omniknight.vmdl")
       end
       if text == "modelcm" then
           local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
           hero:SetOriginalModel("models/heroes/crystal_maiden/crystal_maiden_arcana.vmdl")
       end
       if text == "modelstatue" then
           local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
           hero:SetOriginalModel("models/props_structures/tower_bad_sfm.vmdl")
       end]]
end