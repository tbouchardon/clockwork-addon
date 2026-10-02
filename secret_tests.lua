-- /clk testsecret : cartographie de ce que le client autorise sur les valeurs secrètes (12.0).
-- À lancer en combat (mannequin d'entraînement ciblé), puis hors combat pour comparer.
-- Section A : pour chaque API, l'appel passe-t-il, la valeur est-elle secrète, quelles opérations sont permises.
-- Section B : quels moyens d'affichage acceptent une valeur secrète (StatusBar, textures, courbes, texte).
-- Section G : durée restante de vos debuffs sur la cible (objets durée des auras).
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

--- Texte affichable d'une valeur, sans jamais manipuler de chaîne secrète (tostring d'un secret renvoie un secret).
local function safeText(value)
    if isSecret(value) == "oui" then return "<secret>" end
    local ok, text = pcall(tostring, value)
    if not ok then return "<illisible>" end
    if isSecret(text) == "oui" then return "<secret>" end
    local okSub, truncated = pcall(string.sub, text, 1, 24)
    return okSub and truncated or "<illisible>"
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

    table.insert(parts, "valeur=" .. safeText(value))

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
        local ok, found = pcall(function()
            local actionType, id = GetActionInfo(slot)
            return actionType == "spell" and id ~= nil
        end)
        if ok and found then return slot, select(2, GetActionInfo(slot)) end
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
    probe(lines, "UnitPowerPercent(unit)", function() return call("UnitPowerPercent", unit) end)
    probe(lines, "UnitPowerPercent(unit, type)", function() return call("UnitPowerPercent", unit, UnitPowerType(unit)) end)
    probe(lines, "UnitPowerPercent(unit, type, true)", function() return call("UnitPowerPercent", unit, UnitPowerType(unit), true) end)
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
        table.insert(lines, "(emplacement d'action testé : " .. slot .. ", sort " .. safeText(spellId) .. ")")
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
    local nextSpell = probe(lines, "C_AssistedCombat.GetNextCastSpell", function() return call("C_AssistedCombat.GetNextCastSpell") end)
    probe(lines, "FindSpellActionButtons(sort recommandé)", function()
        local slots = call("C_ActionBar.FindSpellActionButtons", nextSpell)
        return slots and slots[1]
    end)
    probe(lines, "IsSpellOverlayed (sort testé)", function() return call("C_SpellActivationOverlay.IsSpellOverlayed", spellId) end)
    probe(lines, "IsSpellOverlayed global (sort testé)", function() return call("IsSpellOverlayed", spellId) end)
    probe(lines, "Barres de vie visibles", function() return #call("C_NamePlate.GetNamePlates") end)
    probe(lines, "Barre 1 : UnitCanAttack", function()
        local plate = call("C_NamePlate.GetNamePlates")[1]
        return UnitCanAttack("player", plate.namePlateUnitToken)
    end)
    probe(lines, "Barre 1 : UnitAffectingCombat", function()
        local plate = call("C_NamePlate.GetNamePlates")[1]
        return UnitAffectingCombat(plate.namePlateUnitToken)
    end)
    probe(lines, "Barre 1 : UnitThreatSituation", function()
        local plate = call("C_NamePlate.GetNamePlates")[1]
        return UnitThreatSituation("player", plate.namePlateUnitToken)
    end)
    probe(lines, "GetTime (témoin, jamais secret)", function() return GetTime() end)
end

--- Bilan sur tous les emplacements de barre : pour chaque API, nombre d'emplacements testés, secrets et en erreur.
local function sectionAllSlots(lines)
    table.insert(lines, "")
    table.insert(lines, "--- A. Bilan sur tous les emplacements de barre (testés / secrets / erreurs) ---")

    local checks = {
        { "GetActionCooldown start", function(slot) return (GetActionCooldown(slot)) end },
        { "IsUsableAction",          function(slot) return (IsUsableAction(slot)) end },
        { "IsActionInRange",         function(slot) return IsActionInRange(slot) end },
        { "ActionHasRange",          function(slot) return ActionHasRange(slot) end },
        { "GetSpellInfo castTime",   function(_, id) return call("C_Spell.GetSpellInfo", id).castTime end },
        { "GetSpellCharges current", function(_, id)
            local charges = call("C_Spell.GetSpellCharges", id)
            return charges and charges.currentCharges
        end },
    }

    local slots = {}
    for slot = 1, 180 do
        local ok, actionType, id = pcall(function()
            local actionType, id = GetActionInfo(slot)
            if actionType == "spell" then return actionType, id end
        end)
        if ok and actionType then table.insert(slots, { slot = slot, id = id }) end
    end
    table.insert(lines, #slots .. " emplacement(s) contenant un sort")

    for _, check in ipairs(checks) do
        local secrets, errors, firstError = 0, 0, nil
        for _, entry in ipairs(slots) do
            local ok, value = pcall(check[2], entry.slot, entry.id)
            if not ok then
                errors = errors + 1
                firstError = firstError or short(value)
            elseif isSecret(value) == "oui" then
                secrets = secrets + 1
            end
        end
        table.insert(lines, string.format("%-28s %3d / %3d / %3d%s", check[1], #slots, secrets, errors,
            firstError and ("  (" .. firstError .. ")") or ""))
    end
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
    display(lines, "Texture:SetColorTexture(0, 0, UnitPowerPercent(unit, type, true), 1)", function()
        frame.texture:SetColorTexture(0, 0, call("UnitPowerPercent", unit, UnitPowerType(unit), true), 1)
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
        safeText(UnitAffectingCombat("player")), safeText(InCombatLockdown()), safeText(UnitExists("target")),
        type(issecretvalue) == "function" and "présent" or "absent"))
    table.insert(lines, "Lecture : KO sur un nombre = opération interdite par le client ; KO sur nil/booléen = normal.")

    sectionValues(lines, "player")
    if UnitExists("target") then sectionValues(lines, "target") end
    sectionPlayerOnly(lines)
    sectionAllSlots(lines)
    sectionDisplay(lines, "player")
    if UnitExists("target") then sectionDisplay(lines, "target") end

    table.insert(lines, "")
    table.insert(lines, "--- C. Blocs du QR code en erreur (Clockwork.guard) ---")
    table.insert(lines, Clockwork.guardReport())

    Clockwork.combatLogReport(lines)
    Clockwork.sectionWorkarounds(lines)
    Clockwork.sectionAuras(lines)

    table.insert(lines, "")
    table.insert(lines, "--- D. Événements refusés par le client ---")
    local refused = false
    for eventName, err in pairs(Clockwork.refusedEvents or {}) do
        table.insert(lines, eventName .. " : " .. short(err))
        refused = true
    end
    if not refused then table.insert(lines, "Aucun.") end

    Clockwork.showTextWindow(table.concat(lines, "\n"))
end

-- Enregistreurs pour la section E : ce que le client transmet encore (UNIT_AURA, incantations réussies, surbrillances).
-- Le journal de combat (COMBAT_LOG_EVENT_UNFILTERED) est réservé à l'interface de Blizzard en 12.x.

Clockwork.auraProbe = { events = 0, errors = 0, added = 0, secretFields = {}, examples = {} }
Clockwork.castProbe = { events = 0, secretSpellId = 0, secretGUID = 0, examples = {} }
Clockwork.glowProbe = { events = 0, secretSpellId = 0, examples = {} }

local function remember(list, line, size)
    if #list >= size then table.remove(list, 1) end
    table.insert(list, line)
end

local function spellName(spellId)
    if isSecret(spellId) == "oui" then return "<secret>" end
    local ok, name = pcall(call, "C_Spell.GetSpellName", spellId)
    return ok and safeText(name) or "?"
end

function Clockwork.recordCastSucceeded(unit, castGUID, spellId)
    if unit ~= "player" then return end
    local probe = Clockwork.castProbe
    probe.events = probe.events + 1
    if isSecret(spellId) == "oui" then probe.secretSpellId = probe.secretSpellId + 1 end
    if isSecret(castGUID) == "oui" then probe.secretGUID = probe.secretGUID + 1 end
    remember(probe.examples, string.format("t=%.1f spellId=%s %s", GetTime(), safeText(spellId), spellName(spellId)), 10)
    if isSecret(spellId) ~= "oui" and probe.spellIds then probe.spellIds[spellId] = true end
end

function Clockwork.recordOverlayGlow(state, spellId)
    local probe = Clockwork.glowProbe
    probe.events = probe.events + 1
    if isSecret(spellId) == "oui" then probe.secretSpellId = probe.secretSpellId + 1 end
    remember(probe.examples, string.format("t=%.1f %-7s spellId=%s %s", GetTime(), state, safeText(spellId), spellName(spellId)), 10)
end

function Clockwork.recordUnitAura(unit, updateInfo)
    if unit ~= "player" and unit ~= "target" then return end
    local probe = Clockwork.auraProbe
    probe.events = probe.events + 1

    local ok, err = pcall(function()
        if not updateInfo or not updateInfo.addedAuras then return end
        for _, aura in ipairs(updateInfo.addedAuras) do
            probe.added = probe.added + 1
            for _, field in ipairs({ "spellId", "name", "duration", "expirationTime", "sourceUnit", "isFromPlayerOrPlayerPet", "auraInstanceID" }) do
                if isSecret(aura[field]) == "oui" then probe.secretFields[field] = (probe.secretFields[field] or 0) + 1 end
            end
            remember(probe.examples, string.format("%-6s spellId=%s %s durée=%s fin=%s source=%s", unit,
                safeText(aura.spellId), safeText(aura.name), safeText(aura.duration), safeText(aura.expirationTime),
                safeText(aura.sourceUnit)), 10)
        end
    end)

    if not ok then
        probe.errors = probe.errors + 1
        probe.lastError = short(err)
    end
end

function Clockwork.combatLogReport(lines)
    local cast = Clockwork.castProbe
    table.insert(lines, "")
    table.insert(lines, "--- E. Incantations réussies du joueur (UNIT_SPELLCAST_SUCCEEDED, depuis le chargement) ---")
    table.insert(lines, string.format("%d événement(s), spellId secret %d fois, castGUID secret %d fois", cast.events, cast.secretSpellId, cast.secretGUID))
    for _, line in ipairs(cast.examples) do table.insert(lines, "  " .. line) end

    local glow = Clockwork.glowProbe
    table.insert(lines, "")
    table.insert(lines, "--- E. Surbrillances de procs (SPELL_ACTIVATION_OVERLAY_GLOW_SHOW / HIDE) ---")
    table.insert(lines, string.format("%d événement(s), spellId secret %d fois", glow.events, glow.secretSpellId))
    for _, line in ipairs(glow.examples) do table.insert(lines, "  " .. line) end

    local aura = Clockwork.auraProbe
    table.insert(lines, "")
    table.insert(lines, "--- E. UNIT_AURA (joueur et cible, depuis le chargement) ---")
    table.insert(lines, string.format("%d événement(s), %d aura(s) ajoutée(s), %d erreur(s)%s", aura.events, aura.added, aura.errors,
        aura.lastError and (" (" .. aura.lastError .. ")") or ""))
    for field, secrets in pairs(aura.secretFields) do
        table.insert(lines, string.format("  %-24s secret %d / %d", field, secrets, aura.added))
    end
    table.insert(lines, "Dernières auras ajoutées :")
    for _, line in ipairs(aura.examples) do table.insert(lines, "  " .. line) end
end

-- Section F : contournements trouvés dans la documentation de l'API 12.1 (Blizzard_APIDocumentationGenerated).

-- Sorts lancés par le joueur, pour tester leur niveau de secret (rempli par recordCastSucceeded)
Clockwork.castProbe.spellIds = Clockwork.castProbe.spellIds or {}

-- Surbrillances de procs relevées en continu (l'événement peut ne pas arriver : on interroge aussi l'API)
Clockwork.overlayProbe = { scans = 0, seen = {} }

local function barSpells()
    local spells = {}
    for slot = 1, 180 do
        local ok, actionType, id = pcall(function()
            local actionType, id = GetActionInfo(slot)
            if actionType == "spell" then return actionType, id end
        end)
        if ok and actionType then table.insert(spells, { slot = slot, id = id }) end
    end
    return spells
end

C_Timer.NewTicker(0.25, function()
    local probe = Clockwork.overlayProbe
    probe.scans = probe.scans + 1
    pcall(function()
        for _, entry in ipairs(barSpells()) do
            local ok, glowing = pcall(call, "C_SpellActivationOverlay.IsSpellOverlayed", entry.id)
            if ok and glowing == true then probe.seen[entry.id] = GetTime() end
        end
    end)
end)

local SECRECY = { [0] = "jamais", [1] = "toujours", [2] = "selon contexte" }

local function secrecy(path, id)
    local ok, level = pcall(call, path, id)
    if not ok then return "KO" end
    return SECRECY[level] or safeText(level)
end

local function sectionWorkarounds(lines)
    table.insert(lines, "")
    table.insert(lines, "--- F. Restrictions actives (C_RestrictedActions) ---")
    local states = { [0] = "inactive", [1] = "en cours d'activation", [2] = "active" }
    for name, value in pairs(Enum.AddOnRestrictionType or {}) do
        local ok, state = pcall(call, "C_RestrictedActions.GetAddOnRestrictionState", value)
        table.insert(lines, string.format("  %-14s %s", name, ok and (states[state] or safeText(state)) or ("KO : " .. short(state))))
    end
    for _, name in ipairs({ "HasSecretRestrictions", "ShouldAurasBeSecret", "ShouldCooldownsBeSecret", "ShouldUnitStatsBeSecret" }) do
        probe(lines, "C_Secrets." .. name, function() return call("C_Secrets." .. name) end)
    end
    probe(lines, "C_Secrets.ShouldUnitIdentityBeSecret(target)", function() return call("C_Secrets.ShouldUnitIdentityBeSecret", "target") end)
    probe(lines, "UnitGUID(target)", function() return UnitGUID("target") end)

    table.insert(lines, "")
    table.insert(lines, "--- F. Secret par sort : aura / incantation / recharge, et lecture de l'aura en combat ---")
    local ids, seen = {}, {}
    for _, entry in ipairs(barSpells()) do
        if not seen[entry.id] then table.insert(ids, entry.id); seen[entry.id] = true end
    end
    for id in pairs(Clockwork.castProbe.spellIds) do
        if not seen[id] then table.insert(ids, id); seen[id] = true end
    end
    for _, id in ipairs(ids) do
        local okAura, aura = pcall(call, "C_UnitAuras.GetPlayerAuraBySpellID", id)
        local auraText = okAura and (aura and ("aura lue, fin=" .. safeText(aura.expirationTime)) or "pas d'aura") or ("KO : " .. short(aura))
        table.insert(lines, string.format("  %-8s %-24s aura=%-15s cast=%-15s recharge=%-15s %s", safeText(id), spellName(id),
            secrecy("C_Secrets.GetSpellAuraSecrecy", id), secrecy("C_Secrets.GetSpellCastSecrecy", id),
            secrecy("C_Secrets.GetSpellCooldownSecrecy", id), auraText))
    end

    table.insert(lines, "")
    table.insert(lines, "--- F. Variantes de sorts (recommandation de Blizzard -> bouton) ---")
    local okNext, nextSpell = pcall(call, "C_AssistedCombat.GetNextCastSpell")
    if okNext and nextSpell then
        probe(lines, "GetNextCastSpell", function() return nextSpell end)
        probe(lines, "GetBaseSpell(recommandé)", function() return call("C_Spell.GetBaseSpell", nextSpell) end)
        probe(lines, "Bouton du sort de base", function()
            local slots = call("C_ActionBar.FindSpellActionButtons", call("C_Spell.GetBaseSpell", nextSpell))
            return slots and slots[1]
        end)
    end
    for _, entry in ipairs(barSpells()) do
        local ok, override = pcall(call, "C_Spell.GetOverrideSpell", entry.id)
        if ok and override and isSecret(override) ~= "oui" and override ~= entry.id then
            table.insert(lines, string.format("  bouton %d : %s %s -> variante %s %s", entry.slot, safeText(entry.id), spellName(entry.id), safeText(override), spellName(override)))
        end
    end

    table.insert(lines, "")
    table.insert(lines, "--- F. Temps de recharge via objet durée (C_Spell.GetSpellCooldownDuration) ---")
    local frame = testFrame()
    for _, entry in ipairs(barSpells()) do
        local okDuration, duration = pcall(call, "C_Spell.GetSpellCooldownDuration", entry.id)
        if okDuration and duration then
            local label = string.format("bouton %d %s", entry.slot, spellName(entry.id))
            probe(lines, label .. " : HasSecretValues", function() return duration:HasSecretValues() end)
            probe(lines, label .. " : IsActive", function() return duration:IsActive() end)
            probe(lines, label .. " : GetRemainingPercent", function() return duration:GetRemainingPercent() end)
            display(lines, label .. " : SetColorTexture(RemainingPercent)", function()
                frame.texture:SetColorTexture(duration:GetRemainingPercent(), 0, 0, 1)
            end)
            display(lines, label .. " : courbe 0..60 s -> SetColorTexture", function()
                local curve = call("C_CurveUtil.CreateCurve")
                curve:AddPoint(0, 0)
                curve:AddPoint(60, 1)
                frame.texture:SetColorTexture(duration:EvaluateRemainingDuration(curve), 0, 0, 1)
            end)
            display(lines, label .. " : IsActive -> EvaluateColorFromBoolean", function()
                local color = call("C_CurveUtil.EvaluateColorFromBoolean", duration:IsActive(), CreateColor(1, 1, 1, 1), CreateColor(0, 0, 0, 1))
                frame.texture:SetColorTexture(color:GetRGBA())
            end)
            break -- un seul bouton suffit pour valider la méthode
        elseif not okDuration then
            table.insert(lines, "  GetSpellCooldownDuration KO : " .. short(duration))
            break
        end
    end

    table.insert(lines, "")
    table.insert(lines, "--- F. Ennemis proches (barres de vie, jetons nameplateN) ---")
    local plates, hostile, hostileInCombat, errors, firstError = 0, 0, 0, 0, nil
    for index = 1, 40 do
        local unit = "nameplate" .. index
        local ok, err = pcall(function()
            if not UnitExists(unit) then return end
            plates = plates + 1
            if UnitCanAttack("player", unit) then
                hostile = hostile + 1
                if UnitAffectingCombat(unit) then hostileInCombat = hostileInCombat + 1 end
            end
        end)
        if not ok then errors = errors + 1; firstError = firstError or short(err) end
    end
    table.insert(lines, string.format("  %d barre(s), %d attaquable(s), %d attaquable(s) en combat, %d erreur(s)%s",
        plates, hostile, hostileInCombat, errors, firstError and (" (" .. firstError .. ")") or ""))

    table.insert(lines, "")
    table.insert(lines, string.format("--- F. Procs relevés par IsSpellOverlayed (%d relevés depuis le chargement) ---", Clockwork.overlayProbe.scans))
    local any = false
    for id, time in pairs(Clockwork.overlayProbe.seen) do
        table.insert(lines, string.format("  %s %s, dernier vu à t=%.1f", safeText(id), spellName(id), time))
        any = true
    end
    if not any then table.insert(lines, "  aucun") end
end

Clockwork.sectionWorkarounds = sectionWorkarounds

-- Section G : durée restante des debuffs du joueur sur la cible, malgré le secret des auras en combat.
-- Piste : C_UnitAuras.GetAuraDuration rend un objet durée, que l'on peut convertir en couleur comme les temps de recharge.
-- Reste à savoir si l'on obtient un auraInstanceID utilisable (non secret) et à quel sort il correspond.

local function sectionAuras(lines)
    table.insert(lines, "")
    table.insert(lines, "--- G. Debuffs du joueur sur la cible : identifiants d'instance et objets durée ---")
    if not UnitExists("target") then
        table.insert(lines, "  pas de cible : cibler un mannequin portant un de vos debuffs")
        return
    end

    local frame = testFrame()
    local curve = select(2, pcall(function()
        local created = call("C_CurveUtil.CreateCurve")
        created:AddPoint(0, 0)
        created:AddPoint(60, 1)
        return created
    end))

    local function durationProbes(label, instanceID)
        probe(lines, label .. " : instance secrète (SecretUtil)", function() return call("C_Secrets.ShouldUnitAuraInstanceBeSecret", "target", instanceID) end)
        probe(lines, label .. " : spellId", function() return call("C_UnitAuras.GetAuraDataByAuraInstanceID", "target", instanceID).spellId end)
        local okDuration, duration = pcall(call, "C_UnitAuras.GetAuraDuration", "target", instanceID)
        if not okDuration then
            table.insert(lines, string.format("%-56s KO : %s", label .. " : GetAuraDuration", short(duration)))
            return
        end
        probe(lines, label .. " : durée HasSecretValues", function() return duration:HasSecretValues() end)
        probe(lines, label .. " : durée GetRemainingDuration", function() return duration:GetRemainingDuration() end)
        display(lines, label .. " : courbe 0..60 s -> SetColorTexture", function()
            frame.texture:SetColorTexture(duration:EvaluateRemainingDuration(curve), 0, 0, 1)
        end)
    end

    -- 1. Liste des instances posées par le joueur
    local okIds, ids = pcall(call, "C_UnitAuras.GetUnitAuraInstanceIDs", "target", "HARMFUL|PLAYER")
    if not okIds then
        table.insert(lines, "  GetUnitAuraInstanceIDs(HARMFUL|PLAYER) KO : " .. short(ids))
    else
        local okCount, count = pcall(function() return #ids end)
        table.insert(lines, string.format("  GetUnitAuraInstanceIDs(HARMFUL|PLAYER) : table secrète=%s, %s instance(s)",
            isSecret(ids), okCount and safeText(count) or "<illisible>"))
        for index = 1, 5 do
            local okId, instanceID = pcall(function() return ids[index] end)
            if not okId or instanceID == nil then break end
            probe(lines, "instance " .. index .. " : identifiant", function() return instanceID end)
            durationProbes("instance " .. index, instanceID)
        end
    end

    -- 2. Recherche par sort : sorts des barres et sorts lancés depuis le chargement
    table.insert(lines, "")
    table.insert(lines, "  Recherche par sort (GetUnitAuraBySpellID sur la cible) :")
    local ids2, seen = {}, {}
    for _, entry in ipairs(barSpells()) do
        if not seen[entry.id] then table.insert(ids2, entry.id); seen[entry.id] = true end
    end
    for id in pairs(Clockwork.castProbe.spellIds) do
        if not seen[id] then table.insert(ids2, id); seen[id] = true end
    end
    local found = 0
    for _, id in ipairs(ids2) do
        local okAura, aura = pcall(call, "C_UnitAuras.GetUnitAuraBySpellID", "target", id)
        local label = safeText(id) .. " " .. spellName(id)
        if not okAura then
            table.insert(lines, string.format("%-56s KO : %s", "  " .. label, short(aura)))
        elseif isSecret(aura) == "oui" then
            table.insert(lines, string.format("%-56s aura secrète", "  " .. label))
        elseif aura then
            found = found + 1
            probe(lines, "  " .. label .. " : sort secret (SecretUtil)", function() return call("C_Secrets.ShouldSpellAuraBeSecret", id) end)
            probe(lines, "  " .. label .. " : auraInstanceID", function() return aura.auraInstanceID end)
            probe(lines, "  " .. label .. " : expirationTime", function() return aura.expirationTime end)
            durationProbes("  " .. label, aura.auraInstanceID)
        end
        if found >= 3 then break end
    end
    if found == 0 then table.insert(lines, "  aucune aura trouvée par sort (ou toutes secrètes / KO, voir ci-dessus)") end
end

Clockwork.sectionAuras = sectionAuras
