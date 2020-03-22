-- ===== ===== ===== ===== =====
-- Copyright (c) 2017 Kad Venku
-- License       MIT License
-- ===== ===== ===== ===== =====

--- Class cGameObjectTypeBuilding.
-- Wrapper for upgrade objects.

-- Import new functions:
require( "libErrorFunctions" )
require( "libDebugFunctions" )
require( "libPGGenericFunctionLibrary" )
-- Import new classes:
require( "cGameObjectType" )

cGameObjectTypeBuilding = {}
cGameObjectTypeBuilding.__index = cGameObjectTypeBuilding
setmetatable( cGameObjectTypeBuilding, { __index = cGameObjectType } )

--- Constructor.
-- Creates a new LUA object of type cGameObjectTypeBuilding.
-- @tparam cObjectManager parentObjectManager
-- @tparam string newGameObjectName Game object name
-- @tparam table newGameObjectData Game object data.
-- @within Constructor
function cGameObjectTypeBuilding.New( parentObjectManager, newGameObjectName, newGameObjectData )
    local self = setmetatable( {}, cGameObjectTypeBuilding )

    self.Parent                = parentObjectManager
    self.GameObjectTypeXML     = newGameObjectName
    self.ObjectType            = "TEXT_LUA_OBJECT_TYPE_GAMEOBJECT_WRAPPER_BUILDING"
    self.DebugModeActive       = require( "configGlobalSettings" ).gSetting_DebugMode

    self.StringID                   = newGameObjectData.ObjectTextID
    self.GameObjectTypeCapital      = newGameObjectData.GameObjectTypeCapital
    self.AvailableForFactions       = newGameObjectData.AvailableForFactions
    self.GUIFilterTags              = newGameObjectData.GUIFilterTags
    self.CategoryMask               = newGameObjectData.CategoryMask
    self.ObjectFilterTags           = newGameObjectData.ObjectFilterTags
    self.Traits                     = { }
    self.HeroType                   = newGameObjectData.HeroType
    self.MaintenanceCost            = newGameObjectData.MaintenanceCost
    self.DiplomaticInfluence        = newGameObjectData.DiplomaticInfluence
    self.DiplomaticRating           = newGameObjectData.DiplomaticRating
    self.GUIDummy                   = newGameObjectData.GUIDummy
    self.MilitaryRating             = Find_Object_Type( self.GameObjectTypeCapital ).Get_Combat_Rating()
    local lTraits = newGameObjectData.Traits
    self:InitialiseTraits( lTraits )
    -- Building specific settings:
    if self:IsTaggedAs( "BASE_SHIELD" ) or self:IsTaggedAs( "PLANETARY_SHEILD" ) then
        self.ShieldStrength         = newGameObjectData.ShieldStrength
    else
        self.ShieldStrength         = 0
    end

    -- build state related settings:
    self.Buildable             = { }
    for _,factionName in pairs( self.AvailableForFactions ) do
        -- self.Buildable[factionName] = false
        self:SetIsBuildable( factionName, false )
    end
    self.HiddenFromGUI         = false

    return self
end
--- Returns a boolean, depending on the IsPlanetaryShieldGenerator attribute.
-- @treturn bool
function cGameObjectTypeBuilding:GetIsPlanetaryShieldGenerator()
    return self:IsTaggedAs( "PLANETARY_SHEILD" )
end
--- Returns a boolean, depending on the IsBaseShieldGenerator attribute.
-- @treturn bool
function cGameObjectTypeBuilding:GetIsBaseShieldGenerator()
    return self:IsTaggedAs( "BASE_SHIELD" )
end
--- Returns the shield generator's strength.
-- @treturn number
function cGameObjectTypeBuilding:GetShieldStrength()
    return self.ShieldStrength
end
--- Test, whether the object is a ruin building.
-- @treturn bool
function cGameObjectTypeBuilding:GetIsRuin()
    return self:IsTaggedAs( "RUIN" )
end
--- Returns the 3DGUI preview object type.
-- @treturn string 3DPreview object type.
function cGameObjectTypeBuilding:GetGUIDummy()
    return self.GUIDummy
end
--- Returns the diplomatic influence of the object.
-- @treturn number Diplomatic influence.
function cGameObjectTypeBuilding:GetDiplomaticInfluence()
    return self.DiplomaticInfluence
end

return cGameObjectTypeBuilding
