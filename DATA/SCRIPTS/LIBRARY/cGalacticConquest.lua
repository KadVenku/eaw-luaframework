-- ===== ===== ===== ===== =====
-- Copyright (c) 2017 Kad Venku
-- License       MIT License
-- ===== ===== ===== ===== =====

--- cGalacticConquest class.
-- Governs the framework and has access to all child classes.

-- Import new functions:
require( "libErrorFunctions" )
require( "libDebugFunctions" )
require( "libPGGenericFunctionLibrary" )
-- Import new classes:
require( "cFaction" )
require( "cEventHandler" )
require( "cGUIHandler" )
require( "cObjectManager" )
require( "cGlobalMessageHandler" )
require( "cMajorFaction" )
require( "cMinorFaction" )
require( "cPlanet" )

cGalacticConquest = {}
cGalacticConquest.__index = cGalacticConquest

--- Constructor.
-- Creates a new LUA object of type cGalacticConquest.
-- @tparam String newGCName Used as key to load all relevant data from the static conquest table.
-- @within Initialisation
function cGalacticConquest.New( newGCName )
    local self = setmetatable( {}, cGalacticConquest )

    self.Name       = newGCName
    self.ObjectType = "TEXT_LUA_OBJECT_TYPE_GC"
    self.DebugModeActive = require( "configGlobalSettings" ).gSetting_DebugMode

    -- Initialisation from static library:
    local GCDataTable = require( "libGCDefinitions" )
    if GCDataTable[newGCName] ~= nil then
        self.EventHandler                          = { }
        self.GUIHandler                            = nil
        self.ObjectManager                         = nil
        self.GlobalMessageHandler                  = nil
        self.Factions                              = { } -- empty faction list
        self.FactionNameList                       = GCDataTable[newGCName].Factions    -- Temporary table. Ditched after initialization.
        self.Planets                               = { } -- empty planet list
        self.PlanetNameList                        = GCDataTable[newGCName].Planets    -- Temporary table. Ditched after initialization.
        self.RequestedTradeRoutes                  = GCDataTable[newGCName].TradeRoutes    -- Temporary table. Ditched after initialization.
        self.GalacticFleets                        = { }
        self.FleetAccidentCooldowns                = { }
        self.GalacticFleetsByFactions              = { }
    else
        ThrowObjectInitialisationError( self:GetObjectType() )
    end
    if self.DebugModeActive then
        debugPushDroidMessage( "TEXT_DEBUG_GC_OBJECT_CREATED" )
    end
    return self
end
--- Initialises the galactic conquest scenario.
-- This function creates all necessary objects and is responsible for linking them correctly after creation.
-- This has to be called after the constructor, as some object might not yet be valid.
-- @within Initialisation
function cGalacticConquest:Initialise()
    if self.DebugModeActive then
        debugPushDroidMessage( "TEXT_DEBUG_GC_INITIALISATION_STARTED" )
        debugPushDroidMessage( "TEXT_DEBUG_GC_INITIALISATION_CREATING_OBJECTS" )
    end
    self:CreatePlanets()
    self:CreateFactions()
    self.EventHandler         = { }
    local evtHndCnt = require( "configGlobalSettings").gSetting_Global_EventHandlerCount
    for i = 1, evtHndCnt, 1 do
        local newEvtHndl = cEventHandler.New( self )
        table.insert( self.EventHandler, newEvtHndl )
    end

    -- Create a stack for every message type.
    local validMsgTypes = require( "libStaticMessageTypeDefinitions" )
    for _,msgType in pairs( validMsgTypes ) do
        local msgCountID = msgType.."_COUNT"
        GlobalValue.Set( msgCountID, 0 )
    end
    -- Last attacked planet:
    GlobalValue.Set( "MP_LAST_SPACE_BATTLE", 0 )
    GlobalValue.Set( "MP_LAST_GROUND_BATTLE", 0 )

    self.GUIHandler           = cGUIHandler.New( self )
    self.ObjectManager        = cObjectManager.New( self )
    self.GlobalMessageHandler = cGlobalMessageHandler.New( self )
    if self.DebugModeActive then
        debugPushDroidMessage( "TEXT_DEBUG_GC_INITIALISATION_REGISTERING_OBJECT_RELATIONS" )
    end
    self:InitialisePlanets()
    self:InitialiseFactions()
    self:InitialiseTradeRoutes()
    self.GUIHandler:Initialise()
    self.ObjectManager:Initialise()
    if self.DebugModeActive then
        debugPushDroidMessage( "TEXT_DEBUG_GC_INITIALISATION_GUIHANDLER_FINISHED" )
    end
    self:EvaluateGalacticFleets()
    if self.DebugModeActive then
        debugPushDroidMessage( "TEXT_DEBUG_GC_INITIALISATION_FINISHED" )
    end
