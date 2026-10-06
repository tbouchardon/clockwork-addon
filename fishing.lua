-- Résultat de chaque lancer de pêche, pour le Java (vérifier ses clics) et les statistiques du menu.
--
-- Un lancer = une canalisation du joueur pendant que la pêche est demandée (FISH_MOD). Son résultat :
--   prise          : butin de pêche ouvert (LOOT_READY / LOOT_OPENED et IsFishingLoot), butin automatique compris
--   échappé        : « Votre poisson s'est échappé » (UI_ERROR_MESSAGE, ERR_FISH_ESCAPED) : clic trop tardif
--   rien à ferrer  : « Aucun poisson n'a mordu » (ERR_FISH_NOT_HOOKED) : clic trop tôt, faux clic
--   rien           : fin de la canalisation sans rien de tout cela (pas de clic, ou clic hors du bouchon)
-- Le résultat est arrêté 1,5 s après la fin de la canalisation (le butin peut arriver juste après).
--
-- Case (5, 1) du bloc 1 : R = compteur de lancers terminés (modulo 256) / 255, G = résultat du dernier / 255
-- (1 prise, 2 échappé, 3 rien à ferrer, 4 rien). Le Java repère un nouveau lancer terminé au changement du compteur.

Clockwork.FISHING_OUTCOMES = { CAUGHT = 1, ESCAPED = 2, NOT_HOOKED = 3, NOTHING = 4 }

local SETTLE_DELAY = 1.5

Clockwork.fishing = {
    counter = 0,
    outcome = 0,
    stats = { casts = 0, caught = 0, escaped = 0, notHooked = 0, nothing = 0 },
}

local attempt -- lancer en cours ou en attente de son résultat

function Clockwork:initFishingCell()
    self.fishingResult = self:createDot("fishingResult", 5, -1)
end

function Clockwork:updateFishingCell()
    local fishing = Clockwork.fishing
    self.fishingResult.texture:SetColorTexture(fishing.counter / 255, fishing.outcome / 255, 0, 1)
end

local STAT_KEYS = { "caught", "escaped", "notHooked", "nothing" }

local function settle(finished)
    if finished.done then return end
    finished.done = true
    local outcome = finished.outcome or Clockwork.FISHING_OUTCOMES.NOTHING
    local fishing = Clockwork.fishing
    fishing.counter = (fishing.counter + 1) % 256
    fishing.outcome = outcome
    fishing.stats.casts = fishing.stats.casts + 1
    local key = STAT_KEYS[outcome]
    fishing.stats[key] = fishing.stats[key] + 1
    Clockwork.log.debug("Pêche : résultat " .. key)
    -- Case repeinte tout de suite : la grille n'est pas forcément mise à jour (ClockWork éteint pendant la pêche)
    Clockwork.guard("fishingResult", function() Clockwork:updateFishingCell() end)
end

--- Début d'une canalisation du joueur : un lancer de pêche si la pêche est demandée.
function Clockwork.recordFishingStart()
    if not Clockwork.FISH_MOD then return end
    if attempt and not attempt.done then settle(attempt) end
    attempt = {}
end

--- Fin de la canalisation : le résultat est arrêté un peu plus tard (butin, message d'erreur).
function Clockwork.recordFishingStop()
    local finished = attempt
    if not finished or finished.done or finished.stopping then return end
    finished.stopping = true
    C_Timer.After(SETTLE_DELAY, function() settle(finished) end)
end

local function setOutcome(outcome)
    if attempt and not attempt.done then attempt.outcome = attempt.outcome or outcome end
end

function Clockwork.recordFishingLoot()
    if IsFishingLoot and IsFishingLoot() then setOutcome(Clockwork.FISHING_OUTCOMES.CAUGHT) end
end

function Clockwork.recordFishingError(message)
    if message == nil then return end
    if ERR_FISH_ESCAPED and message == ERR_FISH_ESCAPED then
        setOutcome(Clockwork.FISHING_OUTCOMES.ESCAPED)
    elseif ERR_FISH_NOT_HOOKED and message == ERR_FISH_NOT_HOOKED then
        setOutcome(Clockwork.FISHING_OUTCOMES.NOT_HOOKED)
    end
end

--- Statistiques de la session pour le menu : « 12 prises / 15 lancers (80 %) ».
function Clockwork.fishingSummary()
    local stats = Clockwork.fishing.stats
    if stats.casts == 0 then return "aucun lancer" end
    return string.format("%d prise(s) / %d lancer(s) (%d %%), %d échappé(s), %d faux clic(s)", stats.caught, stats.casts,
        math.floor(stats.caught * 100 / stats.casts + 0.5), stats.escaped, stats.notHooked)
end
