"use strict";


//=============================================================================
//=============================================================================
function _AbilitySlotUpdater_SetTextSafe( panel, childName, textValue )
{
	if ( panel === null )
		return;
	var childPanel = panel.FindChildInLayoutFile( childName )
	if ( childPanel === null )
		return;
	
	childPanel.text = textValue;
}

//更新玩家Panel
//=============================================================================
//=============================================================================
function _AbilitySlotUpdater_UpdatePlayerPanel( abilityslotConfig, playersContainer )
{
	var playerId = Game.GetLocalPlayerID();
	var playerPanelName = "_dynamic_player_" + playerId;
	var playerPanel = playersContainer.FindChild( playerPanelName );
	if ( playerPanel === null )
	{
		playerPanel = $.CreatePanel( "Panel", playersContainer, playerPanelName );
		playerPanel.SetAttributeInt( "player_id", playerId );
		playerPanel.BLoadLayout( abilityslotConfig.playerXmlName, false, false );
		
	}

	
	var playerHeroAbilityContainer = playerPanel.FindChildInLayoutFile("PlayerHeroAbilityContainer")
	if ( playerHeroAbilityContainer )
	{
		var heroEntityIndex = Players.GetPlayerHeroEntityIndex( playerId );
		for (var i = 1; i < Entities.GetAbilityCount(heroEntityIndex); ++i)
		{
			var abilityInstance = Entities.GetAbility(heroEntityIndex, i);
			if (abilityInstance)
			{
				var abilityName = "ShaoLin_DaMo";//abilityInstance.GetAbilityName(heroEntityIndex);
				var abilityPanelName = "_dynamic_ability_" + i;
				var abilityPanel = playerHeroAbilityContainer.FindChild( abilityPanelName );
				if ( abilityPanel === null)
				{
					abilityPanel = $.CreatePanel("Panel", playerHeroAbilityContainer, abilityPanelName);
					var abilityButton = $.CreatePanel("Button", abilityPanel, abilityPanelName + "button");
					//abilityButton.setPanelEvent("onmouseactivate", "DOTAShowAbilityTooltipForEntityIndex(abilityName, heroEntityIndex)");
					var abilityImage =  $.CreatePanel("DOTAAbilityImage", abilityButton, abilityPanelName + "image");
					//abilityImage.abilityname(abilityName);
				}
			}
			
		}
	}
}
//=============================================================================
//=============================================================================
function AbilitySlotUpdater_InitializeAbilitySlot( abilityslotConfig, abilityslotPanel )
{

	_AbilitySlotUpdater_UpdatePlayerPanel( abilityslotConfig, abilityslotPanel );
	return { "abilityslotConfig": abilityslotConfig, "abilityslotPanel":abilityslotPanel }
}
//=============================================================================
//=============================================================================
function AbilitySlotUpdater_SetAbilitySlotActive( abilityslotHandle, isActive )
{
	if ( abilityslotHandle.abilityslotConfig === null || abilityslotHandle.abilityslotPanel === null )
	{
		return;
	}
	
	if ( isActive )
	{
		_AbilitySlotUpdater_UpdatePlayerPanel( abilityslotHandle.abilityslotConfig, abilityslotHandle.abilityslotPanel );
	}
}