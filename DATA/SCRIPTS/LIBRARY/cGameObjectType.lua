-- ===== ===== ===== ===== =====
-- Copyright (c) 2017 Kad Venku
-- License       MIT License
-- ===== ===== ===== ===== =====

--- {abstract} cGameObjectType base class.
-- All game objects inherit this class's functionality.

-- Import new functions:
require( "libErrorFunctions" )
require( "libDebugFunctions" )
require( "libPGGenericFunctionLibrary" )

cGameObjectType = {}
cGameObjectType.__index = cGameObjectType

--- Constructor.
-- Creates a new LUA object of type cGameObjectType.
-- @tparam cObjectManager parentObjectManager
-- @tparam string newGameObjectName GameObject as defined in the xml.
-- @within Initialisation
function cGameObjectType.New( parentObjectManager, newGameObjectName )
    local self = setmetatable( {}, cGameObjectType )

    self.Parent                = parentObjectManager
    self.GameObjectTypeXML     = newGameObjectName
    self.ObjectType            = "TEXT_LUA_OBJECT_TYPE_GAMEOBJECT_WRAPPER"
    self.DebugModeActive       = require( "configGlobalSettings" ).gSetting_DebugMode

    return self
end
--- Returns the cGameObjectType type.
-- @within Getter Functions
function cGameObjectType:GetType()
    return self.ObjectType
end
--- Returns the name of the cGameObjectType as defined in the corresponding xml entry.
-- @treturn string
-- @within Getter Functions
function cGameObjectType:GetObjectTypeXML()
    return self.GameObjectTypeXML
end
--- Returns the name of the cGameObjectType in capital letters.
-- Can be used to test for validity, when the object.Get_Type().Get_Name() has been used, as this returns the name in capital letters.
-- @treturn string Name in CAPITAL letters.
-- @within Getter Functions
function cGameObjectType:GetObjectTypeCapital()
    return self.GameObjectTypeCapital
end
--- Returns whether the object is buildable, or not.
-- @treturn bool
-- @within Getter Functions
function cGameObjectType:GetIsBuildable( factionInQuestion )
    return self.Buildable[factionInQuestion]
end
--- Sets the Buildable attribute.
-- @tparam string factionInQuestion Faction name.
-- @tparam bool newBuildability
-- @within Setter Functions
function cGameObjectType:SetIsBuildable( factionInQuestion, newBuildability )
    self.Buildable[factionInQuestion] = newBuildability
end
--- Returns whether the object is currently hidden from the GUI, or not.
-- @treturn bool
-- @within Getter Functions
function cGameObjectType:GetIsHiddenFromGUI()
    return self.HiddenFromGUI
end
--- Sets the HiddenFromGUI attribute.
-- @tparam bool newHiddenState
-- @within Setter Functions
function cGameObjectType:SetIsHiddenFromGUI( newHiddenState )
    self.HiddenFromGUI = newHiddenState
end
--- Returns maintenance cost for the object type.
-- @treturn integer
-- @within Getter Functions
function cGameObjectType:GetMaintenanceCostSingleObject()
    return self.MaintenanceCost
end
--- Get the maintenance cost for all instances as sum.
-- @treturn integer
-- @within Getter Functions
function cGameObjectType:GetMaintenanceCostAllObjectsOfFaction( cFactionObj )
    if self:IsAvailableToFaction( cFactionObj:GetName() ) then
        -- Only compute anything if the object has maintenance cost.
        if self:GetMaintenanceCostSingleObject() > 0 then
            local existingObjects = self:GetInstancesOfSelfFilteredBy( "OWNER", cFactionObj )
            if existingObjects then
                local existingObjectCount = table.getn( existingObjects )
                local maintenanceCost = self:GetMaintenanceCostSingleObject() * existingObjectCount
                return maintenanceCost
            end
            return 0
        else
            return 0
        end
    end
end
--- Returns the cGameObjectType's CategoryMask.
-- Concatenates all tagged category masks with the '|' operator for filtering purposes.
-- @usage Consider this example table for the CategoryMask attribute:
-- self.CategoryMask = { "Capital", "Structure", "SpaceHero" }
-- self:GetCategoryMask()
-- This call would then return:
-- "Capital | Structure | SpaceHero"
-- @treturn string
-- @within Getter Functions
function cGameObjectType:GetCategoryMask()
    local CategoryMaskFilter = table.concat( self.CategoryMask, " | " )
    return CategoryMaskFilter
end


--- Is the game object available to a certain faction?
-- This setting does not return the state of the object, or whether it is currently unavailable, it instead returns a bool depending on whether the object could be constructed.
-- @tparam string factionInQuestion
-- @treturn bool
-- @within Getter Functions
function cGameObjectType:IsAvailableToFaction( factionInQuestion )
    return IsContentOfTable( self.AvailableForFactions, factionInQuestion )
end
--- Makes an object available to a faction during play.
-- @tparam string factionInQuestion
-- @within Setter Functions
function cGameObjectType:MakeAvailableToFaction( factionInQuestion )
    table.insert( self.AvailableForFactions, factionInQuestion )
end
--- Tests whether the cGameObjectType is flagged with a certain flag/list of flags.
-- @tparam  string/table tagObject
-- @treturn bool
-- @within Getter Functions
function cGameObjectType:IsGUIFilterTaggedAs( tagObject )
    return IsObjectTaggedAs( self.GUIFilterTags, tagObject )
end
--- Tests whether the cGameObjectType is flagged with a certain flag/list of flags.
-- @tparam  string/table tagObject
-- @treturn bool
-- @within Getter Functions
function cGameObjectType:IsTaggedAs( tagObject )
    return IsObjectTaggedAs( self.ObjectFilterTags, tagObject )
