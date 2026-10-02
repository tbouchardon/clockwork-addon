-- /clk testsecret : cartographie de ce que le client autorise sur les valeurs secrètes (12.0).
-- À lancer en combat (mannequin d'entraînement ciblé), puis hors combat pour comparer.
-- Section A : pour chaque API, l'appel passe-t-il, la valeur est-elle secrète, quelles opérations sont permises.
-- Section B : quels moyens d'affichage acceptent une valeur secrète (StatusBar, textures, courbes, texte).
-- Les API incertaines sont résolues dynamiquement : une API inexistante est signalée « absent ».

local function api(path)
    local object = _G
    for part in string.gmatch(path, "[^%.]+") do
        if type(object) ~= "table" then return nil end
        object = object[part]
    end
    return object
end

local function call(path, ...)
    local fn = api(path)
    if type(fn) ~= "function" then error("absent", 0) end
    return fn(...)
end

local function short(err)
    local message = tostring(err):gsub("^[^:]*:%d+: ", "")
    if #message > 80 then message = message:sub(1, 77) .. "..." end
    return message
end

local function isSecret(value)
    if type(issecretvalue) ~= "function" then return "?" end
    local ok, result = pcall(issecretvalue, value)
    if not ok then return "?" end
    return result and "oui" or "non"
end

-- Opérations testées sur chaque valeur ; KO sur un booléen ou nil est normal, seul KO sur un nombre est significatif
local OPERATIONS = {
    { "tostring", function(v) return tostring(v) end },
    { "calcul",   function(v) return v + 0 end },
    { "compare",  function(v) return v < 1 end },
    { "concat",   function(v) return "" .. v end },
    { "cle",      function(v) local t = {}; t[v] = true; return t end },
    { "if",       function(v) if v then return 1 end return 0 end },
}

local function probe(lines, label, getter)
    local okCall, value = pcall(getter)
    if not okCall then
        table.insert(lines, string.format("%-40s APPEL KO : %s", label, short(value)))
        return nil
    end

    local okType, valueType = pcall(type, value)
    local parts = { string.format("%-40s %-8s secret=%-3s", label, okType and valueType or "?", isSecret(value)) }

    for _, operation in ipairs(OPERATIONS) do
        local ok = pcall(operation[2], value)
        table.insert(parts, operation[1] .. "=" .. (ok and "OK" or "KO"))
    end

    local okString, text = pcall(tostring, value)
    if okString then table.insert(parts, "valeur=" .. text:sub(1, 24)) end

    table.insert(lines, table.concat(parts, " "))
    return value
end

local function display(lines, label, action)
    local ok, err = pcall(action)
    table.insert(lines, string.format("%-56s %s", label, ok and "OK" or ("KO : " .. short(err))))
end

--- Premier emplacement de barre d'action contenant un sort.
local function firstSpellSlot()
    for slot = 1, 180 do
        local ok, actionType, id = pcall(GetActionInfo, slot)
        if ok and actionType == "spell" and id then return slot, id end
    end
end

local function testFrame()
    local frame = Clockwork_SecretTestFrame or CreateFrame("Frame", "Clockwork_SecretTestFrame", UIParent)
    frame:SetSize(100, 20)
    frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -500, 500) -- hors écran
    if not frame.bar then
        frame.bar = CreateFrame("StatusBar", nil, frame)
        frame.bar:SetAllPoints()
        frame.bar:SetStatusBarTexture("Interface\\Buttons\\WHITE8X8")
        frame.texture = frame:CreateTexture(nil, "OVERLAY")
        frame.texture:SetSize(1, 1)
        frame.texture:SetPoint("TOPLEFT")
        frame.text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        frame.text:SetPoint("CENTER")
    end
    return frame
end

