--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 10/02/2017
-- Time: 16:56
-- To change this template use File | Settings | File Templates.
--

local function rotation1() -- Sp Feu
end

---------------------------------------------------------------------------------------------------------------------
local function rotation2() -- Sp Givre
end

---------------------------------------------------------------------------------------------------------------------
local function rotation3()
end

local function rotations()
    if Clockwork.spe == 1 then
        rotation1()
    elseif Clockwork.spe == 2 then
        rotation2()
    elseif Clockwork.spe == 3 then
        rotation3()
    end
end

Clockwork.rotations[Clockwork.Enum.Class.MAGE] = rotations
