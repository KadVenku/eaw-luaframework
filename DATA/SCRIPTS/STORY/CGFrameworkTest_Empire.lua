-- ===== ===== ===== ===== =====
-- Copyright (c) 2017 Kad Venku
-- License       MIT License
-- ===== ===== ===== ===== =====

require( "PGBase" )
require( "PGDebug" )
require( "pgevents" )
require( "pgcommands" )
require( "PGBaseDefinitions" )
require( "PGStateMachine" )
require( "PGStoryMode" )
require( "PGSpawnUnits" )
-- libraries:
require( "libErrorFunctions" )
require( "libDebugFunctions" )
require( "libPGGenericFunctionLibrary" )
-- new classes:
require( "cGalacticConquest" )

function Definitions()
    StoryModeEvents = { InitialiseGalacticConquestEvent = InitialiseGalacticConquest }

    -- Kad 24/06/2017 14:04:31 - Required globals:
    cGCThread_EvaluateOwner            = nil
    cGCThread_EvaluateOwner_TimeStamp  = nil
    cGCThread_RefreshGUI               = nil
    cGCThread_RefreshGUI_TimeStamp     = nil
    cGCThread_FiscalUpdate             = nil
    cGCThread_FiscalUpdate_TimeStamp   = nil
    cGCThread_EvaluateFleets           = nil
    cGCThread_EvaluateFleets_TimeStamp = nil
    cGCThread_ServeEvents              = { }
    cGCThread_ServeEvents_TimeStamp    = { }
    cGCThread_ThreadListener           = nil
    cGCThread_ThreadListener_TimeStamp = nil
    GalacticConquest                   = nil
end

function InitialiseGalacticConquest( message )
    if message == OnEnter then
        GalacticConquest = cGalacticConquest.New( "SANDBOX_EQUAL_FOOTING" )
        GalacticConquest:Initialise()
        StartGalacticConquest()
        -- DEBUGGING: Unnecessary code below:
        -- GalacticConquest:FlashCapitalPlanets()
        GalacticConquest:RegisterEvent( "EVENT_TYPE_SPAWNUNITS", { ReinforceStructID = "SPAWN_THRAWN", ReinforcePositionTable = { FindPlanet( "Coruscant" ), }, OwnerObject = Find_Player( "Empire" ) } )
        GalacticConquest:RegisterEvent( "EVENT_TYPE_SPAWNUNITS", { ReinforceStructID = "TEST_STRUCT", ReinforcePositionTable = { FindPlanet( "Coruscant" ), FindPlanet( "Kuat" ) }, OwnerObject = Find_Player( "Empire" ), Timer = 85, } )
        GalacticConquest:FlashCapitalPlanets()
        local thrawnRef = Find_First_Object( "Admonitor_Star_Destroyer" )
        local trawnType = GalacticConquest.ObjectManager:GetCGameObjectTypeByReference( Find_First_Object( "Admonitor_Star_Destroyer" ) )
        GalacticConquest:RegisterEvent( "EVENT_TYPE_DIPLSTARTDIPLOMATICMISSION", { GameObjectTypeLUAObject = thrawnType, GameObjectReference = thrawnRef, PlanetLUAObject = GalacticConquest.Planets["Coruscant"], Timer = 28, } )
        GalacticConquest:RegisterEvent( "EVENT_TYPE_PDORBITALBOMBARDMENTBEGIN", { TargetPlanet = GalacticConquest.Planets["Coruscant"], BombardingFaction = GalacticConquest.Planets["Coruscant"]:GetOwner(), Timer = 10, } )
        local cPln = GalacticConquest.Planets["Coruscant"]:GetPlanetInReach( GalacticConquest.Planets["Coruscant"]:GetOwner() )
        cPln:AddPlanetHighlight( "FINAL_PLANET" )
        Sleep( 5.0 )
        cPln:Destroy()
        Sleep( 5.0 )
        cPln:RemovePlanetHighlight( "FINAL_PLANET" )
        -- GalacticConquest:FlashCapitalPlanets()
        -- local DiplVal = GalacticConquest.Planets["Coruscant"]:GetDiplomaticRating()
        -- local DipValRaw = GalacticConquest.Planets["Coruscant"]:GetCurrentDiplomaticInfluenceOwnerRaw()
        -- debugFactionRawMilitaryStrength( DipValRaw, DiplVal )
        -- GalacticConquest:RegisterEvent( "EVENT_TYPE_DIPLTURNPLANET", { PlanetLUAObject = GalacticConquest.Planets["Kuat"], FactionLUAObjectNewOwner = GalacticConquest.Factions["Rebel_Alliance"], Timer = 180 } )
        -- Sleep(1.0)
        -- DiplVal = GalacticConquest.Planets["Coruscant"]:GetDiplomaticRating()
        -- DipValRaw = GalacticConquest.Planets["Coruscant"]:GetCurrentDiplomaticInfluenceOwnerRaw()
        -- debugFactionRawMilitaryStrength( DipValRaw, DiplVal )
        -- Sleep(1.0)
        -- DiplVal = GalacticConquest.Planets["Coruscant"]:GetDiplomaticRating()
        -- DipValRaw = GalacticConquest.Planets["Coruscant"]:GetCurrentDiplomaticInfluenceOwnerRaw()
        -- debugFactionRawMilitaryStrength( DipValRaw, DiplVal )
        -- Sleep(1.0)
        -- DiplVal = GalacticConquest.Planets["Coruscant"]:GetDiplomaticRating()
        -- DipValRaw = GalacticConquest.Planets["Coruscant"]:GetCurrentDiplomaticInfluenceOwnerRaw()
        -- debugFactionRawMilitaryStrength( DipValRaw, DiplVal )
        -- Sleep(1.0)
        -- DiplVal = GalacticConquest.Planets["Coruscant"]:GetDiplomaticRating()
        -- DipValRaw = GalacticConquest.Planets["Coruscant"]:GetCurrentDiplomaticInfluenceOwnerRaw()
        -- debugFactionRawMilitaryStrength( DipValRaw, DiplVal )
        -- Sleep(1.0)
        -- Sleep(1.0)
        -- GalacticConquest.Planets["Coruscant"]:TakeDamage( 8765 )
        -- GalacticConquest:HighlightAllEmpirePlanets()
        -- GalacticConquest:HighlightAllRebelPlanets()
        -- GalacticConquest:HighlightAllUnderworldPlanets()
    elseif message == OnUpdate then
    elseif message == OnExit then
    end
