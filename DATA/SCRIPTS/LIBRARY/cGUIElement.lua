-- ===== ===== ===== ===== =====
-- Copyright (c) 2017 Lukas Grünwald
-- License       MIT License
-- ===== ===== ===== ===== =====

--- {abstract} cGUIelement base class.
-- All cGUIElement_[...] inherit the functionality from this base class.

require( "libPGGenericFunctionLibrary" )

cGUIElement = {}
cGUIElement.__index = cGUIElement

--- Constructor.
-- Creates a new LUA object of type cGUIElement.
-- @tparam cGUIHandler parentGUIHandler
-- @tparam string guiObjectName
-- @tparam string guiDebugStringKey
-- @tparam table guiObjectFlags
-- @within Initialisation
function cGUIElement.New( parentGUIHandler, guiObjectName, guiDebugStringKey, guiObjectFlags )
    local self = setmetatable( {}, cGUIElement )
    self.GUIObjectName   = guiObjectName
    self.StringKey       = guiDebugStringKey
    self.GUIFlags        = guiObjectFlags
    self.Parent          = parentGUIHandler
    self.IsLocked        = false
    self.DebugModeActive = require( "configGlobalSettings" ).gSetting_DebugMode

    return self
end

--- {abstract} Initialises the data required for the button (like story events, flags, etc).
function cGUIElement:Initialise()
    return false
end
--- Tests whether the GUIelement is flagged with a certain flag/list of flags.
-- @tparam  string/table flagObject
-- @treturn bool
function cGUIElement:IsFlaggedAs( flagObject )
    return IsObjectTaggedAs( self.GUIFlags, flagObject )
end
--- Returns the GUIObject's string key.
-- @treturn string
-- @within Getter Functions
function cGUIElement:GetStringKey()
    return self.StringKey
end
--- Returns the GUIObject's lock state.
-- @treturn bool
-- @within Getter Functions
function cGUIElement:GetLocked()
    return self.IsLocked
end
--- Sets the GUIObject's lock state.
-- @tparam bool newLockState
-- @within Setter Functions
function cGUIElement:SetLocked( newLockState )
    self.IsLocked = newLockState
end
--- Returns the GUIObject's name as defined in the xml.
-- @treturn string
-- @within Getter Functions
function cGUIElement:GetGUIObjectName()
    return self.GUIObjectName
end
--- Locks the GUI element.
function cGUIElement:Lock()
    if not self:GetLocked() then
        local lockEvent = Get_Story_Plot( "__luaFramework/cGUIHandler/cGUIElement.xml" ).Get_Event( "cGUIElement_LockGUIElement" )
        lockEvent.Set_Reward_Parameter( 1, self:GetGUIObjectName() )
        Story_Event( "cGUIElement_LockGUIElement_Trigger" )
        if self.DebugModeActive then
            debugGUIElementLockUnlockEvent( self:GetStringKey(), "LOCK" )
        end
        self:SetLocked( true )
    end
end
--- Unlocks the GUI element.
function cGUIElement:Unlock()
    if self:GetLocked() then
        local unlockEvent = Get_Story_Plot( "__luaFramework/cGUIHandler/cGUIElement.xml" ).Get_Event( "cGUIElement_UnlockGUIElement" )
        unlockEvent.Set_Reward_Parameter( 1, self:GetGUIObjectName() )
        Story_Event( "cGUIElement_UnlockGUIElement_Trigger" )
        if self.DebugModeActive then
            debugGUIElementLockUnlockEvent( self:GetStringKey(), "UNLOCK" )
        end
        self:SetLocked( false )
    end
end
--- If the GUI element is locked, it'll be unlocked and vice versa.
function cGUIElement:ToggleLockState()
    if self:GetLocked() then
        self:Unlock()
    else
        self:Lock()
    end
end
function cGUIElement:ShouldProcess()
    return true
end

--- {abstract} Executes the functionality associated with the GUI element.
-- Has to be overwritten on a per class basis.
function cGUIElement:Execute()
    return false
end

return cGUIElement
