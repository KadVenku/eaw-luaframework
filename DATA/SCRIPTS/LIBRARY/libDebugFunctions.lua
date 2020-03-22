-- ===== ===== ===== ===== =====
-- Copyright (c) 2017 Kad Venku
-- License       MIT License
-- ===== ===== ===== ===== =====

--- Generic debugging functionality.
-- Provides threaded functions to push messages to the droid log or the mission holochron.

--- Pushes a message to the droid log.
-- @tparam string msgContent
-- @within Debugging Functions
function debugPushDroidMessage( msgContent )
    Create_Thread( "tOutPushDroidMessage", msgContent )
end
--- Threaded output for the droid log push.
-- @tparam string msgContent
-- @within Threaded Output Handler
function tOutPushDroidMessage( msgContent )
    Game_Message( msgContent )
end

--- Displays a planet owner change message via the mission holochron.
-- @tparam string planetStringKey
-- @tparam string prevOwnerStringKey
-- @tparam string newOwnerStringKey
-- @within Debugging Functions
function debugPlanetOwnerChange( planetStringKey, prevOwnerStringKey, newOwnerStringKey )
    Create_Thread( "tOutPlanetOwnerChange", { planetStringKey, prevOwnerStringKey, newOwnerStringKey } )
end
--- Threaded output for the planet owner change push.
-- @tparam table table
-- @within Threaded Output Handler
function tOutPlanetOwnerChange( table )
    local debugEvent = Get_Story_Plot( "__luaFramework/libErrorHandler/libErrorHandler.xml" ).Get_Event( "libErrorHandler_DisplayErrorMessage" )
    local dialogFile = "libDebugHandlerDialog"
    debugEvent.Set_Dialog( dialogFile )
    debugEvent.Clear_Dialog_Text()
    debugEvent.Add_Dialog_Text( "TEXT_DEBUG_TYPE_OWNER_CHANGE", table[1] )
    debugEvent.Add_Dialog_Text( "TEXT_DEBUG_PREVIOUS_OWNER", table[2] )
    debugEvent.Add_Dialog_Text( "TEXT_DEBUG_NEW_OWNER", table[3] )
    Story_Event( "libErrorHandler_DisplayErrorMessage_Trigger" )
end
--- Displays a planet selected message via the mission holochron.
-- @tparam string planetStringKey
-- @tparam table gObjectTable Table containing the string keys of all ground objects built on the provided planet.
-- @tparam table sObjectTable Table containing the string keys of all space objects built on the provided planet.
-- @within Debugging Functions
function debugPlanetSelected( planetStringKey, gObjectTable, sObjectTable )
    Create_Thread( "tOutPlanetSelected", { planetStringKey, gObjectTable, sObjectTable } )
end
--- Threaded output for the planet selected message push.
-- @tparam table table
-- @within Threaded Output Handler
function tOutPlanetSelected( table )
    local debugEvent = Get_Story_Plot( "__luaFramework/libErrorHandler/libErrorHandler.xml" ).Get_Event( "libErrorHandler_DisplayErrorMessage" )
    local dialogFile = "libDebugHandlerDialog"
    debugEvent.Set_Dialog( dialogFile )
    debugEvent.Clear_Dialog_Text()
    debugEvent.Add_Dialog_Text( "TEXT_DEBUG_TYPE_PLANET_SELECTED", table[1] )
    if table[2] then
        debugEvent.Add_Dialog_Text( "TEXT_DEBUG_TYPE_PLANET_SELECTED_GROUNDBUILDINGS" )
        for _,key in pairs( table[2] ) do
            debugEvent.Add_Dialog_Text( "TEXT_OUT_FORMATTED_TAB1", key )
        end
    end
    if table[3] then
        debugEvent.Add_Dialog_Text( "TEXT_DEBUG_TYPE_PLANET_SELECTED_SPACEBUILDINGS" )
        for _,key in pairs( table[3] ) do
            debugEvent.Add_Dialog_Text( "TEXT_OUT_FORMATTED_TAB1", key )
        end
    end
    Story_Event( "libErrorHandler_DisplayErrorMessage_Trigger" )