end
-- =========  ========= MAIN LOOP THREADING ==========  ==========

--- Starts the GC framework in a multi-threaded environment.
-- @see cGCThreaded_EvaluateOwner
-- @see cGCThreaded_RefreshGUI
-- @see cGCThreaded_EvaluateFleets
-- @see cGCThreaded_ServeEvents
function StartGalacticConquest( )
    local OwnerTick       = require( "configGlobalSettings" ).gSetting_Eval_OwnerTick
    local GUIRefreshTick  = require( "configGlobalSettings" ).gSetting_Eval_GUIEventTick
    local MaintenanceTick = require( "configGlobalSettings" ).gSetting_Global_FiscalCycle
    local FleetTick       = require( "configGlobalSettings" ).gSetting_Eval_FleetsTick
    local EventTick       = require( "configGlobalSettings" ).gSetting_EventHandlerTick
    cGCThread_EvaluateOwner   = Create_Thread( "cGCThreaded_EvaluateOwner", OwnerTick )
    cGCThread_RefreshGUI      = Create_Thread( "cGCThreaded_RefreshGUI", GUIRefreshTick )
    cGCThread_FiscalUpdate = Create_Thread( "cGCThreaded_FiscalUpdate", MaintenanceTick )
    cGCThread_EvaluateFleets  = Create_Thread( "cGCThreaded_EvaluateFleets", FleetTick )

    -- Kad 24/06/2017 14:00:54 - Creates EventHandler worker threads. They don't know about each other and the GalacticConquest keeps them completely decoupled.
    local evtHndCnt = require( "configGlobalSettings").gSetting_Global_EventHandlerCount
    for i = 1, evtHndCnt, 1 do
        local tab = { EventTick, i }
        if i > 1 then
            Sleep( EventTick/evtHndCnt )
        end
        cGCThread_ServeEvents[i] = Create_Thread( "cGCThreaded_ServeEvents", tab )
    end

    local ThreadWatchdogTick  = require( "configGlobalSettings" ).gSetting_Global_ThreadWatchdogTick
    cGCThread_ThreadListener  = Create_Thread( "cGCThreaded_ThreadListener", ThreadWatchdogTick )
end
--- Starts the owner evaluation loop.
function cGCThreaded_EvaluateOwner( newOwnerTick )
    while true do
        cGCThread_EvaluateOwner_TimeStamp = GetCurrentTime()
        GalacticConquest:EvaluatePlanetsContested()
        GalacticConquest:EvaluatePlanetOwners()
        GalacticConquest:EvaluatePlanetBuildings()
        Sleep( newOwnerTick )
    end
end
--- Starts the fleet evaluation loop.
function cGCThreaded_EvaluateFleets( newFleetsTick )
    while true do
        GalacticConquest:EvaluateGalacticFleets()
        Sleep( newFleetsTick )
    end
