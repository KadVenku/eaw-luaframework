-- ===== ===== ===== ===== =====
-- Copyright (c) 2017 Lukas Grünwald
-- License       MIT License
-- ===== ===== ===== ===== =====

-- Import new functions:
require( "libErrorFunctions" )
require( "libDebugFunctions" )
-- Import new classes:
require( "cEvent" )
require( "cPlanet" )

cEvent_Type_DIPLUpdateAllianceRating = {}
cEvent_Type_DIPLUpdateAllianceRating.__index = cEvent_Type_DIPLUpdateAllianceRating
setmetatable( cEvent_Type_DIPLUpdateAllianceRating, { __index = cEvent } )
--- Constructor.
-- Creates a new LUA object of type cEvent_Type_DIPLUpdateAllianceRating.
-- @tparam cEventHandler parentEventHandler
-- @within Constructor
function cEvent_Type_DIPLUpdateAllianceRating.New( parentEventHandler, MajorFaction, MinorFaction, newTimer )
    local self = setmetatable( {}, cEvent_Type_DIPLUpdateAllianceRating )
    self.Parent                  = parentEventHandler
    self.Type                    = "TEXT_LUA_OBJECT_TYPE_EVENT_DIPLUPDATEALLIANCERATING"
    self.CMajorFaction           = MajorFaction
    self.CMinorFaction           = MinorFaction
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
function cEvent_Type_DIPLUpdateAllianceRating:Execute()
	-- Kad 28/06/2017 19:26:17 - Prevent calling this on not allied factions... Would be pointless and embarrassing.
	if self.CFactionMajor:IsAlliedWith( self.CFactionMinor ) then
		local sector = self.CFactionMinor:GetHomeSector()
		local numberOwnedOrAllied = 0
		local planetsInSector = table.getn( sector )
		for _,cPlanetObj in pairs( sector ) do
			if cPlanetObj:GetOwner() == self.CFactionMajor or cPlanetObj:GetAlliedFaction() == self.CFactionMajor then
				numberOwnedOrAllied = numberOwnedOrAllied + 1
			end
		end
		local allianceRating = numberOwnedOrAllied / planetsInSector
		for i = 1, require("configGlobalSettings").gSetting_Diplomacy_MaxAllianceTier, 1 do
			if allianceRating >= require( "configGlobalSettings" ).gSetting_Diplomacy_AllianceLostThreshold then
				if allianceRating >= require( "configGlobalSettings" ).gSetting_Diplomacy_AllianceThesholds[i] then
					if not self.CFactionMajor:GetIsDiplomacyStageTriggered( self.CFactionMinor:GetName(), i ) then
						local diplRewardTable = self.CFactionMinor:GetRewardSet( i )
						if diplRewardTable then
							for _,reward in pairs( diplRewardTable ) do
								self.Parent.Parent:RegisterEvent( reward.EventType, reward.ArgumentTable )
							end
						end
					end
				end
				if allianceRating < require( "configGlobalSettings" ).gSetting_Diplomacy_AllianceThesholds[i+1] then
					break -- Kad 03/07/2017 11:16:42 - We just stop when the next tier cannot be reached anyways.
				end
			else
				-- Kad 03/07/2017 11:12:50 - TODO: Add alliance lost event!
			end
		end
    	debugEventExecuted( self:GetObjectType(), self:IsTimedEvent(), self:GetTimer() )
    end
end

return cEvent_Type_DIPLUpdateAllianceRating
