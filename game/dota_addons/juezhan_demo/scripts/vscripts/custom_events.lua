---
--- Created by lhing17.
--- DateTime: 2017/8/19 10:30
---
function HeroSelected( id, keys )
    local playerID = keys.PlayerID
    GameRules.GameMode.SelectedHeroName[playerID] = keys.hero
    local heroEntity = PlayerResource:GetPlayer(playerID):GetAssignedHero()
    PrecacheUnitByNameAsync(keys.hero, function()
        PlayerResource:ReplaceHeroWith(playerID, keys.hero, PlayerResource:GetGold(playerID), 0)
        heroEntity:RemoveSelf()
    end)
end
function OnSelectDifficultyClick( id, keys )
    print("selectedDifficulty"..keys.difficulty)
    local playerID = keys.PlayerID
    CustomNetTables:SetTableValue( "difficulty", tostring(playerID), { difficulty = keys.difficulty } )
    local player = PlayerResource:GetPlayer(playerID)
    if keys.difficulty == "EasyButton" then
        GameRules.GameMode.SelectDifficulty[playerID] = 1
    elseif keys.difficulty == "NormalButton" then
        GameRules.GameMode.SelectDifficulty[playerID] = 2
    elseif keys.difficulty == "HardButton" then
        GameRules.GameMode.SelectDifficulty[playerID] = 3
    elseif keys.difficulty == "DemonButton" then
        GameRules.GameMode.SelectDifficulty[playerID] = 4
    elseif keys.difficulty == "TeamButton" then
        GameRules.GameMode.SelectDifficulty[playerID] = 5
    elseif keys.difficulty == "NightmareButton" then
        GameRules.GameMode.SelectDifficulty[playerID] = 6
    end
end
function OnSelectClick( id, keys )
    local playerID = keys.PlayerID
    CustomNetTables:SetTableValue( "player_hero", tostring(playerID), { heroname = keys.hero } )
end
function OnSelectHover( id, keys )
    if keys.hero ~= "null" then
        --CustomNetTables:SetTableValue( "player", "heroname", {heroname=keys.hero} )
    end
end
function OnSelectDenominationClick (id, keys)
    print("selectedDenomination: "..keys.denomination)
    local playerID = keys.PlayerID
    print("playerId:"..playerID)
    CustomNetTables:SetTableValue( "denomination", tostring(playerID), { denomination = keys.denomination } )
    local player = PlayerResource:GetPlayer(playerID)
    GameRules.GameMode.Denomination[playerID] = keys.denomination
end