-- ===== ===== ===== ===== =====
-- Copyright (c) 2017 Lukas Grünwald
-- License       MIT License
-- ===== ===== ===== ===== =====

--- Basic cGUIHandler class.
-- Responsible for all GUI related interactions like button presses pushing dialogue boxes and so on.

-- Import new functions:
require( "libErrorFunctions" )
require( "libDebugFunctions" )
-- Import new classes:
require( "cGUIElement" )
require( "cGUIElement_Type_Filter" )

cGUIHandler = {}
cGUIHandler.__index = cGUIHandler

--- Constructor.
-- Creates a new LUA object of type cGUIHandler.
-- @tparam cGalacticConquest parentGC Reference to the parent GC.
-- @within Initialisation
function cGUIHandler.New( parentGC )
    local self = setmetatable( {}, cGUIHandler )

    self.Parent          = parentGC
    self.ObjectType      = "TEXT_LUA_OBJECT_TYPE_GUIHANDLER"
    self.GUIElements     = { }
    self.SelectedPlanet  = false
    self.DebugModeActive = require( "configGlobalSettings" ).gSetting_DebugMode

    local NewButtons = require( "libStaticGUIElements" )
    if table.getn( NewButtons ) > 0 then
        for _, newButton in pairs( NewButtons ) do
            self:RegisterNewGUIElement( newButton.GUIElementName, newButton.GUIElementType, newButton.GUIDebugStringKey, newButton.GUIElementLayer, newButton.GUIElementData )
        end
    end

    return self
end

--- Sets up all flags and prerequisites for the object.
-- @within Initialization
function cGUIHandler:Initialise()
    local storyPlot = Get_Story_Plot( "__luaFramework/cGUIHandler/cGUIHandler.xml" )
    for planetName, cPlanetObj in pairs( self.Parent.Planets ) do
        local storyEvent = storyPlot.Get_Event( "cGUIHandler_SetSelectedPlanetFlag_"..planetName )
        storyEvent.Set_Reward_Parameter( 1, self.Parent:GetHumanPlayerFaction():GetGameFactionName() )
    end
    for _,guiObj in pairs( self.GUIElements ) do
        guiObj:Initialise()
    end
end
--- Returns a the currently selected planet if no planet is selected, this returns false.
-- @treturn cPlanet/bool
-- @within Getter Functions
function cGUIHandler:GetSelectedPlanet()
    return self.SelectedPlanet
end
--- Updates the selection state of the planets.
function cGUIHandler:UpdateSelectedPlanet()
    local hasSelectedAPlanet = false
    for planetName, cPlanetObj in pairs ( self.Parent.Planets ) do
        if Check_Story_Flag( self.Parent:GetHumanPlayerFaction():GetPlayerObject(), "cGUIHandler_SelectedPlanetFlag_"..planetName, nil, true ) then
            cPlanetObj:SetSelected( true )
            self.SelectedPlanet = cPlanetObj
            hasSelectedAPlanet = true
            if self.DebugModeActive then
                local gBuildStringList = cPlanetObj:GetGroundBuildingsAsString()
                local sBuildStringList = cPlanetObj:GetSpaceBuildingsAsString()
                debugPlanetSelected( cPlanetObj:GetStringKey(), gBuildStringList, sBuildStringList )
            end
        else
            cPlanetObj:SetSelected( false )
        end
    end
    if not hasSelectedAPlanet then
        self.SelectedPlanet = false
    end
end
--- Returns the lua object type as string key.
-- Used for error handling.
-- @treturn String
-- @within Getter Functions
function cGUIHandler:GetType()
    return self.ObjectType
end

--- Registers a GUI element with the GUIHandler instance.
-- @tparam string newGUIElementName The name of the GUIelement as defined in the xml.
-- @tparam string newGUIElementType The type of the GUI element. This defines the class the GUI element belongs to. A specific action requires a specific class.
-- @tparam string newGUIDebugStringKey The string key of the GUI object.
-- @tparam table newGUIElementFlags a single string or a table of strings which help to make the element addressable either via a group (e.g. "GALACTIC", "ZOOMED", "DIPLOMACY") or via several flags. think of them as identifying keywords.
-- @tparam table newGUIElementData Initialisation data for the GUI element
-- @within Initialisation
function cGUIHandler:RegisterNewGUIElement( newGUIElementName, newGUIElementType, newGUIDebugStringKey, newGUIElementFlags, newGUIElementData )
    local newGUIElement = false
    local guiFlags = false
    -- catch single strings:
    if not type( newGUIElementFlags ) == "table" then
        guiFlags = { newGUIElementFlags }
    else
        guiFlags = newGUIElementFlags
    end
    if newGUIElementType == "VANILLA_BUTTON" then
        newGUIElement = cGUIElement.New( self, newGUIElementName, newGUIDebugStringKey, guiFlags )
    elseif newGUIElementType == "GUI_ELEM_BTN_FILTER" then
        newGUIElement = cGUIElement_Type_Filter.New( self, newGUIElementName, newGUIDebugStringKey, guiFlags, newGUIElementData )
    end
    if newGUIElement then
        self.GUIElements[newGUIElementName] = newGUIElement
    end
end
--- Wrapper function.
-- Locks all GUI elements with the "GALACTIC" flag.
function cGUIHandler:LockAllGalacticElements()
    self:LockGUIElements( "GALACTIC" )
end
--- Wrapper function.
-- Unlocks ll GUI elements with the "GALACTIC" flag.
function cGUIHandler:UnlockAllGalacticElements()
    self:UnlockGUIElements( "GALACTIC" )
end
--- Locks all GUI elements with a specific flag.
-- @tparam string/table guiElemFlag
function cGUIHandler:LockGUIElements( guiElemFlag )
    for _,guiElem in pairs( self.GUIElements ) do
        if guiElem:IsFlaggedAs( guiElemFlag ) then
            guiElem:Lock()
        end
    end
end
--- Unlocks all GUI elements with a specific flag.
-- @tparam string/table guiElemFlag
function cGUIHandler:UnlockGUIElements( guiElemFlag )
    for _,guiElem in pairs( self.GUIElements ) do
        if guiElem:IsFlaggedAs( guiElemFlag ) then
            guiElem:Unlock()
        end
    end
end
--- Processes all registered GUI elements.
-- @within Game Cycle
function cGUIHandler:ProcessGUI()
    for _, guiElement in pairs( self.GUIElements ) do
        if guiElement:ShouldProcess() then
            guiElement:Execute()
        end
    end
end

return cGUIHandler
