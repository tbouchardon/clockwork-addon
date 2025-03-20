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
local function beastmastery()        -- Sp Feu
    initial()
end

---------------------------------------------------------------------------------------------------------------------
local function marksmanship()        -- Sp Givre
    initial()
end

---------------------------------------------------------------------------------------------------------------------
local function survival()
    initial()
end

Clockwork.rotations[Clockwork.Enum.Specialization.Hunter.BeastMastery] = beastmastery
Clockwork.rotations[Clockwork.Enum.Specialization.Hunter.Marksmanship] = marksmanship
Clockwork.rotations[Clockwork.Enum.Specialization.Hunter.Survival] = survival
Clockwork.rotations[Clockwork.Enum.Specialization.Hunter.Initial] = initial
