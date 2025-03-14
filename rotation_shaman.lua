--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 10/02/2017
-- Time: 16:56
-- To change this template use File | Settings | File Templates.
--

local function initial() -- no Sp
end
local function initialActions() -- no Sp
end

---------------------------------------------------------------------------------------------------
local function elemental()
end
local function elementalActions()
end

---------------------------------------------------------------------------------------------------
local function enhancement()
end
local function enhancementActions()
end

---------------------------------------------------------------------------------------------------
local function restoration()
end
local function restorationActions()
end

Clockwork.rotations[Clockwork.Enum.Specialization.Shaman.Elemental] = elemental
Clockwork.rotations[Clockwork.Enum.Specialization.Shaman.Enhancement] = enhancement
Clockwork.rotations[Clockwork.Enum.Specialization.Shaman.Restoration] = restoration
Clockwork.rotations[Clockwork.Enum.Specialization.Shaman.Initial] = initial

Clockwork.rotationsActions[Clockwork.Enum.Specialization.Shaman.Elemental] = elementalActions
Clockwork.rotationsActions[Clockwork.Enum.Specialization.Shaman.Enhancement] = enhancementActions
Clockwork.rotationsActions[Clockwork.Enum.Specialization.Shaman.Restoration] = restorationActions
Clockwork.rotationsActions[Clockwork.Enum.Specialization.Shaman.Initial] = initialActions
