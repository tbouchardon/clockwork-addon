clockWork.SHIFT = 927620
clockWork.CTRL = 519254
clockWork.ALT = 919836

function clockWork.initKeys()

    -- clockWork.printDebug("function clockWork.initKeys(")

    --clockWork.keyMaj = clockWork.createDot("clockWork_keyMaj", 2, -2)
    --clockWork.keyCtrl = clockWork.createDot("clockWork_keyCtrl", 3, -2)
    --clockWork.keyAlt = clockWork.createDot("clockWork_keyAlt", 4, -2)

    clockWork.keyQ = clockWork.createDot("clockWork_keyQ", 2, -4, 13, 14)
    clockWork.keyD = clockWork.createDot("clockWork_keyD", 3, -4, 15, 16)
    clockWork.keyR = clockWork.createDot("clockWork_keyR", 4, -4, 17, 18)
    clockWork.keyT = clockWork.createDot("clockWork_keyT", 5, -4, 19, 20)
    clockWork.keyF = clockWork.createDot("clockWork_keyF", 6, -4, 21, 22)
    clockWork.keyG = clockWork.createDot("clockWork_keyG", 7, -4, 23, 24)

    clockWork.key1 = clockWork.createDot("clockWork_key1", 2, -5, 1)
    clockWork.key2 = clockWork.createDot("clockWork_key2", 3, -5, 2)
    clockWork.key3 = clockWork.createDot("clockWork_key3", 4, -5, 3)
    clockWork.key4 = clockWork.createDot("clockWork_key4", 5, -5, 4)
    clockWork.key5 = clockWork.createDot("clockWork_key5", 6, -5, 5)
    clockWork.key6 = clockWork.createDot("clockWork_key6", 7, -5, 6)
    clockWork.key7 = clockWork.createDot("clockWork_key7", 8, -5, 7)
    clockWork.key8 = clockWork.createDot("clockWork_key8", 9, -5, 8)
    clockWork.key9 = clockWork.createDot("clockWork_key9", 10, -5, 9)
    clockWork.key0 = clockWork.createDot("clockWork_key0", 11, -5, 10)
    clockWork.keyPar = clockWork.createDot("clockWork_keyPar", 12, -5, 11)
    clockWork.keyEq = clockWork.createDot("clockWork_keyEq", 13, -5, 12)
end

function clockWork.resetKeys()

    -- clockWork.printDebug("function clockWork.resetKeys(")

    clockWork.keyQ.texture:SetColorTexture(0, 0, 0, 1)
    clockWork.keyQ.priority = -1
    clockWork.keyD.texture:SetColorTexture(0, 0, 0, 1)
    clockWork.keyD.priority = -1
    clockWork.keyR.texture:SetColorTexture(0, 0, 0, 1)
    clockWork.keyR.priority = -1
    clockWork.keyT.texture:SetColorTexture(0, 0, 0, 1)
    clockWork.keyT.priority = -1
    clockWork.keyF.texture:SetColorTexture(0, 0, 0, 1)
    clockWork.keyF.priority = -1
    clockWork.keyG.texture:SetColorTexture(0, 0, 0, 1)
    clockWork.keyG.priority = -1
    clockWork.keyEq.texture:SetColorTexture(0, 0, 0, 1)
    clockWork.keyEq.priority = -1
    clockWork.keyPar.texture:SetColorTexture(0, 0, 0, 1)
    clockWork.keyPar.priority = -1
    clockWork.key0.texture:SetColorTexture(0, 0, 0, 1)
    clockWork.key0.priority = -1
    clockWork.key9.texture:SetColorTexture(0, 0, 0, 1)
    clockWork.key9.priority = -1
    clockWork.key8.texture:SetColorTexture(0, 0, 0, 1)
    clockWork.key8.priority = -1
    clockWork.key7.texture:SetColorTexture(0, 0, 0, 1)
    clockWork.key7.priority = -1
    clockWork.key6.texture:SetColorTexture(0, 0, 0, 1)
    clockWork.key6.priority = -1
    clockWork.key5.texture:SetColorTexture(0, 0, 0, 1)
    clockWork.key5.priority = -1
    clockWork.key4.texture:SetColorTexture(0, 0, 0, 1)
    clockWork.key4.priority = -1
    clockWork.key3.texture:SetColorTexture(0, 0, 0, 1)
    clockWork.key3.priority = -1
    clockWork.key2.texture:SetColorTexture(0, 0, 0, 1)
    clockWork.key2.priority = -1
    clockWork.key1.texture:SetColorTexture(0, 0, 0, 1)
    clockWork.key1.priority = -1