local function sectionValues(lines, unit)
    table.insert(lines, "")
    table.insert(lines, "--- A. Valeurs : " .. unit .. " ---")
    probe(lines, "UnitExists", function() return UnitExists(unit) end)
    probe(lines, "UnitHealth", function() return UnitHealth(unit) end)
    probe(lines, "UnitHealthMax", function() return UnitHealthMax(unit) end)
    probe(lines, "UnitHealthPercent(true)", function() return call("UnitHealthPercent", unit, true) end)
    probe(lines, "UnitHealthPercent(true, ScaleTo100)", function() return call("UnitHealthPercent", unit, true, api("CurveConstants.ScaleTo100")) end)
    probe(lines, "UnitPower", function() return UnitPower(unit) end)
    probe(lines, "UnitPowerMax", function() return UnitPowerMax(unit) end)
    probe(lines, "UnitPower(ComboPoints)", function() return UnitPower(unit, Enum.PowerType.ComboPoints) end)
    probe(lines, "UnitAffectingCombat", function() return UnitAffectingCombat(unit) end)
    probe(lines, "UnitIsDeadOrGhost", function() return UnitIsDeadOrGhost(unit) end)
    probe(lines, "UnitCastingInfo (nom)", function() return (UnitCastingInfo(unit)) end)
    probe(lines, "Aura aidante 1 : table", function() return call("C_UnitAuras.GetAuraDataByIndex", unit, 1, "HELPFUL") end)
    probe(lines, "Aura aidante 1 : spellId", function() return call("C_UnitAuras.GetAuraDataByIndex", unit, 1, "HELPFUL").spellId end)
    probe(lines, "Aura aidante 1 : expirationTime", function() return call("C_UnitAuras.GetAuraDataByIndex", unit, 1, "HELPFUL").expirationTime end)
    probe(lines, "Aura nuisible 1 : spellId", function() return call("C_UnitAuras.GetAuraDataByIndex", unit, 1, "HARMFUL").spellId end)
    probe(lines, "Aura nuisible 1 : expirationTime", function() return call("C_UnitAuras.GetAuraDataByIndex", unit, 1, "HARMFUL").expirationTime end)
end

local function sectionPlayerOnly(lines)
    table.insert(lines, "")
    table.insert(lines, "--- A. Valeurs : joueur, actions et position ---")
    probe(lines, "UnitReaction(player, target)", function() return UnitReaction("player", "target") end)
    probe(lines, "GetPlayerFacing", function() return call("GetPlayerFacing") end)
    probe(lines, "GetPlayerMapPosition.x", function()
        return C_Map.GetPlayerMapPosition(C_Map.GetBestMapForUnit("player"), "player").x
    end)

    local slot, spellId = firstSpellSlot()
    if slot then
        table.insert(lines, "(emplacement d'action testé : " .. slot .. ", sort " .. tostring(spellId) .. ")")
        probe(lines, "GetActionCooldown : start", function() return (GetActionCooldown(slot)) end)
        probe(lines, "GetActionCooldown : duration", function() return select(2, GetActionCooldown(slot)) end)
        probe(lines, "IsUsableAction", function() return (IsUsableAction(slot)) end)
        probe(lines, "IsActionInRange", function() return IsActionInRange(slot) end)
        probe(lines, "C_Spell.GetSpellCooldown : startTime", function() return call("C_Spell.GetSpellCooldown", spellId).startTime end)
        probe(lines, "C_Spell.IsSpellUsable", function() return (call("C_Spell.IsSpellUsable", spellId)) end)
    else
        table.insert(lines, "(aucun sort dans les barres d'action)")
    end

    probe(lines, "C_AssistedCombat.IsAvailable", function() return (call("C_AssistedCombat.IsAvailable")) end)
    probe(lines, "C_AssistedCombat.GetNextCastSpell", function() return call("C_AssistedCombat.GetNextCastSpell") end)
    probe(lines, "GetTime (témoin, jamais secret)", function() return GetTime() end)
end

