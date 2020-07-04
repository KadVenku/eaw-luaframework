-- ===== ===== ===== ===== =====
-- Copyright (c) 2017 Lukas Grünwald
-- License       MIT License
-- ===== ===== ===== ===== =====

-- Import new functions:
require( "libErrorFunctions" )
require( "libDebugFunctions" )
require( "libGCFunctionLibrary" )
-- Import new classes:

cPlanet = {}
cPlanet.__index = cPlanet

--- Constructor.
-- Creates a new LUA object of type cPlanet.
-- @tparam String newPlanetName Used as key to load all relevant data from the static planet table.
-- @tparam cGalacticConnquest parentGC Reference to the parent GC, so the planet can access fleet functions and evaluations.
-- @within Initialisation
function cPlanet.New( newPlanetName, parentGC )
    local self = setmetatable( {}, cPlanet )

    self.Name       = newPlanetName -- The Planet's name.
    self.ObjectType = "TEXT_LUA_OBJECT_TYPE_PLANET" -- LUA Object Type. Used for Error messages.
    self.Parent     = parentGC -- Reference to the parent GC object.
    self.GameObject = FindPlanet( newPlanetName ) -- Reference to the game object.
    self.Owner      = false -- Reference to the cFaction Object which owns the planet.
    self.Selected   = false -- Is the planet selected by the user?
    self.Contested  = false -- Is the planet contested by an enemy fleet?

    self.DebugModeActive = require( "configGlobalSettings" ).gSetting_DebugMode

    -- Initialisation from static library:
    local PlanetDataTable = require( "libStaticPlanetDefinitions" )
    if PlanetDataTable[newPlanetName] ~= nil then
        self.StringKey                  = PlanetDataTable[newPlanetName].StringKey -- The MasterTextFile string key.
        self.ID                         = PlanetDataTable[newPlanetName].ID -- The planet's unique integer ID
        self.IsNavPoint                 = PlanetDataTable[newPlanetName].IsNavPoint -- Is the planet a NavPoint?
        self.PlanetsInReach             = { }  -- Planets which can be reached with one single hyperjump.
        self.SpaceBuildpads             = PlanetDataTable[newPlanetName].SpaceBuildpads
        self.SpaceBuildingsBuiltNumber  = 0
        self.SpaceBuildings             = { }
        self.MajorShipyardPlanet        = PlanetDataTable[newPlanetName].ShipyardPlanet
        self.PersistentBuildings        = { }
        self.GUIDisplayedObjects        = { }
        self.MaxHealth                  = PlanetDataTable[newPlanetName].HealthPoints
        self.CurrentHealth              = PlanetDataTable[newPlanetName].HealthPoints
        self.MaxShieldPoints            = PlanetDataTable[newPlanetName].ShieldPoints
        self.CurrentShieldPoints        = PlanetDataTable[newPlanetName].ShieldPoints
        if self.IsNavPoint then
            self.GroundAccessible       = false -- We don't want false data from the config file.
        else
            self.GroundAccessible       = PlanetDataTable[newPlanetName].GroundAccessible
        end
        self.GroundBuildpads            = PlanetDataTable[newPlanetName].GroundBuildpads
        self.GroundBuildingsBuiltNumber = 0
        self.GroundBuildings            = { }
        self.RuinBuildings              = 0
        self.ApplicableStates           = PlanetDataTable[newPlanetName].ApplicableStates
        self.CurrentState               = PlanetDataTable[newPlanetName].CurrentState
        self.StateIndicator             = false
        self.IsStoryObject              = PlanetDataTable[newPlanetName].IsStoryObject
        self.IsStoryProtected           = PlanetDataTable[newPlanetName].IsStoryProtected
        self.BelongsToFaction           = false -- Setup is handled via the faction; used to cross reference.
        self.IsCapital                  = false -- Setup is handled via the faction; used to cross reference.
        self.IsAlliedWithFaction        = false -- Initialised with a EvaluateOwner() call.
        self.AllianceStrength           = require( "configGlobalSettings" ).gSetting_Diplomacy_InitialPlanetAllianceStrength
        self.DiplomaticValue            = require( "configGlobalSettings" ).gSetting_Diplomacy_InitialPlanetInfluenceStrength
        self.ForeignDiplomaticInfuence  = {}
        self.DiplomacyDisabledForPlanet = PlanetDataTable[newPlanetName].DiplomacyDisabledForPlanet
        self.TacticalModel              = PlanetDataTable[newPlanetName].TacticalModel
        self.TacticalMapsByState        = PlanetDataTable[newPlanetName].TacticalMapsByState
        self.ActiveDiplomaticMission    = false
    else
        ThrowObjectInitialisationError( self:GetObjectType() )
    end

    return self