end
--- Initialises the planets loaded from the active planet list and registers them with the GC.
-- @within Initialisation
function cGalacticConquest:CreatePlanets()
    for _,planet_name in pairs( self.PlanetNameList ) do
        local planet = cPlanet.New( planet_name, self )
        self:RegisterPlanet( planet )
    end
    -- Ditch the planet name list parameter:
    self.PlanetNameList = nil
    if self.DebugModeActive then
        debugPushDroidMessage( "TEXT_DEBUG_GC_PLANET_CREATION_FINISHED" )
    end
end
--- Initialises the object relations for planets.
-- Setting up the planetary ownership and things alike.
-- @within Initialisation
function cGalacticConquest:InitialisePlanets()
    for planetName, cPlanetObj in pairs( self.Planets ) do
        cPlanetObj:Initialise()
    end
    if self.DebugModeActive then
        debugPushDroidMessage( "TEXT_DEBUG_GC_PLANET_RELATIONS_UPDATED" )
    end
end
--- Initialises the factions loaded from the active faction list and registers them with the GC.
-- @within Initialisation
function cGalacticConquest:CreateFactions()
    for _, newFactionStruct in pairs( self.FactionNameList ) do
        if newFactionStruct.Type == "TYPE_FACTION_MAJOR" then
            local newFac = cMajorFaction.New( self, newFactionStruct.Name )
            self:RegisterFaction( newFac )
        elseif newFactionStruct.Type == "TYPE_FACTION_MINOR" then
            local newFac = cMinorFaction.New( self, newFactionStruct.Name )
            self:RegisterFaction( newFac )
        end
    end
    -- Ditch the faction name list parameter:
    self.FactionNameList = nil
    if self.DebugModeActive then
        debugPushDroidMessage( "TEXT_DEBUG_GC_FACTION_CREATION_FINISHED" )
    end
end
--- Initialises the object relations for factions.
-- Setting up the faction relations and things alike.
-- @within Initialisation
function cGalacticConquest:InitialiseFactions()
    for factionName, cFactionObj in pairs( self.Factions ) do
        cFactionObj:Initialise()
    end
    if self.DebugModeActive then
        debugPushDroidMessage( "TEXT_DEBUG_GC_FACTION_RELATIONS_UPDATED" )
    end
end
--- Initialises all registered trade routes.
-- @within Initialisation
function cGalacticConquest:InitialiseTradeRoutes()
    local TradeRouteDefinitions = require( "libStaticTraderouteDefinitions" )
    for _, newRoute in pairs( self.RequestedTradeRoutes ) do
        if TradeRouteDefinitions[newRoute] ~= nil then
            local cPlanet1 = self:GetPlanetObjectByName( TradeRouteDefinitions[newRoute].Planet1 )
            local cPlanet2 = self:GetPlanetObjectByName( TradeRouteDefinitions[newRoute].Planet2 )
            if cPlanet1 and cPlanet2 then
                -- Cross referencing the two planets:
                cPlanet1:AddPlanetInReach( cPlanet2 )
                cPlanet2:AddPlanetInReach( cPlanet1 )
            end
        else
            ThrowObjectNotFoundError( "TEXT_LUA_OBJECT_TYPE_TRADEROUTE" )
        end
    end
    -- ditch the self.RequestedTradeRoutes
    self.RequestedTradeRoutes = nil
    if self.DebugModeActive then
        debugPushDroidMessage( "TEXT_DEBUG_GC_TRADEROUTE_CREATION_FINISHED" )
    end
end