end
--- Displays a (timed) event executuion message via the mission holochron.
-- @tparam string eventType
-- @tparam string isTimed
-- @tparam string eventTimer
-- @within Debugging Functions
function debugEventExecuted( eventType, isTimed, eventTimer )
    Create_Thread( "tOutEventExecuted", { eventType, isTimed, eventTimer } )
end
--- Threaded output (timed) event executuion message push.
-- @tparam table table
-- @within Threaded Output Handler
function tOutEventExecuted( table )
    local debugEvent = Get_Story_Plot( "__luaFramework/libErrorHandler/libErrorHandler.xml" ).Get_Event( "libErrorHandler_DisplayErrorMessage" )
    local dialogFile = "libDebugHandlerDialog"
    debugEvent.Set_Dialog( dialogFile )
    debugEvent.Clear_Dialog_Text()
    debugEvent.Add_Dialog_Text( "TEXT_DEBUG_TYPE_EVENT_EXECUTED" )
    debugEvent.Add_Dialog_Text( "TEXT_DEBUG_EXECUTED_EVENT_TYPE", table[1] )
    if table[2] then
        debugEvent.Add_Dialog_Text( "TEXT_DEBUG_EXECUTED_EVENT_TIMED" )
        debugEvent.Add_Dialog_Text( "TEXT_DEBUG_EXECUTED_EVENT_TIMED_EXECUTED_WITH_DELAY", table[3] )
    end
    Story_Event( "libErrorHandler_DisplayErrorMessage_Trigger" )
end
--- Displays a GUI element (un-)locked message via the mission holochron.
-- @tparam string guiElemStringKey
-- @tparam string evtType
-- @within Debugging Functions
function debugGUIElementLockUnlockEvent( guiElemStringKey, evtType )
    Create_Thread( "tOutGUIElementLockUnlockEvent", { guiElemStringKey, evtType } )
end
--- Threaded output for the GUI element (un-)locked message push.
-- @tparam table table
-- @within Threaded Output Handler
function tOutGUIElementLockUnlockEvent( table )
    local debugEvent = Get_Story_Plot( "__luaFramework/libErrorHandler/libErrorHandler.xml" ).Get_Event( "libErrorHandler_DisplayErrorMessage" )
    local dialogFile = "libDebugHandlerDialog"
    debugEvent.Set_Dialog( dialogFile )
    debugEvent.Clear_Dialog_Text()
    if table[2] == "LOCK" then
        debugEvent.Add_Dialog_Text( "TEXT_DEBUG_TYPE_GUI_ELEMENT_LOCKED", table[1] )
    else
        debugEvent.Add_Dialog_Text( "TEXT_DEBUG_TYPE_GUI_ELEMENT_UNLOCKED", table[1] )
    end
    Story_Event( "libErrorHandler_DisplayErrorMessage_Trigger" )
end
--- Displays a list of available buildings for a given faction via the mission holochron.
-- @tparam string playerFactionKey
-- @tparam table objectStringTable
-- @within Debugging Functions
function debugAvailableObjectType( playerFactionKey, objectStringTable )
    Create_Thread( "tOutAvailableObjectType", { playerFactionKey, objectStringTable })
end
--- Threaded output for the available buildings message push.
-- @tparam table table
-- @within Threaded Output Handler
function tOutAvailableObjectType( table )
    local debugEvent = Get_Story_Plot( "__luaFramework/libErrorHandler/libErrorHandler.xml" ).Get_Event( "libErrorHandler_DisplayErrorMessage" )
    local dialogFile = "libDebugHandlerDialog"
    debugEvent.Set_Dialog( dialogFile )
    debugEvent.Clear_Dialog_Text()
    debugEvent.Add_Dialog_Text( "TEXT_DEBUG_BUILDINGS_AVAILABLE_FOR_PLAYER", table[1] )
    for i,struct in pairs( table[2] ) do
        debugEvent.Add_Dialog_Text( "TEXT_DEBUG_BUILDINGS_AVAILABLE_MSG_TYPE", table[2][i][1] )
        debugEvent.Add_Dialog_Text( "TEXT_DEBUG_BUILDINGS_AVAILABLE_MSG_BUILDABLE", table[2][i][2] )
    end
    Story_Event( "libErrorHandler_DisplayErrorMessage_Trigger" )
