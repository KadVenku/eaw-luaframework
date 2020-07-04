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

cEvent_Type_DIPLMakeAllies = {}
cEvent_Type_DIPLMakeAllies.__index = cEvent_Type_DIPLMakeAllies
setmetatable( cEvent_Type_DIPLMakeAllies, { __index = cEvent } )
--- Constructor.
-- Creates a new LUA object of type cEvent_Type_DIPLMakeAllies.
-- @tparam cEventHandler parentEventHandler
-- @within Constructor
function cEvent_Type_DIPLMakeAllies.New( parentEventHandler, cFactionMajor, cFactionMinor, newTimer )
    local self = setmetatable( {}, cEvent_Type_DIPLMakeAllies )
    self.Parent                  = parentEventHandler
    self.Type                    = "TEXT_LUA_OBJECT_TYPE_EVENT_DIPLMAKEALLIES"
    self.MajorFaction            = cFactionMajor
    self.MinorFaction            = cFactionMinor
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
function cEvent_Type_DIPLMakeAllies:Execute()
	-- Kad 24/06/2017 13:12:13 - The caller is responsible for making sure that major and minor faction are actually major and minor faction.
	self.MajorFaction:MakeAlly( self.MinorFaction )
	self.MinorFaction:MakeAlly( self.MajorFaction )
    -- Kad 27/06/2017 19:24:59 - Freshly wed partners, time for presents!
    -- Kad 28/06/2017 14:39:45 - TODO: Implement EVENT_TYPE_DIPLUPDATEALLIANCERATING;
    self.Parent.Parent:RegisterEvent( "EVENT_TYPE_DIPLUPDATEALLIANCERATING", { CFactionMajor = self.MajorFaction, CFactionMinor = self.MinorFaction, Timer = 0.5, }) -- Kad 27/06/2017 19:25:51 - Giving some time, so all update cycles can run properly.
end

return cEvent_Type_DIPLMakeAllies