end
--- Initialises all planet relations to other objects which cannot be initialised in the constructor.
-- Updates owner relations and the like.
-- @within Initialisation
function cPlanet:Initialise()
    local PlanetDataTable = require( "libStaticPlanetDefinitions" )
    if PlanetDataTable[self:GetName()] ~= nil then
        local GUIObjTypes = require( "libStaticGUIObjectMappings" )
        for _,GUIObj in pairs( GUIObjTypes ) do
            local GUIObjSet = {
                ObjectName      = GUIObj,
                ObjectReference = false,
                IsVisible       = false,
            }
            self.GUIDisplayedObjects[GUIObj] = GUIObjSet
        end
        local persBuildingTable = PlanetDataTable[self:GetName()].PersistentBuildings
        if table.getn( persBuildingTable ) > 0 then
            for _,objType in pairs( persBuildingTable ) do
                self:AddPersistentObject( objType )
            end
        end
    else
        ThrowObjectInitialisationError( self:GetObjectType() )
    end
end

-- ===== ===== ===== GETTER AND SETTER SECTION ===== ===== =====

--- Returns the planet name.
-- @treturn String
-- @within Getter Functions
function cPlanet:GetName()
    return self.Name
end
--- Returns the whether a planet is selected.
-- @treturn bool
-- @within Getter Functions
function cPlanet:GetSelected()
    return self.Selected
end
--- Returns the game object.
-- @treturn GameObject
function cPlanet:GetPlanetLocation()
    return self.GameObject
end
--- Sets a planet select state.
-- @tparam bool newSelectedState
-- @within Setter Functions
function cPlanet:SetSelected( newSelectedState )
    self.Selected = newSelectedState
end
--- Returns the MasterTextFile key.
-- @treturn String
-- @within Getter Functions
function cPlanet:GetStringKey()
    return self.StringKey
end
--- Returns the lua object type as string key.
-- Used for error handling.
-- @treturn String
-- @within Getter Functions
function cPlanet:GetObjectType()
    return self.ObjectType
end
--- Is the planet a nav point?.
-- @treturn bool
-- @within Getter Functions
function cPlanet:GetIsNavPoint()
    return self.IsNavPoint
end
--- Returns the planet's owner as cFaction object.
-- @treturn cFaction
-- @within Getter Functions
function cPlanet:GetOwner()
    return self.Owner
end
--- Returns the planet's home faction.
-- @treturn[1] bool false if single planet.
-- @treturn[2] cFaction if part of sector.
-- @within Getter Functions
function cPlanet:GetHomeFaction()
    return self.BelongsToFaction
end
--- Sets a new ally for a planet.
-- This is not the same as the owner, and instead is being used by the diplomacy system.
-- @tparam cFaction newAllyObject
-- @within Setter Functions
function cPlanet:SetAlliedFaction( newAllyObject )
    self.IsAlliedWithFaction = newAllyObject
end
function cPlanet:GetAlliedFaction()
    return self.IsAlliedWithFaction
end
--- Sets the planet's owner as cFaction object.
-- @tparam cFaction newOwner
-- @within Setter Functions
function cPlanet:SetOwner( newOwner )
    self.Owner = newOwner
end
--- Sets the planet's parent GC reference.
-- @tparam cGalacticConquest galacticConquestReference
-- @within Setter Functions
function cPlanet:SetParent( galacticConquestReference )
    self.Parent = galacticConquestReference
end
--- Sets the planet's owning faction.
-- @tparam cFaction owningFactionReference
-- @within Setter Functions
function cPlanet:SetParentFaction( owningFactionReference )
    self.BelongsToFaction = owningFactionReference
end
--- Gets the planet's owning faction.
-- @treturn bool
-- @treturn owningFactionReference
-- @within Getter Functions
function cPlanet:GetParentFaction()
    return self.BelongsToFaction
end
--- Sets the IsCapital attribute.
-- @tparam bool isPlanetCapital
-- @within Setter Functions
function cPlanet:SetIsCapital( isPlanetCapital )
    self.IsCapital = isPlanetCapital
end
--- Gets the IsCapital attribute.
-- @treturn bool
-- @within Getter Functions
function cPlanet:GetIsCapital()
    return self.IsCapital
end
--- Returns the localisation key of the planet.
-- @treturn string
function cPlanet:GetStringKey()
    return self.StringKey
end
--- Returns the contested state.
-- @treturn bool
function cPlanet:GetContested()
    return self.Contested
end
--- Sets the contested state.
-- @tparam bool state
function cPlanet:SetContested( state )
    self.Contested = state
end
function cPlanet:GetCurrentDiplomaticInfluenceOwnerRaw()
    return self.DiplomaticValue
end
--- Applies the owner faction's trait modifiers to the raw rating.
-- This function should be used to calculate diplomacy related operations.
-- @treturn number Raw diplomatic rating.
function cPlanet:GetCurrentDiplomaticInfluenceOwner()
    local lRawDiplVal = self:GetCurrentDiplomaticInfluenceOwnerRaw()
    local lTraitTable = self.Owner:GetTraits()
    for _,facTrait in pairs( lTraitTable ) do
        lRawDiplVal = lRawDiplVal * facTrait.DiplomaticInfluenceMult
    end
    return lRawDiplVal
