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
local function blood()        -- Sp Feu
    initial()
end

---------------------------------------------------------------------------------------------------------------------
local function frost()        -- Sp Givre
    initial()
end

---------------------------------------------------------------------------------------------------------------------
local function unholy()
    initial()
end

Clockwork.rotations[Clockwork.Enum.Specialization.DeathKnight.Blood] = blood
Clockwork.rotations[Clockwork.Enum.Specialization.DeathKnight.Frost] = frost
Clockwork.rotations[Clockwork.Enum.Specialization.DeathKnight.Unholy] = unholy
Clockwork.rotations[Clockwork.Enum.Specialization.DeathKnight.Initial] = initial