--- Evaluates galactic fleets.
-- Registers fleets by factions.
-- @within Game Cycle
function cGalacticConquest:EvaluateGalacticFleets()
    self.GalacticFleetsByFactions = nil
    self.GalacticFleetsByFactions = { }
    self.GalacticFleets = nil
    self.GalacticFleets = Find_All_Objects_Of_Type( "Galactic_Fleet" )
    for factionKey, cFactionObj in pairs( self.Factions ) do
        -- create an empty list for each faction
        local lFactionFleetTable = { }
        for _,gFleetObj in pairs( self.GalacticFleets ) do
            if gFleetObj.Get_Owner() == cFactionObj:GetPlayerObject() then
                table.insert( lFactionFleetTable, gFleetObj )
            end
        end
        self.GalacticFleetsByFactions[cFactionObj:GetName()] = lFactionFleetTable
    end
    local hyperspaceAccidentExecuteChance = require( "configGlobalSettings" ).gSetting_FleetHyperspaceAccident_ExecuteChance
    if self.DebugModeActive then
        hyperspaceAccidentExecuteChance = 0.2
    end
    if GameRandom.Get_Float() <= hyperspaceAccidentExecuteChance then
        for _, fleet in pairs( self.GalacticFleets ) do
            if self:EvaluateAccidentAppropriateForFleet( fleet ) then
                if self:EvaluateAccidentAvoidanceChanceForFleet( fleet ) < require( "configGlobalSettings" ).gSetting_FleetHyperspaceAccident_AccidentChance then
                    self:RegisterEvent( "EVENT_TYPE_FLEETHYPERSPACEACCIDENT", { FleetObject = fleet } )
                end
            end
        end
    end
end

--- Executes a galactic maintenance cycle.
-- @tparam bool applyToPC Should the player faction pay maintenance cost.
-- @tparam bool applyToAI Should the AI pay maintenance cost.
-- @within Game Cycle
function cGalacticConquest:MaintenanceCycle( applyToPC, applyToAI )
    for _ , cFacObj in pairs( self.Factions ) do
        if applyToPC and cFacObj:GetIsHumanPlayer() then
            self.ObjectManager:ApplyMaintenanceCost( cFacObj )
        elseif applyToAI and ( not cFacObj:GetIsHumanPlayer() ) then
            self.ObjectManager:ApplyMaintenanceCost( cFacObj )
        end
    end
end

function cGalacticConquest:UpdateTimedHolochronLogs()
    self:GetHumanPlayerFaction():ClearDiplomaticMissionHolochron()
    self:GetHumanPlayerFaction():UpdateDiplomaticMissionHolochron()
end

--- Is a hyperspace accident appropriate for the fleet?.
-- @tparam FleetObject fleetInQuestion
-- @treturn bool
-- @within Fleet Accident Functions
function cGalacticConquest:EvaluateAccidentAppropriateForFleet( fleetInQuestion )
    if fleetInQuestion.Get_Parent_Object() then
        return false
    end
    local minShipCount = require( "configGlobalSettings" ).gSetting_FleetHyperspaceAccident_MinShipsInFleet
    if self.DebugModeActive then
        minShipCount = 1
    end
    if fleetInQuestion.Get_Contained_Object_Count() < minShipCount then
        return false
    end
    if fleetInQuestion.Contains_Hero() then
        return false
    end
    local preventingUnitTypes = require( "configGlobalSettings" ).gSetting_FleetHyperspaceAccident_PreventingUnitTypes
    for _, preventingUnitType in pairs( preventingUnitTypes ) do
        if fleetInQuestion.Contains_Object_Type( Find_Object_Type( preventingUnitType ) ) then
            return false
        end
    end
    return true
end

--- Get the avoidance chance for the fleet:
-- @tparam FleetObject fleetInQuestion
-- @treturn float
-- @within Fleet Accident Functions
function cGalacticConquest:EvaluateAccidentAvoidanceChanceForFleet( fleetInQuestion )
    local avoidingUnitStructs = require( "configGlobalSettings" ).gSetting_FleetHyperspaceAccident_AvoidingUnitTypes
    local maxAvoidanceChance = 0.0
    for _, avoidanceStruct in pairs( avoidingUnitStructs ) do
        if fleetInQuestion.Contains_Object_Type( Find_Object_Type( avoidanceStruct.ObjectType ) ) then
            if avoidanceStruct.AvoidanceChance >= maxAvoidanceChance then
                maxAvoidanceChance = avoidanceStruct.AvoidanceChance
            end
        end
    end
    maxAvoidanceChance = ClampValue( maxAvoidanceChance, 0.0, 1.0 )
    return maxAvoidanceChance
end
-- =========  =========  ==========  ==========