end
function cPlanet:GetCurrentDiplomaticInfluenceForeignFaction( cFacObj )
    if self.ForeignDiplomaticInfuence[cFacObj:GetName()] ~= nil then
        return self.ForeignDiplomaticInfuence[cFacObj:GetName()]
    end
    return 0
end
--- Returns the prefix for all planet related global values.
-- @treturn string
function cPlanet:GetGlobalValuePrefix()
    local gValString
    local gValPref = "GVAL_PLANET_"
    local pName = self:GetName()
    pName = ConvertToUpperCase( pName )
    local gValString = gValPref..pName.."_"
    return gValString
end
--- Adds a new planet object to the planet in reach table.
-- @tparam cPlanet newPlanetInReach
function cPlanet:AddPlanetInReach( newPlanetInReach )
    if self.PlanetsInReach[newPlanetInReach:GetName()] ~= nil then
        ThrowObjectAlreadyRegisteredError( newPlanetInReach:GetStringKey() )
    else
        self.PlanetsInReach[newPlanetInReach:GetName()] = newPlanetInReach
    end
end
function cPlanet:ChangeOwner( cFactionNewOwner )
-- Kad 23/06/2017 16:27:27 - We'll just change the player object owner in here and let the owner handler pick up the rest.
    self:GetPlanetLocation().Change_Owner( cFactionNewOwner:GetPlayerObject() )
end
--- Evaluates a planet's current owner.
-- If the owners don't match, or are not set this will trigger a EVENTTYPE_PLANET_OWNERCHANGE
-- @within Evaluations
function cPlanet:EvaluateOwner()
    -- Owning player object; that's what the game sees. In addition this is the de-facto owner of the planet.
    local owningPlayerObject = self.GameObject.Get_Owner()
    -- the LUA cFaction Object; that's what the framework sees:
    local owningFactionObject = self.Parent:GetFactionObjectByPlayerObject( owningPlayerObject )
    if owningFactionObject then
        if self:GetOwner() then
            if self:GetOwner() ~= owningFactionObject then
                -- Updating the cFaction owner:
                if self.DebugModeActive then
                    debugPlanetOwnerChange( self:GetStringKey(), self:GetOwner():GetStringKey(), owningFactionObject:GetStringKey() )
                end
                self:SetOwner( owningFactionObject )
                self:EvaluateBuildings()
                self:UpdatePersistentObjects()
                self:EvaluateBuildings()
            end
        else
            self:SetOwner( owningFactionObject )
            self.IsAlliedWithFaction = owningFactionObject
        end
    else
        self:SetOwner( false )
    end
end
--- Updates the building lists on the planet.
-- TODO Try triggering the update via the built event from the gamescoring.lua module
function cPlanet:EvaluateBuildings()
    -- Local tables to prevent invalidating the old data.
    local sBuild = { }
    local gBuild = { }
    -- Set all GUI objects invisible:
    for _,guiObj in pairs( self.GUIDisplayedObjects ) do
        guiObj.IsVisible = false
    end
    -- Get all buildings:
    local buildingList = Find_All_Objects_Of_Type( "Structure" )
    for index,objRef in pairs( buildingList ) do
        if TestValid( objRef ) then
            if objRef.Get_Planet_Location() == self:GetPlanetLocation() then
                local cObjType = self.Parent.ObjectManager:GetCGameObjectTypeByReference( objRef )
                if cObjType then
                    if cObjType:IsTaggedAs( "ORBITAL" ) then
                        table.insert( sBuild, objRef )
                        local gui3DObj = cObjType:GetGUIDummy()
                        if gui3DObj then
                            if self.GUIDisplayedObjects[gui3DObj].ObjectReference then
                                self.GUIDisplayedObjects[gui3DObj].IsVisible = true
                            else
                                self.GUIDisplayedObjects[gui3DObj].ObjectReference = self:AttachGUI3DObject( self.GUIDisplayedObjects[gui3DObj].ObjectName )
                                self.GUIDisplayedObjects[gui3DObj].IsVisible = true
                            end
                        end
                    elseif cObjType:IsTaggedAs( "GROUND" ) then
                        table.insert( gBuild, objRef )
                        local gui3DObj = cObjType:GetGUIDummy()
                        if gui3DObj then
                            if self.GUIDisplayedObjects[gui3DObj].ObjectReference then
                                self.GUIDisplayedObjects[gui3DObj].IsVisible = true
                            else
                                self.GUIDisplayedObjects[gui3DObj].ObjectReference = self:AttachGUI3DObject( self.GUIDisplayedObjects[gui3DObj].ObjectName )
                                self.GUIDisplayedObjects[gui3DObj].IsVisible = true
                            end
                        end
                    end
                end
            end
        end
    end
    for _,guiObj in pairs( self.GUIDisplayedObjects ) do
        -- Temporary fix to keep persistent objects displayed after a space battle.
        -- Re-spawning them is technically not desired, but in this case needed.
        if not guiObj.IsVisible then
            if guiObj.ObjectReference then
                guiObj.ObjectReference.Despawn()
                guiObj.ObjectReference = false
            end
        end
        -- if guiObj.IsVisible then
        --     if guiObj.ObjectReference then
        --         self:ShowAttachedGUIObject( guiObj.ObjectReference )
        --     end
        -- else
        --     if guiObj.ObjectReference then
        --         self:HideAttachedGUIObject( guiObj.ObjectReference )
        --     end
        -- end
    end
    self.SpaceBuildings = sBuild -- Invalidate the old building tables.
    self.GroundBuildings = gBuild -- Invalidate the old building tables.
    self.SpaceBuildingsBuiltNumber = table.getn( self.SpaceBuildings ) -- update building count.
    self.GroundBuildingsBuiltNumber = table.getn( self.GroundBuildings ) -- update building count.
