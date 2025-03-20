--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 10/02/2017
-- Time: 16:56
-- To change this template use File | Settings | File Templates.
--

local function initial() -- no Sp
end

---------------------------------------------------------------------------------------------------
local function elemental()
    initial()
end

---------------------------------------------------------------------------------------------------
local function enhancement()
    initial()
end

---------------------------------------------------------------------------------------------------
local function restoration()
    initial()
end

Clockwork.rotations[Clockwork.Enum.Specialization.Shaman.Elemental] = elemental
Clockwork.rotations[Clockwork.Enum.Specialization.Shaman.Enhancement] = enhancement
Clockwork.rotations[Clockwork.Enum.Specialization.Shaman.Restoration] = restoration
Clockwork.rotations[Clockwork.Enum.Specialization.Shaman.Initial] = initial
