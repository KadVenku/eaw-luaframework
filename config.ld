-- ldoc configuration file
title = "EaW Lua Framework"
project = "EaW Lua Framework"

description = [[
An event driven framework for the Petroglyph game Star Wars: Empire at War - Forces of Corruption written entirely in LUA 5.1.
The purpose of this framework is providing mod makers with the ability to add new gameplay mechanics on top of the existing game as well as allowing easy interaction with the game's GUI and story scripting system.


The general idea is to mirror every necessary game object (planets, factions,...) as a LUA object. This way interaction between registered objects can be programmed and extended to one's liking via LUA 5.1 and only has to fall back to onto the game's default functionality to interact directly with the mirrored and linked game object.

In addition the framework provides a fully functional event handler which registers custom event types which inherit from a base event class. These can be affiliated with in-game actions or LUA object actions.
]]

file = {
    'DATA/SCRIPTS/LIBRARY/cEvent.lua',
    'DATA/SCRIPTS/LIBRARY/cEventHandler.lua',
    'DATA/SCRIPTS/LIBRARY/cEvent_Type_DIPLCheckFactionAlliance.lua',
    'DATA/SCRIPTS/LIBRARY/cEvent_Type_DIPLEndDiplomaticMission.lua',
    'DATA/SCRIPTS/LIBRARY/cEvent_Type_DIPLMakeAllies.lua',
    'DATA/SCRIPTS/LIBRARY/cEvent_Type_DIPLStartDiplomaticMission.lua',
    'DATA/SCRIPTS/LIBRARY/cEvent_Type_DIPLTurnPlanet.lua',
    'DATA/SCRIPTS/LIBRARY/cEvent_Type_DIPLUpdateAllianceRating.lua',
    'DATA/SCRIPTS/LIBRARY/cEvent_Type_FleetHyperspaceAccident.lua',
    'DATA/SCRIPTS/LIBRARY/cEvent_Type_OrbitalBombardmentBegin.lua',
    'DATA/SCRIPTS/LIBRARY/cEvent_Type_OrbitalBombardmentBurst.lua',
    'DATA/SCRIPTS/LIBRARY/cEvent_Type_OrbitalBombardmentEnd.lua',
    'DATA/SCRIPTS/LIBRARY/cEvent_Type_SpawnUnits.lua',
    'DATA/SCRIPTS/LIBRARY/cEvent_Type_Testevent.lua',
    'DATA/SCRIPTS/LIBRARY/cFaction.lua',
    'DATA/SCRIPTS/LIBRARY/cGUIElement.lua',
    'DATA/SCRIPTS/LIBRARY/cGUIElement_Type_Filter.lua',
    'DATA/SCRIPTS/LIBRARY/cGUIHandler.lua',
    'DATA/SCRIPTS/LIBRARY/cGalacticConquest.lua',
    'DATA/SCRIPTS/LIBRARY/cGameObjectType.lua',
    'DATA/SCRIPTS/LIBRARY/cGameObjectTypeBuilding.lua',
    'DATA/SCRIPTS/LIBRARY/cGameObjectTypeUnit.lua',
    'DATA/SCRIPTS/LIBRARY/cGameObjectTypeUpgrade.lua',
    'DATA/SCRIPTS/LIBRARY/cGlobalMessageHandler.lua',
    'DATA/SCRIPTS/LIBRARY/cMajorFaction.lua',
    'DATA/SCRIPTS/LIBRARY/cMinorFaction.lua',
    'DATA/SCRIPTS/LIBRARY/cObjectManager.lua',
    'DATA/SCRIPTS/LIBRARY/cPlanet.lua',
    'DATA/SCRIPTS/LIBRARY/configGlobalSettings.lua',
    'DATA/SCRIPTS/LIBRARY/libDebugFunctions.lua',
    'DATA/SCRIPTS/LIBRARY/libErrorFunctions.lua',
    'DATA/SCRIPTS/LIBRARY/libGCDefinitions.lua',
    'DATA/SCRIPTS/LIBRARY/libGCFunctionLibrary.lua',
    'DATA/SCRIPTS/LIBRARY/libPGGenericFunctionLibrary.lua',
    'DATA/SCRIPTS/LIBRARY/libStaticEventTypeDefinitions.lua',
    'DATA/SCRIPTS/LIBRARY/libStaticFactionDefinitions.lua',
    'DATA/SCRIPTS/LIBRARY/libStaticGUIElements.lua',
    'DATA/SCRIPTS/LIBRARY/libStaticGUIObjectMappings.lua',
    'DATA/SCRIPTS/LIBRARY/libStaticMessageTypeDefinitions.lua',
    'DATA/SCRIPTS/LIBRARY/libStaticObjectDefinitionsBuildings.lua',
    'DATA/SCRIPTS/LIBRARY/libStaticObjectDefinitionsUnits.lua',
    'DATA/SCRIPTS/LIBRARY/libStaticObjectDefinitionsUpgrades.lua',
    'DATA/SCRIPTS/LIBRARY/libStaticPlanetDefinitions.lua',
    'DATA/SCRIPTS/LIBRARY/libStaticPlanetStates.lua',
    'DATA/SCRIPTS/LIBRARY/libStaticStructReinforces.lua',
    'DATA/SCRIPTS/LIBRARY/libStaticTraderouteDefinitions.lua',
    'DATA/SCRIPTS/LIBRARY/libStaticTraitDefinitions.lua'
}
examples = {
    'DATA/SCRIPTS/LIBRARY/cEvent.lua',
    'DATA/SCRIPTS/LIBRARY/cEventHandler.lua',
    'DATA/SCRIPTS/LIBRARY/cEvent_Type_DIPLCheckFactionAlliance.lua',
    'DATA/SCRIPTS/LIBRARY/cEvent_Type_DIPLEndDiplomaticMission.lua',
    'DATA/SCRIPTS/LIBRARY/cEvent_Type_DIPLMakeAllies.lua',
    'DATA/SCRIPTS/LIBRARY/cEvent_Type_DIPLStartDiplomaticMission.lua',
    'DATA/SCRIPTS/LIBRARY/cEvent_Type_DIPLTurnPlanet.lua',
    'DATA/SCRIPTS/LIBRARY/cEvent_Type_DIPLUpdateAllianceRating.lua',
    'DATA/SCRIPTS/LIBRARY/cEvent_Type_FleetHyperspaceAccident.lua',
    'DATA/SCRIPTS/LIBRARY/cEvent_Type_OrbitalBombardmentBegin.lua',
    'DATA/SCRIPTS/LIBRARY/cEvent_Type_OrbitalBombardmentBurst.lua',
    'DATA/SCRIPTS/LIBRARY/cEvent_Type_OrbitalBombardmentEnd.lua',
    'DATA/SCRIPTS/LIBRARY/cEvent_Type_SpawnUnits.lua',
    'DATA/SCRIPTS/LIBRARY/cEvent_Type_Testevent.lua',
    'DATA/SCRIPTS/LIBRARY/cFaction.lua',
    'DATA/SCRIPTS/LIBRARY/cGUIElement.lua',
    'DATA/SCRIPTS/LIBRARY/cGUIElement_Type_Filter.lua',
    'DATA/SCRIPTS/LIBRARY/cGUIHandler.lua',
    'DATA/SCRIPTS/LIBRARY/cGalacticConquest.lua',
    'DATA/SCRIPTS/LIBRARY/cGameObjectType.lua',
    'DATA/SCRIPTS/LIBRARY/cGameObjectTypeBuilding.lua',
    'DATA/SCRIPTS/LIBRARY/cGameObjectTypeUnit.lua',
    'DATA/SCRIPTS/LIBRARY/cGameObjectTypeUpgrade.lua',
    'DATA/SCRIPTS/LIBRARY/cGlobalMessageHandler.lua',
    'DATA/SCRIPTS/LIBRARY/cMajorFaction.lua',
    'DATA/SCRIPTS/LIBRARY/cMinorFaction.lua',
    'DATA/SCRIPTS/LIBRARY/cObjectManager.lua',
    'DATA/SCRIPTS/LIBRARY/cPlanet.lua',
    'DATA/SCRIPTS/LIBRARY/configGlobalSettings.lua',
    'DATA/SCRIPTS/LIBRARY/libDebugFunctions.lua',
    'DATA/SCRIPTS/LIBRARY/libErrorFunctions.lua',
    'DATA/SCRIPTS/LIBRARY/libGCDefinitions.lua',
    'DATA/SCRIPTS/LIBRARY/libGCFunctionLibrary.lua',
    'DATA/SCRIPTS/LIBRARY/libPGGenericFunctionLibrary.lua',
    'DATA/SCRIPTS/LIBRARY/libStaticEventTypeDefinitions.lua',
    'DATA/SCRIPTS/LIBRARY/libStaticFactionDefinitions.lua',
    'DATA/SCRIPTS/LIBRARY/libStaticGUIElements.lua',
    'DATA/SCRIPTS/LIBRARY/libStaticGUIObjectMappings.lua',
    'DATA/SCRIPTS/LIBRARY/libStaticMessageTypeDefinitions.lua',
    'DATA/SCRIPTS/LIBRARY/libStaticObjectDefinitionsBuildings.lua',
    'DATA/SCRIPTS/LIBRARY/libStaticObjectDefinitionsUnits.lua',
    'DATA/SCRIPTS/LIBRARY/libStaticObjectDefinitionsUpgrades.lua',
    'DATA/SCRIPTS/LIBRARY/libStaticPlanetDefinitions.lua',
    'DATA/SCRIPTS/LIBRARY/libStaticPlanetStates.lua',
    'DATA/SCRIPTS/LIBRARY/libStaticStructReinforces.lua',
    'DATA/SCRIPTS/LIBRARY/libStaticTraderouteDefinitions.lua',
    'DATA/SCRIPTS/LIBRARY/libStaticTraitDefinitions.lua'
}
readme = "README.md"
all = true
