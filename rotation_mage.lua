--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 10/02/2017
-- Time: 16:56
-- To change this template use File | Settings | File Templates.
--

local function initial()        -- no Sp
end

---------------------------------------------------------------------------------------------------
local function arcane()        -- Sp Feu
end

---------------------------------------------------------------------------------------------------------------------
local function fire()        -- Sp Givre
end

---------------------------------------------------------------------------------------------------------------------
local function frost()
end

Clockwork.rotations[Clockwork.Enum.Specialization.Mage.Arcane] = arcane
Clockwork.rotations[Clockwork.Enum.Specialization.Mage.Fire] = fire
Clockwork.rotations[Clockwork.Enum.Specialization.Mage.Frost] = frost
Clockwork.rotations[Clockwork.Enum.Specialization.Mage.Initial] = initial