local function sectionDisplay(lines, unit)
    table.insert(lines, "")
    table.insert(lines, "--- B. Affichage d'une valeur secrète : " .. unit .. " ---")

    local frame = testFrame()
    local okPercent, percent = pcall(call, "UnitHealthPercent", unit, true)
    local okPercent100, percent100 = pcall(call, "UnitHealthPercent", unit, true, api("CurveConstants.ScaleTo100"))
    if not okPercent or not okPercent100 then
        table.insert(lines, "UnitHealthPercent indisponible (" .. short(okPercent and percent100 or percent) .. ") : tests sur UnitHealth / UnitHealthMax")
        local ratio = function() return UnitHealth(unit) / UnitHealthMax(unit) end
        local okRatio, value = pcall(ratio)
        percent, percent100 = okRatio and value or nil, okRatio and value * 100 or nil
    end

    display(lines, "StatusBar:SetValue(UnitHealthPercent), bornes 0..1", function()
        frame.bar:SetMinMaxValues(0, 1)
        frame.bar:SetValue(percent)
    end)
    probe(lines, "StatusBar:GetValue() ensuite", function() return frame.bar:GetValue() end)
    display(lines, "StatusBar:SetMinMaxValues(0, UnitHealthMax) + SetValue(UnitHealth)", function()
        frame.bar:SetMinMaxValues(0, UnitHealthMax(unit))
        frame.bar:SetValue(UnitHealth(unit))
    end)
    display(lines, "Texture:SetColorTexture(UnitHealthPercent, 0, 0, 1)", function()
        frame.texture:SetColorTexture(percent, 0, 0, 1)
    end)
    display(lines, "Texture:SetVertexColor(UnitHealthPercent, 0, 0, 1)", function()
        frame.texture:SetVertexColor(percent, 0, 0, 1)
    end)
    display(lines, "Texture:SetAlpha(UnitHealthPercent)", function()
        frame.texture:SetAlpha(percent)
    end)
    display(lines, "Texture:SetWidth(UnitHealthPercent ScaleTo100)", function()
        frame.texture:SetWidth(percent100)
    end)
    display(lines, "FontString:SetText(UnitHealth)", function()
        frame.text:SetText(UnitHealth(unit))
    end)
    display(lines, "FontString:SetFormattedText(\"%d\", UnitHealth)", function()
        frame.text:SetFormattedText("%d", UnitHealth(unit))
    end)

    -- Courbe de couleur : si elle passe, l'encodage actuel (un pixel, rouge = PV) peut être conservé
    local okCurve, curve = pcall(function()
        local created = call("C_CurveUtil.CreateColorCurve")
        created:AddPoint(0, CreateColor(0, 0, 0, 1))
        created:AddPoint(1, CreateColor(1, 0, 0, 1))
        return created
    end)
    if not okCurve then
        table.insert(lines, string.format("%-56s KO : %s", "C_CurveUtil.CreateColorCurve + AddPoint", short(curve)))
        return
    end
    local okColor, color = pcall(call, "UnitHealthPercent", unit, true, curve)
    if not okColor then
        table.insert(lines, string.format("%-56s KO : %s", "UnitHealthPercent(unit, true, courbe)", short(color)))
        return
    end
    probe(lines, "Courbe : couleur obtenue", function() return color end)
    probe(lines, "Courbe : couleur.r", function() return color.r end)
    display(lines, "Courbe : Texture:SetVertexColor(couleur:GetRGBA())", function()
        frame.texture:SetVertexColor(color:GetRGBA())
    end)
    display(lines, "Courbe : Texture:SetColorTexture(couleur:GetRGBA())", function()
        frame.texture:SetColorTexture(color:GetRGBA())
    end)
end

function Clockwork.testSecrets()
    local lines = {}
    local version, build, _, interface = GetBuildInfo()

    table.insert(lines, "=== Clockwork /clk testsecret ===")
    table.insert(lines, string.format("Client %s (%s), interface %s, %s", tostring(version), tostring(build), tostring(interface), date("%Y-%m-%d %H:%M:%S")))
    table.insert(lines, string.format("En combat : %s | verrou de combat : %s | cible : %s | issecretvalue : %s",
        tostring(UnitAffectingCombat("player")), tostring(InCombatLockdown()), tostring(UnitExists("target")),
        type(issecretvalue) == "function" and "présent" or "absent"))
    table.insert(lines, "Lecture : KO sur un nombre = opération interdite par le client ; KO sur nil/booléen = normal.")

    sectionValues(lines, "player")
    if UnitExists("target") then sectionValues(lines, "target") end
    sectionPlayerOnly(lines)
    sectionDisplay(lines, "player")
    if UnitExists("target") then sectionDisplay(lines, "target") end

    table.insert(lines, "")
    table.insert(lines, "--- C. Blocs du QR code en erreur (Clockwork.guard) ---")
    table.insert(lines, Clockwork.guardReport())

    Clockwork.showTextWindow(table.concat(lines, "\n"))
end
