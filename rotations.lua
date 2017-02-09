local INSPECT = 1 --28 yards
local TRADE = 2 --11.11 yards
local DUEL = 3 --9.9 yards
local FOLLOW = 4 --28 yards

function ksuto.rotation()

    ksuto.printDebug("UnitClass : " .. UnitClass("player"))
    if UnitClass("player") == "Warlock" then ksuto.warlockAfflictionRotation() end
end

function ksuto.warlockAfflictionRotation()

    ksuto.printDebug("warlockRotation()")

    ksuto.updatePositionCoordinates()

    if (ksuto.DEBUG_MOD) then ksuto.unitHasBuff("player", "for debug purpose") end

    if UnitExists("target") and
            not UnitIsDeadOrGhost("target") and
            not UnitIsDeadOrGhost("player")
            and UnitIsEnemy("player", "target") then

        AttackTarget()

        --        ksuto.shouldHitShiftedKey(ksuto.keyT, not ksuto.unitHasBuff("player", ""))
        --ksuto.shouldHitKey(ksuto.keyPar, ksuto.checkTargetDistance(INSPECT))
        ksuto.shouldHitKey(ksuto.key5, ksuto.checkDebuffSpellCast("Curse of Agony"), 5)
        ksuto.shouldHitKey(ksuto.key4, ksuto.checkDebuffSpellCast("Corruption"), 4)
        ksuto.shouldHitKey(ksuto.key3, ksuto.checkDebuffSpellCast("Immolate"), 3)
        ksuto.shouldHitKey(ksuto.key2, ksuto.checkTargetDistance(FOLLOW)) -- Shadow Bolt as of now
    else
        ksuto.key5.texture:SetTexture(0, 0, 0, 1)
        ksuto.key4.texture:SetTexture(0, 0, 0, 1)
        ksuto.key3.texture:SetTexture(0, 0, 0, 1)
        ksuto.key2.texture:SetTexture(0, 0, 0, 1)
    end
end

------------------------------------------------- Usefull functions -------------------------------------------------
function ksuto.checkDebuffSpellCast(spell, slot)

    if not ksuto.unitHasDebuff("target", spell)
            and ksuto.checkTargetDistance(FOLLOW) then
        return true
    else
        return false
    end
end

function ksuto.checkTargetDistance(distance)

    if CheckInteractDistance("target", distance) then
        return true
    else
        return false
    end
end

function ksuto.checkSpellRange(slot)

    if ActionHasRange(slot) then
        if IsActionInRange(slot) then
            return true
        else
            return false
        end
    else
        return false
    end
end

function ksuto.omgAnAlly()

    if UnitIsPlayer("target") then
        return true
    else
        return false
    end
end