-- ===== ===== ===== ===== =====
-- Copyright (c) 2017 Lukas Grünwald
-- License       MIT License
-- ===== ===== ===== ===== =====


local StaticFactionDefinitions = {
    ["Galactic_Empire"] = {
        StringKey               = "TEXT_FACTION_EMPIRE",
        GameFactionName         = "EMPIRE",
        AffectedByDiplomacy     = true,
        IsProtectoriateOf       = false,
        AllianceStages          = { [1] = {}, [2] = {}, [3] = {}, [4] = {}, },
        HomePlanets             = { "Coruscant", "Byss", "Alderaan", "Fresia", "Corulag", "Corellia", "Kuat", "Kessel", },
        CapitalPlanet           = "Coruscant",
        Traits                  = { "DICTATORSHIP", "PROUD", "MILITARISTIC", },
    },
    ["Rebel_Alliance"] = {
        StringKey               = "TEXT_FACTION_REBELS",
        GameFactionName         = "REBEL",
        AffectedByDiplomacy     = true,
        IsProtectoriateOf       = false,
        AllianceStages          = { [1] = {}, [2] = {}, [3] = {}, [4] = {}, },
        HomePlanets             = { "Hoth", "Mustafar", "Dagobah", "Atzerri", "Endor", "Utapau", },
        CapitalPlanet           = "Hoth",
        Traits                  = { },
    },
    ["Zann_Consortium"] = {
        StringKey               = "TEXT_FACTION_UNDERWORLD",
        GameFactionName         = "UNDERWORLD",
        AffectedByDiplomacy     = true,
        IsProtectoriateOf       = false,
        AllianceStages          = { [1] = {}, [2] = {}, [3] = {}, [4] = {}, },
        HomePlanets             = { "Hypori", "Ryloth", "Mandalore", "Bothawui", "Tatooine", "Geonosis", "Shola", },
        CapitalPlanet           = "Hypori",
        Traits                  = { },
    },
    ["Pirate_Player"] = {
        StringKey               = "TEXT_FACTION_PIRATES",
        GameFactionName         = "PIRATES",
        AffectedByDiplomacy     = false,
        IsProtectoriateOf       = false,
        AllianceStages          = { [1] = {}, [2] = {}, [3] = {}, [4] = {}, },
        HomePlanets             = { },
        CapitalPlanet           = false,
        Traits                  = { },
    },
    ["Neutral_Player"] = {
        StringKey               = "TEXT_FACTION_NEUTRAL",
        GameFactionName         = "NEUTRAL",
        AffectedByDiplomacy     = false,
        IsProtectoriateOf       = false,
        AllianceStages          = { [1] = {}, [2] = {}, [3] = {}, [4] = {}, },
        HomePlanets             = { },
        CapitalPlanet           = false,
        Traits                  = { },
    },
    ["Hostile_Player"] = {
        StringKey               = "TEXT_FACTION_HOSTILE",
        GameFactionName         = "HOSTILE",
        AffectedByDiplomacy     = false,
        IsProtectoriateOf       = false,
        AllianceStages          = { [1] = {}, [2] = {}, [3] = {}, [4] = {}, },
        HomePlanets             = { },
        CapitalPlanet           = false,
        Traits                  = { },
    },
}

return StaticFactionDefinitions
