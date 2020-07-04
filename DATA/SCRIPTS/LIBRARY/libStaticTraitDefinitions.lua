-- ===== ===== ===== ===== =====
-- Copyright (c) 2017 Lukas Grünwald
-- License       MIT License
-- ===== ===== ===== ===== =====

--- Trait definitions.
-- Traits can be used to make factions more unique in terms of their reaction to certain external influence, but also on terms of how they are perceived by other forces.
-- The numeric values are to be treated as percentages, so if you want to boost a rating use a value x > 1.0, if you want to reduce a rating use a value 0.0 <= x < 1.0, If you don't wan the attribute to be influenced use a multiplier of x = 1.0.
-- Currently used values are:
-- @usage
-- ["TRAITNAME"] = {
--     MilitaryPowerMult       = 1.000, -- The faction's military power is multiplied by this modifier.
--     MilitaryInfluenceMult   = 1.000, -- The faction is more/less susceptible to military intimidation.
--     DiplomaticPowerMult     = 1.000, -- The faction's diplomatic influence is diminished/boosted by this amount.
--     DiplomaticInfluenceMult = 1.000, -- The faction is more/less influenced via diplomatic means.
--     MaintenanceMult         = 1.000, -- Does the trait influence the maintenance cost of units.
-- },
-- Traits have been expanded to also support objects. Being a diplomat now is a object trait, this allows for faster filtering and better reaction to circumstances.
local StaticTraitDefinitions = {
    FactionTraits = {
        {
            TraitID                 = "DEMOCRACY",
            MilitaryPowerMult       = 0.850,
            MilitaryInfluenceMult   = 0.650,
            DiplomaticPowerMult     = 1.150,
            DiplomaticInfluenceMult = 1.050,
            MaintenanceMult         = 1.000,
        }, -- DEMOCRACY trait: A faction that is a democracy uses those base multipliers. It tries to reflect the much higher valued democratic approach in relation to the "last resort" military way.
        {
            TraitID                 = "DICTATORSHIP",
            MilitaryPowerMult       = 1.050,
            MilitaryInfluenceMult   = 1.000,
            DiplomaticPowerMult     = 0.850,
            DiplomaticInfluenceMult = 0.800,
            MaintenanceMult         = 1.000,
        },-- DICTATORSHIP trait: A faction that is governed by a dictator values military approach higher than diplomatic approaches.
        {
            TraitID                 = "PROUD",
            MilitaryPowerMult       = 1.250,
            MilitaryInfluenceMult   = 0.900,
            DiplomaticPowerMult     = 1.000,
            DiplomaticInfluenceMult = 0.855,
            MaintenanceMult         = 1.000,
        }, -- PROUD trait: The faction is very proud of itself, thus valuing its military power way higher than it actually is, whilst giving less about the opinions of other factions.
        {
            TraitID                 = "MILITARISTIC",
            MilitaryPowerMult       = 1.225,
            MilitaryInfluenceMult   = 1.112,
            DiplomaticPowerMult     = 1.000,
            DiplomaticInfluenceMult = 1.000,
            MaintenanceMult         = 1.000,
        }, -- MILITARISTIC trait: Bonus to military power. Values an opponent's military power as well.
        {
            TraitID                 = "ISOLATIONIST",
            MilitaryPowerMult       = 1.000,
            MilitaryInfluenceMult   = 0.850,
            DiplomaticPowerMult     = 1.000,
            DiplomaticInfluenceMult = 0.800,
            MaintenanceMult         = 1.015,
        },-- ISOLATIONIST trait: Doesn't give much on opponent's influences, but increased maintenance cost due to the isolation.
        {
            TraitID                 = "WAR_CRIMINAL_BOMBARDMENT",
            MilitaryPowerMult       = 1.050,
            MilitaryInfluenceMult   = 0.750,
            DiplomaticPowerMult     = 0.850,
            DiplomaticInfluenceMult = 0.985,
            MaintenanceMult         = 1.000,
        }, -- WAR_CRIMINAL_BOMBARDMENT trait: Used to reduce all subsequent diplomatic actions with this faction.
    },
    GameObjectTraits = {
        {
            TraitID                         = "BASE_DIPLOMAT",
            DiplomaticInfluenceBaseValue    = 15.0,
            DiplomaticInfluenceMultiplier   = 1.02,
            DiplomaticInfluenceDamageChance = 0.085,
            DiplomaticMissionDuration       = 180, -- Time in seconds
        },

        {
            TraitID                         = "HERO_DIPLOMAT",
            DiplomaticInfluenceBaseValue    = 18.5,
            DiplomaticInfluenceMultiplier   = 1.035,
            DiplomaticInfluenceDamageChance = 0.015,
            DiplomaticMissionDuration       = 120, -- Time in seconds
        },
    },
}

return StaticTraitDefinitions
