-- ===== ===== ===== ===== =====
-- Copyright (c) 2017 Kad Venku
-- License       MIT License
-- ===== ===== ===== ===== =====

--- cGlobalMessageHandler.
-- Handles global messaging between game modes.

require( "PGBase" )
require( "PGDebug" )
-- libraries:
require( "libErrorFunctions" )
require( "libDebugFunctions" )
require( "libPGGenericFunctionLibrary" )

cGlobalMessageHandler = {}
cGlobalMessageHandler.__index = cGlobalMessageHandler

--- Constructor.
-- @tparam cGalacticConquest parentGC Only used in Galactic mode, tactical modes do not have a parent GC object.
-- @within Constructor
function cGlobalMessageHandler.New( parentGC )
local self = setmetatable( {}, cGlobalMessageHandler )
    self.Parent              = parentGC
    self.Type                = "TEXT_LUA_OBJECT_TYPE_CGLOBALMESSAGEHANDLER"
    self.MessageCountPadding = require( "configGlobalSettings" ).gSetting_Global_MaxMessagePadding
    -- local validMsgTypes = require( "libStaticMessageTypeDefinitions" )
    -- Create a stack for every message type. Don't create that!!
    -- for _,msgType in pairs( validMsgTypes ) do
    --     local msgCountID = msgType.."_COUNT"
    --     GlobalValue.Set( msgCountID, 0 )
    -- end
    return self
end

--- Pushes a message to the message stack.
-- @tparam string msgID
-- @tparam number msgContent
function cGlobalMessageHandler:PushGMsg( msgID, msgContent )
    local msgCountID = msgID.."_COUNT"
    local msgNbr = GlobalValue.Get( msgCountID ) + 1
    if GetStringLength( msgNbr ) <= self.MessageCountPadding then
        GlobalValue.Set( msgCountID, msgNbr )
        local finalMsgID = self:MsgIDEncode( msgID, msgNbr )
        -- Creates a string like "MP_XXX_nnn" where X is a character and n a natural number, e.g. "MP_POD_012"
        GlobalValue.Set( finalMsgID, msgContent )
    else
        ThrowMessageStackFullError()
    end
end

--- Pop message from message stack.
-- This function pops a message from it's designated stack.
-- @tparam string msgType
function cGlobalMessageHandler:PopGMsg( msgType )
    local msgCountID = msgType.."_COUNT"
    local msgCount = GlobalValue.Get( msgCountID )
    if msgCount > 0 then
        local nMsgCount = msgCount - 1
        GlobalValue.Set( msgCountID, nMsgCount )
        -- local popMsgID = msgType.."_"..AddPadding( msgCount, self.MessageCountPadding, "0" )
        local popMsgID = self:MsgIDEncode( msgType, msgCount )
        local msgContent = GlobalValue.Get( popMsgID )
        return popMsgID, msgContent
    end
    ThrowMessageStackFullError()
    return false, false
end

--- Encodes a given message type to its ID
-- @tparam string msgType Message type
-- @tparam number msgNbr Message index on stack.
function cGlobalMessageHandler:MsgIDEncode( msgType, msgNbr )
    local mType     = msgType
    local mNbr      = AddPadding( msgNbr, self.MessageCountPadding, "0" )
    local retString = mType.."_"..mNbr
    return retString
end
--- Decodes a given message ID to its type
-- @tparam string msgID Message ID from the global stack.
function cGlobalMessageHandler:MsgIDDecode( msgID )
    local msgIDInact = msgID
    local msgType    = StringSub( msgIDInact, 1, 6 )
    local msgNbr     = StringSub( msgIDInact, 8, 7 + self.MessageCountPadding )
    return msgType, msgNbr
