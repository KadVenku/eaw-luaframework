-- ===== ===== ===== ===== =====
-- Copyright (c) 2017 Kad Venku
-- License       MIT License
-- ===== ===== ===== ===== =====

--- Class cGameObjectTypeUpgrade.
-- Wrapper for upgrade objects.

-- Import new functions:
require( "libErrorFunctions" )
require( "libDebugFunctions" )
require( "libPGGenericFunctionLibrary" )
-- Import new classes:
require( "cGameObjectType" )

cGameObjectTypeUpgrade = {}
cGameObjectTypeUpgrade.__index = cGameObjectTypeUpgrade
setmetatable( cGameObjectTypeUpgrade, { __index = cGameObjectType } )

--- Constructor.
-- Creates a new LUA object of type cGameObjectTypeUpgrade.
-- @tparam cObjectManager parentObjectManager
-- @tparam string newGameObjectName Game object name
-- @within Constructor
function cGameObjectTypeUpgrade.New( parentObjectManager, newGameObjectName )
    local self = setmetatable( {}, cGameObjectTypeUpgrade )

    self.Parent                = parentObjectManager
    self.GameObjectTypeXML     = newGameObjectName
    self.ObjectType            = "TEXT_LUA_OBJECT_TYPE_GAMEOBJECT_WRAPPER_UPGRADE"
    self.DebugModeActive       = require( "configGlobalSettings" ).gSetting_DebugMode

    local ObjectInformationTable = require( "libStaticObjectDefinitionsUpgrades" )
    if ObjectInformationTable[newGameObjectName] ~= nil then
        self.GameObjectTypeCapital = nil
        self.AvailableForFactions  = { }
        self.GUIFilterTags         = { }
        self.CategoryMask          = { }
        self.ObjectFilterTags      = { }
        self.HeroType              = false
        self.Traits                = { }
        self.MaintenanceCost       = 0
        self.DiplomaticInfluence   = 0
        self.DiplomaticRating      = 0
        self.MilitaryRating        = 0
        self.Buildable             = nil
        self.HiddenFromGUI         = false
        local lTraits = newGameObjectData.Traits
        self:InitialiseTraits( lTraits )
    else
        ThrowObjectInitialisationError( self.ObjectType )
    end

    return self
end

return cGameObjectTypeUpgrade
