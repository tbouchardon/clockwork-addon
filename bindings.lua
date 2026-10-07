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
