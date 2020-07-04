-- ===== ===== ===== ===== =====
-- Copyright (c) 2017 Lukas Grünwald
-- License       MIT License
-- ===== ===== ===== ===== =====

--- cEvent_Type_DIPLTurnPlanet.
-- This turns a planet gracefully; All units are allowed to be evacuated;

-- Import new functions:
require( "libErrorFunctions" )
require( "libDebugFunctions" )
-- Import new classes:
require( "cEvent" )
require( "cPlanet" )

cEvent_Type_DIPLTurnPlanet = {}
cEvent_Type_DIPLTurnPlanet.__index = cEvent_Type_DIPLTurnPlanet
setmetatable( cEvent_Type_DIPLTurnPlanet, { __index = cEvent } )
--- Constructor.
-- Creates a new LUA object of type cEvent_Type_DIPLTurnPlanet.
-- @tparam cEventHandler parentEventHandler
-- @within Constructor
function cEvent_Type_DIPLTurnPlanet.New( parentEventHandler, cPlanetObj, cNewOwner, newTimer )
    local self = setmetatable( {}, cEvent_Type_DIPLTurnPlanet )
    self.Parent                  = parentEventHandler
    self.Type                    = "TEXT_LUA_OBJECT_TYPE_EVENT_DIPLTURNPLANET"
    self.CPlanet                 = cPlanetObj
    self.NewOwner                = cNewOwner
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
function cEvent_Type_DIPLTurnPlanet:Execute()
    self.CPlanet:ChangeOwner( self.NewOwner )
    -- Kad 23/06/2017 16:48:32 - TODO: Team decision: should we handle evacuation so that units are moved as one fleet instead of derpy-derp
end

return cEvent_Type_DIPLTurnPlanet
