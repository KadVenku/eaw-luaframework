-- ===== ===== ===== ===== =====
-- Copyright (c) 2017 Lukas Grünwald
-- License       MIT License
-- ===== ===== ===== ===== =====

--- Error handling library.
-- Provides standardised and threaded functions which push error messages to the mission dialogue.

--- Throws an error message.
-- Thrown if for some reason a object could not be initialised.
-- Wrapper for threaded call.
-- A restart of the Campaign is advised.
-- @tparam String initObj MasterTextFile key for the object which failed to initialise.
-- @see OutObjectInitialisationError
-- @within Error Handler
function ThrowObjectInitialisationError( initObj )
    Create_Thread( "OutObjectInitialisationError", initObj )
end
--- Threaded GUIPush.
-- @tparam String initObj MasterTextFile key for the object which failed to initialise.
-- @within Threaded GUI Push Functions
function OutObjectInitialisationError( initObj )
    local erEvent = Get_Story_Plot( "__luaFramework/libErrorHandler/libErrorHandler.xml" ).Get_Event( "libErrorHandler_DisplayErrorMessage" )
    local dialogFile = "libErrorHandlerDialog"
    erEvent.Set_Dialog( dialogFile )
    erEvent.Clear_Dialog_Text()
    erEvent.Add_Dialog_Text( "TEXT_ERROR_CLASS_FATAL" )
    erEvent.Add_Dialog_Text( "TEXT_ERROR_TYPE_INIT_OBJ" )
    if initObj ~= nil then
        erEvent.Add_Dialog_Text( initObj )
    end
    erEvent.Add_Dialog_Text( "TEXT_ERROR_REQUIRED_ACTION_REPORT" )
    erEvent.Add_Dialog_Text( "TEXT_ERROR_REQUIRED_ACTION_RESTART" )
    Story_Event( "libErrorHandler_DisplayErrorMessage_Trigger" )
end
--- Throws an error message.
-- Thrown if the game tries to register an already existing object.
-- As long as it's not an initialisation error, things should be fine.
-- Wrapper for threaded call.
-- @tparam String objectType MasterTextFile key for the object type which failed to initialise.
-- @tparam String objectName MasterTextFile key for the object name which failed to initialise.
-- @see OutObjectAlreadyRegisteredError
-- @within Error Handler
function ThrowObjectAlreadyRegisteredError( objectType, objectName )
    Create_Thread( "OutObjectAlreadyRegisteredError", objectType, objectName )
end
--- Threaded GUIPush.
-- @tparam String objectType MasterTextFile key for the object type which failed to initialise.
-- @tparam String objectName MasterTextFile key for the object name which failed to initialise.
-- @within Threaded GUI Push Functions
function OutObjectAlreadyRegisteredError( objectType, objectName )
    local erEvent = Get_Story_Plot( "__luaFramework/libErrorHandler/libErrorHandler.xml" ).Get_Event( "libErrorHandler_DisplayErrorMessage" )
    local dialogFile = "libErrorHandlerDialog"
    erEvent.Set_Dialog( dialogFile )
    erEvent.Clear_Dialog_Text()
    erEvent.Add_Dialog_Text( "TEXT_ERROR_CLASS_NORMAL" )
    erEvent.Add_Dialog_Text( "TEXT_ERROR_TYPE_ALREADY_REGISTERED_OBJ" )
    if objectType ~= nil then
        erEvent.Add_Dialog_Text( objectType )
    end
    if objectName ~= nil then
        erEvent.Add_Dialog_Text( objectName )
    end
    erEvent.Add_Dialog_Text( "TEXT_ERROR_REQUIRED_ACTION_REPORT" )
    Story_Event( "libErrorHandler_DisplayErrorMessage_Trigger" )
end

--- Throws an error if a referenced object could not be found.
-- This is a critical error which will usually mess up data handling, and might crash the script.
-- Wrapper for threaded call.
-- @tparam String missingObject The missing object's MasterTextFile key.
-- @see OutObjectNotFoundError
-- @within Error Handler
function ThrowObjectNotFoundError( missingObject )
    Create_Thread("OutObjectNotFoundError", missingObject)
end
--- Threaded GUIPush.
-- @tparam String missingObject The missing object's MasterTextFile key.
-- @within Threaded GUI Push Functions
function OutObjectNotFoundError( missingObject )
    local erEvent = Get_Story_Plot( "__luaFramework/libErrorHandler/libErrorHandler.xml" ).Get_Event( "libErrorHandler_DisplayErrorMessage" )
    local dialogFile = "libErrorHandlerDialog"
    erEvent.Set_Dialog( dialogFile )
    erEvent.Clear_Dialog_Text()
    erEvent.Add_Dialog_Text( "TEXT_ERROR_CLASS_NORMAL" )
    erEvent.Add_Dialog_Text( "TEXT_ERROR_TYPE_OBJECT_NOT_FOUND" )
    if missingObject ~= nil then
        erEvent.Add_Dialog_Text( missingObject )
    end
    erEvent.Add_Dialog_Text( "TEXT_ERROR_REQUIRED_ACTION_REPORT" )
    erEvent.Add_Dialog_Text( "TEXT_ERROR_REQUIRED_ACTION_RESTART" )
    Story_Event( "libErrorHandler_DisplayErrorMessage_Trigger" )
