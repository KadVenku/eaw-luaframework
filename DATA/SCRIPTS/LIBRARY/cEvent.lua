-- ===== ===== ===== ===== =====
-- Copyright (c) 2017 Kad Venku
-- License       MIT License
-- ===== ===== ===== ===== =====

--- {abstract} Event base class.
-- All event inherit their functionality from this.

-- Import new functions:
require( "libErrorFunctions" )
require( "libDebugFunctions" )

cEvent = {}
cEvent.__index = cEvent

--- {abstract} Constructor.
-- @tparam cEventHandler parentEventHandler Needs the access to the event handler, so it can communicate with all objects.
-- @within Constructor
function cEvent.New( parentEventHandler )
local self = setmetatable( {}, cEvent )
    self.Parent              = parentEventHandler
    self.Type                = "TEXT_LUA_OBJECT_TYPE_EVENT_BASIC"
    self.IsTimed             = false
    self.RegisteredTimestamp = false
    self.Timer               = false
    return self
end
--- Returns the IsTimed attribute.
-- @treturn bool
-- @within Getter Functions
function cEvent:IsTimedEvent()
    return self.IsTimed
end
--- Returns the event type.
-- @treturn string
-- @within Getter Functions
function cEvent:GetObjectType()
    return self.Type
end
--- Returns the event delay.
-- @treturn float
-- @within Getter Functions
function cEvent:GetTimer()
    return self.Timer
end
--- Returns the event registered timestamp.
-- @treturn int (I think; could be game cycles too, not sure.)
-- @within Getter Functions
function cEvent:GetRegisteredTimestamp()
    return self.RegisteredTimestamp
end
--- Calculates whether a timed event is allowed to be executed.
-- Uses the vanilla GetCurrenttime() function. This should return the seconds passed since the GC has been started.
-- @treturn bool
-- @within Getter Functions
function cEvent:IsReadyToExecute()
    if self:GetRegisteredTimestamp() + self:GetTimer() <= GetCurrentTime() then
        return true
    end
    return false
end
--- {abstract} Executes the event.
function cEvent:Execute()
    return false
end

return cEvent
