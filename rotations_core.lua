

ksuto.INSPECT = 1 --28 yards
ksuto.TRADE = 2 --11.11 yards
ksuto.DUEL = 3 --9.9 yards
ksuto.FOLLOW = 4 --28 yards

function ksuto.rotation()

    ksuto.printDebug("UnitClass : " .. UnitClass("player"))
    if UnitClass("player") == "Warlock" then ksuto.warlockAfflictionRotation() end
end

function ksuto.checkDebuffSpellCast(spell)

    if not ksuto.unitHasDebuff("target", spell)
            and ksuto.checkTargetDistance(ksuto.FOLLOW) then
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

function ksuto.resetKeys()

    ksuto.keyEq.texture:SetTexture(0, 0, 0, 1)
    ksuto.keyPar.texture:SetTexture(0, 0, 0, 1)
    ksuto.key0.texture:SetTexture(0, 0, 0, 1)
    ksuto.key9.texture:SetTexture(0, 0, 0, 1)
    ksuto.key8.texture:SetTexture(0, 0, 0, 1)
    ksuto.key7.texture:SetTexture(0, 0, 0, 1)
    ksuto.key6.texture:SetTexture(0, 0, 0, 1)
    ksuto.key5.texture:SetTexture(0, 0, 0, 1)
    ksuto.key4.texture:SetTexture(0, 0, 0, 1)
    ksuto.key3.texture:SetTexture(0, 0, 0, 1)
    ksuto.key2.texture:SetTexture(0, 0, 0, 1)
    ksuto.key1.texture:SetTexture(0, 0, 0, 1)
end