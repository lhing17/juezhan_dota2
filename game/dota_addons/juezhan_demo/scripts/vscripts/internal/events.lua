-- The overall game state has changed
function GameMode:_OnGameRulesStateChange(keys)
    if GameMode._reentrantCheck then
        return
    end

    local newState = GameRules:State_Get()
    if newState == DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD then
        self.bSeenWaitForPlayers = true
    elseif newState == DOTA_GAMERULES_STATE_INIT then
        --Timers:RemoveTimer("alljointimer")
    elseif newState == DOTA_GAMERULES_STATE_SETUP then
        for k, v in pairs(self.Players) do
            CustomNetTables:SetTableValue( "player_hero", tostring(k), { heroname = "npc_dota_hero_juggernaut" } )
            --CustomNetTables:SetTableValue( "scoreboard", tostring(k), { lv=1, str=0, agi=0, int=0, wavedef=0, damagesave=0, goldsave=0 } )
            CustomNetTables:SetTableValue( "difficulty", tostring(k), { difficulty = "NoSelect" } )
            CustomNetTables:SetTableValue( "denomination", tostring(k), { denomination = "noDenomination" } )
        end

    elseif newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
        GameMode:PostLoadPrecache()
        GameMode:OnAllPlayersLoaded()

        if USE_CUSTOM_TEAM_COLORS_FOR_PLAYERS then
            for i = 0, 9 do
                if PlayerResource:IsValidPlayer(i) then
                    local color = TEAM_COLORS[PlayerResource:GetTeam(i)]
                    PlayerResource:SetCustomPlayerColor(i, color[1], color[2], color[3])
                end
            end
        end
    elseif newState == DOTA_GAMERULES_STATE_STRATEGY_TIME then

    elseif newState == DOTA_GAMERULES_STATE_PRE_GAME then
        self.player_count = PlayerResource:GetPlayerCountForTeam( DOTA_TEAM_GOODGUYS )
        print("count of player" .. self.player_count)

        -- print("任务系统准备初始化...")
        Quest:Init()
        HeroState :Init()
        --难度计算
        Timers:CreateTimer(HERO_SELECTION_TIME, function()
            self.GameStartTime = GameRules:GetGameTime()
            -- 难度投票计算
            local difficulty_count = { 0, 0, 0, 0, 0, 0 }
            for playerID, difficulty_select in pairs(self.SelectDifficulty) do
                difficulty_count[difficulty_select] = difficulty_count[difficulty_select] + 1
            end
            local index = 1             -- maximum index
            local max = difficulty_count[index]          -- maximum value
            for i, value in ipairs(difficulty_count) do
                if value >= max then
                    index = i
                    max = value
                end
            end
            if max == 0 then
                index = 2
            end
            local select_difficulty = index
            CustomGameEventManager:Send_ServerToAllClients("difficulty", { difficulty = select_difficulty })
            for k, v in pairs(self.Players) do
                --print("denomination:" .. k)
                --print(self.Denomination[k])
                CustomGameEventManager:Send_ServerToPlayer(v, "denomination", { denomination = self.Denomination[k] } )
            end
            GameRules:SetCustomGameDifficulty(select_difficulty)

        end)
    elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        GameMode:OnGameInProgress()
        GameMode:SpawnAttackersAndCreatures() -- 刷怪函数
    end


    GameMode._reentrantCheck = true
    GameMode:OnGameRulesStateChange(keys)
    GameMode._reentrantCheck = false
end



-- An NPC has spawned somewhere in game.  This includes heroes
function GameMode:_OnNPCSpawned(keys)
    if GameMode._reentrantCheck then
        return
    end

    local npc = EntIndexToHScript(keys.entindex)

    if npc:IsRealHero() and npc.bFirstSpawned == nil then
        npc.bFirstSpawned = true
        GameMode:OnHeroInGame(npc)
    end

    GameMode._reentrantCheck = true
    GameMode:OnNPCSpawned(keys)
    GameMode._reentrantCheck = false
end

-- An entity died
function GameMode:_OnEntityKilled( keys )

    -- 野怪死后复活
    for k, v in pairs(creatures) do
        if not (v.creep:IsNull()) then
            if v.creep:entindex() == keys.entindex_killed then
                GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("spawn_creatures"),
                function()
                    -- 确保游戏正在进行中（游戏结束后在面板不再刷怪）
                    if GameRules:State_Get() >= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
                        v.creep = self:DoSpawn(v.location_entity, v.creep_name, DOTA_TEAM_NEUTRALS)
                        return nil
                    end
                end,
                v.respawn_time)
            end
        end
    end


    if GameMode._reentrantCheck then
        return
    end

    -- The Unit that was Killed
    local killedUnit = EntIndexToHScript( keys.entindex_killed )
    -- The Killing entity
    local killerEntity

    if keys.entindex_attacker ~= nil then
        killerEntity = EntIndexToHScript( keys.entindex_attacker )
    end

    if killedUnit:IsRealHero() then
        DebugPrint("KILLED, KILLER: " .. killedUnit:GetName() .. " -- " .. killerEntity:GetName())
        if END_GAME_ON_KILLS and GetTeamHeroKills(killerEntity:GetTeam()) >= KILLS_TO_END_GAME_FOR_TEAM then
            GameRules:SetSafeToLeave( true )
            GameRules:SetGameWinner( killerEntity:GetTeam() )
        end

        --PlayerResource:GetTeamKills
        if SHOW_KILLS_ON_TOPBAR then
            GameRules:GetGameModeEntity():SetTopBarTeamValue( DOTA_TEAM_BADGUYS, GetTeamHeroKills(DOTA_TEAM_BADGUYS) )
            GameRules:GetGameModeEntity():SetTopBarTeamValue( DOTA_TEAM_GOODGUYS, GetTeamHeroKills(DOTA_TEAM_GOODGUYS) )
        end
    end

    GameMode._reentrantCheck = true
    GameMode:OnEntityKilled( keys )
    GameMode._reentrantCheck = false
end

-- This function is called once when the player fully connects and becomes "Ready" during Loading
function GameMode:_OnConnectFull(keys)
    if GameMode._reentrantCheck then
        return
    end

    local playerEntity = PlayerResource:GetPlayer(keys.PlayerID)
    self.Players[keys.PlayerID] = playerEntity

    GameMode:_CaptureGameMode()

    local entIndex = keys.index + 1
    -- The Player entity of the joining user
    local ply = EntIndexToHScript(entIndex)

    local userID = keys.userid

    self.vUserIds = self.vUserIds or {}
    self.vUserIds[userID] = ply

    GameMode._reentrantCheck = true
    GameMode:OnConnectFull( keys )
    GameMode._reentrantCheck = false
end