-- État du joueur et de la cible dans la grille (vie, ressource, combat, réaction de la cible), puis la grille v4
-- (qrcode_v2.lua). L'addon ne décide plus rien : les rotations sont des fichiers YAML du cerveau Java, les rotations Lua
-- d'avant la 12.x (valeurs secrètes) ont été retirées.

--- Met à jour toute la grille. Chaque bloc est isolé (Clockwork.guard) : une erreur sur une valeur secrète ne fige pas
--- le reste.
--- @return nil
function Clockwork:updateGrid()
    self:updateUIStatus()
end

--- Updates the UI elements based on player and target status.
--- @return nil
function Clockwork:updateUIStatus()
    Clockwork.guard("combat", function()
        if UnitAffectingCombat("player") then
            self.inCombat.texture:SetColorTexture(1, 1, 1, 1)
            self.wasInCombat = true
        else
            self:resetCombat()
        end
    end)

    Clockwork.guard("playerHealth", function()
        self.playerHealth.texture:SetColorTexture(Clockwork.healthRatio("player"), 0, 0, 1)
    end)

    Clockwork.guard("playerMana", function()
        self.playerMana.texture:SetColorTexture(0, 0, Clockwork.powerRatio("player"), 1)
    end)

    Clockwork.guard("target", function()
        if (UnitExists("target") and not UnitIsUnit("player", "target")) then
            if (UnitIsDeadOrGhost("target")) then
                -- Cible morte : gris, ni hostile ni amicale pour le cerveau Java (UnitIsDeadOrGhost n'est pas secret)
                self.targetReaction.texture:SetColorTexture(0.5, 0.5, 0.5, 1)
            elseif (Clockwork.targetIsUnfriendly()) then
                self.targetReaction.texture:SetColorTexture(1, 0, 0, 1)
            elseif (Clockwork.targetIsNeutral()) then
                self.targetReaction.texture:SetColorTexture(1, 1, 0, 1)
            elseif (Clockwork.targetIsFriendly()) then
                self.targetReaction.texture:SetColorTexture(0, 1, 0, 1)
            else
                self.targetReaction.texture:SetColorTexture(0, 0, 0, 1)
            end
        else
            self.targetReaction.texture:SetColorTexture(0, 0, 0, 1)
            self.targetHealth.texture:SetColorTexture(0, 0, 0, 1)
            self.targetMana.texture:SetColorTexture(0, 0, 0, 1)
        end
    end)

    Clockwork.guard("targetHealth", function()
        if (UnitExists("target") and not UnitIsUnit("player", "target")) then
            self.targetHealth.texture:SetColorTexture(Clockwork.healthRatio("target"), 0, 0, 1)
            self.targetMana.texture:SetColorTexture(0, 0, Clockwork.powerRatio("target"), 1)
        end
    end)

    self:updateQrCodeV2()

    Clockwork.guard("drive", function()
        -- PV et mana étant secrets, on attend la fin du buff de nourriture ou de boisson au lieu de comparer à 100 %
        if Clockwork.DRIVE_MOD == true and Clockwork.isEatingOrDrinking() then
            self.drive.texture:SetColorTexture(0, 0, 0, 1)
        elseif Clockwork.DRIVE_MOD == true then
            self.drive.texture:SetColorTexture(1, 1, 1, 1)
        end
    end)
end

-- Noms des buffs de repas, dans la langue du client (tables du jeu : Nourriture 433, Boisson 430, Rafraîchissement...)
local MEAL_BUFFS = {
    frFR = { "Nourriture", "Boisson", "Rafraîchissement" },
    enUS = { "Food", "Drink", "Refreshment" },
    enGB = { "Food", "Drink", "Refreshment" },
}

--- Le joueur mange ou boit (buff de repas) : le pilote automatique attend la fin. Buffs lisibles hors combat seulement.
--- @return boolean
function Clockwork.isEatingOrDrinking()
    -- On ne mange pas en combat, et les auras y sont inaccessibles en 12.x (appel refusé, « Lua Taint »)
    if UnitAffectingCombat("player") then return false end
    for _, name in ipairs(MEAL_BUFFS[GetLocale()] or MEAL_BUFFS.enUS) do
        if Clockwork.unitHasBuff("player", name) then return true end
    end
    return false
end

--- Calculates the health percentage of a unit.
--- Ratio de vie de l'unité, de 0 à 1.
--- En 12.x c'est une valeur SECRÈTE : la transmettre telle quelle à un widget (SetColorTexture, StatusBar...),
--- ne jamais la comparer ni faire de calcul avec (erreur Lua).
--- @param unit string
--- @return number
function Clockwork.healthRatio(unit)
    return UnitHealthPercent(unit, true)
end

--- Ratio de la ressource principale de l'unité (mana, énergie, rage...), de 0 à 1. Valeur SECRÈTE, comme healthRatio.
--- @param unit string
--- @return number
function Clockwork.powerRatio(unit)
    return UnitPowerPercent(unit, UnitPowerType(unit), true)
end

--- Checks if the target is unfriendly.
--- @return boolean
function Clockwork.targetIsUnfriendly()
    if not UnitExists("target") then
        return false
    end

    return UnitReaction("player", "target") < 4
end

--- Checks if the target is neutral.
--- @return boolean
function Clockwork.targetIsNeutral()
    if not UnitExists("target") then
        return false
    end

    return UnitReaction("player", "target") == 4
end

--- Checks if the target is friendly.
--- @return boolean
function Clockwork.targetIsFriendly()
    if not UnitExists("target") then
        return false
    end

    return UnitReaction("player", "target") > 4
end

--- Resets combat-related variables.
--- @return nil
function Clockwork:resetCombat()
    self.inCombat.texture:SetColorTexture(0, 0, 0, 1)
    self.wasInCombat = false
end

function Clockwork.unitHasBuff(unit, effect)
    local index = 1
    while C_UnitAuras.GetBuffDataByIndex(unit, index) do
        local aura = C_UnitAuras.GetAuraDataByIndex(unit, index)

        if (aura and string.find(aura.name, effect) and aura.isFromPlayerOrPlayerPet) then
            local remainingTime = 0

            if aura.expirationTime then
                remainingTime = aura.expirationTime - GetTime()
            end

            return true, true, remainingTime
        end

        index = index + 1
    end

    return false, index > 1, 0
end