end
--- Returns the string keys for the space buildings on a planet.
-- @treturn table
function cPlanet:GetSpaceBuildingsAsString()
    local retTable = {}
    for _,objRef in pairs( self.SpaceBuildings ) do
        local cObjType = self.Parent.ObjectManager:GetCGameObjectTypeByReference( objRef )
        if cObjType then
            local stringKey = cObjType:GetStringKey()
            table.insert( retTable, stringKey )
        end
    end
    if table.getn( retTable ) > 0 then
        return retTable
    end
    return false
end
--- Returns the string keys for the ground buildings on the planet.
-- @treturn table
function cPlanet:GetGroundBuildingsAsString()
    local retTable = {}
    for _,objRef in pairs( self.GroundBuildings ) do
        local cObjType = self.Parent.ObjectManager:GetCGameObjectTypeByReference( objRef )
        if cObjType then
            local stringKey = cObjType:GetStringKey()
            table.insert( retTable, stringKey )
        end
    end
    if table.getn( retTable ) > 0 then
        return retTable
    end
    return false
end
--- Evaluates, whether an enemy fleet orbits a planet.
-- @treturn bool Returns a boolean depending on checked result.
-- @treturn GalacticFleetObject Returns the contesting fleet object. Can be used to check for present diplomats, etc.
function cPlanet:EvaluatePlanetContested()
    local gFleets = self.Parent.GalacticFleets
    for _,fleetObj in pairs( gFleets ) do
        if fleetObj.Get_Parent_Object() == self:GetPlanetLocation() and fleetObj.Get_Owner() ~= self.GameObject.Get_Owner() then
            if self.DebugModeActive and not self:GetContested() then
                debugPlanetContested( self:GetStringKey() )
            end
            self:SetContested( true )
            return true, fleetObj
        end
    end
    self:SetContested( false )
    return false, false
end
--- Evaluates the influence on the planet of the owner faction.
-- This returns the raw influence without the faction traits applied.
function cPlanet:EvaluateDiplomaticInfluenceOwnerFactionRaw()
    -- Backing up tables to prevent invalidations via the building update cycle:
    local oBldngTable = self.SpaceBuildings
    -- Backing up tables to prevent invalidations via the building update cycle:
    local gBldngTable = self.GroundBuildings
    -- we won't reuse the old influence, instead calculate a new one.
    local lDipInf = 0.0
    local prevVal = self.DiplomaticValue
    -- Kad 18/06/2017 13:56:13 - We take a certain percentage of the old influence into account, so the influence does grow slowly, even if no diplomat is present.
    local prevValMult = require( "configGlobalSettings" ).gSetting_Diplomacy_OwnerPreviousEvalValueKept
    prevVal = prevVal * prevValMult
    lDipInf = lDipInf + prevVal
    for _,objRef in pairs( oBldngTable ) do
        if TestValid( objRef ) then
            local cObjType = self.Parent.ObjectManager:GetCGameObjectTypeByReference( objRef )
            if cObjType  then
                lDipInf = lDipInf + cObjType:GetDiplomaticInfluence()
            end
        end
    end
    for _,objRef in pairs( gBldngTable ) do
        if TestValid( objRef ) then
            local cObjType = self.Parent.ObjectManager:GetCGameObjectTypeByReference( objRef )
            if cObjType  then
                lDipInf = lDipInf + cObjType:GetDiplomaticInfluence()
            end
        end
    end
    -- Now evaluate units as well:
    local ownerUnits = Find_All_Objects_Of_Type( self.Owner:GetPlayerObject() )
    local lDipMult = 1.0
    for _,unitRef in pairs( ownerUnits ) do
        if TestValid( unitRef ) and unitRef.Get_Planet_Location() == self:GetPlanetLocation() then
            local cObjType = self.Parent.ObjectManager:GetCGameObjectTypeByReference( unitRef )
            if cObjType then
                if cObjType:IsTaggedAs( "DIPLOMAT" ) then
                    -- We use the object's traits here:
                    for _,unitTrait in pairs( cObjType.Traits ) do
                        lDipInf = lDipInf + unitTrait.DiplomaticInfluenceBaseValue
                        lDipMult = lDipMult * unitTrait.DiplomaticInfluenceMultiplier
                    end
                end
            end
        end
    end
    -- Kad 18/06/2017 13:57:38 - We might want to cap the influence at a certain level for a planet.
    lDipInf = lDipInf * lDipMult
    local maxInf = require( "configGlobalSettings" ).gSetting_Diplomacy_InfluenceOnPlanetCap
    lDipInf = ClampValue( lDipInf, 0, maxInf )
    self.DiplomaticValue = lDipInf
