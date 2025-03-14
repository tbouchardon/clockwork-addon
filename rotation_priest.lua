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
local function discipline()
end
local function disciplineActions()
end

---------------------------------------------------------------------------------------------------
local function holy()
end
local function holyActions()
end

---------------------------------------------------------------------------------------------------
local function shadow()
end
local function shadowActions()
end

Clockwork.rotations[Clockwork.Enum.Specialization.Priest.Discipline] = discipline
Clockwork.rotations[Clockwork.Enum.Specialization.Priest.Holy] = holy
Clockwork.rotations[Clockwork.Enum.Specialization.Priest.Shadow] = shadow
Clockwork.rotations[Clockwork.Enum.Specialization.Priest.Initial] = initial

Clockwork.rotationsActions[Clockwork.Enum.Specialization.Priest.Discipline] = disciplineActions
Clockwork.rotationsActions[Clockwork.Enum.Specialization.Priest.Holy] = holyActions
Clockwork.rotationsActions[Clockwork.Enum.Specialization.Priest.Shadow] = shadowActions
Clockwork.rotationsActions[Clockwork.Enum.Specialization.Priest.Initial] = initialActions
