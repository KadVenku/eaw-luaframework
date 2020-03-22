-- ===== ===== ===== ===== =====
-- Copyright (c) 2017 Kad Venku
-- License       MIT License
-- ===== ===== ===== ===== =====

--- Class cGameObjectTypeUnit.
-- Wrapper for upgrade objects.

-- Import new functions:
require( "libErrorFunctions" )
require( "libDebugFunctions" )
require( "libPGGenericFunctionLibrary" )
-- Import new classes:
require( "cGameObjectType" )

cGameObjectTypeUnit = {}
cGameObjectTypeUnit.__index = cGameObjectTypeUnit
setmetatable( cGameObjectTypeUnit, { __index = cGameObjectType } )

--- Constructor.
-- Creates a new LUA object of type cGameObjectTypeUnit.
-- @tparam cObjectManager parentObjectManager
-- @tparam string newGameObjectName Game object name
-- @tparam table newGameObjectData Game object data.
-- @within Constructor
function cGameObjectTypeUnit.New( parentObjectManager, newGameObjectName, newGameObjectData )
    local self = setmetatable( {}, cGameObjectTypeUnit )

    self.Parent                = parentObjectManager
    self.GameObjectTypeXML     = newGameObjectName
    self.ObjectType            = "TEXT_LUA_OBJECT_TYPE_GAMEOBJECT_WRAPPER_UNIT"
    self.DebugModeActive       = require( "configGlobalSettings" ).gSetting_DebugMode

    self.StringID                   = newGameObjectData.ObjectTextID
    self.GameObjectTypeCapital      = newGameObjectData.GameObjectTypeCapital
    self.AvailableForFactions       = newGameObjectData.AvailableForFactions
    self.GUIFilterTags              = newGameObjectData.GUIFilterTags
    self.CategoryMask               = newGameObjectData.CategoryMask
    self.ObjectFilterTags           = newGameObjectData.ObjectFilterTags
    self.HeroType                   = newGameObjectData.HeroType
    self.Traits                     = { }
    self.MaintenanceCost            = newGameObjectData.MaintenanceCost
    self.DiplomaticInfluence        = newGameObjectData.DiplomaticInfluence
    self.DiplomaticRating           = newGameObjectData.DiplomaticRating
    self.MilitaryRating             = Find_Object_Type( self.GameObjectTypeCapital ).Get_Combat_Rating()
    local lTraits = newGameObjectData.Traits
    self:InitialiseTraits( lTraits )

    -- build state related settings:
    self.Buildable             = { }
    for _,factionName in pairs( self.AvailableForFactions ) do
        self:SetIsBuildable( factionName, false )
    end
    self.HiddenFromGUI         = false

    return self
end

--- Returns the diplomatic influence of the object.
-- @treturn number Diplomatic influence.
function cGameObjectTypeUnit:GetDiplomaticInfluence()
    return self.DiplomaticInfluence
end

return cGameObjectTypeUnit
