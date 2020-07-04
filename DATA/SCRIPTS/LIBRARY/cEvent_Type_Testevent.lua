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

cEvent_Type_Testevent = {}
cEvent_Type_Testevent.__index = cEvent_Type_Testevent
setmetatable( cEvent_Type_Testevent, { __index = cEvent } )
--- Constructor.
-- Creates a new LUA object of type cEvent_Type_Testevent.
-- @tparam cEventHandler parentEventHandler
-- @within Constructor
function cEvent_Type_Testevent.New( parentEventHandler, newTimer )
    local self = setmetatable( {}, cEvent_Type_Testevent )
    self.Parent                  = parentEventHandler
    self.Type                    = "TEXT_LUA_OBJECT_TYPE_EVENT_TEST"
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
function cEvent_Type_Testevent:Execute()
    debugEventExecuted( self:GetObjectType(), self:IsTimedEvent(), self:GetTimer() )
end

return cEvent_Type_Testevent
