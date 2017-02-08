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
            not UnitIsDeadOrGhost("player") then

        --and	UnitIsEnemy("target", "player")

        AttackTarget()

        ksuto.shouldHitKey(ksuto.key5, not ksuto.unitHasDebuff("target", "Curse of Agony"))
        ksuto.shouldHitKey(ksuto.key4, not ksuto.unitHasDebuff("target", "Corruption"))
        ksuto.shouldHitKey(ksuto.key3, not ksuto.unitHasDebuff("target", "Immolate"))
        ksuto.shouldHitKey(ksuto.key2, true)
    else
        ksuto.key5.texture:SetTexture(0, 0, 0, 1)
        ksuto.key4.texture:SetTexture(0, 0, 0, 1)
        ksuto.key3.texture:SetTexture(0, 0, 0, 1)
        ksuto.key2.texture:SetTexture(0, 0, 0, 1)
    end
end