end
--- Starts the selected planet evaluation.
function cGCThreaded_RefreshGUI( newSelectTick )
    local guiHandler = GalacticConquest.GUIHandler
    while true do
        cGCThread_RefreshGUI = GetCurrentTime()
        guiHandler:UpdateSelectedPlanet()
        guiHandler:ProcessGUI()
        Sleep( newSelectTick )
    end
end
--- Starts the first event handler.
function cGCThreaded_ServeEvents( table )
    local newEvtTick = table[1]
    local handlerIndex = table[2]
    local evtHandler = GalacticConquest.EventHandler[handlerIndex]
    while true do
        cGCThread_ServeEvents_TimeStamp[handlerIndex] = GetCurrentTime()
        evtHandler:ServeEvents()
        Sleep( newEvtTick )
    end
end
--- Starts the Unit maintenance cycle.
-- Fetches the required gSettings each time; which allows for enabling/disabling the maintenance on-the-fly. (Hopefully...)
function cGCThreaded_FiscalUpdate( newEventTick )
    Sleep( 0.5 ) -- Kad 23/06/2017 12:51:29 - In case of some other message that also deems itself important enough.
    GalacticConquest:UpdateTimedHolochronLogs() -- Kad 23/06/2017 12:50:35 - Run once at the beginning, to initialize the holochron.
    Sleep( newEventTick - 1.0 )
    while true do
        cGCThread_FiscalUpdate_TimeStamp = GetCurrentTime()
        local PlayerMaintenance = require( "configGlobalSettings" ).gSetting_Feat_MaintenancePC
        local AIMaintenance = require( "configGlobalSettings" ).gSetting_Feat_MaintenanceAI
        GalacticConquest:MaintenanceCycle( PlayerMaintenance, AIMaintenance )
        GalacticConquest:UpdateTimedHolochronLogs()
        Sleep( newEventTick )
    end
end
--- If a thread crashes, we'll restart it.
-- TODO: Fix this piece of sh*t. It's still not correctly re-spawning all workers.
function cGCThreaded_ThreadListener( newEventTick )
    local maxTimeOutMult  = require( "configGlobalSettings" ).gSetting_Global_ThreadWatchdogTimeoutMult
    local OwnerTick       = require( "configGlobalSettings" ).gSetting_Eval_OwnerTick
    local GUIRefreshTick  = require( "configGlobalSettings" ).gSetting_Eval_GUIEventTick
    local MaintenanceTick = require( "configGlobalSettings" ).gSetting_Global_FiscalCycle
    local FleetTick       = require( "configGlobalSettings" ).gSetting_Eval_FleetsTick
    local EventTick       = require( "configGlobalSettings" ).gSetting_EventHandlerTick
    while true do
        local CurrTime = GetCurrentTime()
        if CurrTime - cGCThread_EvaluateOwner_TimeStamp > maxTimeOutMult * OwnerTick then
            ThrowThreadCrashedError( "TEXT_LUA_OBJECT_TYPE_THREAD_OWNEREVAL" )
            cGCThread_EvaluateOwner = Create_Thread( "cGCThreaded_EvaluateOwner", OwnerTick )
        end
        CurrTime = GetCurrentTime()
        if CurrTime - cGCThread_RefreshGUI_TimeStamp > maxTimeOutMult * GUIRefreshTick then
            ThrowThreadCrashedError( "TEXT_LUA_OBJECT_TYPE_THREAD_GUI" )
            cGCThread_RefreshGUI = Create_Thread( "cGCThreaded_RefreshGUI", GUIRefreshTick )
        end
        CurrTime = GetCurrentTime()
        if CurrTime - cGCThread_FiscalUpdate_TimeStamp > maxTimeOutMult * MaintenanceTick then
            ThrowThreadCrashedError( "TEXT_LUA_OBJECT_TYPE_THREAD_GUI" )
            cGCThread_RefreshGUI = Create_Thread( "cGCThreaded_RefreshGUI", GUIRefreshTick )
        end
        CurrTime = GetCurrentTime()
        if CurrTime - cGCThread_EvaluateFleets_TimeStamp > maxTimeOutMult * FleetTick then
            ThrowThreadCrashedError( "TEXT_LUA_OBJECT_TYPE_THREAD_FLEETS" )
            cGCThread_EvaluateFleets = Create_Thread( "cGCThreaded_EvaluateFleets", FleetTick )
        end
        for i, timeStamp in pairs( cGCThread_ServeEvents_TimeStamp ) do
            CurrTime = GetCurrentTime()
            if CurrTime - timeStamp > maxTimeOutMult * EventTick then
                ThrowThreadCrashedError( "TEXT_LUA_OBJECT_TYPE_THREAD_EVTHANDLER" )
                cGCThread_ServeEvents[i] = Create_Thread( "cGCThreaded_ServeEvents", { i, EventTick } )
            end
        end
        Sleep( newEventTick )
    end
end
