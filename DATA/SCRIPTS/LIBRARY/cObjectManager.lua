-- ===== ===== ===== ===== =====
-- Copyright (c) 2017 Lukas Grünwald
-- License       MIT License
-- ===== ===== ===== ===== =====

-- Import new functions:
require( "libErrorFunctions" )
require( "libDebugFunctions" )
require( "libPGGenericFunctionLibrary" )
-- Import new classes:
require( "cGameObjectType" )
require( "cGameObjectTypeUpgrade" )
require( "cGameObjectTypeUnit" )
require( "cGameObjectTypeBuilding" )

--- Basic cEventHandler class

cObjectManager = {}
cObjectManager.__index = cObjectManager
--- {public} Constructor.
-- @tparam cGalacticConquest parentGC
-- @within Initialisation
function cObjectManager.New( parentGC )
    local self = setmetatable( {}, cObjectManager )
    self.Parent = parentGC
    self.ObjectTypeTable = {}
    self.HumanPayerObject = false
    self:RegisterObjectTypes()
    self.DebugModeActive = require( "configGlobalSettings" ).gSetting_DebugMode

    return self
end

--- Sets up the object management system.
-- Sets up faction-related buildabilities, availabilities, etc.
-- Human player only: Hides objects from GUI until filter has been pressed.
-- @within Initialization
function cObjectManager:Initialise()
    self.HumanPayerObject = self.Parent:GetHumanPlayerFaction()
    local GCDataTable = require( "libGCDefinitions" )
    for _, faction in pairs( GCDataTable[self.Parent:GetName()].Factions ) do
        for _, objType in pairs( self.ObjectTypeTable ) do
            if IsContentOfTable( faction.InitiallyBuildableObjects, objType:GetObjectTypeXML() ) or IsContentOfTable( faction.InitiallyBuildableObjects, objType:GetObjectTypeCapital() ) then
                if objType:IsAvailableToFaction( faction.Name ) then
                    objType:SetIsBuildable( faction.Name, true )
                    if faction.Name == self.HumanPayerObject:GetName() then
                        objType:HideFromGUI( faction.Name )
                    end
                end
            else
                if objType:IsAvailableToFaction( self.HumanPayerObject:GetName() ) then
                    objType:HideFromGUI()
                end
            end
        end
    end
    if self.DebugModeActive then
        self:ListAllAvailableObjectsForFaction( self.HumanPayerObject )
    end
end

--- Registers all defined object types.
-- ATTENTION: all non-registered object types are not accounted for!!.
-- @within Initialization
function cObjectManager:RegisterObjectTypes()
    -- Register buildings:
    local staticObjectDefinitionsBuildings = require( "libStaticObjectDefinitionsBuildings" )
    for _, buildingTypeData in pairs( staticObjectDefinitionsBuildings ) do
        self.ObjectTypeTable[buildingTypeData.GameObjectTypeCapital] = cGameObjectTypeBuilding.New( self, buildingTypeData.GameObjectTypeXML, buildingTypeData )
    end
    -- Register buildings:
    local staticObjectDefinitionsUnits = require( "libStaticObjectDefinitionsUnits" )
    for _, unitTypeData in pairs( staticObjectDefinitionsUnits ) do
        self.ObjectTypeTable[unitTypeData.GameObjectTypeCapital] = cGameObjectTypeUnit.New( self, unitTypeData.GameObjectTypeXML, unitTypeData )
    end
end

--- Shows objects on the GUI which are tagged similar to the filter.
-- @tparam string factionInQuestion
-- @tparam table filterTags Object tags.
function cObjectManager:GUIFilterShowTag( factionInQuestion, filterTags )
    for _,objType in pairs( self.ObjectTypeTable ) do
        if objType:IsAvailableToFaction( factionInQuestion ) then
            if objType:IsGUIFilterTaggedAs( filterTags ) then
                objType:ShowOnGUI( factionInQuestion )
            else
                objType:HideFromGUI( factionInQuestion )
            end
        end
    end
end
--- Hides all objects from the GUI for a set faction.
-- @tparam string factionInQuestion faction to lock stuff for. Optional: If not provided all object are hidden.
function cObjectManager:HideAllObjectsFromGUI( factionInQuestion )
    for _,objType in pairs( self.ObjectTypeTable ) do
        objType:HideFromGUI( factionInQuestion )
    end
end
--- Shows all objects on GUI.
function cObjectManager:ShowAllObjectsOnGUI()
    for _,objType in pairs( self.ObjectTypeTable ) do
        objType:ShowOnGUI()
    end
end
--- Throws a debug message and lists all available objects for a given faction.
-- @tparam cFaction cFactionObj
function cObjectManager:ListAllAvailableObjectsForFaction( cFactionObj )
    local displayStringTable = { }
    for _,objType in pairs( self.ObjectTypeTable ) do
        if objType:IsAvailableToFaction( cFactionObj:GetName() ) then
            local struct = { objType:GetStringKey() }
            if objType:GetIsBuildable( cFactionObj:GetName() ) then
                table.insert( struct, "TEXT_DEBUG_TRUE" )
            else
                table.insert( struct, "TEXT_DEBUG_FALSE" )
            end
            table.insert( displayStringTable, struct )
        end
    end
    if table.getn( displayStringTable ) > 0 then
        debugAvailableObjectType( cFactionObj:GetStringKey(), displayStringTable )
    end
end
--- Applies the maintenance cycle.
-- @tparam cFaction cFactionObj
function cObjectManager:ApplyMaintenanceCost( cFactionObj )
    local maintenanceCost = 0
    for _, objType in pairs( self.ObjectTypeTable ) do
        if objType:IsAvailableToFaction( cFactionObj:GetName() ) then
            maintenanceCost = maintenanceCost + objType:GetMaintenanceCostAllObjectsOfFaction( cFactionObj )
        end
    end
    local fTraits = cFactionObj:GetTraits()
    for _, factionTrait in pairs( fTraits ) do
        maintenanceCost = maintenanceCost * factionTrait.MaintenanceMult
    end
    maintenanceCost = (-1)*maintenanceCost
    cFactionObj:GetPlayerObject().Give_Money( maintenanceCost )
end
--- Returns the registered cGameObjectType for a given GameObject reference.
-- This will return false if no registered cGameObjectType can be found.
-- @tparam GameObject refObject
-- @treturn cGameObjectType objType
function cObjectManager:GetCGameObjectTypeByReference( refObject )
    local refObjTypeName = refObject.Get_Type().Get_Name()
    for _,objType in pairs( self.ObjectTypeTable ) do
        if objType:GetObjectTypeCapital() == refObjTypeName then
            return objType
        end
    end
    return false
end

return cObjectManager
