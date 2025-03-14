Clockwork.SHIFT = 927620
Clockwork.CTRL = 519254
Clockwork.ALT = 919836

function Clockwork.initKeys()
    -- Clockwork.log.debug("function Clockwork.initKeys(")

    --Clockwork.keyMaj = Clockwork.createDot("clockWork_keyMaj", 2, -2)
    --Clockwork.keyCtrl = Clockwork.createDot("clockWork_keyCtrl", 3, -2)
    --Clockwork.keyAlt = Clockwork.createDot("clockWork_keyAlt", 4, -2)

    Clockwork.keyQ = Clockwork.createDot("clockWork_keyQ", 2, -4, 13, 14)
    Clockwork.keyD = Clockwork.createDot("clockWork_keyD", 3, -4, 15, 16)
    Clockwork.keyR = Clockwork.createDot("clockWork_keyR", 4, -4, 17, 18)
    Clockwork.keyT = Clockwork.createDot("clockWork_keyT", 5, -4, 19, 20)
    Clockwork.keyF = Clockwork.createDot("clockWork_keyF", 6, -4, 21, 22)
    Clockwork.keyG = Clockwork.createDot("clockWork_keyG", 7, -4, 23, 24)

    Clockwork.key1 = Clockwork.createDot("clockWork_key1", 2, -5, 1)
    Clockwork.key2 = Clockwork.createDot("clockWork_key2", 3, -5, 2)
    Clockwork.key3 = Clockwork.createDot("clockWork_key3", 4, -5, 3)
    Clockwork.key4 = Clockwork.createDot("clockWork_key4", 5, -5, 4)
    Clockwork.key5 = Clockwork.createDot("clockWork_key5", 6, -5, 5)
    Clockwork.key6 = Clockwork.createDot("clockWork_key6", 7, -5, 6)
    Clockwork.key7 = Clockwork.createDot("clockWork_key7", 8, -5, 7)
    Clockwork.key8 = Clockwork.createDot("clockWork_key8", 9, -5, 8)
    Clockwork.key9 = Clockwork.createDot("clockWork_key9", 10, -5, 9)
    Clockwork.key0 = Clockwork.createDot("clockWork_key0", 11, -5, 10)
    Clockwork.keyPar = Clockwork.createDot("clockWork_keyPar", 12, -5, 11)
    Clockwork.keyEq = Clockwork.createDot("clockWork_keyEq", 13, -5, 12)
end

function Clockwork.resetKeys()
    -- Clockwork.log.debug("function Clockwork.resetKeys(")

    Clockwork.keyQ.texture:SetColorTexture(0, 0, 0, 1)
    Clockwork.keyQ.priority = -1
    Clockwork.keyD.texture:SetColorTexture(0, 0, 0, 1)
    Clockwork.keyD.priority = -1
    Clockwork.keyR.texture:SetColorTexture(0, 0, 0, 1)
    Clockwork.keyR.priority = -1
    Clockwork.keyT.texture:SetColorTexture(0, 0, 0, 1)
    Clockwork.keyT.priority = -1
    Clockwork.keyF.texture:SetColorTexture(0, 0, 0, 1)
    Clockwork.keyF.priority = -1
    Clockwork.keyG.texture:SetColorTexture(0, 0, 0, 1)
    Clockwork.keyG.priority = -1
    Clockwork.keyEq.texture:SetColorTexture(0, 0, 0, 1)
    Clockwork.keyEq.priority = -1
    Clockwork.keyPar.texture:SetColorTexture(0, 0, 0, 1)
    Clockwork.keyPar.priority = -1
    Clockwork.key0.texture:SetColorTexture(0, 0, 0, 1)
    Clockwork.key0.priority = -1
    Clockwork.key9.texture:SetColorTexture(0, 0, 0, 1)
    Clockwork.key9.priority = -1
    Clockwork.key8.texture:SetColorTexture(0, 0, 0, 1)
    Clockwork.key8.priority = -1
    Clockwork.key7.texture:SetColorTexture(0, 0, 0, 1)
    Clockwork.key7.priority = -1
    Clockwork.key6.texture:SetColorTexture(0, 0, 0, 1)
    Clockwork.key6.priority = -1
    Clockwork.key5.texture:SetColorTexture(0, 0, 0, 1)
    Clockwork.key5.priority = -1
    Clockwork.key4.texture:SetColorTexture(0, 0, 0, 1)
    Clockwork.key4.priority = -1
    Clockwork.key3.texture:SetColorTexture(0, 0, 0, 1)
    Clockwork.key3.priority = -1
    Clockwork.key2.texture:SetColorTexture(0, 0, 0, 1)
    Clockwork.key2.priority = -1
    Clockwork.key1.texture:SetColorTexture(0, 0, 0, 1)
    Clockwork.key1.priority = -1
