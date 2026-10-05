Clockwork.INSPECT = 1 --28 yards
Clockwork.TRADE = 2   --11.11 yards
Clockwork.DUEL = 3    --9.9 yards
Clockwork.FOLLOW = 4  --28 yards

Clockwork.rotations = {}

--- Updates the player's status and executes rotations.
--- Chaque bloc est isolé (Clockwork.guard) : une erreur sur une valeur secrète ne fige plus le reste du QR code.
--- @return nil
function Clockwork:rotation()
    -- Clockwork.log.debug("function Clockwork.rotation()")

    self:updateUIStatus()
    Clockwork:resetKeys()

    -- Ne rien faire si un cast est déjà en cours
    if (self.CASTING == true) then
        return;
    end

    if (IsMounted()) then
        return
    end

    -- Ne lancer les rotations que si le joueur est hors combat, ou la cible ET le joueur en combat
    if not (Clockwork.AGGRO_MOD or Clockwork.bothPlayerAndTargetInCombat() or Clockwork.playerNotInCombat()) then
        return
    end

    -- Rotation écrite à la main et rotation assistée, isolées l'une de l'autre : si la première échoue sur une
    -- valeur secrète, la seconde continue d'allumer sa touche
    Clockwork.guard("rotation", function()
        local rotation = Clockwork.rotations[Clockwork.player.specialization.id]
        if rotation then rotation() end
    end)

    Clockwork.guard("assisted", function() self:assistedRotation() end)
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

    Clockwork.guard("groupHealth", function()
        if UnitExists("raid1") then
            self:updateRaidHealth()
        elseif UnitExists("party1") then
            self:updatePartyHealth()
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
    for _, name in ipairs(MEAL_BUFFS[GetLocale()] or MEAL_BUFFS.enUS) do
        if Clockwork.unitHasBuff("player", name) then return true end
    end
    return false
end

--- Checks if both player and target are in combat.
--- @return boolean
function Clockwork.bothPlayerAndTargetInCombat()
    return UnitAffectingCombat("player") and UnitAffectingCombat("target")
end

--- Checks if the player is not in combat.
--- @return boolean
function Clockwork.playerNotInCombat()
    return not UnitAffectingCombat("player")
end

--- Checks if a debuff can be cast on the target.
--- @param spell string
--- @param slot number?
--- @return boolean
function Clockwork.debuffCanBeCast(spell, slot)
    -- Clockwork.log.debug("function Clockwork.debuffCanBeCast(" .. tostring(spell) .. ", " .. tostring(slot))

    Clockwork.log.debug("Clockwork.debuffCanBeCast(" .. tostring(spell) .. "," .. tostring(slot) .. ')')

    if not spell then
        return false
    end

    if not Clockwork.unitHasDebuff("target", spell) then
        if slot ~= nil then
            return Clockwork.actionCanBeCast(slot)
        else
            Clockwork.log.notice("No slot ! (" .. tostring(spell) .. ")")
            return true
        end
    else
        return false
    end
end

--- Checks if the target is in melee range.
--- @return boolean
function Clockwork.targetInMeeleRange()
    return Clockwork.targetInRange(Clockwork.TRADE)
end

--- Checks if the target is in the specified range.
--- @param distance number
--- @return boolean
function Clockwork.targetInRange(distance)
    -- Clockwork.log.debug("function Clockwork.targetInRange(" .. tostring(distance))

    -- distance - A value from 1 to 5:
    -- 1 = Compare Achievements, 28 yards
    -- 2 = Trade, 8 yards
    -- 3 = Duel, 7 yards
    -- 4 = Follow, 28 yards
    -- 5 = Pet-battle Duel, 7 yards
    
    if CheckInteractDistance("target", distance) then
        return true
    else
        return false
    end
end

--- Checks if an action can be cast.
--- @param actionSlot number
--- @return boolean
function Clockwork.actionCanBeCast(actionSlot)
    Clockwork.log.debug("function Clockwork.actionCanBeCast(" .. tostring(actionSlot))

    if (Clockwork.CHECK_ACTIONS_CAST == false) then
        return true
    end

    local actionType, id, subType = GetActionInfo(actionSlot)
    if not id then
        Clockwork.log.debug("No action in slot" .. tostring(actionSlot))
        return false
    end
    Clockwork.log.debug("id = " .. id)
    local spellInfo = C_Spell.GetSpellInfo(id)
    Clockwork.log.debug(tostring(actionType) .. ": " .. tostring(spellInfo.name) .. " (" .. tostring(spellInfo.spellID) .. ") ")
    Clockwork.log.debug("ActionHasRange(" .. actionSlot .. ") = " .. tostring(ActionHasRange(actionSlot)))
    Clockwork.log.debug("IsActionInRange(" .. actionSlot .. ") = " .. tostring(IsActionInRange(actionSlot)))

    local canBeCast = true

    if ActionHasRange(actionSlot) then
        canBeCast = IsActionInRange(actionSlot) ~= false -- Can be true or nil
    end

    --Clockwork.log.debug("canBeCast1 : " .. tostring(canBeCast))

    -- Le temps de recharge (GetActionCooldown) est secret en combat en 12.x : il ne peut plus être comparé ici.
    -- La recommandation de Blizzard en tient compte ; le Java pourra le lire en pixel via C_Spell.GetSpellCooldownDuration.

    --Clockwork.log.debug("canBeCast2 : " .. tostring(canBeCast))

    if canBeCast == true then
        local isUsable, notEnoughMana = IsUsableAction(actionSlot)

        Clockwork.log.debug("IsUsableAction(" .. actionSlot .. ") = isUsable " .. tostring(isUsable))
        --         Clockwork.log.debug("IsUsableAction("..actionSlot..") = notEnoughMana " .. tostring(notEnoughMana))

        canBeCast = isUsable ~= nil and isUsable == true
    end

    if (canBeCast == true) then
        if spellInfo.castTime ~= 0 then
            canBeCast = Clockwork.player.isMoving == false
        end
    end

    --Clockwork.log.debug("canBeCast3 : " .. tostring(canBeCast))

    return canBeCast
end

--- Checks if the target is an enemy player.
--- @return boolean
function Clockwork.enemyPlayer()
    -- Clockwork.log.debug("function Clockwork.enemyPlayer(")

    if UnitIsPlayer("target") then
        return true
    else
        return false
    end
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

--- Checks if the target exists, can be attacked, and the player is alive.
--- @return boolean
function Clockwork.unitExistCanAndShouldDie()
    return UnitExists("target") and
        not UnitIsDeadOrGhost("target") and
        not UnitIsDeadOrGhost("player") and                             -- > La cible ET le joueur sont vivants (>_<)
        (not UnitIsTapDenied("target")) and                             -- > La cible peut être marquée par le joueur.
        (Clockwork.targetIsNeutral() or Clockwork.targetIsUnfriendly()) -- > La cible est un enemi (rouge uniquement)
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

--- Affiche les PV d'un membre du groupe : rouge = ratio de vie, noir si absent.
--- Le bleu est réservé au signal « cibler ce membre » lu par le Java (ComplexKey).
--- @param index number
--- @param unit string
--- @return nil
function Clockwork:showMemberHealth(index, unit)
    if UnitExists(unit) then
        self.raid[index].texture:SetColorTexture(Clockwork.healthRatio(unit), 0, 0, 1)
    else
        self.raid[index].texture:SetColorTexture(0, 0, 0, 1)
    end
end

--- Updates party health information.
--- @return nil
function Clockwork:updatePartyHealth()
    for index = 1, 4 do
        self:showMemberHealth(index, "party" .. tostring(index))
    end
end

--- Updates raid health information.
--- @return nil
function Clockwork:updateRaidHealth()
    for index = 1, 40 do
        self:showMemberHealth(index, "raid" .. tostring(index))
    end
end

--- Checks if the player is out of combat.
--- @return boolean
function Clockwork.outOfCombat()
    return (not UnitIsDeadOrGhost("player")) and (not UnitAffectingCombat("player"))
end

--- Casts a spell if possible based on conditions.
--- @param params {spell:{name:string, id:integer}, condition:boolean|nil, priority:number|nil, duration:number|nil}
--- @return nil
function Clockwork:castSpellIfPossible(params)

    -- A condition of 'false' explicitly prevents casting. nil or true allows it.
    if params.condition == false then
        return
    end

    local action, error = self:getActionSlotAndBindingForSpell(params.spell.id)
    if not action then
        -- Clockwork.log.error(error) -- Optionally log why it failed
        return
    end

    if not Clockwork.actionCanBeCast(action.slot) then return end

    local modifier = nil
    if action.alt then
        modifier = Clockwork.ALT
    end
    if action.ctrl then
        modifier = Clockwork.CTRL
    end
    if action.shift then
        modifier = Clockwork.SHIFT
    end

    self:hitKeyWithModifier({
        key = action.key,
        priority = params.priority or 1,
        duration = params.duration
    }, modifier)
end
