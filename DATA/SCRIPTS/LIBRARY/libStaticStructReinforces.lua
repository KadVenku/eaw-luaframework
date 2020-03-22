-- ===== ===== ===== ===== =====
-- Copyright (c) 2017 Kad Venku
-- License       MIT License
-- ===== ===== ===== ===== =====

local ReinforceStructTable = {
    ["TEST_STRUCT"] = {
        Objects = {
            {
                ObjectType  = "Tartan_Patrol_Cruiser",
                ObjectCount = 8,
                Commander   = false,
            },
            {
                ObjectType  = "Nebulon_B_Frigate",
                ObjectCount = 5,
                Commander   = true,
            },
        },
        FleeOnFlagshipDestruction = true,
        AutonomousAI              = true,
        AIFaction                 = "Pirates",
        SupportsFaction           = "Empire",
    },
    ["SPAWN_THRAWN"] = {
        Objects = {
            {
                ObjectType  = "Admonitor_Star_Destroyer",
                ObjectCount = 1,
                Commander   = false,
            },
        },
        FleeOnFlagshipDestruction = true,
        AutonomousAI              = true,
        AIFaction                 = "Pirates",
        SupportsFaction           = "Empire",
    },
}

return ReinforceStructTable
