-- ===== ===== ===== ===== =====
-- Copyright (c) 2017 Lukas Grünwald
-- License       MIT License
-- ===== ===== ===== ===== =====

--- {abstract} Base cFaction class.
-- Base class for all faction types.

-- Import new functions:
require( "libErrorFunctions" )
require( "libDebugFunctions" )
require( "libPGGenericFunctionLibrary" )

cFaction = {}
cFaction.__index = cFaction

--- {abstract} Constructor.
-- Creates a new LUA object of type cFaction.
-- @tparam cGalacticConquest parentGC The parent GC for this faction.
-- @tparam String newFactionName Used as key to load all relevant data from the static faction table.
-- @within Initialisation
function cFaction.New( parentGC, newFactionName )
    local self = setmetatable( {}, cFaction )

    self.Name             = newFactionName
    self.Parent           = parentGC
    self.ObjectType       = "TEXT_LUA_OBJECT_TYPE_FACTION"

    -- Initialisation from static library:
    local FactionDataTable = require( "libStaticFactionDefinitions" )
    if FactionDataTable[newFactionName] ~= nil then
        self.StringKey                 = FactionDataTable[newFactionName].StringKey
        self.GameFactionName           = FactionDataTable[newFactionName].GameFactionName
        self.PlayerObject              = Find_Player( self.GameFactionName )
        self.IsHuman                   = false
        self.FactionMilitaryStrength   = 0.0  -- Military strength of a faction.
        self.FactionDiplomaticStrength = 0.0  -- diplomatic strength of a faction. How many allies do we have? Who is the protector of this faction?
        self.FactionGalacticPerception = 0.0    -- How do other factions see this faction? It's a value computed from a factions military and diplomatic strength, as well as its allies.
        self.AffectedByDiplomacy       = FactionDataTable[newFactionName].AffectedByDiplomacy -- Can we use diplomacy with this faction?
        self.IsProtectoriateOf         = false   -- Only used for minor factions.
        self.HomePlanets               = { }  -- This was previously handled as sector. Now it's more open to support factions instead.
        self.CapitalPlanet             = nil  -- Capital of the sector.
        self.Traits                    = { }  -- Tags with traits which affect how a faction reacts to you. The Empire won't be impressed all that much by raw military strength, things like that.
        self.CurrentlyBuildableObjects = { }
        self.DebugModeActive           = require( "configGlobalSettings" ).gSetting_DebugMode
    else
        ThrowObjectInitialisationError( self.ObjectType )
    end

    return self
end

--- {abstract}.
-- Empty dummy: All factions are either major or minor.
-- @within {abstract} Initialisation
function cFaction:Initialise()
    return false
end
--- Initialises the home sector of a faction.
-- Attributes the specified planets to the faction.
-- Updates a planet to be capital.
-- @tparam table sectorPlanetTable Contains all planets of a sector.
-- @tparam string capitalPlanetName Name of the capital. Has to be contained within the sector table.
-- @within Initialisation
function cFaction:InitialiseHomeSector( sectorPlanetTable, capitalPlanetName )
    if table.getn( sectorPlanetTable ) > 0 then
        for _,newPlanetName in pairs( sectorPlanetTable ) do
            local planetObj = self.Parent:GetPlanetObjectByName( newPlanetName )
            if planetObj then
                table.insert( self.HomePlanets, planetObj )
                planetObj:SetParentFaction( self )
                if newPlanetName == capitalPlanetName then
                    planetObj:SetIsCapital( true )
                end
            end
        end
    end
end
--- Initializes the faction traits.
-- Only loads traits which are defined, if a trait is not defined, the trait will be skipped.
function cFaction:InitialiseTraits( traitTable )
    local lTraitTable = traitTable
    local lTraitDefinitions = require( "libStaticTraitDefinitions" ).FactionTraits
    for _,trait in pairs(lTraitDefinitions) do
        if IsContentOfTable( lTraitTable, trait.TraitID ) then
            table.insert( self.Traits, trait )
        end
    end
end

function cFaction:IsPlanetPartOfHomeSector( cPlanetObj )
    return IsContentOfTable( self.HomePlanets, cPlanetObj )
end

--- Returns a faction's name (Not the string key or the PlayerObject).
-- @treturn String
-- @within Getter functions
function cFaction:GetName()
    return self.Name
end
--- Returns a faction's string key.
-- @treturn String
-- @within Getter functions
function cFaction:GetStringKey()
    return self.StringKey
