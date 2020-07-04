-- ===== ===== ===== ===== =====
-- Copyright (c) 2017 Lukas Grünwald
-- License       MIT License
-- ===== ===== ===== ===== =====

--- Class: cEvent_Type_DIPLStartDiplomaticMission
-- Creates a timed diplomatic event and de-spawns the diplomat.

-- Import new functions:
require( "libErrorFunctions" )
require( "libDebugFunctions" )
-- Import new classes:
require( "cEvent" )

cEvent_Type_DIPLStartDiplomaticMission = {}
cEvent_Type_DIPLStartDiplomaticMission.__index = cEvent_Type_DIPLStartDiplomaticMission
setmetatable( cEvent_Type_DIPLStartDiplomaticMission, { __index = cEvent } )
--- Constructor.
-- Creates a new LUA object of type cEvent_Type_DIPLStartDiplomaticMission.
-- @tparam cEventHandler parentEventHandler
-- @within Constructor
function cEvent_Type_DIPLStartDiplomaticMission.New( parentEventHandler, cGameObjDiplomat, cGObjDiplomatReference,  cPlanetLocation, newTimer )
    local self = setmetatable( {}, cEvent_Type_DIPLStartDiplomaticMission )
    self.Parent                  = parentEventHandler
    self.Type                    = "TEXT_LUA_OBJECT_TYPE_EVENT_DIPLSTARTDIPLOMATICMISSION"
    self.DiplomatType            = self.Parent.Parent.ObjectManager:GetCGameObjectTypeByReference( cGObjDiplomatReference )
    self.DiplomatObject          = cGObjDiplomatReference
    self.Planet                  = cPlanetLocation
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
function cEvent_Type_DIPLStartDiplomaticMission:Execute()
    if TestValid( self.DiplomatObject ) then
        if self.DiplomatObject.Get_Planet_Location() == self.Planet:GetPlanetLocation() then
            self.Planet:SetActiveDiplomaticMission()
            local missionDuration = 9999
            -- Kad 18/06/2017 15:52:15 - A wrongly configured object could have several diplomat traits, we'll use the one trait with the smallest delay:
            if self.DiplomatType then
                for _,objTrait in pairs( self.DiplomatType.Traits ) do
                    if objTrait.DiplomaticMissionDuration > 0 then
                        if objTrait.DiplomaticMissionDuration < missionDuration then
                            missionDuration = objTrait.DiplomaticMissionDuration
                        end
                    end
                end
            else
                missionDuration = require( "configGlobalSettings" ).gSetting_Diplomacy_MissionDurationFallback
            end
            local diplomatFaction = self.Parent.Parent:GetFactionObjectByPlayerObject( self.DiplomatObject.Get_Owner() )
            local lDipMission = { Planet = self.Planet, Diplomat = self.DiplomatType, TimeInitialised = GetCurrentTime(), Timer = missionDuration, }
            -- Kad 19/06/2017 15:37:43 - Register end event. That is actually doing all the work.
            self.Parent.Parent:RegisterEvent( "EVENT_TYPE_DIPLENDDIPLOMATICMISSION", { GameObjectTypeLUAObject = self.DiplomatType, FactionLUAObject = diplomatFaction, PlanetLUAObject = self.Planet , Timer = missionDuration } )
            -- Kad 18/06/2017 15:47:12 - Despawning the diplomat.
            self.DiplomatObject.Despawn()
            -- Kad 19/06/2017 14:05:18 - Display active mission if human:
            diplomatFaction:AddDiplomaticMission( lDipMission )
            if diplomatFaction:GetIsHumanPlayer() then -- Kad 22/06/2017 14:30:44 - We only want to get the value, not update it.
                diplomatFaction:ClearDiplomaticMissionHolochron()
                diplomatFaction:UpdateDiplomaticMissionHolochron()
            end
        end
    end
end

return cEvent_Type_DIPLStartDiplomaticMission
