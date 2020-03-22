-- ===== ===== ===== ===== =====
-- Copyright (c) 2017 Kad Venku
-- License       MIT License
-- ===== ===== ===== ===== =====

--- Generic function library.
-- Provides access to functions which are being reused all over the framework and are of general use throughout the mod.
require( "PGBase" )
require( "PGDebug" )

--- Tests whether an object is referenced within a table.
-- @tparam table tableObj
-- @tparam {object} contentObj
-- @treturn bool
-- @within Table Functionality
function IsContentOfTable( tableObj, contentObj )
    if table.getn( tableObj ) > 0 and contentObj ~= nil then
        for _, obj in pairs( tableObj ) do
            if obj == contentObj then
                return true
            end
        end
    end
    return false
end

--- Tests whether a key is referenced within a table.
-- @tparam table tableObj
-- @tparam {object} keyObj
-- @treturn bool
-- @within Table Functionality
function IsKeyOfTable( tableObj, keyObj )
    if table.getn( tableObj ) > 0 and keyObj ~= nil then
        for key, _ in pairs( tableObj ) do
            if key == keyObj then
                return true
            end
        end
    end
    return false
end

--- Claps a given newValue to a given maxValue and minValue.
-- @tparam float newValue
-- @tparam float minValue
-- @tparam float maxValue
-- @treturn float
-- @within Math Library
function ClampValue( newValue, minValue, maxValue )
    if maxValue ~= nil then
        if newValue < minValue then
            return minValue
        elseif newValue > maxValue then
            return maxValue
        else
            return newValue
        end
    else
        if newValue < minValue then
            return minValue
        else
            return newValue
        end
    end
end

--- Tests whether a given object is tagged with a certain flag.
-- LUA objects are often tagged with flags in the mod, this generic function allows for testing for a specific flag or a specific set of flags.
-- @tparam table tagTable The list of tags an object is tagged with. Usually a self-contained attribute.
-- @tparam table/string tagObject Flag the object should be tagged with.
-- @treturn bool
-- @within Framework Library
function IsObjectTaggedAs( tagTable, tagObject )
    -- Testing for multiple flags at once. Similar to an '&&' junction.
    if type( tagObject ) == "table" then
        for _,flag in pairs( tagObject ) do
            if not IsContentOfTable( tagTable, flag ) then
                return false
            end
        end
        return true
    else
    -- Testing for a single flag:
        return IsContentOfTable( tagTable, tagObject )
    end
end

--- Unwraps units from reinforcement struct depending on game mode.
-- @tparam string objectStructID The struct ID as defined in the table.
-- @within Framework Library
function UnwrapUnitsFromFleetStruct( objectStructID )
    if Get_Game_Mode() == "Galactic" then
        local objTypeTable = require( "libStaticStructReinforces" )[objectStructID].Objects
        if table.getn( objTypeTable) > 0 then
            local spawnTable = { }
            for _,objDef in pairs( objTypeTable ) do
                for i = 1, objDef.ObjectCount, 1 do
                    table.insert( spawnTable, objDef.ObjectType )
                end
            end
            if table.getn( spawnTable ) > 0 then
                return spawnTable
            end
        end
        return false
    end

    return false
end

--- Applies padding to the given value to a given size.
-- The function will pad or cut a given string, depending on its length in relation to the given padding size.
-- @tparam string origVal Original string.
-- @tparam number strLen The length the string will be padded to.
-- @tparam string paddingChar The padding char. If not provided it'll default to "0"
-- @within String Standard Library Wrapper
function AddPadding( origVal, strLen, paddingChar )
    local oValTab = {}
    local retValTab = {}
    local origiVal = origVal
    local lPadChar = "0"
    if paddingChar ~= nil then
        lPadChar = paddingChar
    end
    -- Convert initial value to string:
    if type( origiVal ) ~= "string" then
        origiVal = tostring( origVal )
    end
    if string.len( origiVal ) > strLen then
        -- Our string is longer than the allowed string length... Cut it down!!
        oValTab = StringToCharArray( origiVal )
        local lDiff = string.len( origiVal ) - strLen
        for i = lDiff + 1, string.len( origiVal ), 1 do
            retValTab[i-lDiff] = oValTab[i]
        end
        local retString = table.concat( retValTab )
        return retString
    else
        -- Fill necessary padding:
        local necPad = strLen - string.len( origiVal )
        for i = 1, necPad, 1 do
            retValTab[i] = lPadChar
        end
        -- Fill in rest of string:
        necPad = necPad + 1
        for i = necPad, strLen, 1 do
            local sPos = i - necPad + 1
            retValTab[i] = string.sub( origiVal, sPos, sPos )
        end
        local retString = table.concat( retValTab )
        return retString
    end
