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

cEvent_Type_DIPLCheckFactionAlliance = {}
cEvent_Type_DIPLCheckFactionAlliance.__index = cEvent_Type_DIPLCheckFactionAlliance
setmetatable( cEvent_Type_DIPLCheckFactionAlliance, { __index = cEvent } )
--- Constructor.
-- Creates a new LUA object of type cEvent_Type_DIPLCheckFactionAlliance.
-- @tparam cEventHandler parentEventHandler
-- @within Constructor
function cEvent_Type_DIPLCheckFactionAlliance.New( parentEventHandler, cHomeFaction, cNewFaction, newTimer )
    local self = setmetatable( {}, cEvent_Type_DIPLCheckFactionAlliance )
    self.Parent                  = parentEventHandler
    self.Type                    = "TEXT_LUA_OBJECT_TYPE_EVENT_DIPLUPDATEFACTIONALLIANCE"
    self.HomeFaction             = cHomeFaction
    self.InfluencingFaction      = cNewFaction
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
function cEvent_Type_DIPLCheckFactionAlliance:Execute()
    local oldFactionOwnedOrAllied = 0
    local newFactionOwnedOrAllied = 0
    local isCapitalFallen         = false
    local homeSector              = self.HomeFaction:GetHomeSector()
    local planetInSectorCount     = table.getn( homeSector )

    for _,cPlanetObj in pairs( homeSector ) do
        local cFacOwner = cPlanetObj:GetOwner()
        local cFacAlly  = cPlanetObj:GetAlliedFaction()
        if cFacOwner == self.HomeFaction or cFacAlly == self.HomeFaction then
            oldFactionOwnedOrAllied = oldFactionOwnedOrAllied + 1 -- Kad 22/06/2017 13:11:43 - Everything's ~coming~ adding up, ~Lucifer~ Ambassador!
            if cPlanetObj:GetIsCapital() then
                isCapitalFallen = false
            end
        elseif cFacOwner == self.InfluencingFaction or cFacAlly == self.InfluencingFaction then
            newFactionOwnedOrAllied = newFactionOwnedOrAllied + 1
            if cPlanetObj:GetIsCapital() then
                isCapitalFallen = true
            end
        end
    end
    local ownerSectorPercentage   = ( oldFactionOwnedOrAllied / planetInSectorCount ) * 100
    local foreignSectorPercentage = ( newFactionOwnedOrAllied / planetInSectorCount ) * 100

    if ownerSectorPercentage <= foreignSectorPercentage then
        if foreignSectorPercentage >= require( "configGlobalSettings" ).sSetting_Diplomacy_SectorTurnoverPercentageNoCapital or ( isCapitalFallen and foreignSectorPercentage >= require( "configGlobalSettings" ).sSetting_Diplomacy_SectorTurnoverPercentageCapital ) then
            for _,cPlanetObj in pairs( homeSector ) do
                if cPlanetObj:GetOwner() == self.HomeFaction then
                    -- Kad 22/06/2017 13:38:52 - We could technically do that in here, but that means we're duplicating a lot of code, so we use the intended event instead.
                    self.Parent.Parent:RegisterEvent( "EVENT_TYPE_DIPLTURNPLANET", { PlanetLUAObject = cPlanetObj, FactionLUAObjectNewOwner = self.InfluencingFaction, Timer = 1.0 } ) -- Kad 22/06/2017 13:37:02 - Added a timer to remove some stress from the system with several events being executed at the same time, not that we get stuck or something stupid... If we still get stuck in big sectors, I might pump the number of workers up to four.
                end
            end
            self.Parent.Parent:RegisterEvent( "EVENT_TYPE_DIPLMAKEALLIES", { CFactionMajor = self.InfluencingFaction, CFactionMinor = self.HomeFaction, } )
        else
            -- Kad 22/06/2017 13:41:26 - Whilst we technically have convinced the faction to turn, other factions hold significant parts of the sector, so we task the player with taking those back:
            if self.InfluencingFaction:GetIsHumanPlayer() then -- Kad 22/06/2017 15:14:59 - Once the AI subclasses are set up, we might want to start an attack plan for the AI and the planets.
                local takeBackPlanets = {}
                for _,cPlanetObj in pairs( homeSector ) do
                    if not ( cPlanet:GetOwner() == self.InfluencingFaction or cPlanet:GetOwner() == self.HomeFaction ) then
                        table.insert( takeBackPlanets, cPlanetObj )
                    end
                end
                -- Kad 23/06/2017 16:07:11 - TODO: Implement!
                self.Parent.Parent:RegisterEvent( "EVENT_TYPE_DIPLTAKEBACKPLANETS", { CPlanetTable = takeBackPlanets , FactionLUAObjectHumanPlayer = self.InfluencingFaction, FactionLUAObjectContractor = self.HomeFaction } )
            end
        end
    end
    debugEventExecuted( self:GetObjectType(), self:IsTimedEvent(), self:GetTimer() )
end

return cEvent_Type_DIPLCheckFactionAlliance
