-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function GameMode:_InitGameMode()
    if GameMode._reentrantCheck then
        return
    end

    -- 初始化游戏参数
    self.player_count = 0
    print(self)
    print("player_count" .. self.player_count)
    self.SelectedHeroName = {}
    self.Denomination = {}
    self.SelectDifficulty = {}
    self.DifficultySelected = false
    self.Players = {}
    self.GameStartTime = 0
    self.is_cheat = false

    -- Setup rules
    GameRules:SetHeroRespawnEnabled( ENABLE_HERO_RESPAWN )
    GameRules:SetUseUniversalShopMode( UNIVERSAL_SHOP_MODE )
    GameRules:SetSameHeroSelectionEnabled( ALLOW_SAME_HERO_SELECTION )
    GameRules:SetHeroSelectionTime( HERO_SELECTION_TIME )
    GameRules:SetPreGameTime( PRE_GAME_TIME)
    GameRules:SetPostGameTime( POST_GAME_TIME )
    GameRules:SetTreeRegrowTime( TREE_REGROW_TIME )
    GameRules:SetUseCustomHeroXPValues( USE_CUSTOM_XP_VALUES )
    GameRules:SetGoldPerTick(GOLD_PER_TICK)
    GameRules:SetGoldTickTime(GOLD_TICK_TIME)
    GameRules:SetRuneSpawnTime(RUNE_SPAWN_TIME)
    GameRules:SetUseBaseGoldBountyOnHeroes(USE_STANDARD_HERO_GOLD_BOUNTY)
    GameRules:SetHeroMinimapIconScale( MINIMAP_ICON_SIZE )
    GameRules:SetCreepMinimapIconScale( MINIMAP_CREEP_ICON_SIZE )
    GameRules:SetRuneMinimapIconScale( MINIMAP_RUNE_ICON_SIZE )

    GameRules:SetFirstBloodActive( ENABLE_FIRST_BLOOD )
    GameRules:SetHideKillMessageHeaders( HIDE_KILL_BANNERS )

    GameRules:SetCustomGameEndDelay( GAME_END_DELAY )
    GameRules:SetCustomVictoryMessageDuration( VICTORY_MESSAGE_DURATION )
    GameRules:SetStartingGold( STARTING_GOLD )

    if SKIP_TEAM_SETUP then
        GameRules:SetCustomGameSetupAutoLaunchDelay( 0 )
        GameRules:LockCustomGameSetupTeamAssignment( true )
        GameRules:EnableCustomGameSetupAutoLaunch( true )
    else
        GameRules:SetCustomGameSetupAutoLaunchDelay( AUTO_LAUNCH_DELAY )
        GameRules:LockCustomGameSetupTeamAssignment( LOCK_TEAM_SETUP )
        GameRules:EnableCustomGameSetupAutoLaunch( ENABLE_AUTO_LAUNCH )
    end


    -- This is multiteam configuration stuff
    if USE_AUTOMATIC_PLAYERS_PER_TEAM then
        local num = math.floor(10 / MAX_NUMBER_OF_TEAMS)
        local count = 0
        for team, number in pairs(TEAM_COLORS) do
            if count >= MAX_NUMBER_OF_TEAMS then
                GameRules:SetCustomGameTeamMaxPlayers(team, 0)
            else
                GameRules:SetCustomGameTeamMaxPlayers(team, num)
            end
            count = count + 1
        end
    else
        local count = 0
        for team, number in pairs(CUSTOM_TEAM_PLAYER_COUNT) do
            if count >= MAX_NUMBER_OF_TEAMS then
                GameRules:SetCustomGameTeamMaxPlayers(team, 0)
            else
                GameRules:SetCustomGameTeamMaxPlayers(team, number)
            end
            count = count + 1
        end
    end

    if USE_CUSTOM_TEAM_COLORS then
        for team, color in pairs(TEAM_COLORS) do
            SetTeamCustomHealthbarColor(team, color[1], color[2], color[3])
        end
    end
    DebugPrint('[BAREBONES] GameRules set')

    --InitLogFile( "log/barebones.txt","")

    -- Event Hooks
    -- All of these events can potentially be fired by the game, though only the uncommented ones have had
    -- Functions supplied for them.  If you are interested in the other events, you can uncomment the
    -- ListenToGameEvent line and add a function to handle the event
    ListenToGameEvent('dota_player_gained_level', Dynamic_Wrap(GameMode, 'OnPlayerLevelUp'), self)
    ListenToGameEvent('dota_ability_channel_finished', Dynamic_Wrap(GameMode, 'OnAbilityChannelFinished'), self)
    ListenToGameEvent('dota_player_learned_ability', Dynamic_Wrap(GameMode, 'OnPlayerLearnedAbility'), self)
    ListenToGameEvent('entity_killed', Dynamic_Wrap(GameMode, '_OnEntityKilled'), self)
    ListenToGameEvent('player_connect_full', Dynamic_Wrap(GameMode, '_OnConnectFull'), self)
    ListenToGameEvent('player_disconnect', Dynamic_Wrap(GameMode, 'OnDisconnect'), self)
    ListenToGameEvent('dota_item_purchased', Dynamic_Wrap(GameMode, 'OnItemPurchased'), self)
    ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(GameMode, 'OnItemPickedUp'), self)
    ListenToGameEvent('last_hit', Dynamic_Wrap(GameMode, 'OnLastHit'), self)
    ListenToGameEvent('dota_non_player_used_ability', Dynamic_Wrap(GameMode, 'OnNonPlayerUsedAbility'), self)
    ListenToGameEvent('player_changename', Dynamic_Wrap(GameMode, 'OnPlayerChangedName'), self)
    ListenToGameEvent('dota_rune_activated_server', Dynamic_Wrap(GameMode, 'OnRuneActivated'), self)
    ListenToGameEvent('dota_player_take_tower_damage', Dynamic_Wrap(GameMode, 'OnPlayerTakeTowerDamage'), self)
    ListenToGameEvent('tree_cut', Dynamic_Wrap(GameMode, 'OnTreeCut'), self)
    ListenToGameEvent('entity_hurt', Dynamic_Wrap(GameMode, 'OnEntityHurt'), self)
    ListenToGameEvent('player_connect', Dynamic_Wrap(GameMode, 'PlayerConnect'), self)
    ListenToGameEvent('dota_player_used_ability', Dynamic_Wrap(GameMode, 'OnAbilityUsed'), self)
    ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(GameMode, '_OnGameRulesStateChange'), self)
    ListenToGameEvent('npc_spawned', Dynamic_Wrap(GameMode, '_OnNPCSpawned'), self)
    ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(GameMode, 'OnPlayerPickHero'), self)
    ListenToGameEvent('dota_team_kill_credit', Dynamic_Wrap(GameMode, 'OnTeamKillCredit'), self)
    ListenToGameEvent("player_reconnected", Dynamic_Wrap(GameMode, 'OnPlayerReconnect'), self)

    ListenToGameEvent("dota_illusions_created", Dynamic_Wrap(GameMode, 'OnIllusionsCreated'), self)
    ListenToGameEvent("dota_item_combined", Dynamic_Wrap(GameMode, 'OnItemCombined'), self)
    ListenToGameEvent("dota_player_begin_cast", Dynamic_Wrap(GameMode, 'OnAbilityCastBegins'), self)
    ListenToGameEvent("dota_tower_kill", Dynamic_Wrap(GameMode, 'OnTowerKill'), self)
    ListenToGameEvent("dota_player_selected_custom_team", Dynamic_Wrap(GameMode, 'OnPlayerSelectedCustomTeam'), self)
    ListenToGameEvent("dota_npc_goal_reached", Dynamic_Wrap(GameMode, 'OnNPCGoalReached'), self)

    ListenToGameEvent("player_chat", Dynamic_Wrap(GameMode, 'OnPlayerChat'), self)

    CustomGameEventManager:RegisterListener( "selection_hero_click", OnSelectClick )
    CustomGameEventManager:RegisterListener( "selection_hero_hover", OnSelectHover )
    CustomGameEventManager:RegisterListener( "selection_difficulty_click", OnSelectDifficultyClick )
    CustomGameEventManager:RegisterListener( "hero_selected", HeroSelected )
    CustomGameEventManager:RegisterListener( "selection_denomination_click", OnSelectDenominationClick)
    --CustomGameEventManager:RegisterListener("myui_open", OnMyUIOpen)
    --CustomGameEventManager:RegisterListener("js_to_lua", OnJsToLua)
    --CustomGameEventManager:RegisterListener("lua_to_js", OnLuaToJs)
    --ListenToGameEvent("dota_tutorial_shop_toggled", Dynamic_Wrap(GameMode, 'OnShopToggled'), self)

    --ListenToGameEvent('player_spawn', Dynamic_Wrap(GameMode, 'OnPlayerSpawn'), self)
    --ListenToGameEvent('dota_unit_event', Dynamic_Wrap(GameMode, 'OnDotaUnitEvent'), self)
    --ListenToGameEvent('nommed_tree', Dynamic_Wrap(GameMode, 'OnPlayerAteTree'), self)
    --ListenToGameEvent('player_completed_game', Dynamic_Wrap(GameMode, 'OnPlayerCompletedGame'), self)
    --ListenToGameEvent('dota_match_done', Dynamic_Wrap(GameMode, 'OnDotaMatchDone'), self)
    --ListenToGameEvent('dota_combatlog', Dynamic_Wrap(GameMode, 'OnCombatLogEvent'), self)
    --ListenToGameEvent('dota_player_killed', Dynamic_Wrap(GameMode, 'OnPlayerKilled'), self)
    --ListenToGameEvent('player_team', Dynamic_Wrap(GameMode, 'OnPlayerTeam'), self)

    --[[This block is only used for testing events handling in the event that Valve adds more in the future
    Convars:RegisterCommand('events_test', function()
        GameMode:StartEventTest()
      end, "events test", 0)]]

    -----------------------------------------
    -- 初 始 化 进 攻 怪 和 野 怪
    -----------------------------------------
    --初始化10头狼
    index = 1;
    wolf = { 'lang1', 'lang2', 'lang3', 'lang4', 'lang5', 'lang6'}
    for i, v in pairs(wolf) do
        creatures[index] = Creature:new(Entities:FindByName(nil, v), "npc_creep_sep_wolf", 10)
        index = index + 1
    end
    --野猪王
    creatures[index] = Creature:new(Entities:FindByName(nil, 'pigking'), "npc_creep_sep_pigking", 20)
    index = index + 1
