-- ===== ===== ===== ===== =====
-- Copyright (c) 2017 Lukas Grünwald
-- License       MIT License
-- ===== ===== ===== ===== =====

local StaticEventTypeDefinitions = {
	-- Kad 28/06/2017 14:44:08 - Test events.
    "EVENT_TYPE_TESTEVENT",-- Kad 28/06/2017 14:41:54 - TODO: Remove!
    -- Kad 28/06/2017 14:44:01 - Generic events.
    "EVENT_TYPE_FLEETHYPERSPACEACCIDENT",-- Kad 28/06/2017 14:41:24 - Destroys random parts of a fleet in hyperspace.
    "EVENT_TYPE_SPAWNUNITS",-- Kad 28/06/2017 14:43:40 - Spawns units from a fleet struct.

    -- Kad 28/06/2017 14:40:39 - Diplomatic events:
    "EVENT_TYPE_DIPLSTARTDIPLOMATICMISSION",-- Kad 28/06/2017 14:40:50 - Despawns the diplomat and updates the mission holochron
    "EVENT_TYPE_DIPLENDDIPLOMATICMISSION",-- Kad 28/06/2017 14:41:15 - Does the actual work.
    "EVENT_TYPE_DIPLCHECKFACTIONALLIANCE",-- Kad 28/06/2017 14:42:09 - Checks, whether an EVENT_TYPE_DIPLMAKEALLIES should be spawned.
    "EVENT_TYPE_DIPLTURNPLANET",-- Kad 28/06/2017 14:42:40 - Gracefully turns over a planet from faction A to B. A keeps units and ships.
    "EVENT_TYPE_DIPLMAKEALLIES",-- Kad 28/06/2017 14:43:17 - Creates an alliance between faction A and B.
    "EVENT_TYPE_DIPLUPDATEALLIANCERATING", -- Kad 28/06/2017 14:44:30 - Updates an existing alliance rating.
    "EVENT_TYPE_PDORBITALBOMBARDMENTBEGIN", -- Kad 07/07/2017 13:39:02 - Starts an orbital bombardment.
    "EVENT_TYPE_PDORBITALBOMBARDMENTBURST", -- Kad 07/07/2017 10:12:14 - The "stage" of a bombardment. Each burst deals damage to the planet.
    "EVENT_TYPE_PDORBITALBOMBARDMENTEND", -- Kad 07/07/2017 13:41:55 - Cleans up and updates the planet state.
}

return StaticEventTypeDefinitions