--- Returns the lua object type as string key.
-- Used for error handling.
-- @treturn String
-- @within Getter Functions
function cGalacticConquest:GetObjectType()
    return self.ObjectType
end
--- Returns the lua object's name'.
-- @treturn String
-- @within Getter Functions
function cGalacticConquest:GetName()
    return self.Name
end
--- Returns the cFaction given a faction name.
-- @tparam String queriedFactionName single faction name.
-- @treturn cFaction
-- @within Getter Functions
function cGalacticConquest:GetFactionObjectByName( queriedFactionName )
    if self.Factions[queriedFactionName] ~= nil then
        return self.Factions[queriedFactionName]
    else
        ThrowObjectNotFoundError( queriedFactionName )
        return false
    end
end
--- Returns the cFaction given a player object.
-- @tparam PlayerObject queriedPlayerObject single faction object.
-- @treturn cFaction
-- @within Getter Functions
function cGalacticConquest:GetFactionObjectByPlayerObject( queriedPlayerObject )
    local cFactionReturn = nil
    for factionName, cFactionObject in pairs( self.Factions ) do
        if cFactionObject:GetPlayerObject() == queriedPlayerObject then
            cFactionReturn = cFactionObject
            break
        end
    end
    if cFactionReturn == nil then
        ThrowObjectNotFoundError( queriedPlayerObject.Get_Faction_Name() )
        return false
    end
    return cFactionReturn
end
--- Returns the cPlanet given a Planet name.
-- @tparam String queriedPlanetName single planet name.
-- @treturn cPlanet
-- @within Getter Functions
function cGalacticConquest:GetPlanetObjectByName( queriedPlanetName )
    if self.Planets[queriedPlanetName] ~= nil then
        return self.Planets[queriedPlanetName]
    else
        ThrowObjectNotFoundError( queriedPlanetName )
        return false
    end
end
--- Links a single planet to its parent GC.
-- @tparam cPlanet newPlanet
-- @error Throws an ObjectAlreadyRegisteredError, which allows the program to continue.
-- @within Setter Functions
function cGalacticConquest:RegisterPlanet( newPlanet )
    if not self:IsRegisteredPlanet( newPlanet ) then
        self.Planets[newPlanet:GetName()] = newPlanet
    else
        ThrowObjectAlreadyRegisteredError( newPlanet:GetObjectType(), newPlanet:GetDisplayName() )
    end
end
--- Links a single faction to its parent GC.
-- @tparam cFaction newFaction
-- @error Throws an ObjectAlreadyRegisteredError, which allows the program to continue.
-- @within Setter Functions
function cGalacticConquest:RegisterFaction( newFaction )
    if not self:IsRegisteredFaction( newFaction ) then
        self.Factions[newFaction:GetName()] = newFaction
    else
        ThrowObjectAlreadyRegisteredError( newFaction:GetObjectType(), newFaction:GetDisplayName() )
    end
end
--- Returns the human cFaction.
-- @within Getter Functions
function cGalacticConquest:GetHumanPlayerFaction()
    for factionName, cFactionObject in pairs( self.Factions ) do
        if cFactionObject:GetIsHumanPlayer() then
            return cFactionObject
        end
    end
    return false
end
-- =========  =========  ==========  ==========

--- Tests whether an planet object has already been registered.
-- This can either be used to test whether an object is valid or - during initialisation - whether an object tries to register twice.
-- @tparam cPlanet planetInQuestion
-- @treturn Bool
-- @within Validity
function cGalacticConquest:IsRegisteredPlanet( planetInQuestion )
    if self.Planets[planetInQuestion:GetName()] ~= nil then
        return true
    else
        return false
    end
end
--- Tests whether a faction object has already been registered.
-- This can either be used to test whether an object is valid or - during initialisation - whether an object tries to register twice.
-- @tparam cFaction factionInQuestion
-- @treturn Bool
-- @within Validity
function cGalacticConquest:IsRegisteredFaction( factionInQuestion )
    if self.Factions[factionInQuestion:GetName()] ~= nil then
        return true
    else
        return false
    end
end