--[[    --江南七怪
    --TODO 怪物类型未改
    creatures[index] = Creature:new(Entities:FindByName(nil, 'kezhene'), "npc_creep_sep_pigking", 20)
    index = index + 1
    creatures[index] = Creature:new(Entities:FindByName(nil, 'zhucong'), "npc_creep_sep_pigking", 20)
    index = index + 1
    creatures[index] = Creature:new(Entities:FindByName(nil, 'hanbaoju'), "npc_creep_sep_pigking", 20)
    index = index + 1
    creatures[index] = Creature:new(Entities:FindByName(nil, 'zhangasheng'), "npc_creep_sep_pigking", 20)
    index = index + 1
    creatures[index] = Creature:new(Entities:FindByName(nil, 'nanxiren'), "npc_creep_sep_pigking", 20)
    index = index + 1
    creatures[index] = Creature:new(Entities:FindByName(nil, 'hanxiaoying'), "npc_creep_sep_pigking", 20)
    index = index + 1
    creatures[index] = Creature:new(Entities:FindByName(nil, 'quanjinfa'), "npc_creep_sep_pigking", 20)
    index = index + 1]]

    --蝎子
    scorpion = { 'scorpion1', 'scorpion2', 'scorpion3', 'scorpion4', 'scorpion5', 'scorpion6' }
    for i, v in pairs(scorpion) do
        creatures[index] = Creature:new(Entities:FindByName(nil, v), "npc_creep_sep_scorpion", 10)
        index = index + 1
    end

