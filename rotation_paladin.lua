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
local function holy()        -- Sp Feu
    initial()
end

---------------------------------------------------------------------------------------------------------------------
local function protection()        -- Sp Givre
    initial()
end

---------------------------------------------------------------------------------------------------------------------
local function retribution()
    initial()
end

Clockwork.rotations[Clockwork.Enum.Specialization.Paladin.Holy] = holy
Clockwork.rotations[Clockwork.Enum.Specialization.Paladin.Protection] = protection
Clockwork.rotations[Clockwork.Enum.Specialization.Paladin.Retribution] = retribution
Clockwork.rotations[Clockwork.Enum.Specialization.Paladin.Initial] = initial
