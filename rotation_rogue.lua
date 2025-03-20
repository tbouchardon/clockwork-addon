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
local function assassination()        -- Sp Feu
    initial()
end

---------------------------------------------------------------------------------------------------------------------
local function outlaw()        -- Sp Givre
    initial()
end

---------------------------------------------------------------------------------------------------------------------
local function subtlety()
    initial()
end

Clockwork.rotations[Clockwork.Enum.Specialization.Rogue.Assassination] = assassination
Clockwork.rotations[Clockwork.Enum.Specialization.Rogue.Outlaw] = outlaw
Clockwork.rotations[Clockwork.Enum.Specialization.Rogue.Subtlety] = subtlety
Clockwork.rotations[Clockwork.Enum.Specialization.Rogue.Initial] = initial
