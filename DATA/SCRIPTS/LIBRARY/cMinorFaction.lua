-- ===== ===== ===== ===== =====
-- Copyright (c) 2017 Kad Venku
-- License       MIT License
-- ===== ===== ===== ===== =====

--- cMinorFaction class.
-- Used to mirror all non-playable factions.

-- Import new functions:
require( "libErrorFunctions" )
require( "libDebugFunctions" )
-- Import new classes:
require( "cFaction" )

cMinorFaction = {}
cMinorFaction.__index = cMinorFaction
setmetatable( cMinorFaction, { __index = cFaction } )

--- Constructor.
-- Creates a new LUA object of type cMinorFaction.
-- @tparam cGalacticConquest parentGC The parent GC for this faction.
-- @tparam String newFactionName Used as key to load all relevant data from the static faction table.
-- @within Initialisation
function cMinorFaction.New( parentGC, newFactionName )
    local self = setmetatable( {}, cMinorFaction )

    self.Name             = newFactionName
    self.Parent           = parentGC
    self.ObjectType       = "TEXT_LUA_OBJECT_TYPE_FACTION_MINOR"

    -- Initialisation from static library:
    local FactionDataTable = require( "libStaticFactionDefinitions" )
    if FactionDataTable[newFactionName] ~= nil then
        self.StringKey                 = FactionDataTable[newFactionName].StringKey
        self.GameFactionName           = FactionDataTable[newFactionName].GameFactionName
        self.PlayerObject              = Find_Player( self.GameFactionName )
        self.IsHuman                   = false  -- Simply setting this to false, because minor factions are never playable.
        self.FactionMilitaryStrength   = 0.0  -- Military strength of a faction.
        self.FactionDiplomaticStrength = 0.0  -- diplomatic strength of a faction. How many allies do we have? Who is the protector of this faction?
        self.FactionGalacticPerception = 0.0    -- How do other factions see this faction? It's a value computed from a factions military and diplomatic strength, as well as its allies.
        self.AffectedByDiplomacy       = FactionDataTable[newFactionName].AffectedByDiplomacy -- Can we use diplomacy with this faction?
        self.AllianceTiers             = FactionDataTable[newFactionName].AllianceStages
        self.IsProtectoriateOf         = false   -- Only used for minor factions.
        self.HomePlanets               = { }  -- This was previously handled as sector. Now it's more open to support factions instead.
        self.CapitalPlanet             = nil  -- Capital of the sector.
        self.Traits                    = FactionDataTable[newFactionName].Traits  -- Tags with traits which affect how a faction reacts to you. The Empire won't be impressed all that much by raw military strength, things like that.
        self.CurrentlyBuildableObjects = { }
        self.Protectorates             = { }
        self.DebugModeActive           = require( "configGlobalSettings" ).gSetting_DebugMode
    else
        ThrowObjectInitialisationError( self.ObjectType )
    end

    return self
end

--- Initialisation function.
-- This can only be called after all necessary objects have been created, as those attributes reflect interactions between objects.
-- @within Initialisation
function cMinorFaction:Initialise()
    local FactionDataTable = require( "libStaticFactionDefinitions" )
    if FactionDataTable[self:GetName()] == nil then
        ThrowObjectInitialisationError( self.ObjectType )
    else
        -- self.FactionMilitaryStrength   = self:EvaluateFactionMilitaryStrength()
        -- self.FactionDiplomaticStrength = self:EvaluateFactionDiplomaticStrength()
        -- self.FactionGalacticPerception = self:EvaluateFactionGalacticPerception()
        if FactionDataTable[self:GetName()].IsProtectoriateOf then
            self.IsProtectoriateOf     = self.Parent:GetFactionObjectByName( FactionDataTable[self:GetName()].IsProtectoriateOf )
        end
        local lHomePlanets = FactionDataTable[self:GetName()].HomePlanets
        local lCapital = FactionDataTable[self:GetName()].CapitalPlanet
        self:InitialiseHomeSector( lHomePlanets, lCapital )
        local lTraits = FactionDataTable[self:GetName()].Traits
        if lTraits or table.getn( lTraits ) > 0 then
            self:InitialiseTraits( lTraits )
        end
        self:EvaluateRawMilitaryStrength()
    end
end
function cMinorFaction:MakeAlly( cMajorFaction )
    self.IsProtectoriateOf = cMajorFaction
end
function cMinorFaction:GetRewardSet( rewardSetID )
    return self.AllianceTiers[rewardSetID]
end

return cMinorFaction