end
--- Initializes the faction traits.
-- Only loads traits which are defined, if a trait is not defined, the trait will be skipped.
function cGameObjectType:InitialiseTraits( traitTable )
    local lTraitTable = traitTable
    local lTraitDefinitions = require( "libStaticTraitDefinitions" ).GameObjectTraits
    for _,trait in pairs(lTraitDefinitions) do
        if IsContentOfTable( lTraitTable, trait.TraitID ) then
            table.insert( self.Traits, trait )
        end
    end
end
--- Returns a list of all instances of the cGameObjectType.
-- this uses the XML name of the cGameObjectType to collect it.
-- @treturn table If not objects can be found it returns false instead.
-- @within Getter Functions
function cGameObjectType:GetAllInstancesOfSelf()
    local returnTable = Find_All_Objects_Of_Type( self:GetObjectTypeXML() )
    if table.getn( returnTable ) > 0 then
        return returnTable
    end
    return false
end
--- Returns a list of objects filtered by the criteria specified.
-- Possible filters are (Might be expanded later on):
-- "PLANET": Returns all instances of the cGameObjectType filtered by the planet they reside on.
-- "OWNER": Returns all instances of the cGameObjectType filtered by the owner.
-- @tparam string filterType String filter for the function.
-- @tparam luaObject filterObject object to filter by.
-- @treturn table If not objects can be found it returns false instead.
-- @within Getter Functions
function cGameObjectType:GetInstancesOfSelfFilteredBy( filterType, filterObject )
    local allObjects = false
    if filterType == "PLANET" or filterType == "planet" or filterType == "Planet" then
        allObjects = self:GetAllInstancesOfSelf()
        if allObjects then
            for index, gameObj in pairs( allObjects ) do
                if gameObj.Get_Planet_Location() ~= filterObject:GetPlanetLocation() then
                    allObjects[index] = nil
                end
            end
        end
    elseif filterType == "OWNER" or filterType == "Owner" or filterType == "owner" then
        allObjects = self:GetAllInstancesOfSelf()
        if allObjects then
            for index, gameObj in pairs( allObjects ) do
                if gameObj.Get_Owner() ~= filterObject:GetPlayerObject() then
                    allObjects[index] = nil
                end
            end
        end
    end
    return allObjects
end

--- Hides an object from the GUI. This does not affect the buildable state at all.
-- @tparam cFaction factionInQuestion
function cGameObjectType:HideFromGUI( factionInQuestion )
    if not self:GetIsHiddenFromGUI() then
        if factionInQuestion ~= nil then
            if self:GetIsBuildable( factionInQuestion ) then
                local hideEvent = Get_Story_Plot( "__luaFramework/cGameObjectHandler/cGameObjectType.xml" ).Get_Event( "cGameObjectType_LockObjectTypeBuildable" )
                hideEvent.Set_Reward_Parameter( 0, self:GetObjectTypeXML() )
                Story_Event( "cGameObjectType_LockObjectTypeBuildable_Trigger" )
                self:SetIsHiddenFromGUI( true )
            end
        else
            local hideEvent = Get_Story_Plot( "__luaFramework/cGameObjectHandler/cGameObjectType.xml" ).Get_Event( "cGameObjectType_LockObjectTypeBuildable" )
            hideEvent.Set_Reward_Parameter( 0, self:GetObjectTypeXML() )
            Story_Event( "cGameObjectType_LockObjectTypeBuildable_Trigger" )
            self:SetIsHiddenFromGUI( true )
        end
    end
end
--- Shows an object type on the GUI.
-- @tparam cFaction factionInQuestion
function cGameObjectType:ShowOnGUI( factionInQuestion )
    if self:GetIsHiddenFromGUI() then
        if factionInQuestion ~= nil then
            if self:GetIsBuildable( factionInQuestion ) then
                local hideEvent = Get_Story_Plot( "__luaFramework/cGameObjectHandler/cGameObjectType.xml" ).Get_Event( "cGameObjectType_UnlockObjectTypeBuildable" )
                hideEvent.Set_Reward_Parameter( 0, self:GetObjectTypeXML() )
                Story_Event( "cGameObjectType_UnlockObjectTypeBuildable_Trigger" )
                self:SetIsHiddenFromGUI( false )
            end
        else
            local hideEvent = Get_Story_Plot( "__luaFramework/cGameObjectHandler/cGameObjectType.xml" ).Get_Event( "cGameObjectType_UnlockObjectTypeBuildable" )
            hideEvent.Set_Reward_Parameter( 0, self:GetObjectTypeXML() )
            Story_Event( "cGameObjectType_UnlockObjectTypeBuildable_Trigger" )
            self:SetIsHiddenFromGUI( false )
        end
    end
end
--- Returns the objects in-game string key
-- @treturn string
-- @within Getter Functions
function cGameObjectType:GetStringKey()
    return self.StringID
end
--- {abstract} Abstract getter function.
-- @within Abstracts
function cGameObjectType:GetIsPlanetaryShieldGenerator()
    return false
end
--- {abstract} Abstract getter function.
-- @within Abstracts
function cGameObjectType:GetIsBaseShieldGenerator()
    return false
end
--- {abstract} Abstract getter function.
-- @within Abstracts
function cGameObjectType:GetShieldStrength()
    return 0
end
--- {abstract} Abstract getter function.
-- @within Abstracts
function cGameObjectType:GetGUIDummy()
    return false
end
--- {abstract} Abstract getter function.
-- @within Abstracts
function cGameObjectType:GetDiplomaticInfluence()
    return 0.0
end

return cGameObjectType