end
--- Returns the current raw diplomatic value.
-- Calling this function forces an update of the self.DiplomaticAttribute
-- @treturn number self.DiplomaticValue
function cPlanet:GetDiplomaticRatingRaw()
    self:EvaluateDiplomaticInfluenceOwnerFactionRaw()
    return self.DiplomaticValue
end
--- Applies the owner faction's trait modifiers to the raw rating.
-- This function should be used to calculate diplomacy related operations.
-- @treturn number Raw diplomatic rating.
function cPlanet:GetDiplomaticRating()
    local lRawDiplVal = self:GetDiplomaticRatingRaw()
    local lTraitTable = self.Owner:GetTraits()
    for _,facTrait in pairs( lTraitTable ) do
        lRawDiplVal = lRawDiplVal * facTrait.DiplomaticInfluenceMult
    end
    return lRawDiplVal
end
--- Evaluates the influence on the planet of a given faction.
-- This returns the raw influence without the faction traits applied.
-- @tparam cFaction cFacObj Faction to be evaluated.
-- @tparam cGameObjectType cGameObjDiplomatType Diplomat leading the talks.
function cPlanet:EvaluateForeignDiplomaticInfuenceRaw( cFacObj, cGameObjDiplomatType )
    local lDipInf = 0.0
    local lDipMult = 1.0
    local upperCap = require( "configGlobalSettings" ).gSetting_Diplomacy_InfluenceOnPlanetCap
    -- Kad 08/06/2017 17:33:24 - We're now only updating the diplomat that does the sweet talking.
    for _,unitTrait in pairs( cGameObjDiplomatType.Traits ) do
        lDipInf = lDipInf + unitTrait.DiplomaticInfluenceBaseValue
        lDipMult = lDipMult * unitTrait.DiplomaticInfluenceMultiplier
    end
    lDiplInf = lDipInf * lDipMult
    lDiplInf = ClampValue( lDiplInf, 0, upperCap )
    if self.ForeignDiplomaticInfuence[cFacObj:GetName()] ~= nil then
        local lInf = self.ForeignDiplomaticInfuence[cFacObj:GetName()]
        lInf = lInf + lDiplInf
        lInf = ClampValue( lInf, 0, upperCap )
        self.ForeignDiplomaticInfuence[cFacObj:GetName()] = lInf
    else
        self.ForeignDiplomaticInfuence[cFacObj:GetName()] = lDiplInf
    end
    -- Kad 08/06/2017 17:40:54 - Update the other factions accordingly. This does take the traits into account!
    local fInfluencingMult = 1.0
    local dFacTraits = cFacObj:GetTraits()
    for _,dFacTrait in pairs( dFacTraits ) do
        fInfluencingMult = fInfluencingMult * dFacTrait.DiplomaticPowerMult
    end
    for factionName,Influence in pairs( self.ForeignDiplomaticInfuence ) do
        if factionName ~= cFacObj:GetName() then
            local fTraits = self.Parent.Factions[factionName]:GetTraits()
            local influencedMult = 1.0
            for _,fTrait in pairs( fTraits ) do
                influencedMult = influencedMult * fTrait.DiplomaticInfluenceMult
            end
            local diplDiff = lDiplInf * fInfluencingMult * nfluencedMult
            Influence = Influence - diplDiff
            -- Kad 08/06/2017 18:04:51 - 0 < Influence < InfluenceCap
            Influence = ClampValue( Influence, 0, upperCap )
        end
    end
end
--- Returns the current raw diplomatic value of a given faction.
-- Calling this function forces an update of the self.ForeignDiplomaticInfuence table.
-- @tparam cFaction cFacObj Faction to be evaluated.
-- @tparam cGameObjectType cGameObjDiplomatType Diplomat leading the talks.
-- @treturn number ForeignDiplomaticInfuence[cFacObj:GetName()]
function cPlanet:GetForeignDiplomaticInfuenceRaw( cFacObj, cGameObjDiplomatType )
    self:EvaluateForeignDiplomaticInfuenceRaw( cFacObj, cGameObjDiplomatType )
    return self.ForeignDiplomaticInfuence[cFacObj:GetName()]
end
--- Applies the desired faction's trait modifiers to the raw rating.
-- This function should be used to calculate diplomacy related operations.
-- @tparam cFaction cFacObj Faction to be evaluated.
-- @tparam cGameObjectType cGameObjDiplomatType Diplomat leading the talks.
-- @treturn number Raw diplomatic rating.
function cPlanet:GetForeignDiplomaticInfuence( cFacObj, cGameObjDiplomatType )
    local lRawDiplVal = self:GetForeignDiplomaticInfuenceRaw( cFacObj, cGameObjDiplomatType )
    local lTraitTable = cFacObj:GetTraits()
    for _,facTrait in pairs( lTraitTable ) do
        lRawDiplVal = lRawDiplVal * facTrait.DiplomaticPowerMult
    end
    return lRawDiplVal
