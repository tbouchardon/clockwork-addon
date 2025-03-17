--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 10/02/2017
-- Time: 16:56
-- To change this template use File | Settings | File Templates.
--

local function initial()        -- no Sp
end
local function initialActions() -- no Sp
    Clockwork.dropSpellInShortcut(Clockwork.Enum.Spell.Mage.ECLAIR_DE_GIVRE_116, 1)
end

---------------------------------------------------------------------------------------------------
local function arcane()        -- Sp Feu
end
local function arcaneActions() -- Sp Feu
end

---------------------------------------------------------------------------------------------------------------------
local function fire()        -- Sp Givre
end
local function fireActions() -- Sp Givre
end

---------------------------------------------------------------------------------------------------------------------
local function frost()
end
local function frostActions()
    Clockwork.dropSpellInShortcut(Clockwork.Enum.Spell.Mage.ECLAIR_DE_GIVRE_116, 1)
end

Clockwork.rotations[Clockwork.Enum.Specialization.Mage.Arcane] = arcane
Clockwork.rotations[Clockwork.Enum.Specialization.Mage.Fire] = fire
Clockwork.rotations[Clockwork.Enum.Specialization.Mage.Frost] = frost
Clockwork.rotations[Clockwork.Enum.Specialization.Mage.Initial] = initial

Clockwork.rotationsActions[Clockwork.Enum.Specialization.Mage.Arcane] = arcaneActions
Clockwork.rotationsActions[Clockwork.Enum.Specialization.Mage.Fire] = fireActions
Clockwork.rotationsActions[Clockwork.Enum.Specialization.Mage.Frost] = frostActions
Clockwork.rotationsActions[Clockwork.Enum.Specialization.Mage.Initial] = initialActions
