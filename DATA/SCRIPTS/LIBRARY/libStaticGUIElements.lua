-- ===== ===== ===== ===== =====
-- Copyright (c) 2017 Kad Venku
-- License       MIT License
-- ===== ===== ===== ===== =====

local StaticButtonDefinitions = {
    --[[
    {
        GUIElementName = "name_of_the_gui_element_in_xml",
        GUIElementType = "button_type_represented_as_button_class"
    }
    ]]
    {
        GUIElementName    = "b_buildings_tab",
        GUIElementType    = "GUI_ELEM_BTN_FILTER",
        GUIDebugStringKey = "TEXT_LUA_OBJECT_TYPE_BUTTON_B_FILTERS0",
        GUIElementLayer   = {"GALACTIC",},
        GUIElementData    = {
            GUIElementFilterTags = { "BUILDING" },
            GUIElementStoryEventFlag = "cGUIElement_Type_Filter_GUIElement_b_buildings_tab_PressedFlag",
        },
    },
    {
        GUIElementName    = "b_unit_tab",
        GUIElementType    = "GUI_ELEM_BTN_FILTER",
        GUIDebugStringKey = "TEXT_LUA_OBJECT_TYPE_BUTTON_B_FILTERS1",
        GUIElementLayer   = {"GALACTIC",},
        GUIElementData    = {
            GUIElementFilterTags = { "UNIT" },
            GUIElementStoryEventFlag = "cGUIElement_Type_Filter_GUIElement_b_unit_tab_PressedFlag",
        },
    },
    {
        GUIElementName    = "b_upgrades_tab",
        GUIElementType    = "GUI_ELEM_BTN_FILTER",
        GUIDebugStringKey = "TEXT_LUA_OBJECT_TYPE_BUTTON_B_FILTERS2",
        GUIElementLayer   = {"GALACTIC",},
        GUIElementData    = {
            GUIElementFilterTags = { "UPGRADE" },
            GUIElementStoryEventFlag = "cGUIElement_Type_Filter_GUIElement_b_upgrades_tab_PressedFlag",
        },
    },
}

return StaticButtonDefinitions
