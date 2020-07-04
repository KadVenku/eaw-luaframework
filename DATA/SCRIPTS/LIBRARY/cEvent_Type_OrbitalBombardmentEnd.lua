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

cEvent_Type_OrbitalBombardmentEnd = {}
cEvent_Type_OrbitalBombardmentEnd.__index = cEvent_Type_OrbitalBombardmentEnd
setmetatable( cEvent_Type_OrbitalBombardmentEnd, { __index = cEvent } )
--- Constructor.
-- Creates a new LUA object of type cEvent_Type_OrbitalBombardmentEnd.
-- @tparam cEventHandler parentEventHandler
-- @within Constructor
function cEvent_Type_OrbitalBombardmentEnd.New( parentEventHandler, cPlanetToBombard, cFactionBombarding, newTimer )
    local self = setmetatable( {}, cEvent_Type_OrbitalBombardmentEnd )
    self.Parent                  = parentEventHandler
    self.Type                    = "TEXT_LUA_OBJECT_TYPE_EVENT_PDORBITALBOMBARDMENTEND"
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
function cEvent_Type_OrbitalBombardmentEnd:Execute()
    Remove_All_Text()
    if self.CPlanetToBombard:IsShielded() and self.CPlanetToBombard:GetShield() > 0 then -- Kad 07/07/2017 15:13:13 - Ouch, that was a fail, the shield's still up!
        if self.CFactionBombarding:GetIsHumanPlayer() then
            self:DisplayMissionFailure( true, true )
        elseif self.CPlanetToBombard:GetOwner():GetIsHumanPlayer() then
            self:DisplayMissionFailure( false, true )
        end
    elseif self.CPlanetToBombard:GetHealth() > 0 then
        if self.CFactionBombarding:GetIsHumanPlayer() then
            self:DisplayMissionFailure( true, false )
        elseif self.CPlanetToBombard:GetOwner():GetIsHumanPlayer() then
            self:DisplayMissionFailure( false, false )
        end
    else -- Kad 14/07/2017 14:55:17 - Bombardment succeeded.
        if self.CFactionBombarding:GetIsHumanPlayer() then
            self:DisplayMissionSuccess( true )
        elseif self.CPlanetToBombard:GetOwner():GetIsHumanPlayer() then
            self:DisplayMissionSuccess( false )
        end
        self.CPlanetToBombard:AdvanceState( "STATE_BOMBARDED" )
        -- Kad 14/07/2017 14:54:05 - TODO: Register refugees.
    end
end

function cEvent_Type_OrbitalBombardmentEnd:DisplayMissionFailure( attacker, shieldStillUp )
    local hcTriggerEvent = Get_Story_Plot( "__luaFramework/cGUIHandler/cGUIMissionHolochronOutput.xml" ).Get_Event( "info_PlanetaryBombardmentFailure" )
    hcTriggerEvent.Clear_Dialog_Text()
    hcTriggerEvent.Add_Dialog_Text( "TEXT_MISSION_CONTENT_PLANETARY_BOMBARDMENT_FAILURE_LOCATION", self.CPlanetToBombard:GetStringKey() )
    if attacker then
        if shieldStillUp then
            hcTriggerEvent.Add_Dialog_Text( "TEXT_MISSION_CONTENT_PLANETARY_BOMBARDMENT_FAILURE_SHIELD_UP_A00" )
            hcTriggerEvent.Add_Dialog_Text( "TEXT_MISSION_CONTENT_PLANETARY_BOMBARDMENT_FAILURE_SHIELD_UP_A01", self.CPlanetToBombard:GetShield() * 100 )
        else
            hcTriggerEvent.Add_Dialog_Text( "TEXT_MISSION_CONTENT_PLANETARY_BOMBARDMENT_FAILURE_LANDMASS_INTACT_A00" )
            hcTriggerEvent.Add_Dialog_Text( "TEXT_MISSION_CONTENT_PLANETARY_BOMBARDMENT_FAILURE_LANDMASS_INTACT_A01", self.CPlanetToBombard:GetHealth() * 100 )
        end
    else
        if shieldStillUp then
            hcTriggerEvent.Add_Dialog_Text( "TEXT_MISSION_CONTENT_PLANETARY_BOMBARDMENT_FAILURE_SHIELD_UP_D00" )
            hcTriggerEvent.Add_Dialog_Text( "TEXT_MISSION_CONTENT_PLANETARY_BOMBARDMENT_FAILURE_SHIELD_UP_D01", self.CPlanetToBombard:GetShield() * 100 )
        else
            hcTriggerEvent.Add_Dialog_Text( "TEXT_MISSION_CONTENT_PLANETARY_BOMBARDMENT_FAILURE_LANDMASS_INTACT_D00" )
            hcTriggerEvent.Add_Dialog_Text( "TEXT_MISSION_CONTENT_PLANETARY_BOMBARDMENT_FAILURE_LANDMASS_INTACT_D01", self.CPlanetToBombard:GetHealth() * 100 )
        end
    end
    Story_Event( "info_PlanetaryBombardmentFailure_Trigger" )
end

function cEvent_Type_OrbitalBombardmentEnd:DisplayMissionSuccess( attacker )
    local hcTriggerEvent = Get_Story_Plot( "__luaFramework/cGUIHandler/cGUIMissionHolochronOutput.xml" ).Get_Event( "info_PlanetaryBombardmentSuccess" )
    hcTriggerEvent.Clear_Dialog_Text()
    hcTriggerEvent.Add_Dialog_Text( "TEXT_MISSION_CONTENT_PLANETARY_BOMBARDMENT_SUCCESS_LOCATION", self.CPlanetToBombard:GetStringKey() )
    if attacker then
        hcTriggerEvent.Add_Dialog_Text( "TEXT_MISSION_CONTENT_PLANETARY_BOMBARDMENT_SUCCESS_CONSEQUENCES_A00" )
        hcTriggerEvent.Add_Dialog_Text( "TEXT_MISSION_CONTENT_PLANETARY_BOMBARDMENT_SUCCESS_CONSEQUENCES_A01" )
    else
        hcTriggerEvent.Add_Dialog_Text( "TEXT_MISSION_CONTENT_PLANETARY_BOMBARDMENT_SUCCESS_CONSEQUENCES_D00" )
    end
    Story_Event( "info_PlanetaryBombardmentSuccess_Trigger" )
end

return cEvent_Type_OrbitalBombardmentEnd
