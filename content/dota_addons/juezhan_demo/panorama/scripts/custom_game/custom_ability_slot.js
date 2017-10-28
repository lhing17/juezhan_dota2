"use strict";

var g_AbilitySlotHandle = null;

function UpdateAbilitySlot()
{
	AbilitySlotUpdater_SetAbilitySlotActive( g_AbilitySlotHandle, true );

	$.Schedule( 0.2, UpdateAbilitySlot );
}

(function()
{
	
	if ( AbilitySlotUpdater_InitializeAbilitySlot === null ) { $.Msg( "WARNING: This file requires shared_ability_slot_updater.js to be included." ); }

	var abilityslotConfig =
	{
		"playerXmlName" : "file://{resources}/layout/custom_game/custom_ability_slot_player.xml",
	};
	g_AbilitySlotHandle = AbilitySlotUpdater_InitializeAbilitySlot( abilityslotConfig, $( "#AbilitiesContainer" ) );
	$.Msg("BBB");
	UpdateAbilitySlot();
})();

