-- ===== ===== ===== ===== =====
-- Copyright (c) 2017 Kad Venku
-- License       MIT License
-- ===== ===== ===== ===== =====

-- Import new functions:
require( "libErrorFunctions" )
require( "libDebugFunctions" )
-- Import new classes:
require( "cEvent" )
require( "cPlanet" )

cEvent_Type_OrbitalBombardmentBurst = {}
cEvent_Type_OrbitalBombardmentBurst.__index = cEvent_Type_OrbitalBombardmentBurst
setmetatable( cEvent_Type_OrbitalBombardmentBurst, { __index = cEvent } )
--- Constructor.
-- Creates a new LUA object of type cEvent_Type_OrbitalBombardmentBurst.
-- @tparam cEventHandler parentEventHandler
-- @within Constructor
function cEvent_Type_OrbitalBombardmentBurst.New( parentEventHandler, cPlanetToBombard, cFactionBombarding, newTimer )
    local self = setmetatable( {}, cEvent_Type_OrbitalBombardmentBurst )
    self.Parent                  = parentEventHandler
    self.Type                    = "TEXT_LUA_OBJECT_TYPE_EVENT_PDORBITALBOMBARDMENTBURST"
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
function cEvent_Type_OrbitalBombardmentBurst:Execute()
    local tFleet = Find_All_Objects_Of_Type(  require( "configGlobalSettings" ).gSetting_PD_BombardmentCapableClassFilter )
    local bombardmentFleet = {}
    local attackWeight = 0
    for _,objRef in pairs( tFleet ) do
        if objRef.Get_Owner() == self.CFactionBombarding:GetPlayerObject() and objRef.Get_Planet_Location() == self.CPlanetToBombard:GetPlanetLocation() then
            table.insert( bombardmentFleet, objRef )
            attackWeight = attackWeight + objRef.Get_Type().Get_Combat_Rating()
        end
    end
    attackWeight = attackWeight * require( "configGlobalSettings" ).gSetting_PD_BombardmentAttackRatingScaling
    self.CPlanetToBombard:TakeDamage( attackWeight )
end

return cEvent_Type_OrbitalBombardmentBurst