end

function clockWork.shouldHitKey(key, condition, priority)

    -- clockWork.printDebug("function clockWork.shouldHitAltKey(" .. tostring(key) .. ", " .. tostring(should) .. ", " .. tostring(slot))

    clockWork.shouldHitKeyWithModifier(key, condition, priority, nil)
end

function clockWork.shouldHitKeyWithModifier(key, condition, priority, keyModificator)

    priority = clockWork.ternary(clockWork.emptyOrNil(priority), 0, priority)

    --clockWork.printDebug("function clockWork.shouldHitKey(" .. tostring(key) .. ", " .. tostring(should) .. ", " .. tostring(slot) .. ", " .. tostring(modificator))

    clockWork.log.debug("key.slot = " .. tostring(key.slot))
    clockWork.log.debug("should = " .. tostring(condition))
    clockWork.log.debug("slot = " .. tostring(actionSlot))
    clockWork.log.debug("modificator = " .. tostring(modificator))

    if (condition == false) then
        return false
    end

    if (condition == nil or condition == true) then
        --if (actionSlot) then
        --    condition = clockWork.actionCanBeCast(actionSlot)
        --else
        if not keyModificator then
            condition = clockWork.actionCanBeCast(key.slot)
        end
        if keyModificator == clockWork.SHIFT and key.shiftslot then
            condition = clockWork.actionCanBeCast(key.shiftslot)
        end
        if keyModificator == clockWork.ALT and key.altslot then
            condition = clockWork.actionCanBeCast(key.altslot)
        end
        --end
    end

    clockWork.log.debug("should = " .. tostring(should) .. " " .. tostring(modificator)) -- spam "should = nil nil" dès que le mob est ciblé

    -- Mode octal
    -- CTRL  = 1
    -- ALT   = 2
    -- SHIFT = 4
    --

    sum = 0 +
            clockWork.ternary(keyModificator == clockWork.CTRL, 1, 0) +
            clockWork.ternary(keyModificator == clockWork.ALT, 2, 0) +
            clockWork.ternary(keyModificator == clockWork.SHIFT, 4, 0)

    if condition and priority > key.priority
    --and not modificator
    then
        key.texture:SetColorTexture(sum / 255, priority / 255, 1, 1)
        key.priority = priority
        --elseif condition and modificator == clockWork.SHIFT then key.texture:SetColorTexture(1, 0, 0, 1)
        --elseif condition and modificator == clockWork.CTRL then key.texture:SetColorTexture(0, 1, 0, 1)
        --elseif condition and modificator == clockWork.ALT then key.texture:SetColorTexture(0, 0, 1, 1)
        return true
    else
        return false
    end
end

function clockWork.shouldHitShiftKey(key, condition, priority)

    -- clockWork.printDebug("function clockWork.shouldHitShiftKey(" .. tostring(key) .. ", " .. tostring(should) .. ", " .. tostring(slot))

    clockWork.shouldHitKeyWithModifier(key, condition, priority, clockWork.SHIFT)
end

function clockWork.shouldHitCtrlKey(key, condition, priority)

    -- clockWork.printDebug("function clockWork.shouldHitCtrlKey(" .. tostring(key) .. ", " .. tostring(should) .. ", " .. tostring(slot))

    clockWork.log.debug("clockWork.shouldHitCtrlKey" .. tostring(should) .. " " .. tostring(slot))

    clockWork.shouldHitKeyWithModifier(key, condition, priority, clockWork.CTRL)
end

function clockWork.shouldHitAltKey(key, condition, priority)

    -- clockWork.printDebug("function clockWork.shouldHitAltKey(" .. tostring(key) .. ", " .. tostring(should) .. ", " .. tostring(slot))

    clockWork.shouldHitKeyWithModifier(key, condition, priority, clockWork.ALT)
end