end

function Clockwork.shouldHitKey(params)
    -- Clockwork.log.debug("function Clockwork.shouldHitAltKey(" .. tostring(key) .. ", " .. tostring(should) .. ", " .. tostring(slot))

    Clockwork.shouldHitKeyWithModifier(params, nil)
end

function Clockwork.shouldHitKeyWithModifier(params, keyModificator)
    params.priority = Clockwork.ternary(Clockwork.emptyOrNil(params.priority), 1, params.priority)

    --Clockwork.log.debug("function Clockwork.shouldHitKey(" .. tostring(key) .. ", " .. tostring(should) .. ", " .. tostring(slot) .. ", " .. tostring(modificator))

    Clockwork.log.debug("key.slot = " .. tostring(params.key.slot))
    Clockwork.log.debug("should = " .. tostring(params.condition))
    Clockwork.log.debug("modificator = " .. tostring(keyModificator))

    if (params.condition == false) then
        return false
    end

    if (params.condition == nil or params.condition == true) then
        if not keyModificator then
            params.condition = Clockwork.actionCanBeCast(params.key.slot)
        end
        if keyModificator == Clockwork.SHIFT and params.key.shiftslot then
            params.condition = Clockwork.actionCanBeCast(params.key.shiftslot)
        end
        if keyModificator == Clockwork.ALT and params.key.altslot then
            params.condition = Clockwork.actionCanBeCast(params.key.altslot)
        end
    end

    -- Mode octal
    -- CTRL  = 1
    -- ALT   = 2
    -- SHIFT = 4
    --

    local sum = 0 +
        Clockwork.ternary(keyModificator == Clockwork.CTRL, 1, 0) +
        Clockwork.ternary(keyModificator == Clockwork.ALT, 2, 0) +
        Clockwork.ternary(keyModificator == Clockwork.SHIFT, 4, 0)


    local duration = Clockwork.ternary(params.duration == nil, 0, params.duration)

    if params.condition and params.priority > (params.key.priority or 0)
    --and not modificator
    then
        params.key.texture:SetColorTexture(sum / 255, params.priority / 255, duration / 30, 1)
        params.key.priority = params.priority
        --elseif condition and modificator == Clockwork.SHIFT then key.texture:SetColorTexture(1, 0, 0, 1)
        --elseif condition and modificator == Clockwork.CTRL then key.texture:SetColorTexture(0, 1, 0, 1)
        --elseif condition and modificator == Clockwork.ALT then key.texture:SetColorTexture(0, 0, 1, 1)
        return true
    else
        return false
    end
end

function Clockwork.shouldHitShiftKey(params)
    Clockwork.shouldHitKeyWithModifier(params, Clockwork.SHIFT)
end

function Clockwork.shouldHitCtrlKey(params)
    Clockwork.shouldHitKeyWithModifier(params, Clockwork.CTRL)
end

function Clockwork.shouldHitAltKey(params)
    Clockwork.shouldHitKeyWithModifier(params, Clockwork.ALT)
end
