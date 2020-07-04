-- ===== ===== ===== ===== =====
-- Copyright (c) 2017 Lukas Grünwald
-- License       MIT License
-- ===== ===== ===== ===== =====

--- cMajorFaction class.
-- Used to mirror all playable factions.

-- Import new functions:
require( "libErrorFunctions" )
require( "libDebugFunctions" )
-- Import new classes:
require( "cFaction" )

cMajorFaction = {}
cMajorFaction.__index = cMajorFaction
setmetatable( cMajorFaction, { __index = cFaction } )

--- Constructor.
-- Creates a new LUA object of type cMajorFaction.
-- @tparam cGalacticConquest parentGC The parent GC for this faction.
-- @tparam String newFactionName Used as key to load all relevant data from the static faction table.
-- @within Initialisation
function cMajorFaction.New( parentGC, newFactionName )
    local self = setmetatable( {}, cMajorFaction )

    self.Name             = newFactionName
    self.Parent           = parentGC
    self.ObjectType       = "TEXT_LUA_OBJECT_TYPE_FACTION_MAJOR"

    -- Initialisation from static library:
    local FactionDataTable = require( "libStaticFactionDefinitions" )
    if FactionDataTable[newFactionName] ~= nil then
        self.StringKey                 = FactionDataTable[newFactionName].StringKey
        self.GameFactionName           = FactionDataTable[newFactionName].GameFactionName
        self.AllianceTiers             = FactionDataTable[newFactionName].AllianceStages
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
        self.ActiveDiplomaticMissions  = { }
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
function cMajorFaction:Initialise()
    local FactionDataTable = require( "libStaticFactionDefinitions" )
    if FactionDataTable[self:GetName()] == nil then
        ThrowObjectInitialisationError( self.ObjectType )
    else
        self.IsHuman                   = self:EvaluateHumanPlayer()
        -- self.FactionMilitaryStrength   = self:EvaluateFactionMilitaryStrength()
        -- self.FactionDiplomaticStrength = self:EvaluateFactionDiplomaticStrength()
        -- self.FactionGalacticPerception = self:EvaluateFactionGalacticPerception()
        local lHomePlanets = FactionDataTable[self:GetName()].HomePlanets
        local lCapital = FactionDataTable[self:GetName()].CapitalPlanet
        self:InitialiseHomeSector( lHomePlanets, lCapital )
        local lTraits = FactionDataTable[self:GetName()].Traits
        if lTraits then
            if table.getn( lTraits ) > 0 then
                self:InitialiseTraits( lTraits )
            end
        end
        self:EvaluateRawMilitaryStrength()
    end
end

--- Overwrites the default cFaction:EvaluateHumanPlayer() function to actually do something useful.
-- @treturn Bool
-- @within Evaluations
function cMajorFaction:EvaluateHumanPlayer()
    local isHuman = self:GetPlayerObject().Is_Human()
    if isHuman and self.DebugModeActive then
        debugPushDroidMessage( "TEXT_DEBUG_GC_HUMAN_PLAYER_FOUND" )
        debugPushDroidMessage( self:GetStringKey() )
    end
    return isHuman
end
function cMajorFaction:GetProtectorates()
    return self.Protectorates
end
function cMajorFaction:AddDiplomaticMission( mission )
    table.insert( self.ActiveDiplomaticMissions, mission )
end
function cMajorFaction:ClearDiplomaticMissionHolochron()
    Story_Event( "info_DisplayActiveDiplomaticMissionsReset_Trigger" )
end

