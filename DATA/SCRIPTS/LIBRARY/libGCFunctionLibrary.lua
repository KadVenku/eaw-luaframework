-- ===== ===== ===== ===== =====
-- Copyright (c) 2017 Lukas Grünwald
-- License       MIT License
-- ===== ===== ===== ===== =====

--- Generic function library.
-- Provides access to functions which are being reused all over the framework and are of general use on a galactic layer.
require( "PGBase" )
require( "PGDebug" )

--- Destroys a building.
-- Destroys a building and if desired creates an explosion particle and a ruin of given type.
-- @tparam GameObjectReference bldngGameReference
-- @tparam string spawnRuintype
-- @tparam string createExplosionType
function DestroyBuilding( bldngGameReference, createExplosionType )
    local lCreateExplosionType = createExplosionType
    local lBuildingRef         = bldngGameReference
    if TestValid( lBuildingRef ) then
        if lCreateExplosionType == nil then
            lCreateExplosionType = false
        end
        local bldngPos = lBuildingRef.Get_Planet_Location()
        local plOwner  = bldngPos.Get_Owner()

        if TestValid( lBuildingRef ) then
            lBuildingRef.Despawn()
        end
        if lCreateExplosionType then
            Create_Generic_Object( lCreateExplosionType, bldngPos , Find_Player( "Neutral" ) )
        end
    end
end

--- Destroys a unit.
-- Destroys a unit and if desired creates an explosion particle and a ruin of given type.
-- @tparam GameObjectReference bldngGameReference
-- @tparam string spawnRuintype
-- @tparam string createExplosionType
function DestroyUnit( unitGameReference, createExplosionType )
    local lCreateExplosionType = createExplosionType
    local lUnitRef         = unitGameReference
    if TestValid( lUnitRef ) then
        if lCreateExplosionType == nil then
            lCreateExplosionType = false
        end
        local unitPos = lUnitRef.Get_Planet_Location()
        if TestValid( lUnitRef ) then
            lUnitRef.Despawn()
        end
        if lCreateExplosionType then
            Create_Generic_Object( lCreateExplosionType, unitPos , Find_Player( "Neutral" ) )
        end
    end
end
