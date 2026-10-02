-- Isolation des blocs d'affichage et de rotation.
-- En 12.0, une opération interdite sur une valeur secrète lève une erreur Lua : sans isolation, la première erreur
-- interrompt toute la mise à jour et fige l'ensemble du QR code. Chaque bloc est donc exécuté dans un pcall ;
-- la première erreur d'un bloc est signalée une fois dans le chat, les suivantes sont seulement comptées.

Clockwork.guardErrors = {}

--- Exécute fn(...) en isolant ses erreurs.
--- @param name string nom du bloc, pour le rapport
--- @param fn function
--- @return boolean ok
function Clockwork.guard(name, fn, ...)
    local ok, err = pcall(fn, ...)

    if not ok then
        local entry = Clockwork.guardErrors[name]
        if not entry then
            entry = { count = 0, message = tostring(err), since = date("%H:%M:%S") }
            Clockwork.guardErrors[name] = entry
            Clockwork.log.error("[" .. name .. "] " .. entry.message)
        end
        entry.count = entry.count + 1
    end

    return ok
end

--- Rapport des blocs en erreur depuis le chargement (ou le dernier /clk errors reset).
--- @return string
function Clockwork.guardReport()
    local names = {}
    for name in pairs(Clockwork.guardErrors) do table.insert(names, name) end
    table.sort(names)

    if #names == 0 then
        return "Aucun bloc en erreur."
    end

    local lines = {}
    for _, name in ipairs(names) do
        local entry = Clockwork.guardErrors[name]
        table.insert(lines, string.format("%-14s %6d erreur(s) depuis %s : %s", name, entry.count, entry.since, entry.message))
    end
    return table.concat(lines, "\n")
end

function Clockwork.guardReset()
    Clockwork.guardErrors = {}
end
