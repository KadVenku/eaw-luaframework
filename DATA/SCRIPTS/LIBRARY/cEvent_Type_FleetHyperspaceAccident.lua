-- ===== ===== ===== ===== =====
-- Copyright (c) 2017 Kad Venku
-- License       MIT License
-- ===== ===== ===== ===== =====

--- Class cEvent_Type_FleetHyperspaceAccident.
-- Executes fleet hyperspace accidents.

-- Import new functions:
require( "libErrorFunctions" )
require( "libDebugFunctions" )
require( "libPGGenericFunctionLibrary" )
-- Import new classes:
require( "cEvent" )

cEvent_Type_FleetHyperspaceAccident = {}
cEvent_Type_FleetHyperspaceAccident.__index = cEvent_Type_FleetHyperspaceAccident
setmetatable( cEvent_Type_FleetHyperspaceAccident, { __index = cEvent } )
--- Constructor.
-- Creates a new LUA object of type cEvent_Type_FleetHyperspaceAccident.
-- @tparam cEventHandler parentEventHandler
-- @tparam FleetObject fleetObject
-- @tparam integer newTimer
-- @within Constructor
function cEvent_Type_FleetHyperspaceAccident.New( parentEventHandler, fleetObject, newTimer )
    local self = setmetatable( {}, cEvent_Type_FleetHyperspaceAccident )
    self.Parent                  = parentEventHandler
    self.Type                    = "TEXT_LUA_OBJECT_TYPE_EVENT_FLEETHYPERSPACEACCIDENT"
    self.FleetObject             = fleetObject
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
function cEvent_Type_FleetHyperspaceAccident:Execute()
    local minShipsDestroyed = require( "configGlobalSettings" ).gSetting_FleetHyperspaceAccident_MinShipsDestroyed
    local maxShipsDestroyed = require( "configGlobalSettings" ).gSetting_FleetHyperspaceAccident_MaxShipsDestroyed
    local destructionParticle = require( "configGlobalSettings" ).gSetting_FleetHyperspaceAccident_DestructionParticle
    local destroyedObjectPercentage = ClampValue( GameRandom.Get_Float(), minShipsDestroyed, maxShipsDestroyed )
    Create_Generic_Object( destructionParticle, self.FleetObject.Get_Position(), Find_Player( "Neutral" ) )
    if self.FleetObject.Get_Owner().Is_Human() then
        Game_Message("TEXT_MESSAGE_EVENT_FLEET_HYPERSPACE_ACCIDENT")
    end
    self.FleetObject.Destroy_Contained_Objects( destroyedObjectPercentage )
end

return cEvent_Type_FleetHyperspaceAccident
