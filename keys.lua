--ksuto.keyMaj = ksuto.createDot("ksuto_keyMaj", 2, -2)
--ksuto.keyCtrl = ksuto.createDot("ksuto_keyCtrl", 3, -2)
--ksuto.keyAlt = ksuto.createDot("ksuto_keyAlt", 4, -2)

ksuto.keyT = ksuto.createDot("ksuto_keyT", 6, -4)
ksuto.keyG = ksuto.createDot("ksuto_keyG", 5, -4)
ksuto.keyQ = ksuto.createDot("ksuto_keyQ", 4, -4)
ksuto.keyD = ksuto.createDot("ksuto_keyD", 3, -4)
ksuto.keyH = ksuto.createDot("ksuto_keyH", 2, -4)

ksuto.keyEq = ksuto.createDot("ksuto_keyEq", 13, -5)
ksuto.keyPar = ksuto.createDot("ksuto_keyPar", 12, -5)
ksuto.key0 = ksuto.createDot("ksuto_key0", 11, -5)
ksuto.key9 = ksuto.createDot("ksuto_key9", 10, -5)
ksuto.key8 = ksuto.createDot("ksuto_key8", 9, -5)
ksuto.key7 = ksuto.createDot("ksuto_key7", 8, -5)
ksuto.key6 = ksuto.createDot("ksuto_key6", 7, -5)
ksuto.key5 = ksuto.createDot("ksuto_key5", 6, -5)
ksuto.key4 = ksuto.createDot("ksuto_key4", 5, -5)
ksuto.key3 = ksuto.createDot("ksuto_key3", 4, -5)
ksuto.key2 = ksuto.createDot("ksuto_key2", 3, -5)
ksuto.key1 = ksuto.createDot("ksuto_key1", 2, -5)

function ksuto.shouldHitKey(key, should)

    if should then
        key.texture:SetTexture(1, 1, 1, 1)
        return true
    else
        key.texture:SetTexture(0, 0, 0, 1)
        return false
    end
end

function ksuto.shouldHitShiftedKey(key, should)

    if should then
        key.texture:SetTexture(0, 0, 1, 1)
        return true
    else
        key.texture:SetTexture(0, 0, 0, 1)
        return false
    end
end