end

--- Throws an error if an event type doesn't exist or could not register.
-- Wrapper for threaded call.
-- @see OutEventNotRegisteredError
-- @within Error Handler
function ThrowEventNotRegisteredError()
    Create_Thread("OutEventNotRegisteredError" )
end
--- Threaded GUIPush.
-- @within Threaded GUI Push Functions
function OutEventNotRegisteredError()
    local erEvent = Get_Story_Plot( "__luaFramework/libErrorHandler/libErrorHandler.xml" ).Get_Event( "libErrorHandler_DisplayErrorMessage" )
    local dialogFile = "libErrorHandlerDialog"
    erEvent.Set_Dialog( dialogFile )
    erEvent.Clear_Dialog_Text()
    erEvent.Add_Dialog_Text( "TEXT_ERROR_CLASS_NORMAL" )
    erEvent.Add_Dialog_Text( "TEXT_ERROR_TYPE_EVENT_NOT_REGISTERED" )
    erEvent.Add_Dialog_Text( "TEXT_ERROR_REQUIRED_ACTION_REPORT" )
    Story_Event( "libErrorHandler_DisplayErrorMessage_Trigger" )
end
--- Throws an error, if a thread crashed.
-- @tparam string thread
-- @within Error Handler
function ThrowThreadCrashedError( thread )
    Create_Thread( "OutThreadCrashedError", thread )
end
--- Threaded GUIPush.
-- @tparam string thread
-- @within Threaded GUI Push Functions
function OutThreadCrashedError( thread )
    local erEvent = Get_Story_Plot( "__luaFramework/libErrorHandler/libErrorHandler.xml" ).Get_Event( "libErrorHandler_DisplayErrorMessage" )
    local dialogFile = "libErrorHandlerDialog"
    erEvent.Set_Dialog( dialogFile )
    erEvent.Clear_Dialog_Text()
    erEvent.Add_Dialog_Text( "TEXT_ERROR_CLASS_FATAL" )
    erEvent.Add_Dialog_Text( "TEXT_ERROR_TYPE_THREAD_CRASHED" )
    if thread ~= nil then
        erEvent.Add_Dialog_Text( thread )
    end
    erEvent.Add_Dialog_Text( "TEXT_ERROR_REQUIRED_ACTION_REPORT" )
    erEvent.Add_Dialog_Text( "TEXT_ERROR_REQUIRED_ACTION_RESTART" )
    Story_Event( "libErrorHandler_DisplayErrorMessage_Trigger" )
end

function ThrowUnkownGameModError()
    Create_Thread( "OutUnkownGameModError" )
end

function OutUnkownGameModError()
    local erEvent = Get_Story_Plot( "__luaFramework/libErrorHandler/libErrorHandler.xml" ).Get_Event( "libErrorHandler_DisplayErrorMessage" )
    local dialogFile = "libErrorHandlerDialog"
    erEvent.Set_Dialog( dialogFile )
    erEvent.Clear_Dialog_Text()
    erEvent.Add_Dialog_Text( "TEXT_ERROR_CLASS_FATAL" )
    erEvent.Add_Dialog_Text( "TEXT_ERROR_GAME_MODE_NOT_RESOLVED" )
    erEvent.Add_Dialog_Text( "TEXT_ERROR_REQUIRED_ACTION_RESTART" )
    Story_Event( "libErrorHandler_DisplayErrorMessage_Trigger" )
end

function ThrowUnkownGlobalMessageError()
    Create_Thread( "OutUnkownGlobalMessageError" )
end

function OutUnkownGlobalMessageError()
    local erEvent = Get_Story_Plot( "__luaFramework/libErrorHandler/libErrorHandler.xml" ).Get_Event( "libErrorHandler_DisplayErrorMessage" )
    local dialogFile = "libErrorHandlerDialog"
    erEvent.Set_Dialog( dialogFile )
    erEvent.Clear_Dialog_Text()
    erEvent.Add_Dialog_Text( "TEXT_ERROR_CLASS_FATAL" )
    erEvent.Add_Dialog_Text( "TEXT_ERROR_UNKNOWN_GLOBAL" )
    erEvent.Add_Dialog_Text( "TEXT_ERROR_REQUIRED_ACTION_RESTART" )
    Story_Event( "libErrorHandler_DisplayErrorMessage_Trigger" )
end

function ThrowMessageStackFullError()
    Create_Thread( "OutMessageStackFullError" )
end

function OutMessageStackFullError()
    local erEvent = Get_Story_Plot( "__luaFramework/libErrorHandler/libErrorHandler.xml" ).Get_Event( "libErrorHandler_DisplayErrorMessage" )
    local dialogFile = "libErrorHandlerDialog"
    erEvent.Set_Dialog( dialogFile )
    erEvent.Clear_Dialog_Text()
    erEvent.Add_Dialog_Text( "TEXT_ERROR_CLASS_FATAL" )
    erEvent.Add_Dialog_Text( "TEXT_ERROR_MESSAGE_STACK_FULL" )
    erEvent.Add_Dialog_Text( "TEXT_ERROR_REQUIRED_ACTION_RESTART" )
    Story_Event( "libErrorHandler_DisplayErrorMessage_Trigger" )
end