function cMajorFaction:UpdateDiplomaticMissionHolochron()
    local dipMis = self.ActiveDiplomaticMissions
    local displayEvent = Get_Story_Plot( "__luaFramework/cGUIHandler/cGUIMissionHolochronOutput.xml" ).Get_Event( "info_DisplayActiveDiplomaticMissions" )
    local dialogFile = "hcActiveDiplomaticMissions"
    local addedMission = false
    displayEvent.Clear_Dialog_Text()
    displayEvent.Add_Dialog_Text( "TEXT_OUT_FORMATTED_SEPARATOR" )
    for _, diplMission in pairs( dipMis ) do
        displayEvent.Add_Dialog_Text( "TEXT_OUT_FORMATTED_NEWLINE" )
        displayEvent.Add_Dialog_Text( "TEXT_MISSION_CONTENT_ACTIVE_DIPLOMATIC_MISSION_AT", diplMission.Planet:GetStringKey() )
        displayEvent.Add_Dialog_Text( "TEXT_MISSION_CONTENT_ACTIVE_DIPLOMATIC_MISSION_LED_BY", diplMission.Diplomat:GetStringKey() )
        local timeInProgress = GetCurrentTime() - diplMission.TimeInitialised
        local timeLeft = diplMission.Timer - timeInProgress
        local fiscalCycle = require( "configGlobalSettings" ).gSetting_Global_FiscalCycle
        timeLeft = timeLeft/fiscalCycle
        displayEvent.Add_Dialog_Text( "TEXT_MISSION_CONTENT_ACTIVE_DIPLOMATIC_MISSION_TIME_LEFT", timeLeft, "TEXT_CYCLES" )
        displayEvent.Add_Dialog_Text( "TEXT_OUT_FORMATTED_NEWLINE" )
        displayEvent.Add_Dialog_Text( "TEXT_OUT_FORMATTED_SEPARATOR" )
        addedMission = true
    end
    if not addedMission then
        displayEvent.Add_Dialog_Text( "TEXT_OUT_FORMATTED_NEWLINE" )
        displayEvent.Add_Dialog_Text( "TEXT_MISSION_CONTENT_ACTIVE_DIPLOMATIC_MISSION_NONE" )
        displayEvent.Add_Dialog_Text( "TEXT_OUT_FORMATTED_NEWLINE" )
        displayEvent.Add_Dialog_Text( "TEXT_OUT_FORMATTED_SEPARATOR" )
    end
    Story_Event( "info_DisplayActiveDiplomaticMissions_Trigger" )
end
function cMajorFaction:RemoveDiplomaticMission( mission )
    local keyToRemove = false
    for key,entry in pairs( self.ActiveDiplomaticMissions ) do
        if mission.Planet == entry.Planet and mission.Diplomat == entry.Diplomat then
            keyToRemove = key
            break
        end
    end
    if keyToRemove then
        self.ActiveDiplomaticMissions[keyToRemove] = nil
    end
end

function cMajorFaction:MakeAlly( cMinorFactionObj )
    if self.Protectorates[cMinorFactionObj:GetName()] == nil then
        local allyStruct = {
            Faction = cMinorFactionObj,
            Stages = {}
        }
        for i = 1, require("configGlobalSettings").gSetting_Diplomacy_MaxAllianceTier, 1 do
            allyStruct.Stages[1] = false
        end
        self.Protectorates[cMinorFactionObj:GetName()] = allyStruct
    end
end
function cMajorFaction:GetAlly( cMinorFactionObj )
    if self.Protectorates[cMinorFactionObj:GetName()] ~= nil then
        return self.Protectorates[cMinorFactionObj:GetName()]
    end
    return false
end
function cMajorFaction:IsAlliedWith( cMinorFactionObj )
    if self.Protectorates[cMinorFactionObj:GetName()] ~= nil then
        return true
    end
    return false
end
function cMajorFaction:GetIsDiplomacyStageTriggered( factionNameString, diplomacyStage )
    if self.Protectorates[factionNameString] ~= nil then
        return self.Protectorates[factionNameString].Stages[diplomacyStage]
    end
    return false
end
function cMajorFaction:SetDiplomacyStageTriggered( factionNameString, diplomacyStage )
    if self.Protectorates[factionNameString] ~= nil then
        self.Protectorates[factionNameString].Stages[diplomacyStage] = true
    end
end

return cMajorFaction
