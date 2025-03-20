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
local function discipline()
    initial()
end

---------------------------------------------------------------------------------------------------
local function holy()
    initial()
end

---------------------------------------------------------------------------------------------------
local function shadow()
    initial()
end

Clockwork.rotations[Clockwork.Enum.Specialization.Priest.Discipline] = discipline
Clockwork.rotations[Clockwork.Enum.Specialization.Priest.Holy] = holy
Clockwork.rotations[Clockwork.Enum.Specialization.Priest.Shadow] = shadow
Clockwork.rotations[Clockwork.Enum.Specialization.Priest.Initial] = initial