end
--- Attaches a persistent object to the planet.
-- This object will be stuck at this specific planet until a MP_POD message referencing this object has been fired.
-- @tparam string objType
function cPlanet:AddPersistentObject( objType )
    if self.PersistentBuildings[objType] == nil then
        self.PersistentBuildings[objType] = 1
    else
        self.PersistentBuildings[objType] = self.PersistentBuildings[objType] + 1
    end
end
--- Removes a registered persistent object type from a planet.
-- An incoming MP_POD message will create an event that in turn calls this function with the desired persistent object.
-- @tparam string objType
function cPlanet:RemovePersistentObject( objType )
    if self.PersistentBuildings[objType] ~= nil  or self.PersistentBuildings[objType] < 1 then
        self.PersistentBuildings[objType] = 0
    else
        self.PersistentBuildings[objType] = self.PersistentBuildings[objType] - 1
    end
end
--- Update cycle which ensures that persistent objects are in fact still residing on the planet.
-- This function will re-spawn any missing persistent object attached to the planet.
function cPlanet:UpdatePersistentObjects()
    for objType, objCount in pairs( self.PersistentBuildings ) do
        local objTypeTable = Find_All_Objects_Of_Type( objType )
        local objTypePresent = 0
        for _,objRef in pairs( objTypeTable ) do
            if IsContentOfTable( self.SpaceBuildings, objRef ) or IsContentOfTable( self.GroundBuildings, objRef ) then
                objTypePresent = objTypePresent + 1
            end
        end
        if objTypePresent < objCount then
            local respawnTable = {}
            for i = 1, objCount - objTypePresent, 1 do
                table.insert( respawnTable, objType )
            end
            SpawnList( respawnTable, self:GetPlanetLocation(), self:GetPlanetLocation().Get_Owner(), true, true )
        end
    end
end
--- Hides a 3D preview of a present object on the planet.
-- This will only hide objects which are already present on a planet.
-- @tparam GameObject objRef
function cPlanet:HideAttachedGUIObject( objRef )
    objRef.Hide( true )
end
--- Shows an attached GUI 3D Preview.
-- this will only show objects which have already been spawned for the planet.
-- @tparam GameObject objRef
function cPlanet:ShowAttachedGUIObject( objRef )
    objRef.Hide( false )
end
--- Attaches a new 3D GUI preview game object to the planet.
-- If a preview has been requested that has not yet been spawned, this function will create it.
-- @tparam string objType
-- @treturn[1] GameObject 3D GUI Object
function cPlanet:AttachGUI3DObject( objType )
    local GUI3DObj = Create_Generic_Object( objType, self:GetPlanetLocation().Get_Position(), Find_Player( "Neutral" ) )
    return GUI3DObj
end

function cPlanet:SetActiveDiplomaticMission()
    self.ActiveDiplomaticMission = true
end
function cPlanet:SetInactiveDiplomaticMission()
    self.ActiveDiplomaticMission = false
end
function cPlanet:GetActiveDiplomaticMission()
    return self.ActiveDiplomaticMission
