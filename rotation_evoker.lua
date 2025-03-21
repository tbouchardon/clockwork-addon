--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 10/02/2017
-- Time: 16:56
-- To change this template use File | Settings | File Templates.
--

local function initial()
end

---------------------------------------------------------------------------------------------------
local function devastation()
    initial()
end

---------------------------------------------------------------------------------------------------------------------
local function preservation()
    initial()
end

---------------------------------------------------------------------------------------------------------------------
local function augmentation()
    initial()
end

Clockwork.rotations[Clockwork.Enum.Specialization.Evoker.Devastation] = devastation
Clockwork.rotations[Clockwork.Enum.Specialization.Evoker.Preservation] = preservation
Clockwork.rotations[Clockwork.Enum.Specialization.Evoker.Augmentation] = augmentation
Clockwork.rotations[Clockwork.Enum.Specialization.Evoker.Initial] = initial
