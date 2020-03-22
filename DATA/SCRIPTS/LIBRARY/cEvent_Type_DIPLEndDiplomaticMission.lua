-- ===== ===== ===== ===== =====
-- Copyright (c) 2017 Kad Venku
-- License       MIT License
-- ===== ===== ===== ===== =====

require( "PGBase" )
-- Import new functions:
require( "libErrorFunctions" )
require( "libDebugFunctions" )
-- Import new classes:
require( "cEvent" )

cEvent_Type_DIPLEndDiplomaticMission = {}
cEvent_Type_DIPLEndDiplomaticMission.__index = cEvent_Type_DIPLEndDiplomaticMission
setmetatable( cEvent_Type_DIPLEndDiplomaticMission, { __index = cEvent } )
--- Constructor.
-- Creates a new LUA object of type cEvent_Type_DIPLEndDiplomaticMission.
-- @tparam cEventHandler parentEventHandler
-- @within Constructor
function cEvent_Type_DIPLEndDiplomaticMission.New( parentEventHandler, cGameObjectTypeDiplomat, cFactionDiplomatOwner, cPlanetObject, newTimer )
    local self = setmetatable( {}, cEvent_Type_DIPLEndDiplomaticMission )
    self.Parent                  = parentEventHandler
    self.Type                    = "TEXT_LUA_OBJECT_TYPE_EVENT_DIPLENDDIPLOMATICMISSION"
    self.CGameObjectTypeDiplomat = cGameObjectTypeDiplomat
    self.CFactionDiplomatOwner   = cFactionDiplomatOwner
    self.CPlanet                 = cPlanetObject
    if newTimer == nil then
        self.IsTimed             = false
        self.RegisteredTimestamp = false
        self.Timer               = false
    else
        self.IsTimed             = true
        self.RegisteredTimestamp = GetCurrentTime()
        self.Timer               = newTimer
    end

    return self