end
function cPlanet:TakeDamage( damageTaken )
    if self.GroundAccessible then -- Kad 07/07/2017 11:51:57 - Let's prevent someone using this function on planets without ground maps, usually we wouldn't do that, but in this case we're better safe than sorry...
        if self.DebugModeActive then
            Game_Message( "TEXT_DEBUG_PLANET_TAKING_DAMAGE" )
        end
        -- Kad 04/07/2017 19:22:22 - Do we have a shield generator?
        local bTab = self.GroundBuildings
        if self:IsShielded() then
            -- Kad 04/07/2017 19:31:26 - Damage shield:
            self.CurrentShieldPoints = self.CurrentShieldPoints - damageTaken
            local carryOnDamage = 0 -- Kad 05/07/2017 17:40:17 - ... my wayward son ...
            if self.CurrentShieldPoints < 0 then
                carryOnDamage = self.CurrentShieldPoints
                self.CurrentShieldPoints = 0
                for id, objRef in pairs( bTab ) do
                    local objRefType = self.Parent.ObjectManager:GetCGameObjectTypeByReference( objRef )
                    if objRefType then
                        if self.DebugModeActive then
                            Game_Message( "TEXT_DEBUG_PLANET_TAKING_SHEILD_DAMAGE" )
                        end
                        if objRefType:GetIsPlanetaryShieldGenerator() then
                            if self.PersistentBuildings[objRefType:GetObjectTypeXML()] ~= nil then
                                self:RemovePersistentObject( objRefType:GetObjectTypeXML() )
                            end
                            if self.PersistentBuildings[objRefType:GetObjectTypeCapital()] ~= nil then
                                self:RemovePersistentObject( objRefType:GetObjectTypeCapital() )
                            end
                            DestroyBuilding( objRef, require( "configGlobalSettings" ).gSetting_PD_BombardmentBuildingDestructionParticle )
                            self:AddPersistentObject( require( "configGlobalSettings" ).gSetting_PD_RuinObject )
                            -- Kad 06/07/2017 13:22:05 - Remove the object from our local table, the building manager will take care of updating the actual one.
                            bTab[id] = nil
                        end
                    end
                end
                self.CurrentHealth = self.CurrentHealth + carryOnDamage
            end
        else
            -- Kad 04/07/2017 19:28:24 - Damage the planet:
            self.CurrentHealth = self.CurrentHealth - damageTaken
            if self.DebugModeActive then
                Game_Message( "TEXT_DEBUG_PLANET_TAKING_HEALTH_DAMAGE" )
            end
        end
        if self.CurrentHealth < self.MaxHealth then
            local healthRatio = self.CurrentHealth / self.MaxHealth
            -- Kad 05/07/2017 13:46:28 - Blow random stuff to pieces:
            for id,objRef in pairs( bTab ) do
                if GameRandom.Get_Float() > healthRatio then
                    local objRefType = self.Parent.ObjectManager:GetCGameObjectTypeByReference( objRef )
                    if objRefType then
                        if self.DebugModeActive then
                            Game_Message( "TEXT_DEBUG_PLANET_DESTROYING_BUILDING" )
                        end
                        if not objRefType:GetIsRuin() then
                            if self.PersistentBuildings[objRefType:GetObjectTypeXML()] ~= nil then
                                self:RemovePersistentObject( objRefType:GetObjectTypeXML() )
                            end
                            if self.PersistentBuildings[objRefType:GetObjectTypeCapital()] ~= nil then
                                self:RemovePersistentObject( objRefType:GetObjectTypeCapital() )
                            end
                            DestroyBuilding( objRef, require( "configGlobalSettings" ).gSetting_PD_BombardmentBuildingDestructionParticle )
                            self:AddPersistentObject( require( "configGlobalSettings" ).gSetting_PD_RuinObject )
                            bTab[id] = nil -- Kad 06/07/2017 15:07:06 - Prevent this object from doing anything in future calculations.
                        end
                    end
                end
            end
            local groundUnitTable = Find_All_Objects_Of_Type( "Infantry | Vehicle | Air" ) -- Kad 06/07/2017 13:28:11 - We omit heroes later on
            for _,objRef in pairs( groundUnitTable ) do
                if TestValid( objRef ) then
                    if objRef.Get_Planet_Location() == self:GetPlanetLocation() and objRef.Get_Owner() == self:GetOwner():GetPlayerObject() then
                        if not objRef.Get_Type().Is_Hero() then -- Kad 06/07/2017 13:29:05 - Don't kill heroes.
                            if GameRandom.Get_Float() > healthRatio then
                                DestroyUnit( objRef, require( "configGlobalSettings" ).gSetting_PD_BombardmentUnitDestructionParticle )
                            end
                        end
                    end
                end
            end
        end
    end
end
function cPlanet:GetHealth()
    local currPercentage = self.CurrentHealth / self.MaxHealth
    return currPercentage
end
function cPlanet:GetShield()
    local currPercentage = self.CurrentShieldPoints / self.MaxShieldPoints
    return currPercentage
end
function cPlanet:IsShielded()
    local bTab = self.GroundBuildings
    local isShielded = false
    for _,objRef in pairs( bTab ) do
        local objRefType = self.Parent.ObjectManager:GetCGameObjectTypeByReference( objRef )
        if objRefType then
            if objRefType:GetIsPlanetaryShieldGenerator() then
                if self.DebugModeActive then
                    Game_Message( "TEXT_DEBUG_PLANETARY_SHIELD_PRESENT" )
                end
                isShielded = true
                break
            end
        end
    end
    return isShielded
end
function cPlanet:GetCurrentState()
    return self.CurrentState
end

function cPlanet:AdvanceState( newState, cFactionAttacker, cFactionDefender )
    if IsContentOfTable( self.ApplicableStates, newState ) and self:GetCurrentState() ~= newState then -- Kad 14/07/2017 15:56:07 - We don't want to change from the current state to the current state that'll just end up being fucky.
        self:SetNewState( newState, cFactionAttacker, cFactionDefender )
    else
        -- Kad 07/07/2017 17:49:47 - TODO Throw error!
    end
end