--[[    --十恶不赦
    shie = { 'shie1', 'shie2', 'shie3', 'shie4', 'shie5', 'shie6', 'shie7', 'shie8', 'shie9', 'shie10', 'shie11', 'shie12', 'shie13', 'shie14', 'shie15', 'shie16', 'shie17', 'shie18', 'shie19', 'shie20', 'shie21', 'shie22', 'shie23', 'shie24', 'shie25', 'shie26', 'shie27', 'shie28', 'shie29', 'shie30', 'shie31', 'shie32' }
    for i, v in pairs(shie) do
        creatures[index] = Creature:new(Entities:FindByName(nil, v), "npc_creep_sep_shiebushe", 10)
        index = index + 1
    end

    --十恶不赦BOSS 57
    creatures[index] = Creature:new(Entities:FindByName(nil, 'shieboss'), "npc_creep_sep_scorpion", 10)
    index = index + 1]]
    ------------
    --FB1
    ------------
    --小怪
    instance1_small = {}
    for i = 1, 20 do
        instance1_small[i] = 'instance1_small' .. i
        if (i % 2 == 0) then
            creatures[index] = Creature:new(Entities:FindByName(nil, instance1_small[i]), "npc_creep_sep_thief", 10)
        else
            creatures[index] = Creature:new(Entities:FindByName(nil, instance1_small[i]), "npc_creep_sep_bandit", 10)
        end
        index = index + 1
    end
    --BOSS
    instance1_boss = {}
    for i = 1, 4 do
        instance1_boss[i] = 'instance1_boss' .. i
    end
    creatures[index] = Creature:new(Entities:FindByName(nil, instance1_boss[1]), "npc_creep_sep_bandit_boss", 10)
    index = index + 1

    creatures[index] = Creature:new(Entities:FindByName(nil, instance1_boss[2]), "npc_creep_sep_thief_boss", 10)
    index = index + 1

    creatures[index] = Creature:new(Entities:FindByName(nil, instance1_boss[3]), "npc_creep_sep_huogong", 10)
    index = index + 1

    creatures[index] = Creature:new(Entities:FindByName(nil, instance1_boss[4]), "npc_creep_sep_dingchunqiu", 10)
    index = index + 1
