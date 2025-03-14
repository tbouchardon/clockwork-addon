--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 10/02/2017
-- Time: 16:56
-- To change this template use File | Settings | File Templates.
--

local regen = 53

local function initial() -- no Sp
end
local function initialActions() -- no Sp
end

---------------------------------------------------------------------------------------------------
local function arms()
end
local function armsActions()
end

---------------------------------------------------------------------------------------------------
local function fury()
end
local function furyActions()
end

---------------------------------------------------------------------------------------------------
local function protection()
end
local function protectionActions()
end

Clockwork.rotations[Clockwork.Enum.Specialization.Warrior.Arms] = arms
Clockwork.rotations[Clockwork.Enum.Specialization.Warrior.Fury] = fury
Clockwork.rotations[Clockwork.Enum.Specialization.Warrior.Protection] = protection
Clockwork.rotations[Clockwork.Enum.Specialization.Warrior.Initial] = initial

Clockwork.rotationsActions[Clockwork.Enum.Specialization.Warrior.Arms] = armsActions
Clockwork.rotationsActions[Clockwork.Enum.Specialization.Warrior.Fury] = furyActions
Clockwork.rotationsActions[Clockwork.Enum.Specialization.Warrior.Protection] = protectionActions
Clockwork.rotationsActions[Clockwork.Enum.Specialization.Warrior.Initial] = initialActions