function cPlanet:SetNewState( newState, cFactionAttacker, cFactionDefender )
    -- Kad 07/07/2017 23:25:30 - A State consists of:
    -- NumericID           = 0,
    -- UniqueKey           = "UNIQUE_NAME",
    -- StateIndicator      = false,
    -- EvacuateAllUnits    = false,
    -- TurnsPlanetNeutral  = false,
    -- BlocksGroundAccess  = false,
    -- DestroysPlanet      = false,
    -- EndsCurrentAlliance = false,
    -- AddsTraitToAttacker = false,
    -- AddsTraitToDefender = false,

    -- Kad 07/07/2017 23:24:07 - Load the state:
    local nState = require( "libStaticPlanetStates" )[newState]
    -- Kad 07/07/2017 23:24:16 - Each state consists of the same basic information, so we just do a big if, instead of fancy iteration magic:
    if nState.StateIndicator then
        if self.StateIndicator then
            self.StateIndicator.Despawn()
            self.StateIndicator = false
        end
        self.StateIndicator = Create_Generic_Object( nState.StateIndicator, self:GetPlanetLocation().Get_Position(), Find_Player( "Neutral" ) )
    else
        if self.StateIndicator then
            self.StateIndicator.Despawn()
            self.StateIndicator = false
        end
    end
    -- Kad 10/07/2017 13:16:46 - We don't even need this, do we?
    -- if nState.EvacuateAllUnits then
    --     local groundUnits = Find_All_Objects_Of_Type( "Infantry | Air | Vehicle" )
    --     local groundUnitsByOwner = {}
    --     for _,objRef in pairs( groundUnits ) do
    --         if objRef.Get_Planet_Location() == self:GetPlanetLocation() then
    --             if groundUnitsByOwner[objRef.Get_Owner()] ~= nil then
    --                 table.insert(groundUnitsByOwner[objRef.Get_Owner()], objRef)
    --             else
    --                 groundUnitsByOwner[objRef.Get_Owner()] = {}
    --                 table.insert(groundUnitsByOwner[objRef.Get_Owner()], objRef)
    --             end
    --         end
    --     end
    -- end
    if cFactionAttacker ~= nil then
        if nState.AddsTraitToAttacker then
            cFactionAttacker:AddNewTrait( nState.AddsTraitToAttacker )
        end
    end
    if cFactionDefender ~= nil then
        if nState.AddsTraitToDefender then
            cFactionAttacker:AddNewTrait( nState.AddsTraitToDefender )
        end
    end
    if nState.TurnsPlanetNeutral then
        -- Kad 10/07/2017 14:43:13 - TODO
    end
    if nState.BlocksGroundAccess then
        -- Kad 10/07/2017 14:43:07 - TODO
    end
    if nState.DestroysPlanet then
        self:Destroy()
    end
end

function cPlanet:GetPlanetInReach( desiredOwner )
    -- Kad 10/07/2017 11:32:41 - Not doing a proper graph traversal, I'd have to build the graph first and then do a Dijstra. Instead we'll search only two jumps far and cache the planets. If we can't find a proper planet, we'll randomly choose one from the cache.
    local plnCache = {}
    for _,cPlnObjL0 in pairs( self.PlanetsInReach ) do
        if cPlnObjL0:GetOwner() == desiredOwner or cPlnObjL0:GetOwner():GetPlayerObject() == Find_Player( "Neutral" ) then
            debugFoundSuitablePlanetInReach( cPlnObjL0:GetStringKey(), desiredOwner:GetStringKey() )
            return cPlnObjL0
        else
            table.insert( plnCache, cPlnObjL0 ) -- Kad 10/07/2017 21:44:59 - Cache planet.
            for _,cPlnObjL1 in pairs( cPlnObjL0.PlanetsInReach ) do
                if cPlnObjL1:GetOwner() == desiredOwner or cPlnObjL1:GetOwner():GetPlayerObject() == Find_Player( "Neutral" ) then
                    debugFoundSuitablePlanetInReach( cPlnObjL1:GetStringKey(), desiredOwner:GetStringKey() )
                    return cPlnObjL1
                else
                    table.insert( plnCache, cPlnObjL1 )
                end
            end
        end
    end
    local pln = plnCache[GameRandom( 1, table.getn( plnCache ) )]
    if self.DebugModeActive then
        debugRandomPlanetInReach( pln:GetStringKey(), desiredOwner:GetStringKey() )
    end
    return pln
end

function cPlanet:Destroy()
    local helperDSFleetSpawn = SpawnList( {"Death_Star"}, self:GetPlanetLocation(), Find_Player( "Hostile" ), false, false )
    local helperDeathStar = helperDSFleetSpawn[1]
    local helperDSFleet = Assemble_Fleet( helperDSFleetSpawn )
    helperDeathStar.Set_Check_Contested_Space( false )
    helperDSFleet.Activate_Ability( "Death_Star" )
    helperDeathStar.Set_Check_Contested_Space( true )
    helperDeathStar.Despawn()
    self.GroundAccessible = false
end


-- ============ DEBUG STUFF ============

function cPlanet:AddPlanetHighlight( highlightTag )
    local tag = nil
    if highlightTag == nil then
        tag = self:GetName().."_TAG"
    else
        tag = highlightTag
    end
    Add_Planet_Highlight( self.GameObject, tag )
    return tag
end

function cPlanet:RemovePlanetHighlight( highlightTag )
    if highlightTag ~= nil then
        Remove_Planet_Highlight( highlightTag )
    else
        Remove_Planet_Highlight( self:GetName().."_TAG" )
    end
end

return cPlanet
