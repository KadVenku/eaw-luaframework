-- ===== ===== ===== ===== =====
-- Copyright (c) 2017 Lukas Grünwald
-- License       MIT License
-- ===== ===== ===== ===== =====

-- Import new functions:
require( "libErrorFunctions" )
require( "libDebugFunctions" )
require( "libPGGenericFunctionLibrary" )
-- Import new classes:
require( "cEvent" )
require( "cEvent_Type_Testevent" )
require( "cEvent_Type_FleetHyperspaceAccident" )
require( "cEvent_Type_SpawnUnits" )
require( "cEvent_Type_DIPLStartDiplomaticMission" )
require( "cEvent_Type_DIPLEndDiplomaticMission" )
require( "cEvent_Type_DIPLCheckFactionAlliance" )
require( "cEvent_Type_DIPLTurnPlanet" )
require( "cEvent_Type_OrbitalBombardmentBegin" )
require( "cEvent_Type_OrbitalBombardmentBurst" )
require( "cEvent_Type_OrbitalBombardmentEnd" )

--- Basic cEventHandler class

cEventHandler = {}
cEventHandler.__index = cEventHandler
--- {public} Constructor.
-- @tparam cGalacticConquest parentGC
-- @within Initialisation
function cEventHandler.New( parentGC )
    local self = setmetatable( {}, cEventHandler )
    self.Parent = parentGC
    self.EventQueue = { }
    self.Working = false

    return self
end

--- {public} Tests whether the event handler is currently serving an event queue.
-- @treturn bool
-- @within Getter Functions
function cEventHandler:IsWorking()
    return self.Working
end
--- {public} Returns the number of queued events.
-- @treturn int
-- @within Getter Functions
function cEventHandler:GetEventCount()
    return table.getn( self.EventQueue )
end
--- {private} Sets the working status.
-- @tparam bool newStatus
function cEventHandler:SetWorking( newStatus )
    self.Working = newStatus
end
--- {public} Serves the event queue.
function cEventHandler:ServeEvents()
    self:SetWorking( true )
    if table.getn( self.EventQueue ) > 0 then
        for eventID, cEventObject in pairs( self.EventQueue) do
            if cEventObject:IsTimedEvent() then
                if cEventObject:IsReadyToExecute() then
                    cEventObject:Execute()
                    self.EventQueue[eventID] = nil
                end
            else
                cEventObject:Execute()
                self.EventQueue[eventID] = nil
            end
        end
    end
    self:SetWorking( false )
end
--- {public} Registers a new event to the event queue.
-- @tparam string newEventTypeString
-- @tparam table eventArgumentTable
function cEventHandler:RegisterNewEvent( newEventTypeString, eventArgumentTable )
    if self:IsValidEventType( newEventTypeString ) then
        local newEvent = false
        if newEventTypeString == "EVENT_TYPE_TESTEVENT" then
            newEvent = cEvent_Type_Testevent.New( self, eventArgumentTable.Timer )
        elseif newEventTypeString == "EVENT_TYPE_FLEETHYPERSPACEACCIDENT" then
            newEvent = cEvent_Type_FleetHyperspaceAccident.New( self, eventArgumentTable.FleetObject, eventArgumentTable.Timer )
        elseif newEventTypeString == "EVENT_TYPE_SPAWNUNITS" then
            newEvent = cEvent_Type_SpawnUnits.New( self, eventArgumentTable.ReinforceStructID, eventArgumentTable.ReinforcePositionTable, eventArgumentTable.OwnerObject, eventArgumentTable.Timer )
        elseif newEventTypeString == "EVENT_TYPE_DIPLSTARTDIPLOMATICMISSION" then
            newEvent = cEvent_Type_DIPLStartDiplomaticMission.New( self, eventArgumentTable.GameObjectTypeLUAObject, eventArgumentTable.GameObjectReference, eventArgumentTable.PlanetLUAObject, eventArgumentTable.Timer )
        elseif newEventTypeString == "EVENT_TYPE_DIPLENDDIPLOMATICMISSION" then
            newEvent = cEvent_Type_DIPLEndDiplomaticMission.New( self, eventArgumentTable.GameObjectTypeLUAObject, eventArgumentTable.FactionLUAObject,  eventArgumentTable.PlanetLUAObject, eventArgumentTable.Timer )
        elseif newEventTypeString == "EVENT_TYPE_DIPLCHECKFACTIONALLIANCE" then
            newEvent = cEvent_Type_DIPLCheckFactionAlliance.New( self, eventArgumentTable.FactionLUAObjectOwner, eventArgumentTable.FactionLUAObjectContestor,  eventArgumentTable.Timer )
        elseif newEventTypeString == "EVENT_TYPE_DIPLTURNPLANET" then
            newEvent = cEvent_Type_DIPLTurnPlanet.New( self, eventArgumentTable.PlanetLUAObject, eventArgumentTable.FactionLUAObjectNewOwner, eventArgumentTable.Timer )
        elseif newEventTypeString == "EVENT_TYPE_DIPLMAKEALLIES" then
            newEvent = cEvent_Type_DIPLMakeAllies.New( self, eventArgumentTable.CFactionMajor, eventArgumentTable.CFactionMinor, eventArgumentTable.Timer )
        elseif newEventTypeString == "EVENT_TYPE_DIPLUPDATEALLIANCERATING" then
            newEvent = cEvent_Type_DIPLUpdateAllianceRating.New( self, eventArgumentTable.CFactionMajor, eventArgumentTable.CFactionMinor, eventArgumentTable.Timer )
        elseif newEventTypeString == "EVENT_TYPE_PDORBITALBOMBARDMENTBEGIN" then
                newEvent = cEvent_Type_OrbitalBombardmentBegin.New( self, eventArgumentTable.TargetPlanet, eventArgumentTable.BombardingFaction, eventArgumentTable.Timer )
        elseif newEventTypeString == "EVENT_TYPE_PDORBITALBOMBARDMENTBURST" then
            newEvent = cEvent_Type_OrbitalBombardmentBurst.New( self, eventArgumentTable.TargetPlanet, eventArgumentTable.BombardingFaction, eventArgumentTable.Timer )
        elseif newEventTypeString == "EVENT_TYPE_PDORBITALBOMBARDMENTEND" then
                newEvent = cEvent_Type_OrbitalBombardmentEnd.New( self, eventArgumentTable.TargetPlanet, eventArgumentTable.BombardingFaction, eventArgumentTable.Timer )
        end
        if newEvent then
            table.insert( self.EventQueue, newEvent )
        else
            ThrowEventNotRegisteredError()
        end
    else
        ThrowEventNotRegisteredError()
    end
end

--- {private} Tests for event type validity.
-- @tparam string newEventTypeString
-- @within Validation and Error Handling
function cEventHandler:IsValidEventType( newEventTypeString )
    local ValidEventTypes = require( "libStaticEventTypeDefinitions" )
    return IsContentOfTable( ValidEventTypes, newEventTypeString )
end

return cEventHandler