--- Registers events with the event handler(-s) and does some basic load handling.
-- A new event is always registered with the handler with the fewest events queued.
-- @tparam string newEventTypeString
-- @tparam table eventArgumentTable
-- @within Game Cycle
function cGalacticConquest:RegisterEvent( newEventTypeString, eventArgumentTable )
    local minRegisteredQueue = 999999
    local minEvtHandler = false

    for _, evtHandler in pairs( self.EventHandler ) do
        if not evtHandler:IsWorking() then
            if evtHandler:GetEventCount() <= minRegisteredQueue then
                minRegisteredQueue = evtHandler:GetEventCount()
                minEvtHandler = evtHandler
            end
        end
    end
    -- Fail safe:
    if not minEvtHandler then
        for _, evtHandler in pairs( self.EventHandler ) do
            if not evtHandler:IsWorking() then
                minEvtHandler = evtHandler
            end
        end
    end

    minEvtHandler:RegisterNewEvent( newEventTypeString, eventArgumentTable )
    if self.DebugModeActive then
        debugPushDroidMessage( "TEXT_DEBUG_GC_EVENT_REGISTERING" )
    end
end

-- =========  ========= MAIN GAME LOOP ==========  ==========

--- Evaluates the owner of the planets and updates them accordingly.
-- @within Game Cycle
function cGalacticConquest:EvaluatePlanetOwners()
    for planetName, cPlanetObj in pairs( self.Planets ) do
        cPlanetObj:EvaluateOwner()
    end
end
--- Evaluates the buildings on a planet.
-- Updates the building reference tables and respawns missing persistent objects.
-- @see cPlanet:UpdatePersistentObjects()
-- @see cPlanet:EvaluateBuildings()
-- @within Game Cycle
function cGalacticConquest:EvaluatePlanetBuildings()
    for planetName, cPlanetObj in pairs( self.Planets ) do
        cPlanetObj:UpdatePersistentObjects()
        cPlanetObj:EvaluateBuildings()
    end
end
--- Evaluates whether an enemy fleet is orbiting the planet.
-- It will update the contested variable with the reference to the fleet orbiting.
-- @see cPlanet:EvaluatePlanetContested()
-- @within Game Cycle
function cGalacticConquest:EvaluatePlanetsContested()
    for planetName, cPlanetObj in pairs( self.Planets ) do
        cPlanetObj:EvaluatePlanetContested()
    end
end

-- Test functionality:
function cGalacticConquest:HighlightAllEmpirePlanets()
    for pName, cPlanetObj in pairs( self.Planets ) do
        if cPlanetObj:GetOwner():GetPlayerObject() == Find_Player( "EMPIRE" ) then
            local tag = cPlanetObj:AddPlanetHighlight( "test" )
            Sleep( 1.0 )
            cPlanetObj:RemovePlanetHighlight( tag )
        end
    end
end
function cGalacticConquest:HighlightAllRebelPlanets()
    for pName, cPlanetObj in pairs( self.Planets ) do
        if cPlanetObj:GetOwner():GetPlayerObject() == Find_Player( "REBEL" ) then
            local tag = cPlanetObj:AddPlanetHighlight( "test" )
            Sleep( 1.0 )
            cPlanetObj:RemovePlanetHighlight( tag )
        end
    end
end
function cGalacticConquest:HighlightAllUnderworldPlanets()
    for pName, cPlanetObj in pairs( self.Planets ) do
        if cPlanetObj:GetOwner():GetPlayerObject() == Find_Player( "UNDERWORLD" ) then
            local tag = cPlanetObj:AddPlanetHighlight( "test" )
            Sleep( 1.0 )
            cPlanetObj:RemovePlanetHighlight( tag )
        end
    end
end
function cGalacticConquest:FlashCapitalPlanets()
    for pName, cPlanetObj in pairs( self.Planets ) do
        if cPlanetObj:GetIsCapital() then
            local tag = cPlanetObj:AddPlanetHighlight( "capital" )
            Sleep( 1.0 )
            cPlanetObj:RemovePlanetHighlight( tag )
        end
    end
end

function cGalacticConquest:GetStrongestRawMilitary()
    local strFac = false
    local maxStrength = 0
    for _,cFacObj in pairs( self.Factions ) do
        cFacObj:EvaluateRawMilitaryStrength()
        if cFacObj:GetRawMilitaryStrength() > maxStrength then
            strFac = cFacObj:GetStringKey()
            maxStrength = cFacObj:GetRawMilitaryStrength()
        end
    end
    if self.DebugModeActive then
        debugFactionRawMilitaryStrength( strFac, maxStrength )
    end
    return strFac, maxStrength
end

return cGalacticConquest