end

--- Splits a given string into an array of characters.
-- @tparam string inputString
-- @treturn table Table of single chars
-- @within String Standard Library Wrapper
function StringToCharArray( inputString )
    local retTable = {}
    local inString = inputString
    if type( inString ) ~= "string" then
        inString = tostring( inputString )
    end
    for i = 1, string.len( inString ), 1 do
        retTable[i] = string.sub( inString, i, i )
    end
    return retTable
end

--- Converts a given string to uppercase letters.
-- @tparam string inputString
-- @treturn string inputString converted to uppercase
-- @within String Standard Library Wrapper
function ConvertToUpperCase( inputString )
    local inString = inputString
    if type( inString ) ~= "string" then
        inString = tostring( inputString )
    end
    local retString = string.upper( inString )
    return retString
end
--- Retrieves the length of a given string.
-- Can also return the length of anything that can implicitly be converted to a string.
-- @tparam string inputString
-- @treturn number
-- @within String Standard Library Wrapper
function GetStringLength( inputString )
    local inString = inputString
    if type( inString ) ~= "string" then
        inString = tostring( inputString )
    end
    local sLen = string.len( inString )
    return sLen
end
--- Converts a given string to a number.
-- This implicitly converts a number encoded as string to a number, the function will fail, if there structures within the string that are not numbers.
-- @tparam string inputString
-- @treturn number
-- @within String Standard Library Wrapper
function ConvertToNumber( inputString )
    local outNumber = tonumber( inputString )
    return outNumber
end
--- Converts a float number to a string.
-- Takes a desired float and a padding length.
-- @tparam number inputFloat
-- @tparam number length
-- @treturn string Formatted string
function ConvertFloatToString( inputFloat, length )
    local formattingRule = "%."
    local lLength = ConvertToString( length )
    formattingRule = formattingRule..lLength.."f"
    local formattedString = string.format(formattingRule, inputFloat)
    return formattedString
end
--- Converts a given number to a string.
-- This function will fail and return false, if it's not given a number as argument.
-- @tparam string inputNumber
-- @treturn number.
-- @within String Standard Library Wrapper
function ConvertToString( inputNumber )
    if type( inputNumber ) == "number" then
        local outNumber = tostring( inputNumber )
        return outNumber
    else
        return false
    end
end
--- Retrieves a given subsection of a string.
-- This does NOT modify the original string!.
-- @tparam string inputString
-- @tparam number sCharIndex Starting index of the first desired character in the string.
-- @tparam number eCharIndex Index of the last desired character of the substring.
-- @treturn string
-- @within String Standard Library Wrapper
function StringSub( inputString, sCharIndex, eCharIndex )
    local subString = string.sub( inputString, sCharIndex, eCharIndex )
    return subString
end
--- Reverses a given string.
-- this is NOt a wrapper for the standard library function, as the standard library crashes EaW, it is a less effective implementation that works with the game.
-- @tparam string inputString
-- @treturn string Reversed string.
-- @within String Standard Library Wrapper
function StringReverse( inputString )
    local inStr = inputString
    local charArray = StringToCharArray( inStr )
    local retArray = {}
    for i = table.getn( charArray ), 1, -1 do
        table.insert( retArray, charArray[i] )
    end
    local retString = table.concat( retArray )
    return retString
end
