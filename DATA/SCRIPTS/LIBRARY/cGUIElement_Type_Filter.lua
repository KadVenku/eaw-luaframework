-- ===== ===== ===== ===== =====
-- Copyright (c) 2017 Lukas Grünwald
-- License       MIT License
-- ===== ===== ===== ===== =====

-- Import new functions:
require( "libErrorFunctions" )
require( "libDebugFunctions" )
-- Import new classes:
require( "cGUIElement" )

cGUIElement_Type_Filter = {}
cGUIElement_Type_Filter.__index = cGUIElement_Type_Filter
setmetatable( cGUIElement_Type_Filter, { __index = cGUIElement } )
--- Constructor.
-- Creates a new LUA object of type cGUIElement_Type_Filter.
-- @tparam cEventHandler parentEventHandler
-- @within Constructor
function cGUIElement_Type_Filter.New( parentGUIHandler, guiObjectName, guiDebugStringKey, guiObjectFlags, guiElementData )
    local self = setmetatable( {}, cGUIElement_Type_Filter )
    self.GUIObjectName   = guiObjectName
    self.StringKey       = guiDebugStringKey
    self.GUIFlags        = guiObjectFlags
    self.Parent          = parentGUIHandler
    self.IsLocked        = false
    self.FiltersBy       = guiElementData.GUIElementFilterTags
    self.StoryEventFlag  = guiElementData.GUIElementStoryEventFlag
    self.DebugModeActive = require( "configGlobalSettings" ).gSetting_DebugMode

    return self
end
--- Initialises the filters and registers the proper flags and faction flags.
-- See */__luaFramework/cGUIHandler/cGUIElement_Type_Filter.xml for details.
function cGUIElement_Type_Filter:Initialise()
    local guiObjName = self:GetGUIObjectName()
    local eventName = "cGUIElement_Type_Filter_"..guiObjName.."Pressed"
    local storyPlot = Get_Story_Plot( "__luaFramework/cGUIHandler/cGUIElement_Type_Filter.xml" )
    local storyEvent = storyPlot.Get_Event( eventName )
    storyEvent.Set_Reward_Parameter( 1, self.Parent.Parent:GetHumanPlayerFaction():GetGameFactionName() )
end
--- If the button has been pressed, should the GUI element trigger a reaction.
function cGUIElement_Type_Filter:ShouldProcess()
    local guiObjName = self:GetGUIObjectName()
    if Check_Story_Flag( self.Parent.Parent:GetHumanPlayerFaction():GetPlayerObject(), self.StoryEventFlag, nil, true ) then
        return true
    else
        return false
    end
end
--- Executes the functionality linked to the button.
function cGUIElement_Type_Filter:Execute()
    self.Parent.Parent.ObjectManager:GUIFilterShowTag( self.Parent.Parent:GetHumanPlayerFaction():GetName(), self.FiltersBy )
end

return cGUIElement_Type_Filter
