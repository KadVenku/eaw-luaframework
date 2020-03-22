-- ===== ===== ===== ===== =====
-- Copyright (c) 2017 Kad Venku
-- License       MIT License
-- ===== ===== ===== ===== =====

--- {library} This library contains all usable object types in the game.
-- The way it is set up, it supports multiple affiliations for one single object type by adding factions to the Factions sub-table.
local StaticObjectDefinitionsUnits = {
    {
        -- Generic settings:
        GameObjectTypeXML          = "Imperial_Armor_Group",
        GameObjectTypeCapital      = "IMPERIAL_ARMOR_GROUP",
        AvailableForFactions       = { "Galactic_Empire", },
        GUIFilterTags              = { "UNIT" },
        CategoryMask               = { "tank", },
        ObjectFilterTags           = { "UNIT", "GROUND", },
        ObjectTextID               = "TEXT_IMPERIAL_ARMOR_GROUP",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "Admonitor_Star_Destroyer",
        GameObjectTypeCapital      = "ADMONITOR_STAR_DESTROYER",
        AvailableForFactions       = { "Galactic_Empire", },
        GUIFilterTags              = { "UNIT" },
        CategoryMask               = { "tank", },
        ObjectFilterTags           = { "UNIT", "SPACE", "HERO", "MAJOR_HERO", "DIPLOMAT" },
        ObjectTextID               = "TEXT_UNIT_SD_ADMONITOR",
        HeroType                   = "NONE",
        Traits                     = { "HERO_DIPLOMAT", },
        MaintenanceCost            = 50,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "Imperial_Anti_Aircraft_Company",
        GameObjectTypeCapital      = "IMPERIAL_ANTI_AIRCRAFT_COMPANY",
        AvailableForFactions       = { "Galactic_Empire", },
        GUIFilterTags              = { "UNIT" },
        CategoryMask               = { "tank", },
        ObjectFilterTags           = { "UNIT", "GROUND", },
        ObjectTextID               = "TEXT_IMPERIAL_ANTI_AIRCRAFT",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "Imperial_Heavy_Assault_Company",
        GameObjectTypeCapital      = "IMPERIAL_HEAVY_ASSAULT_COMPANY",
        AvailableForFactions       = { "Galactic_Empire", },
        GUIFilterTags              = { "UNIT" },
        CategoryMask               = { "tank", },
        ObjectFilterTags           = { "UNIT", "GROUND", },
        ObjectTextID               = "TEXT_IMPERIAL_HEAVY_ASSAULT_COMPANY",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "Imperial_Heavy_Scout_Squad",
        GameObjectTypeCapital      = "IMPERIAL_HEAVY_SCOUT_SQUAD",
        AvailableForFactions       = { "Galactic_Empire", },
        GUIFilterTags              = { "UNIT" },
        CategoryMask               = { "Infantry" },
        ObjectFilterTags           = { "UNIT", "GROUND", },
        ObjectTextID               = "TEXT_IMPERIAL_HEAVY_SCOUT_SQUAD",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "Imperial_Artillery_Corp",
        GameObjectTypeCapital      = "IMPERIAL_ARTILLERY_CORP",
        AvailableForFactions       = { "Galactic_Empire", },
        GUIFilterTags              = { "UNIT" },
        CategoryMask               = { "artillery" },
        ObjectFilterTags           = { "UNIT", "GROUND", },
        ObjectTextID               = "TEXT_IMPERIAL_ARTILLERY_CORPS",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "Imperial_Anti_Infantry_Brigade",
        GameObjectTypeCapital      = "IMPERIAL_ANTI_INFANTRY_BRIGADE",
        AvailableForFactions       = { "Galactic_Empire", },
        GUIFilterTags              = { "UNIT" },
        CategoryMask               = { "tank" },
        ObjectFilterTags           = { "UNIT", "GROUND", },
        ObjectTextID               = "TEXT_IMPERIAL_ANTI_INFANTRY",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "Imperial_Stormtrooper_Squad",
        GameObjectTypeCapital      = "IMPERIAL_STORMTROOPER_SQUAD",
        AvailableForFactions       = { "Galactic_Empire", },
        GUIFilterTags              = { "UNIT" },
        CategoryMask               = { "Infantry" },
        ObjectFilterTags           = { "UNIT", "GROUND", },
        ObjectTextID               = "TEXT_IMPERIAL_STORMTROOPER_SQUAD",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "Imperial_Light_Scout_Squad",
        GameObjectTypeCapital      = "IMPERIAL_LIGHT_SCOUT_SQUAD",
        AvailableForFactions       = { "Galactic_Empire", },
        GUIFilterTags              = { "UNIT" },
        CategoryMask               = { "Infantry" },
        ObjectFilterTags           = { "UNIT", "GROUND", },
        ObjectTextID               = "TEXT_IMPERIAL_LIGHT_SCOUT_SQUAD",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "HAV_Juggernaut_Company",
        GameObjectTypeCapital      = "HAV_JUGGERNAUT_COMPANY",
        AvailableForFactions       = { "Galactic_Empire", },
        GUIFilterTags              = { "UNIT", },
        CategoryMask               = { "walker" },
        ObjectFilterTags           = { "UNIT", "GROUND", },
        ObjectTextID               = "TEXT_UNIT_JUGGERNAUT_TEAM",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "Lancet_Air_Wing",
        GameObjectTypeCapital      = "LANCET_AIR_WING",
        AvailableForFactions       = { "Galactic_Empire", },
        GUIFilterTags              = { "UNIT", },
        CategoryMask               = { "artillery" },
        ObjectFilterTags           = { "UNIT", "GROUND", },
        ObjectTextID               = "TEXT_IMPERIAL_LANCET_WING",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "Empire_MDU_Company",
        GameObjectTypeCapital      = "EMPIRE_MDU_COMPANY",
        AvailableForFactions       = { "Galactic_Empire", },
        GUIFilterTags              = { "UNIT", },
        CategoryMask               = { "tank" },
        ObjectFilterTags           = { "UNIT", "GROUND", },
        ObjectTextID               = "TEXT_TOOLTIP_MDU_COMPANY",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "Noghri_Assassin_Squad",
        GameObjectTypeCapital      = "NOGHRI_ASSASSIN_SQUAD",
        AvailableForFactions       = { "Galactic_Empire", },
        GUIFilterTags              = { "UNIT", },
        CategoryMask               = { "Infantry" },
        ObjectFilterTags           = { "UNIT", "GROUND", },
        ObjectTextID               = "TEXT_NOGHRI_ASSASSIN_SQUAD",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "DarkTrooper_P1_Company",
        GameObjectTypeCapital      = "DARKTROOPER_P1_COMPANY",
        AvailableForFactions       = { "Galactic_Empire", },
        GUIFilterTags              = { "UNIT", },
        CategoryMask               = { "artillery" },
        ObjectFilterTags           = { "UNIT", "GROUND", },
        ObjectTextID               = "TEXT_TOOLTIP_DARKTROOPER_P1_COMPANY",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "DarkTrooper_P2_Company",
        GameObjectTypeCapital      = "DARKTROOPER_P2_COMPANY",
        AvailableForFactions       = { "Galactic_Empire", },
        GUIFilterTags              = { "UNIT", },
        CategoryMask               = { "artillery" },
        ObjectFilterTags           = { "UNIT", "GROUND", },
        ObjectTextID               = "TEXT_TOOLTIP_DARKTROOPER_P2_COMPANY",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "DarkTrooper_P3_Company",
        GameObjectTypeCapital      = "DARKTROOPER_P3_COMPANY",
        AvailableForFactions       = { "Galactic_Empire", },
        GUIFilterTags              = { "UNIT", },
        CategoryMask               = { "artillery" },
        ObjectFilterTags           = { "UNIT", "GROUND", },
        ObjectTextID               = "TEXT_TOOLTIP_DARKTROOPER_P3_COMPANY",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "Rebel_Speeder_Wing",
        GameObjectTypeCapital      = "REBEL_SPEEDER_WING",
        AvailableForFactions       = { "Rebel_Alliance" },
        GUIFilterTags              = { "UNIT", },
        CategoryMask               = { "walker" },
        ObjectFilterTags           = { "UNIT", "GROUND", },
        ObjectTextID               = "TEXT_REBEL_SPEEDER_WING",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "Rebel_Artillery_Brigade",
        GameObjectTypeCapital      = "REBEL_ARTILLERY_BRIGADE",
        AvailableForFactions       = { "Rebel_Alliance" },
        GUIFilterTags              = { "UNIT", },
        CategoryMask               = { "artillery" },
        ObjectFilterTags           = { "UNIT", "GROUND", },
        ObjectTextID               = "TEXT_REBEL_ARTILLERY_BRIGADE",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "Rebel_Light_Tank_Brigade",
        GameObjectTypeCapital      = "REBEL_LIGHT_TANK_BRIGADE",
        AvailableForFactions       = { "Rebel_Alliance" },
        GUIFilterTags              = { "UNIT", },
        CategoryMask               = { "tank" },
        ObjectFilterTags           = { "UNIT", "GROUND", },
        ObjectTextID               = "TEXT_REBEL_LIGHT_TANK_BRIGADE",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "Rebel_Heavy_Tank_Brigade",
        GameObjectTypeCapital      = "REBEL_HEAVY_TANK_BRIGADE",
        AvailableForFactions       = { "Rebel_Alliance" },
        GUIFilterTags              = { "UNIT", },
        CategoryMask               = { "tank" },
        ObjectFilterTags           = { "UNIT", "GROUND", },
        ObjectTextID               = "TEXT_REBEL_HEAVY_TANK_BRIGADE",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "Rebel_Infantry_Squad",
        GameObjectTypeCapital      = "REBEL_INFANTRY_SQUAD",
        AvailableForFactions       = { "Rebel_Alliance" },
        GUIFilterTags              = { "UNIT", },
        CategoryMask               = { "Infantry" },
        ObjectFilterTags           = { "UNIT", "GROUND", },
        ObjectTextID               = "TEXT_REBEL_INFANTRY_SQUAD",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "Rebel_Tank_Buster_Squad",
        GameObjectTypeCapital      = "REBEL_TANK_BUSTER_SQUAD",
        AvailableForFactions       = { "Rebel_Alliance" },
        GUIFilterTags              = { "UNIT", },
        CategoryMask               = { "Infantry" },
        ObjectFilterTags           = { "UNIT", "GROUND", },
        ObjectTextID               = "TEXT_REBEL_TANK_BUSTER_SQUAD",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "Rebel_Infiltrator_Team",
        GameObjectTypeCapital      = "REBEL_INFILTRATOR_TEAM",
        AvailableForFactions       = { "Rebel_Alliance" },
        GUIFilterTags              = { "UNIT", },
        CategoryMask               = { "Infantry" },
        ObjectFilterTags           = { "UNIT", "GROUND", },
        ObjectTextID               = "TEXT_UNIT_REBEL_INFILTRATOR",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "Rebel_MDU_Company",
        GameObjectTypeCapital      = "REBEL_MDU_COMPANY",
        AvailableForFactions       = { "Rebel_Alliance" },
        GUIFilterTags              = { "UNIT", },
        CategoryMask               = { "tank" },
        ObjectFilterTags           = { "UNIT", "GROUND", },
        ObjectTextID               = "TEXT_TOOLTIP_MDU_COMPANY",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "Gallofree_HTT_Company",
        GameObjectTypeCapital      = "GALLOFREE_HTT_COMPANY",
        AvailableForFactions       = { "Rebel_Alliance" },
        GUIFilterTags              = { "UNIT", },
        CategoryMask               = { "tank" },
        ObjectFilterTags           = { "UNIT", "GROUND", },
        ObjectTextID               = "TEXT_UNIT_G-HTT_TRANSPORT_COMPANY",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },

    {
        -- Generic settings:
        GameObjectTypeXML          = "Underworld_MDU_Company",
        GameObjectTypeCapital      = "UNDERWORLD_MDU_COMPANY",
        AvailableForFactions       = { "Zann_Consortium" },
        GUIFilterTags              = { "UNIT", },
        CategoryMask               = { "tank" },
        ObjectFilterTags           = { "UNIT", "GROUND", },
        ObjectTextID               = "TEXT_TOOLTIP_MDU_COMPANY",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "Vornskr_Wolf_Pack",
        GameObjectTypeCapital      = "VORNSKR_WOLF_PACK",
        AvailableForFactions       = { "Zann_Consortium" },
        GUIFilterTags              = { "UNIT", },
        CategoryMask               = { "Infantry" },
        ObjectFilterTags           = { "UNIT", "GROUND", },
        ObjectTextID               = "TEXT_UNIT_VORNSKR_WOLF_PACK",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "Destroyer_Droid_Company",
        GameObjectTypeCapital      = "DESTROYER_DROID_COMPANY",
        AvailableForFactions       = { "Zann_Consortium" },
        GUIFilterTags              = { "UNIT", },
        CategoryMask               = { "Infantry" },
        ObjectFilterTags           = { "UNIT", "GROUND", },
        ObjectTextID               = "TEXT_DESTROYER_DROID_COMPANY",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "Underworld_Ewok_Handler_Company",
        GameObjectTypeCapital      = "UNDERWORLD_EWOK_HANDLER_COMPANY",
        AvailableForFactions       = { "Zann_Consortium" },
        GUIFilterTags              = { "UNIT", },
        CategoryMask               = { "Infantry" },
        ObjectFilterTags           = { "UNIT", "GROUND", },
        ObjectTextID               = "TEXT_UNIT_EWOK_HANDLER",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "F9TZ_Cloaking_Transport_Company",
        GameObjectTypeCapital      = "F9TZ_CLOAKING_TRANSPORT_COMPANY",
        AvailableForFactions       = { "Zann_Consortium" },
        GUIFilterTags              = { "UNIT", },
        CategoryMask               = { "tank" },
        ObjectFilterTags           = { "UNIT", "GROUND", },
        ObjectTextID               = "TEXT_F9TZ_TRANSPORT_COMPANY",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "MAL_Rocket_Vehicle_Company",
        GameObjectTypeCapital      = "MAL_ROCKET_VEHICLE_COMPANY",
        AvailableForFactions       = { "Zann_Consortium" },
        GUIFilterTags              = { "UNIT", },
        CategoryMask               = { "artillery" },
        ObjectFilterTags           = { "UNIT", "GROUND", },
        ObjectTextID               = "TEXT_UNIT_MAL_COMPANY",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "MZ8_Pulse_Cannon_Tank_Company",
        GameObjectTypeCapital      = "MZ8_PULSE_CANNON_TANK_COMPANY",
        AvailableForFactions       = { "Zann_Consortium" },
        GUIFilterTags              = { "UNIT", },
        CategoryMask               = { "tank" },
        ObjectFilterTags           = { "UNIT", "GROUND", },
        ObjectTextID               = "TEXT_UNIT_MZ8_PC_TANK_COMPANY",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "Night_Sister_Company",
        GameObjectTypeCapital      = "NIGHT_SISTER_COMPANY",
        AvailableForFactions       = { "Zann_Consortium" },
        GUIFilterTags              = { "UNIT", },
        CategoryMask               = { "Infantry" },
        ObjectFilterTags           = { "UNIT", "GROUND", },
        ObjectTextID               = "TEXT_UNIT_NIGHT_SISTER",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "Canderous_Assault_Tank_Company",
        GameObjectTypeCapital      = "CANDEROUS_ASSAULT_TANK_COMPANY",
        AvailableForFactions       = { "Zann_Consortium" },
        GUIFilterTags              = { "UNIT", },
        CategoryMask               = { "tank" },
        ObjectFilterTags           = { "UNIT", "GROUND", },
        ObjectTextID               = "TEXT_UNIT_CANDEROUS_TANK_COMPANY",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "Underworld_Disruptor_Merc_Squad",
        GameObjectTypeCapital      = "UNDERWORLD_DISRUPTOR_MERC_SQUAD",
        AvailableForFactions       = { "Zann_Consortium" },
        GUIFilterTags              = { "UNIT", },
        CategoryMask               = { "Infantry" },
        ObjectFilterTags           = { "UNIT", "GROUND", },
        ObjectTextID               = "TEXT_UNIT_UNDERWORLD_DISRUPTOR_MERC_SQUAD",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "Underworld_Merc_Squad",
        GameObjectTypeCapital      = "UNDERWORLD_MERC_SQUAD",
        AvailableForFactions       = { "Zann_Consortium" },
        GUIFilterTags              = { "UNIT", },
        CategoryMask               = { "Infantry" },
        ObjectFilterTags           = { "UNIT", "GROUND", },
        ObjectTextID               = "TEXT_UNIT_UNDERWORLD_MERC_SQUAD",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "Tartan_Patrol_Cruiser",
        GameObjectTypeCapital      = "TARTAN_PATROL_CRUISER",
        AvailableForFactions       = { "Galactic_Empire", },
        GUIFilterTags              = { "UNIT", },
        CategoryMask               = { "corvette" },
        ObjectFilterTags           = { "UNIT", "SPACE", },
        ObjectTextID               = "TEXT_UNIT_TARTAN_CRUISER",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "IPV1_System_Patrol_Craft",
        GameObjectTypeCapital      = "IPV1_SYSTEM_PATROL_CRAFT",
        AvailableForFactions       = { "Galactic_Empire", },
        GUIFilterTags              = { "UNIT", },
        CategoryMask               = { "corvette" },
        ObjectFilterTags           = { "UNIT", "SPACE", },
        ObjectTextID               = "TEXT_UNIT_IPV1_SYSTEM",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "Broadside_Class_Cruiser",
        GameObjectTypeCapital      = "BROADSIDE_CLASS_CRUISER",
        AvailableForFactions       = { "Galactic_Empire", },
        GUIFilterTags              = { "UNIT", },
        CategoryMask               = { "corvette" },
        ObjectFilterTags           = { "UNIT", "SPACE", },
        ObjectTextID               = "TEXT_UNIT_BROADSIDE_CRUISER",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "Victory_Destroyer",
        GameObjectTypeCapital      = "VICTORY_DESTROYER",
        AvailableForFactions       = { "Galactic_Empire", },
        GUIFilterTags              = { "UNIT", },
        CategoryMask               = { "frigate" },
        ObjectFilterTags           = { "UNIT", "SPACE", },
        ObjectTextID               = "TEXT_UNIT_VICTORY_DESTROYER",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "Acclamator_Assault_Ship",
        GameObjectTypeCapital      = "ACCLAMATOR_ASSAULT_SHIP",
        AvailableForFactions       = { "Galactic_Empire", },
        GUIFilterTags              = { "UNIT", },
        CategoryMask               = { "frigate" },
        ObjectFilterTags           = { "UNIT", "SPACE", },
        ObjectTextID               = "TEXT_UNIT_ACCLAMATOR",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "Interdictor_Cruiser",
        GameObjectTypeCapital      = "INTERDICTOR_CRUISER",
        AvailableForFactions       = { "Galactic_Empire", },
        GUIFilterTags              = { "UNIT", },
        CategoryMask               = { "frigate" },
        ObjectFilterTags           = { "UNIT", "SPACE", },
        ObjectTextID               = "TEXT_UNIT_INTERDICTOR_CRUISER",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "Star_Destroyer",
        GameObjectTypeCapital      = "STAR_DESTROYER",
        AvailableForFactions       = { "Galactic_Empire", },
        GUIFilterTags              = { "UNIT", },
        CategoryMask               = { "capital" },
        ObjectFilterTags           = { "UNIT", "SPACE", },
        ObjectTextID               = "TEXT_UNIT_STAR_DESTROYER",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
    {
        -- Generic settings:
        GameObjectTypeXML          = "Probe_Droid_Team",
        GameObjectTypeCapital      = "PROBE_DROID_TEAM",
        AvailableForFactions       = { "Galactic_Empire", },
        GUIFilterTags              = { "UNIT", },
        CategoryMask               = { "NonCombatHero" },
        ObjectFilterTags           = { "UNIT", "SPACE", },
        ObjectTextID               = "TEXT_HERO_UNIT_PROBE_DROID",
        HeroType                   = "NONE",
        Traits                     = { },
        MaintenanceCost            = 5,
        DiplomaticInfluence        = 0.0,
        DiplomaticRating           = 0,
        -- Unit specific settings:
    },
}

return StaticObjectDefinitionsUnits