end
--- Returns a faction's gameFactionName.
-- @treturn String
-- @within Getter functions
function cFaction:GetGameFactionName()
    return self.GameFactionName
end
--- Returns a faction's object type.
-- @treturn String
-- @within Getter functions
function cFaction:GetObjectType()
    return self.ObjectType
end
--- Returns the PlayerObject for a faction.
-- @treturn PlayerObject
-- @within Getter functions
function cFaction:GetPlayerObject()
    return self.PlayerObject
end
--- Is the faction human or AI?.
-- Wrapper function for the game's Is_Human() function to work with a cFaction object.
-- @treturn Bool
-- @within Getter functions
function cFaction:GetIsHumanPlayer()
    return self.IsHuman
end
--- Returns a faction's traits.
-- Traits are keywords used to describe a faction, they influence the base behaviour and buff/debuff values.
-- @treturn table Trait table.
function cFaction:GetTraits()
    return self.Traits
end
function cFaction:AddNewTrait( newTrait )
    local nTrait = false
    local lFactionTraits = require( "libStaticTraitDefinitions" ).FactionTraits
    for _,trait in pairs( lFactionTraits ) do
        if trait.TraitID == newTrait then
            nTrait = trait
            break
        end
    end
    if nTrait then
        table.insert( self.Traits, nTrait )
    end
end
--- Returns a faction's raw military strength without trait modifiers applied.
-- This should not be used unless a specific function requires the raw value.
-- @treturn number Raw military strength.
function cFaction:GetRawMilitaryStrength()
    return self.FactionMilitaryStrength
end
--- Returns the home sectors of the planets.
function cFaction:GetHomeSector()
    return self.HomePlanets
end
--- {abstract}.
-- Empty dummy, always returns false.
-- @treturn Bool false
-- @within {abstract} Evaluations
function cFaction:EvaluateHumanPlayer()
    return false
end
--- {abstract}.
-- Empty dummy, always returns false.
-- @treturn Bool false
-- @within {abstract} Evaluations
function cFaction:AddDiplomaticMission( mission )
    return false
end
--- {abstract}.
-- Empty dummy, always returns false.
-- @treturn Bool false
-- @within {abstract} Evaluations
function cFaction:RemoveDiplomaticMission( mission )
    return false
end
--- {abstract}.
-- Empty dummy, always returns false.
-- @treturn Bool false
-- @within {abstract} Evaluations
function cFaction:UpdateDiplomaticMissionHolochron()
    return false
end
--- {abstract}.
-- Empty dummy, always returns false.
-- @treturn Bool false
-- @within {abstract} Evaluations
function cFaction:ClearDiplomaticMissionHolochron()
    return false
end
--- {abstract}.
-- Empty dummy, always returns false.
-- @treturn Bool false
-- @within {abstract} Evaluations
function cFaction:GetProtectorates()
    return false
end
--- {abstract}.
-- Empty dummy, always returns false.
-- @treturn Bool false
-- @within {abstract} Evaluations
function cFaction:MakeAlly()
    return false
end
--- {abstract}.
-- Empty dummy, always returns false.
-- @treturn Bool false
-- @within {abstract} Evaluations
function cFaction:IsAlliedWith()
    return false
end
--- {abstract}.
-- Empty dummy, always returns false.
-- @treturn Bool false
-- @within {abstract} Evaluations
function cFaction:GetAlly()
    return false
end
--- {abstract}.
-- Empty dummy, always returns false.
-- @treturn Bool false
-- @within {abstract} Evaluations
function cFaction:GetIsDiplomacyStageTriggered()
    return true -- Kad 30/06/2017 23:18:57 - Using a little trick here: Usually we test for false, this function is testing for true instead, so we just assume we've already ticked the state and do nothing.
end
--- {abstract}.
-- Empty dummy, always returns false.
-- @treturn Bool false
-- @within {abstract} Evaluations
function cFaction:GetRewardSet()
    return false
end
--- Evaluates a faction's raw military strength.
-- This should only be called before the raw strength is needed as a value, not continuously updated without use.
-- @treturn number Raw strength.
function cFaction:EvaluateRawMilitaryStrength()
    local factionMilitaryStrength = 0.0
    local facObj = self:GetPlayerObject()
    local objectTable = Find_All_Objects_Of_Type( facObj )
    for _,object in pairs( objectTable ) do
        local objRating = object.Get_Type().Get_Combat_Rating()
        factionMilitaryStrength = factionMilitaryStrength + objRating
    end
    self.FactionMilitaryStrength = factionMilitaryStrength
    return factionMilitaryStrength
end

return cFaction