end
--- Executes the event.
function cEvent_Type_DIPLEndDiplomaticMission:Execute()
    self.CPlanet:SetInactiveDiplomaticMission()
    -- Kad 20/06/2017 12:49:35 - Respawn the diplomat, that dude's responsible for the calculations, so we need him active and valid.
    local spawnTable = { self.CGameObjectTypeDiplomat:GetObjectTypeXML(), }
    local planetObject = self.CPlanet:GetPlanetLocation()
    local diplomatTable = SpawnList( spawnTable, planetObject, self.CFactionDiplomatOwner:GetPlayerObject(), true, true )
    -- Kad 20/06/2017 14:01:00 - Makes sure the fleet gets its own slot (and it initiates a battle if the diplomat isn't stealthy)
    local spawnedFleet = Assemble_Fleet( diplomatTable )
    spawnedFleet.Move_To( planetObject )
    -- Kad 20/06/2017 14:31:22 - We only have one object in the table, this has to be our re-spawned diplomat:
    if not TestValid( diplomatTable[1] ) then
        endThrowObjectNotFoundError( self.CGameObjectTypeDiplomat:GetStringKey() )
    end
    -- Kad 20/06/2017 19:01:47 - Now for the actual diplomatic mission:
    local prevOwnerDiplomaticInfluence = self.CPlanet:GetCurrentDiplomaticInfluenceOwner()
    local ownerDiplomaticInfluence     = self.CPlanet:GetDiplomaticRating()
    if self.CFactionDiplomatOwner == self.CPlanet:GetOwner() then
        if ownerDiplomaticInfluence > prevOwnerDiplomaticInfluence then
            -- Kad 23/06/2017 11:51:25 - A diplomatic mission on friendly planet assures that the planet counts as allied, even if the diplomatic rating would favour another faction.
            self.CPlanet:SetAlliedFaction( self.CPlanet:GetOwner() )
            if self.CFactionDiplomatOwner:GetIsHumanPlayer() then
                local increasedInfluencePercentage =  ( ( ownerDiplomaticInfluence - prevOwnerDiplomaticInfluence ) / require( "configGlobalSettings" ).gSetting_Diplomacy_InfluenceOnPlanetCap ) * 100
                local displayEvent = Get_Story_Plot( "__luaFramework/cGUIHandler/cGUIMissionHolochronOutput.xml" ).Get_Event( "info_DisplayDiplomaticMissionSuccess" )
                displayEvent.Clear_Dialog_Text()
                displayEvent.Add_Dialog_Text( "TEXT_MISSION_CONTENT_DIPLOMATIC_MISSION_SUCCESS_BY_AT", self.CGameObjectTypeDiplomat:GetStringKey(), self.CPlanet:GetStringKey() )
                displayEvent.Add_Dialog_Text( "TEXT_OUT_FORMATTED_NEWLINE" )
                displayEvent.Add_Dialog_Text( "TEXT_MISSION_CONTENT_DIPLOMATIC_MISSION_SUCCESS_PERCENTAGE_FRIENDLY", self.CPlanet:GetStringKey(), increasedInfluencePercentage )
                displayEvent.Add_Dialog_Text( "TEXT_OUT_FORMATTED_NEWLINE" )
                displayEvent.Add_Dialog_Text( "TEXT_MISSION_CONTENT_DIPLOMATIC_MISSION_SUCCESS_COURSEOFACTION_FRIENDLY" )
                Story_Event( "info_DisplayDiplomaticMissionSuccess_Trigger" )
            end
        elseif ownerDiplomaticInfluence == prevOwnerDiplomaticInfluence then
            self.CPlanet:SetAlliedFaction( self.CPlanet:GetOwner() )
            if self.CFactionDiplomatOwner:GetIsHumanPlayer() then
                local displayEvent = Get_Story_Plot( "__luaFramework/cGUIHandler/cGUIMissionHolochronOutput.xml" ).Get_Event( "info_DisplayDiplomaticMissionSuccess" )
                displayEvent.Clear_Dialog_Text()
                displayEvent.Add_Dialog_Text( "TEXT_MISSION_CONTENT_DIPLOMATIC_MISSION_SUCCESS_BY_AT", self.CGameObjectTypeDiplomat:GetStringKey(), self.CPlanet:GetStringKey() )
                displayEvent.Add_Dialog_Text( "TEXT_OUT_FORMATTED_NEWLINE" )
                displayEvent.Add_Dialog_Text( "TEXT_MISSION_CONTENT_DIPLOMATIC_MISSION_SUCCESS_PERCENTAGE_STABLE_FRIENDLY", self.CPlanet:GetStringKey() )
                displayEvent.Add_Dialog_Text( "TEXT_OUT_FORMATTED_NEWLINE" )
                displayEvent.Add_Dialog_Text( "TEXT_MISSION_CONTENT_DIPLOMATIC_MISSION_SUCCESS_COURSEOFACTION_FRIENDLY" )
                Story_Event( "info_DisplayDiplomaticMissionSuccess_Trigger" )
            end
        else
            -- Kad 23/06/2017 11:59:31 - We've managed to loose influence... So that's a failure...
            if self.CFactionDiplomatOwner:GetIsHumanPlayer() then
                local lostInfluencePercentage =  ( ( prevOwnerDiplomaticInfluence - ownerDiplomaticInfluence ) / require( "configGlobalSettings" ).gSetting_Diplomacy_InfluenceOnPlanetCap ) * 100
                local displayEvent = Get_Story_Plot( "__luaFramework/cGUIHandler/cGUIMissionHolochronOutput.xml" ).Get_Event( "info_DisplayDiplomaticMissionFailure" )
                displayEvent.Clear_Dialog_Text()
                displayEvent.Add_Dialog_Text( "TEXT_MISSION_CONTENT_DIPLOMATIC_MISSION_FAILURE_BY_AT", self.CGameObjectTypeDiplomat:GetStringKey(), self.CPlanet:GetStringKey() )
                displayEvent.Add_Dialog_Text( "TEXT_OUT_FORMATTED_NEWLINE" )
                displayEvent.Add_Dialog_Text( "TEXT_MISSION_CONTENT_DIPLOMATIC_MISSION_FAILURE_PERCENTAGE_LOST", self.CPlanet:GetStringKey(), lostInfluencePercentage )
                displayEvent.Add_Dialog_Text( "TEXT_OUT_FORMATTED_NEWLINE" )
                displayEvent.Add_Dialog_Text( "TEXT_MISSION_CONTENT_DIPLOMATIC_MISSION_FAILURE_COURSEOFACTION_FRIENDLY" )
                Story_Event( "info_DisplayDiplomaticMissionFailure_Trigger" )
                -- Kad 22/06/2017 15:21:22 - TODO: AI Message; update desire accordingly.
            end
        end
        -- Kad 27/06/2017 19:00:38 - In any case, we update the sector influence, provided a) the planet is part of a sector; b) we're allied with the sector's owner
        if self.CPlanet():GetHomeFaction() and self.CFactionDiplomatOwner:IsAlliedWith( self.CPlanet():GetHomeFaction() ) then
            -- Kad 28/06/2017 14:40:20 - TODO: Implement EVENT_TYPE_DIPLUPDATEALLIANCERATING;
            self.Parent.Parent:RegisterEvent( "EVENT_TYPE_DIPLUPDATEALLIANCERATING", { CFactionMajor = self.cFactionDiplomatOwner, CFactionMinor = self.CPlanet():GetHomeFaction(), Timer = 0.5, })
        end
    else
        local prevForeignDiplomaticInfluence = self.CPlanet:GetCurrentDiplomaticInfluenceForeignFaction( self.CFactionDiplomatOwner )
        local foreignDiplomaticInfluence     = self.CPlanet:GetForeignDiplomaticInfuence( self.CFactionDiplomatOwner, self.CGameObjectTypeDiplomat )
        if ownerDiplomaticInfluence <= foreignDiplomaticInfluence then
            -- Kad 21/06/2017 13:55:31 - Update the object alliance:
            self.CPlanet:SetAlliedFaction( self.CFactionDiplomatOwner )
            -- Kad 21/06/2017 13:41:23 - Test if planet is part of a sector.
            local homeFaction = self.CPlanet:GetHomeFaction()
            if homeFaction then
                -- Kad 28/06/2017 13:49:59 - Spawning the right event now:
                self.Parent.Parent:RegisterEvent( "EVENT_TYPE_DIPLCHECKFACTIONALLIANCE", { FactionLUAObjectOwner = homeFaction, FactionLUAObjectContestor = self.CFactionDiplomatOwner, } )
            else
                self.Parent.Parent:RegisterEvent( "EVENT_TYPE_DIPLTURNPLANET", { PlanetLUAObject = self.CPlanet, FactionLUAObjectNewOwner = self.CFactionDiplomatOwner, } )
            end
        else
            if self.CFactionDiplomatOwner:GetIsHumanPlayer() then -- Kad 22/06/2017 14:26:47 - Only trigger that if the diplomat is human.
                local missingInfluencePercentage =  ( ( ownerDiplomaticInfluence - foreignDiplomaticInfluence ) / require( "configGlobalSettings" ).gSetting_Diplomacy_InfluenceOnPlanetCap ) * 100
                local displayEvent = Get_Story_Plot( "__luaFramework/cGUIHandler/cGUIMissionHolochronOutput.xml" ).Get_Event( "info_DisplayDiplomaticMissionFailure" )
                displayEvent.Clear_Dialog_Text()
                displayEvent.Add_Dialog_Text( "TEXT_MISSION_CONTENT_DIPLOMATIC_MISSION_FAILURE_BY_AT", self.CGameObjectTypeDiplomat:GetStringKey(), self.CPlanet:GetStringKey() )
                displayEvent.Add_Dialog_Text( "TEXT_MISSION_CONTENT_DIPLOMATIC_MISSION_FAILURE_PERCENTAGE", missingInfluencePercentage )
                displayEvent.Add_Dialog_Text( "TEXT_MISSION_CONTENT_DIPLOMATIC_MISSION_FAILURE_COURSEOFACTION", self.CGameObjectTypeDiplomat:GetStringKey() )
                Story_Event( "info_DisplayDiplomaticMissionFailure_Trigger" )
                -- Kad 22/06/2017 15:21:22 - TODO: AI Message; update desire accordingly.
            end
        end
    end
    -- Kad 20/06/2017 12:54:11 - Update the holochron:
    local lDipMission = { Planet = self.CPlanet, Diplomat = self.CGameObjectTypeDiplomat, }
    self.CFactionDiplomatOwner:RemoveDiplomaticMission( lDipMission )
    if self.CFactionDiplomatOwner:GetIsHumanPlayer() then
        self.CFactionDiplomatOwner:ClearDiplomaticMissionHolochron()
        self.CFactionDiplomatOwner:UpdateDiplomaticMissionHolochron()
    end
end

return cEvent_Type_DIPLEndDiplomaticMission
