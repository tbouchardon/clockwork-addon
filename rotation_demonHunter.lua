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
local function havoc()        -- Sp Feu
    initial()
end

---------------------------------------------------------------------------------------------------------------------
local function vengeance()        -- Sp Givre
    initial()
end

Clockwork.rotations[Clockwork.Enum.Specialization.DemonHunter.Havoc] = havoc
Clockwork.rotations[Clockwork.Enum.Specialization.DemonHunter.Vengeance] = vengeance
Clockwork.rotations[Clockwork.Enum.Specialization.DemonHunter.Initial] = initial
