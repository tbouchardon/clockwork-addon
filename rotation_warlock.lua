--
-- Created by IntelliJ IDEA.
-- User: thomas.bouchardon
-- Date: 10/02/2017
-- Time: 16:56
-- To change this template use File | Settings | File Templates.
--

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
--        ksuto.shouldHitKey(ksuto.keyPar, ksuto.checkTargetDistance(ksuto.INSPECT) and ksuto.checkDebuffSpellCast("???????")) -- Check Fear
        ksuto.shouldHitKey(ksuto.key5, ksuto.checkDebuffSpellCast("Curse of Agony"))
        ksuto.shouldHitKey(ksuto.key4, ksuto.checkDebuffSpellCast("Corruption"))
        ksuto.shouldHitKey(ksuto.key3, ksuto.checkDebuffSpellCast("Immolate"))
        ksuto.shouldHitKey(ksuto.key2, ksuto.checkTargetDistance(ksuto.FOLLOW)) -- Shadow Bolt as of now
    else
        ksuto.key5.texture:SetTexture(0, 0, 0, 1)
        ksuto.key4.texture:SetTexture(0, 0, 0, 1)
        ksuto.key3.texture:SetTexture(0, 0, 0, 1)
        ksuto.key2.texture:SetTexture(0, 0, 0, 1)
    end
end