--[[    ------------
    --FB2
    ------------
    instance2_small = {}
    for i = 1, 21 do
        instance2_small[i] = 'instance2_small' .. i
        creatures[index] = Creature:new(Entities:FindByName(nil, instance2_small[i]), "npc_creep_sep_beast", 15)
        index = index + 1
    end
    ------------
    --FB3
    ------------

    instance3_small = {}
    for i = 1, 16 do
        instance3_small[i] = 'instance3_small' .. i
        creatures[index] = Creature:new(Entities:FindByName(nil, instance3_small[i]), "npc_creep_sep_bear", 20)
        index = index + 1
    end]]
    ------------
    --FB4
    ------------

    ------------
    --FB5
    ------------


    ------------
    --进攻怪
    ------------
    attackers[1] = Attacker:new("npc_creep_first")
    attackers[2] = Attacker:new("npc_creep_second")
    attackers[3] = Attacker:new("npc_creep_third")
    attackers[4] = Attacker:new("npc_creep_fourth")
    attackers[5] = Attacker:new("npc_creep_fifth")
    attackers[6] = Attacker:new("npc_creep_sixth")
    attackers[7] = Attacker:new("npc_creep_seventh")
    attackers[8] = Attacker:new("npc_creep_eighth")
    attackers[9] = Attacker:new("npc_creep_ninth")
    attackers[10] = Attacker:new("npc_creep_tenth")
    attackers[11] = Attacker:new("npc_creep_eleventh")
    attackers[12] = Attacker:new("npc_creep_twelfth")
    attackers[13] = Attacker:new("npc_creep_thirteenth")
    attackers[14] = Attacker:new("npc_creep_fourteenth")
    attackers[15] = Attacker:new("npc_creep_fifteenth")
    attackers[16] = Attacker:new("npc_creep_sixteenth")
    attackers[17] = Attacker:new("npc_creep_seventeenth")
    attackers[18] = Attacker:new("npc_creep_eightteenth")
    attackers[19] = Attacker:new("npc_creep_nineteenth")
    attackers[20] = Attacker:new("npc_creep_twentieth")
    attackers[21] = Attacker:new("npc_creep_twentyfirst")
    attackers[22] = Attacker:new("npc_creep_twentysecond")
    attackers[23] = Attacker:new("npc_creep_twentythird")
    attackers[24] = Attacker:new("npc_creep_twentyfourth")
    attackers[25] = Attacker:new("npc_creep_twentyfifth")
    attackers[26] = Attacker:new("npc_creep_twentysixth")
    attackers[27] = Attacker:new("npc_creep_twentyseventh")
    attackers[28] = Attacker:new("npc_creep_twentyeighth")
    attackers[29] = Attacker:new("npc_creep_twentyninth")
    attackers[30] = Attacker:new("npc_creep_thirtieth")



    local spew = 0
    if BAREBONES_DEBUG_SPEW then
        spew = 1
    end
    Convars:RegisterConvar('barebones_spew', tostring(spew), 'Set to 1 to start spewing barebones debug info.  Set to 0 to disable.', 0)

    -- Change random seed
    local timeTxt = string.gsub(string.gsub(GetSystemTime(), ':', ''), '^0+', '')
    math.randomseed(tonumber(timeTxt))

    -- Initialized tables for tracking state
    self.bSeenWaitForPlayers = false
    self.vUserIds = {}

    DebugPrint('[BAREBONES] Done loading Barebones gamemode!\n\n')
    GameMode._reentrantCheck = true
    GameMode:InitGameMode()
    GameMode._reentrantCheck = false
