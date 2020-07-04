-- ===== ===== ===== ===== =====
-- Copyright (c) 2017 Lukas Grünwald
-- License       MIT License
-- ===== ===== ===== ===== =====

--- cEvent_Type_SpawnUnits
-- Spawns a desired unit struct at the desired galactic locations.
-- The Event does NOT care whether the galactic location is owned by the player the units are being spawned for or not.
-- DO NOT USE THIS EVENT TO SPAWN BUILDINGS IN: There is another event to handle that, which is aware of free build spots so it does not overpopulate a planet.

require( "PGBase" )
-- Import new functions:
require( "libErrorFunctions" )
require( "libDebugFunctions" )
-- Import new classes:
require( "cEvent" )
require( "cPlanet" )
require( "libPGGenericFunctionLibrary" )

cEvent_Type_SpawnUnits = {}
cEvent_Type_SpawnUnits.__index = cEvent_Type_SpawnUnits
setmetatable( cEvent_Type_SpawnUnits, { __index = cEvent } )
--- Constructor.
-- Creates a new LUA object of type cEvent_Type_SpawnUnits.
-- @tparam cEventHandler parentEventHandler
-- @tparam string rinfStructID ID of the reinforcement struct to call.
-- @tparam table posTable Position to spawn the objects.
-- @tparam PlayerObject ownObj Owner to spawn the objects for.
-- @tparam number newTimer Optional timer.
-- @within Constructor
function cEvent_Type_SpawnUnits.New( parentEventHandler, rinfStructID, posTable, ownObj, newTimer )
    local self = setmetatable( {}, cEvent_Type_SpawnUnits )
    self.Parent                  = parentEventHandler
    self.Type                    = "TEXT_LUA_OBJECT_TYPE_EVENT_SPAWNUNITS"
    self.ReinforceStructID       = rinfStructID
    self.SpawnPositions          = posTable
    self.OwnerObject             = ownObj
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
function cEvent_Type_SpawnUnits:Execute()
    local unitTable = UnwrapUnitsFromFleetStruct( self.ReinforceStructID )
    if unitTable then
        for _,posObj in pairs( self.SpawnPositions ) do
            local spawnedTable = SpawnList( unitTable, posObj, self.OwnerObject, true, true )
            -- Make sure the fleet does initiate a battle when spawned on an enemy planet.
            -- Also make sure that the reward fleet is spawned as separate fleet, provided there are empty fleet parking lots.
            local spawnedFleet = Assemble_Fleet( spawnedTable )
            spawnedFleet.Move_To( posObj )
        end
    end

end

return cEvent_Type_SpawnUnits