end
--- Encodes a message and returns the message ID and content.
-- ATTENTION: Global message character limit is 7!
-- So we only support 6 character message types, which means we'll have to add more information to the message name.
-- @tparam string msgType Message type.
-- @tparam table args Argument table.
function cGlobalMessageHandler:MsgCntEncode( msgType, args )
    -- Switch behaviour based on game mode:
    if Get_Game_Mode() == "Galactic" then
        -- Switch behaviour based on message type:
        if msgType == "MP_TPD" then
            local msgID      = msgType
            local gSettings  = require( "configGlobalSettings" )
            local facID      = args.FactionID
            local facIDPad   = gSettings.gSetting_Global_PaddingFactionID
            facID            = AddPadding( facID, facIDPad )
            local plnID      = args.PlanetID
            local plnIDPad   = gSettings.gSetting_Global_PaddingPlanetID
            plnID            = AddPadding( plnID, plnIDPad )
            local typeID     = args.PDType
            local typeIDPad  = gSettings.gSetting_Global_PaddingPDEventType
            typeID           = AddPadding( typeID, typeIDPad )
            -- message       = PlanetID:PDTypeID:FactionID
            local msgContent = plnID..typeID..facID
            msgContent       = StringReverse( msgContent )
            msgContent       = ConvertToNumber( msgContent )
            return msgType, msgContent
        elseif msgType == "MP_POD" or msgType == "MP_POB" then
            local msgID        = msgType
            local gSettings    = require( "configGlobalSettings" )
            local objTypeID    = args.ObjectTypeID
            local objTypeIDPad = gSettings.gSetting_Global_PaddingObjectTypeID
            objTypeID          = AddPadding( objTypeID, objTypeIDPad )
            local plnID        = args.PlanetID
            local plnIDPad     = gSettings.gSetting_Global_PaddingPlanetID
            plnID              = AddPadding( plnID, plnIDPad )
            -- message         = ObjectTypeID:PlanetID:1
            local msgContent   = objTypeID..plnID.."1"
            msgContent         = StringReverse( msgContent )
            msgContent         = ConvertToNumber( msgContent )
            return msgType, msgContent
        else
            ThrowUnkownGlobalMessageError()
        end
    elseif Get_Game_Mode() == "Space" then

    elseif Get_Game_Mode() == "Land" then

    else
        ThrowUnkownGameModError()
    end
end

--- Decodes a message from a given ID
-- @tparam string msgType
-- @tparam number msgContent
-- @treturn[1] string Message type
-- @treturn[1] number Planet ID
-- @treturn[1] number Planet Death Type ID
-- @treturn[1] number Faction Type ID
-- @treturn[2] string Message type
-- @treturn[2] number Object Type ID
-- @treturn[2] number Planet ID
function cGlobalMessageHandler:MsgCntDecode( msgType, msgContent )
    -- Switch behaviour based on game mode:
    if Get_Game_Mode() == "Galactic" then
        if msgType == "MP_TPD" then
            local msgStr    = ConvertToString( msgContent )
            msgStr          = StringReverse( msgStr )
            local gSettings = require( "configGlobalSettings" )
            local facIDPad  = gSettings.gSetting_Global_PaddingFactionID
            local plnIDPad  = gSettings.gSetting_Global_PaddingPlanetID
            local typeIDPad = gSettings.gSetting_Global_PaddingPDEventType
            local sSub  = 1
            local eSub  = plnIDPad
            local plnID = StringSub( msgStr, sSub, eSub )
            plnID = ConvertToNumber( plnID )
            sSub = sSub + plnIDPad
            eSub = eSub + typeIDPad
            local typeID = StringSub( msgStr, sSub, eSub )
            typeID = ConvertToNumber( typeID )
            sSub = sSub + typeIDPad
            eSub = eSub + facIDPad
            local facID = StringSub( msgStr, sSub, eSub )
            facID = ConvertToNumber( facID )
            return msgType, plnID, typeID, facID
        elseif msgType == "MP_POD" or msgType == "MP_POB" then
            local msgStr    = ConvertToString( msgContent )
            msgStr          = StringReverse( msgStr )
            local gSettings = require( "configGlobalSettings" )
            local objTypeIDPad = gSettings.gSetting_Global_PaddingObjectTypeID
            local plnIDPad  = gSettings.gSetting_Global_PaddingPlanetID
            local sSub  = 1
            local eSub  = objTypeIDPad
            local objTypeID = StringSub( msgStr, sSub, eSub )
            objTypeID = ConvertToNumber( objTypeID )
            sSub = sSub + objTypeIDPad
            eSub = eSub + plnIDPad
            local plnID = StringSub( msgStr, sSub, eSub )
            plnID = ConvertToNumber( plnID )
            return msgType, objTypeID, plnID
        end
    elseif Get_Game_Mode() == "Space" then

    elseif Get_Game_Mode() == "Land" then

    else
        ThrowUnkownGameModError()
    end
end

return cGlobalMessageHandler