end

mode = nil

-- This function is called as the first player loads and sets up the GameMode parameters
-- 设置游戏参数
function GameMode:_CaptureGameMode()
    if mode == nil then
        -- Set GameMode parameters
        mode = GameRules:GetGameModeEntity()
        mode:SetRecommendedItemsDisabled( RECOMMENDED_BUILDS_DISABLED )
        mode:SetCameraDistanceOverride( CAMERA_DISTANCE_OVERRIDE )
        mode:SetCustomBuybackCostEnabled( CUSTOM_BUYBACK_COST_ENABLED )
        mode:SetCustomBuybackCooldownEnabled( CUSTOM_BUYBACK_COOLDOWN_ENABLED )
        mode:SetBuybackEnabled( BUYBACK_ENABLED )
        mode:SetTopBarTeamValuesOverride( USE_CUSTOM_TOP_BAR_VALUES )
        mode:SetTopBarTeamValuesVisible( TOP_BAR_VISIBLE )
        mode:SetUseCustomHeroLevels( USE_CUSTOM_HERO_LEVELS )
        mode:SetCustomHeroMaxLevel( MAX_LEVEL )
        mode:SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )

        mode:SetBotThinkingEnabled( USE_STANDARD_DOTA_BOT_THINKING )
        mode:SetTowerBackdoorProtectionEnabled( ENABLE_TOWER_BACKDOOR_PROTECTION )

        mode:SetFogOfWarDisabled(DISABLE_FOG_OF_WAR_ENTIRELY)
        mode:SetGoldSoundDisabled( DISABLE_GOLD_SOUNDS )
        mode:SetRemoveIllusionsOnDeath( REMOVE_ILLUSIONS_ON_DEATH )

        mode:SetAlwaysShowPlayerInventory( SHOW_ONLY_PLAYER_INVENTORY )
        mode:SetAnnouncerDisabled( DISABLE_ANNOUNCER )
        if FORCE_PICKED_HERO ~= nil then
            mode:SetCustomGameForceHero( FORCE_PICKED_HERO )
        end
        mode:SetFixedRespawnTime( FIXED_RESPAWN_TIME )
        mode:SetFountainConstantManaRegen( FOUNTAIN_CONSTANT_MANA_REGEN )
        mode:SetFountainPercentageHealthRegen( FOUNTAIN_PERCENTAGE_HEALTH_REGEN )
        mode:SetFountainPercentageManaRegen( FOUNTAIN_PERCENTAGE_MANA_REGEN )
        mode:SetLoseGoldOnDeath( LOSE_GOLD_ON_DEATH )
        mode:SetMaximumAttackSpeed( MAXIMUM_ATTACK_SPEED )
        mode:SetMinimumAttackSpeed( MINIMUM_ATTACK_SPEED )
        mode:SetStashPurchasingDisabled( DISABLE_STASH_PURCHASING )

        for rune, spawn in pairs(ENABLED_RUNES) do
            mode:SetRuneEnabled(rune, spawn)
        end

        mode:SetUnseenFogOfWarEnabled( USE_UNSEEN_FOG_OF_WAR )

        mode:SetDaynightCycleDisabled( DISABLE_DAY_NIGHT_CYCLE )
        mode:SetKillingSpreeAnnouncerDisabled( DISABLE_KILLING_SPREE_ANNOUNCER )
        mode:SetStickyItemDisabled( DISABLE_STICKY_ITEM )

        -- filter 过滤器
        mode:SetModifyGoldFilter(Dynamic_Wrap( GuardingAthena, "ModifyGoldFilter" ), self )


        self:OnFirstPlayerLoaded()
    end
end