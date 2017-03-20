ksuto.SHIFT = 927620
ksuto.CTRL = 519254
ksuto.ALT = 919836

function ksuto.initKeys()

    -- ksuto.printDebug("function ksuto.initKeys(")

    --ksuto.keyMaj = ksuto.createDot("ksuto_keyMaj", 2, -2)
    --ksuto.keyCtrl = ksuto.createDot("ksuto_keyCtrl", 3, -2)
    --ksuto.keyAlt = ksuto.createDot("ksuto_keyAlt", 4, -2)

    ksuto.keyT = ksuto.createDot("ksuto_keyT", 6, -4, 17, 22)
    ksuto.keyG = ksuto.createDot("ksuto_keyG", 5, -4, 16, 21)
    ksuto.keyQ = ksuto.createDot("ksuto_keyQ", 4, -4, 15, 20)
    ksuto.keyD = ksuto.createDot("ksuto_keyD", 3, -4, 14, 19)
    ksuto.keyH = ksuto.createDot("ksuto_keyH", 2, -4, 13, 18)

    ksuto.keyEq = ksuto.createDot("ksuto_keyEq", 13, -5, 12)
    ksuto.keyPar = ksuto.createDot("ksuto_keyPar", 12, -5, 11)
    ksuto.key0 = ksuto.createDot("ksuto_key0", 11, -5, 10)
    ksuto.key9 = ksuto.createDot("ksuto_key9", 10, -5, 9)
    ksuto.key8 = ksuto.createDot("ksuto_key8", 9, -5, 8)
    ksuto.key7 = ksuto.createDot("ksuto_key7", 8, -5, 7)
    ksuto.key6 = ksuto.createDot("ksuto_key6", 7, -5, 6)
    ksuto.key5 = ksuto.createDot("ksuto_key5", 6, -5, 5)
    ksuto.key4 = ksuto.createDot("ksuto_key4", 5, -5, 4)
    ksuto.key3 = ksuto.createDot("ksuto_key3", 4, -5, 3)
    ksuto.key2 = ksuto.createDot("ksuto_key2", 3, -5, 2)
    ksuto.key1 = ksuto.createDot("ksuto_key1", 2, -5, 1)
end

function ksuto.resetKeys()

    -- ksuto.printDebug("function ksuto.resetKeys(")

    ksuto.keyT.texture:SetTexture(0, 0, 0, 1)
    ksuto.keyG.texture:SetTexture(0, 0, 0, 1)
    ksuto.keyQ.texture:SetTexture(0, 0, 0, 1)
    ksuto.keyD.texture:SetTexture(0, 0, 0, 1)
    ksuto.keyH.texture:SetTexture(0, 0, 0, 1)

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

function ksuto.shouldHitKey(key, condition, actionSlot, modificator)

    ksuto.printDebug("function ksuto.shouldHitKey(" .. tostring(key) .. ", " .. tostring(should) .. ", " .. tostring(slot) .. ", " .. tostring(modificator))

    -- ksuto.print("key.slot = " .. tostring(key.slot))
    -- ksuto.print("should = " .. tostring(condition))
    -- ksuto.print("slot = " .. tostring(actionSlot))
    -- ksuto.print("modificator = " .. tostring(modificator))

    if (condition == false) then
        key.texture:SetTexture(0, 0, 0, 1)
        return
    end

    if (condition == nil or condition == true) then
        if (actionSlot) then
            condition = ksuto.actionCanBeCast(actionSlot)
        else
            if not modificator then condition = ksuto.actionCanBeCast(key.slot) end
            if modificator == ksuto.SHIFT and key.shiftslot then condition = ksuto.actionCanBeCast(key.shiftslot) end
            if modificator == ksuto.ALT and key.altslot then condition = ksuto.actionCanBeCast(key.altslot) end
        end
    end

    -- ksuto.print("should = " .. tostring(should) .. " " .. tostring(modificator))

    if condition and not modificator then key.texture:SetTexture(1, 1, 1, 1)
    elseif condition and modificator == ksuto.SHIFT then key.texture:SetTexture(1, 0, 0, 1)
    elseif condition and modificator == ksuto.CTRL then key.texture:SetTexture(0, 1, 0, 1)
    elseif condition and modificator == ksuto.ALT then key.texture:SetTexture(0, 0, 1, 1)
        return true
    else
        --ksuto.print("there")
        key.texture:SetTexture(0, 0, 0, 1)
        return false
    end
end

function ksuto.shouldHitShiftKey(key, should, slot)

    -- ksuto.printDebug("function ksuto.shouldHitShiftKey(" .. tostring(key) .. ", " .. tostring(should) .. ", " .. tostring(slot))

    ksuto.shouldHitKey(key, should, slot, ksuto.SHIFT)
end

function ksuto.shouldHitCtrlKey(key, should, slot)

    -- ksuto.printDebug("function ksuto.shouldHitCtrlKey(" .. tostring(key) .. ", " .. tostring(should) .. ", " .. tostring(slot))

    --    ksuto.print("ksuto.shouldHitCtrlKey" .. tostring(should) .. " " .. tostring(slot))

    ksuto.shouldHitKey(key, should, slot, ksuto.CTRL)
end

function ksuto.shouldHitAltKey(key, should, slot)

    -- ksuto.printDebug("function ksuto.shouldHitAltKey(" .. tostring(key) .. ", " .. tostring(should) .. ", " .. tostring(slot))

    ksuto.shouldHitKey(key, should, slot, ksuto.ALT)
end