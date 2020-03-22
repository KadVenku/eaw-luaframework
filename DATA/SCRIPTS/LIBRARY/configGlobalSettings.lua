-- ===== ===== ===== ===== =====
-- Copyright (c) 2017 Kad Venku
-- License       MIT License
-- ===== ===== ===== ===== =====

--- This is the framework's settings file for global variables.
-- These can be used to configure and balance various parts of the framework.

local GlobalConfigurationSettings = {
    gSetting_Global_EventHandlerCount = 2, -- Number of spawned event handlers.
    gSetting_Global_ThreadWatchdogTick = 1, -- How often are threads checked for activity?
    gSetting_Global_ThreadWatchdogTimeoutMult = 10, -- How often is a thread allowed to miss its update time?
    gSetting_Global_FiscalCycle = 45.0, -- Set this to the same value as <Fiscal_Cycle_Time_In_Secs> in Gameconstants.xml
    -- Padding settings:
    gSetting_Global_MaxMessagePadding = 3, -- Message system supports a maximum of 999 messages per type.
    gSetting_Global_PaddingFactionID = 1, -- padding for faction IDs (max 9); Only supports major factions.
    gSetting_Global_PaddingObjectTypeID = 3, -- Padding for object IDs (max 999)
    gSetting_Global_PaddingObjectTypeCount = 2, -- Padding for object numbers (max 99)
    gSetting_Global_PaddingPlanetID = 3, -- Padding for faction IDs (max 999)
    gSetting_Global_PaddingPDEventType = 2, -- Padding for PD events (max 99)
    -- Debug settings:
    gSetting_DebugMode = true,    -- Debug mode on or off?
    -- Feature settings:
    gSetting_Feat_MaintenanceAI = false, -- Maintenance cost for AI player
    gSetting_Feat_MaintenancePC = true, -- Maintenance cost for human player
    gSetting_Feat_MaintenanceTick = 45.0, -- Set this to the same value as <Fiscal_Cycle_Time_In_Secs> in Gameconstants.xml
    gSetting_Feat_PlanetShieldReplenishTick = 10.0, -- Kad 07/07/2017 15:05:44 - Replenish the shield every x seconds by amount.
    gSetting_Feat_PlanetShieldReplenishAmount = 0.05, -- Kad 07/07/2017 15:05:26 - That's a percentage of the max health!
    -- Evaluation intervals:
    gSetting_Eval_OwnerTick = 0.1,   -- owner check loop time
    gSetting_Eval_GUIEventTick = 0.1,    -- how often is the selected planet updated?
    gSetting_Eval_FleetsTick = 1.0,   -- fleet updater loop time
    gSetting_PD_RuinObject = "E_Ground_Heavy_Vehicle_Factory",
    gSetting_PD_BombardmentBurstCount = 4,
    gSetting_PD_BombardmentBurstIntervalMin = 2.0,
    gSetting_PD_BombardmentBurstIntervalMax = 4.0,
    gSetting_PD_BombardmentAttackRatingScaling = 1.0,
    gSetting_PD_BombardmentCapableClassFilter = "Super | Capital | Frigate",
    gSetting_PD_BombardmentBuildingDestructionParticle = "Planet_Explosion_Galactic",
    gSetting_PD_BombardmentUnitDestructionParticle = "Planet_Explosion_Galactic",
    -- Diplomacy settings:
    gSetting_Diplomacy_MaxAllianceTier = 4,
    gSetting_Diplomacy_AllianceThesholds = { [1] = 0.25, [2] = 0.45, [3] = 0.70, [4] = 0.85, [5] = 1.0, }, -- Kad 03/07/2017 11:17:28 - Do not use tier 5, it's just there so a call doesn't return a nil pointer.
    gSetting_Diplomacy_AllianceLostThreshold = 0.15,
    sSetting_Diplomacy_SectorTurnoverPercentageNoCapital = 65,
    sSetting_Diplomacy_SectorTurnoverPercentageCapital = 45,
    gSetting_Diplomacy_MissionDurationFallback = 360,
    gSetting_Diplomacy_InfluenceOnPlanetCap = 200, -- Max influence one can have on a planet.
    gSetting_Diplomacy_InitialPlanetAllianceStrength = 75,    -- On initialisation, all planets are bound to their owner with this alliance factor.
    gSetting_Diplomacy_InitialPlanetInfluenceStrength = 75,
    gSetting_Diplomacy_DiplomaticMissionLocalInfluenceReduction = 0.9, -- Reduces the local influence by 10%.
    gSetting_Diplomacy_OwnerPreviousEvalValueKept = 1.1, -- 10% of the previous evaluation are being added to the new value. A planet "gets used to" its owner.
    -- Event handler settings:
    gSetting_EventHandlerTick = 0.2,   -- Serve events every x seconds
    -- Fleet hyperspace accident:
    gSetting_FleetHyperspaceAccident_ExecuteChance = 0.05,  -- 5% chance of an hyperspace over all.
    gSetting_FleetHyperspaceAccident_AccidentChance = 0.5,  -- 50% chance of an hyperspace accident.
    gSetting_FleetHyperspaceAccident_DestructionParticle = "Planet_Explosion_Galactic",  -- Spawned particle.
    gSetting_FleetHyperspaceAccident_MinShipsDestroyed = 0.1,   -- At least 10% of the contained ships are being destroyed
    gSetting_FleetHyperspaceAccident_MaxShipsDestroyed = 1.0,   -- But up to 100% can be destroyed.
    gSetting_FleetHyperspaceAccident_MinShipsInFleet = 5,  -- Minimum number of ships contained in a fleet before it becomes dangerously large.
    gSetting_FleetHyperspaceAccident_AvoidingUnitTypes = {
        {
            ObjectType = "Generic_Fleet_Commander_Rebel",
            AvoidanceChance = 0.5,
        },
        {
            ObjectType = "Generic_Fleet_Commander_Empire",
            AvoidanceChance = 0.5,
        },
    },
    gSetting_FleetHyperspaceAccident_PreventingUnitTypes = {
        "TIE_Scout",
    },
}

return GlobalConfigurationSettings
