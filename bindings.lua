--
-- Created by IntelliJ IDEA.
-- User: Kseniya
-- Date: 30/04/2017
-- Time: 21:43
-- To change this template use File | Settings | File Templates.
--

-- Noms affichés dans Options > Raccourcis > Addons (Bindings.xml)
BINDING_HEADER_CLOCKWORK = "ClockWork"
BINDING_NAME_CLOCKWORK_TOGGLE = "Activer / désactiver ClockWork"
BINDING_NAME_CLOCKWORK_FISH = "Pêche automatique"
BINDING_NAME_CLOCKWORK_HEALER = "Mode soigneur"
BINDING_NAME_CLOCKWORK_MULTI = "Mode multi-cibles"
BINDING_NAME_CLOCKWORK_AGGRO = "Mode aggro"
BINDING_NAME_CLOCKWORK_DRIVE = "Pilote automatique"
BINDING_NAME_CLOCKWORK_LOOT = "Ramassage du butin"
BINDING_NAME_CLOCKWORK_MENU = "Afficher / masquer le menu"

-- Raccourcis du bot, en surcharge (jamais enregistrés dans la configuration du joueur), identiques côté Java (TomTom) :
-- le pilote automatique lance la course automatique sans dépendre des touches du joueur (J ouvre Guilde et communautés)
local botBindingOwner = CreateFrame("Frame", "ClockworkBotBindings")
Clockwork.AUTORUN_KEY = "ALT-SHIFT-V"
Clockwork.INTERACT_KEY = "ALT-SHIFT-L"

--- Pose les raccourcis du bot ; hors combat seulement (sinon refusé), d'où l'appel à l'entrée dans le monde.
function Clockwork.applyBotBindings()
    if InCombatLockdown() then return end
    ClearOverrideBindings(botBindingOwner)
    SetOverrideBinding(botBindingOwner, true, Clockwork.AUTORUN_KEY, "TOGGLEAUTORUN")
    -- Ramassage : interagir avec la cible (cadavre à portée), voir loot.lua
    SetOverrideBinding(botBindingOwner, true, Clockwork.INTERACT_KEY, "INTERACTTARGET")
end

function Clockwork:setAllBindings()

    --    local key = "ALT-CTRL-SHIFT-Y"
    --    local action = "TEST_BINDING"

    --    SetBinding("ALT-SHIFT-1", "CLOCKWORK_PRIORITY_CAST_1")
    --    SetBinding("ALT-SHIFT-2", "CLOCKWORK_PRIORITY_CAST_2")
    --    SetBinding("ALT-SHIFT-3", "CLOCKWORK_PRIORITY_CAST_3")
    --    SetBinding("ALT-SHIFT-4", "CLOCKWORK_PRIORITY_CAST_4")
    --    SetBinding("ALT-SHIFT-5", "CLOCKWORK_PRIORITY_CAST_5")
    --    SetBinding("ALT-SHIFT-6", "CLOCKWORK_PRIORITY_CAST_6")
    --    SetBinding("ALT-SHIFT-7", "CLOCKWORK_PRIORITY_CAST_7")
    --    SetBinding("ALT-SHIFT-8", "CLOCKWORK_PRIORITY_CAST_8")
    --    SetBinding("ALT-SHIFT-9", "CLOCKWORK_PRIORITY_CAST_9")
    --    SetBinding("ALT-SHIFT-0", "CLOCKWORK_PRIORITY_CAST_10")
    --    SetBinding("ALT-SHIFT-)", "CLOCKWORK_PRIORITY_CAST_11")
    --    SetBinding("ALT-SHIFT-=", "CLOCKWORK_PRIORITY_CAST_12")
    --    SetBinding("ALT-CTRL-1", "CLOCKWORK_PRIORITY_CAST_13")
    --    SetBinding("ALT-CTRL-2", "CLOCKWORK_PRIORITY_CAST_14")
    --    SetBinding("ALT-CTRL-3", "CLOCKWORK_PRIORITY_CAST_15")
    --    SetBinding("ALT-CTRL-4", "CLOCKWORK_PRIORITY_CAST_16")
    --    SetBinding("ALT-CTRL-5", "CLOCKWORK_PRIORITY_CAST_17")
    --    SetBinding("ALT-CTRL-6", "CLOCKWORK_PRIORITY_CAST_18")
    --
    --    SetBinding("ALT-CTRL-7", "CLOCKWORK_PRIORITY_OOC_CAST_1")
    --    SetBinding("ALT-CTRL-8", "CLOCKWORK_PRIORITY_OOC_CAST_2")
    --    SetBinding("ALT-CTRL-9", "CLOCKWORK_PRIORITY_OOC_CAST_3")
    --    SetBinding("ALT-CTRL-0", "CLOCKWORK_PRIORITY_OOC_CAST_4")
    --    SetBinding("ALT-CTRL-)", "CLOCKWORK_PRIORITY_OOC_CAST_5")
    --    SetBinding("ALT-CTRL-=", "CLOCKWORK_PRIORITY_OOC_CAST_6")

    -- Ciblage des membres : boutons sécurisés et raccourcis surchargés, voir group.lua
end

function Clockwork.printAllBindings()

    for index = 1, GetNumBindings() do
        local command, key1, key2 = GetBinding(index);
        Clockwork.log.notice("GetBindingAction : command = " .. command .. ", key = " .. key1)
    end
end

-- local ok = SetBindingClick("Y", "ButtonTest");
-- Clockwork.log.debug(tostring(ok))
