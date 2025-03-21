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
local function brewmaster()
    initial()
end

---------------------------------------------------------------------------------------------------------------------
local function mistweaver()
    initial()
end

---------------------------------------------------------------------------------------------------------------------
local function windwalker()
    initial()
end

Clockwork.rotations[Clockwork.Enum.Specialization.Monk.Brewmaster] = brewmaster
Clockwork.rotations[Clockwork.Enum.Specialization.Monk.Mistweaver] = mistweaver
Clockwork.rotations[Clockwork.Enum.Specialization.Monk.Windwalker] = windwalker
Clockwork.rotations[Clockwork.Enum.Specialization.Monk.Initial] = initial