end
--- Displays a message if an enemy fleet is orbiting a planet.
-- @tparam string planetStringKey
-- @within Debugging Functions
function debugPlanetContested( planetStringKey )
    Create_Thread( "tOutPlanetContested", planetStringKey )
end
--- Threaded output for the planet selected message push.
-- @tparam string planetStringKey
-- @within Threaded Output Handler
function tOutPlanetContested( planetStringKey )
    local debugEvent = Get_Story_Plot( "__luaFramework/libErrorHandler/libErrorHandler.xml" ).Get_Event( "libErrorHandler_DisplayErrorMessage" )
    local dialogFile = "libDebugHandlerDialog"
    debugEvent.Set_Dialog( dialogFile )
    debugEvent.Clear_Dialog_Text()
    debugEvent.Add_Dialog_Text( "TEXT_DEBUG_TYPE_PLANET_CONTESTED", planetStringKey )
    Story_Event( "libErrorHandler_DisplayErrorMessage_Trigger" )
end

--- Displays a faction's raw military strength.
-- @tparam string factionStringKey
-- @tparam number factionStrength
-- @within Debugging Functions
function debugFactionRawMilitaryStrength( factionStringKey, factionStrength )
    Create_Thread( "tOutFactionRawMilitaryStrength", { factionStringKey, factionStrength } )
end
--- Threaded output for the faction's raw military strength push.
-- @tparam table table
-- @within Threaded Output Handler
function tOutFactionRawMilitaryStrength( table )
    local debugEvent = Get_Story_Plot( "__luaFramework/libErrorHandler/libErrorHandler.xml" ).Get_Event( "libErrorHandler_DisplayErrorMessage" )
    local dialogFile = "libDebugHandlerDialog"
    debugEvent.Set_Dialog( dialogFile )
    debugEvent.Clear_Dialog_Text()
    debugEvent.Add_Dialog_Text( "TEXT_DEBUG_FACTION_MILITARY_STRENGTH_FAC", table[1])
    debugEvent.Add_Dialog_Text( "TEXT_DEBUG_FACTION_MILITARY_STRENGTH_VAL", table[2] )
    Story_Event( "libErrorHandler_DisplayErrorMessage_Trigger" )
end

function debugFoundSuitablePlanetInReach( planetStringKey, factionStringKey )
    Create_Thread( "tOutFoundSuitablePlanetInReach", { planetStringKey, factionStringKey } )
end
--- Threaded output for the faction's raw military strength push.
-- @tparam table table
-- @within Threaded Output Handler
function tOutFoundSuitablePlanetInReach( table )
    local debugEvent = Get_Story_Plot( "__luaFramework/libErrorHandler/libErrorHandler.xml" ).Get_Event( "libErrorHandler_DisplayErrorMessage" )
    local dialogFile = "libDebugHandlerDialog"
    debugEvent.Set_Dialog( dialogFile )
    debugEvent.Clear_Dialog_Text()
    debugEvent.Add_Dialog_Text( "TEXT_DEBUG_REACHABLE_PLANET_FOUND_00")
    debugEvent.Add_Dialog_Text( "TEXT_DEBUG_REACHABLE_PLANET_FOUND_01", table[1], table[2] )
    Story_Event( "libErrorHandler_DisplayErrorMessage_Trigger" )
end

function debugRandomPlanetInReach( planetStringKey, factionStringKey )
    Create_Thread( "tOutRandomPlanetInReach", { planetStringKey, factionStringKey } )
end
--- Threaded output for the faction's raw military strength push.
-- @tparam table table
-- @within Threaded Output Handler
function tOutRandomPlanetInReach( table )
    local debugEvent = Get_Story_Plot( "__luaFramework/libErrorHandler/libErrorHandler.xml" ).Get_Event( "libErrorHandler_DisplayErrorMessage" )
    local dialogFile = "libDebugHandlerDialog"
    debugEvent.Set_Dialog( dialogFile )
    debugEvent.Clear_Dialog_Text()
    debugEvent.Add_Dialog_Text( "TEXT_DEBUG_RANDOM_REACHABLE_PLANET_FOUND_00")
    debugEvent.Add_Dialog_Text( "TEXT_DEBUG_RANDOM_REACHABLE_PLANET_FOUND_01", table[1], table[2] )
    Story_Event( "libErrorHandler_DisplayErrorMessage_Trigger" )
end
