-- ===== ===== ===== ===== =====
-- Copyright (c) 2017 Lukas Grünwald
-- License       MIT License
-- ===== ===== ===== ===== =====

-- Import new functions:
require( "libErrorFunctions" )
require( "libDebugFunctions" )
-- Import new classes:
require( "cEvent" )
require( "cPlanet" )

cEvent_Type_OrbitalBombardmentBegin = {}
cEvent_Type_OrbitalBombardmentBegin.__index = cEvent_Type_OrbitalBombardmentBegin
setmetatable( cEvent_Type_OrbitalBombardmentBegin, { __index = cEvent } )
--- Constructor.
-- Creates a new LUA object of type cEvent_Type_OrbitalBombardmentBegin.
-- @tparam cEventHandler parentEventHandler
-- @within Constructor
function cEvent_Type_OrbitalBombardmentBegin.New( parentEventHandler, cPlanetToBombard, cFactionBombarding, newTimer )
    local self = setmetatable( {}, cEvent_Type_OrbitalBombardmentBegin )
    self.Parent                  = parentEventHandler
    self.Type                    = "TEXT_LUA_OBJECT_TYPE_EVENT_ORBITALBOMBARDMENTBEGIN"
    self.CPlanetToBombard        = cPlanetToBombard
    self.CFactionBombarding      = cFactionBombarding
    if newTimer == nil then
        self.IsTimed             = false
        self.RegisteredTimestamp = false
        self.Timer               = false
    else
        self.IsTimed             = true
        self.RegisteredTimestamp = GetCurrentTime()
        self.Timer               = newTimer
    end

    return self
end
--- Executes the event.
function cEvent_Type_OrbitalBombardmentBegin:Execute()
    local timer = 0
    -- Kad 03/07/2017 14:35:28 - Register as many bombardment bursts as the configuration allows.
    for i = 1, require( "configGlobalSettings" ).gSetting_PD_BombardmentBurstCount, 1 do
        self.Parent.Parent:RegisterEvent( "EVENT_TYPE_PDORBITALBOMBARDMENTBURST", { TargetPlanet = self.CPlanetToBombard, BombardingFaction = self.CFactionBombarding, Timer = timer, } )
        timer = timer + GameRandom( require( "configGlobalSettings" ).gSetting_PD_BombardmentBurstIntervalMin, require( "configGlobalSettings" ).gSetting_PD_BombardmentBurstIntervalMax )
    end
    self.Parent.Parent:RegisterEvent( "EVENT_TYPE_PDORBITALBOMBARDMENTEND", { TargetPlanet = self.CPlanetToBombard, BombardingFaction = self.CFactionBombarding, Timer = timer, } )
    if self.CPlanetToBombard:GetOwner():GetIsHumanPlayer() then
        -- Kad 07/07/2017 13:00:10 - Center camera on planet and add screen text:
        local pointCameraEvent = Get_Story_Plot( "__luaFramework/cGUIHandler/cGUIForcedInteractions.xml" ).Get_Event( "cGUIHandler_ForcedCameraPosition" )
        pointCameraEvent.Set_Reward_Parameter( 0, self.CPlanetToBombard:GetName() )
        Story_Event( "cGUIHandler_ForcedCameraPosition_Trigger" )
        local screenMessageEvent = Get_Story_Plot( "__luaFramework/cGUIHandler/cGUIMissionHolochronOutput.xml" ).Get_Event( "info_GenericScreenSpaceMessage" )
        screenMessageEvent.Set_Reward_Parameter( 0, "TEXT_MESSAGE_EVENT_PLANET_DEATH_BOMBARDMENT_UNDER_PROGRESS" )
        Story_Event( "info_GenericScreenSpaceMessage_Trigger" )
    elseif self.CCFactionBombarding:GetIsHumanPlayer() then
        local pointCameraEvent = Get_Story_Plot( "__luaFramework/cGUIHandler/cGUIForcedInteractions.xml" ).Get_Event( "cGUIHandler_ForcedCameraPosition" )
        pointCameraEvent.Set_Reward_Parameter( 0, self.CPlanetToBombard:GetName() )
        Story_Event( "cGUIHandler_ForcedCameraPosition_Trigger" )
    end
end

--[[ Kad 03/07/2017 14:39:40 - TODO:
Set up:
    If the bombardment does not succeed in breaking the shield and taking down the planet's HP, the planet won't count as destroyed via bombardment, but the health won't be restored. Shield points, unless destroyed, will be fully replenished.
]]

return cEvent_Type_OrbitalBombardmentBegin
