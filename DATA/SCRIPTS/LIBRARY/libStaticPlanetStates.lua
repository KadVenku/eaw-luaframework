-- ===== ===== ===== ===== =====
-- Copyright (c) 2017 Kad Venku
-- License       MIT License
-- ===== ===== ===== ===== =====

local StaticStateDefinitions = {
    ["STATE_INTACT"] = {
        NumericID           = 1,
        UniqueKey           = "STATE_INTACT",
        StateIndicator      = false,
        EvacuateAllUnits    = false,
        TurnsPlanetNeutral  = false,
        BlocksGroundAccess  = false,
        DestroysPlanet      = false,
        EndsCurrentAlliance = false,
        AddsTraitToAttacker = false,
        AddsTraitToDefender = false,
    },
    ["STATE_BOMBARDED"] = {
        NumericID           = 2,
        UniqueKey           = "STATE_BOMBARDED",
        StateIndicator      = "GUI_GC_PLANET_PD_BOMBARDED",
        EvacuateAllUnits    = false,
        TurnsPlanetNeutral  = false,
        BlocksGroundAccess  = false,
        DestroysPlanet      = false,
        EndsCurrentAlliance = false,
        AddsTraitToAttacker = false,
        AddsTraitToDefender = false,
    },
}

return StaticStateDefinitions
