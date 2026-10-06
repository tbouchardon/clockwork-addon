# ClockWork Addon

Addon World of Warcraft qui **affiche l'état du jeu sous forme de grille de pixels colorés** (un « QR code » maison)
dans le coin haut gauche de l'écran. L'application Java [ClockWork](https://github.com/tbouchardon/clockwork-robot) capture
cette grille, la décode et appuie sur les touches à la place du joueur.

L'addon ne joue jamais lui-même : il n'en a pas le droit. Un addon ne peut ni lancer un sort ni déplacer le personnage
en dehors d'un clic du joueur. Il se contente de **décrire** la situation, et c'est le programme externe qui agit.

Branche `12.0` : WoW Midnight (12.x). Grille v3 testée en 12.1.0 build 69933 ; la v4 (groupe, objets, résultat de
pêche, identifiant de cible, ressource de classe) et les raccourcis clavier ne sont pas encore testés en jeu.

---

## Sommaire

1. [Principe](#principe)
2. [Installation et déploiement](#installation-et-déploiement)
3. [Menu en jeu](#menu-en-jeu)
4. [Raccourcis clavier](#raccourcis-clavier)
5. [Commandes en jeu](#commandes-en-jeu)
6. [Organisation du code](#organisation-du-code)
7. [Cycle de mise à jour](#cycle-de-mise-à-jour)
8. [La grille](#la-grille)
9. [Groupe, raid et mode soigneur](#groupe-raid-et-mode-soigneur)
10. [Pêche : résultat de chaque lancer](#pêche--résultat-de-chaque-lancer)
11. [Les valeurs secrètes de la 12.x](#les-valeurs-secrètes-de-la-12x)
12. [Robustesse et diagnostic](#robustesse-et-diagnostic)

---

## Principe

```
 WoW + addon                             ClockWork (Java)
┌──────────────────────────┐   capture   ┌───────────────────────────┐
│ état du jeu → pixels     │ ──────────► │ pixels → état du jeu      │
│ (QR code 32x32, 0,23)    │   d'écran   │ rotation YAML → décision  │
│                          │ ◄────────── │ décision → touche clavier │
└──────────────────────────┘   clavier   └───────────────────────────┘
```

Deux modes de décision coexistent :

| Mode | Qui décide ? | Grille utilisée |
|---|---|---|
| **Historique (v1)** | L'addon : chaque rotation Lua (`rotation_<classe>.lua`) allume la case de la touche à appuyer, avec une priorité. | Cases « touche à appuyer » (lignes 4 et 5). |
| **Cerveau Java (v2 à v4)** | Le Java : l'addon décrit l'état de *toutes* les touches (prête, à portée, temps de recharge, dernier lancement…) et du groupe, le Java applique les règles de `rotation.yaml`. | Cases d'état, d'historique et de sort de chaque touche, dans les quatre blocs ; membres du groupe dans le bloc 2. |

Depuis la 12.x, la plupart des valeurs de combat sont **secrètes** pour les addons (voir plus bas). Les rotations Lua ne
peuvent plus comparer la vie ou les temps de recharge. Le mode cerveau Java contourne le problème : l'addon passe ces
valeurs secrètes directement à l'affichage, sans les lire, et c'est le Java qui les lit à l'écran.

---

## Installation et déploiement

Le dossier du dépôt **n'est pas** le dossier de l'addon dans WoW. On déploie par copie :

```bat
deploy.cmd
```

Ce script fait un `robocopy /MIR` vers `E:\Perso\World of Warcraft\_retail_\Interface\AddOns\ClockWork`, sans les
fichiers de développement (`.git`, `.idea`, `deploy.cmd`, `QR Code.ods`, `wp.txt`, `*.iml`…). Ensuite, en jeu :
`/reload`.

Fichiers chargés : voir `ClockWork.toc`. L'ordre compte : `core.lua` crée la table `Clockwork`, `init_addon.lua`
enregistre les événements et démarre la boucle.

SavedVariables (écrites par WoW sur le disque à chaque `/reload` ou déconnexion, dans
`WTF/Account/<COMPTE>/SavedVariables/ClockWork.lua`) :

- `CLOCKWORK_ROTATIONS` : réglages des rotations Lua ;
- `CLOCKWORK_SETTINGS` : position et épinglage du menu, modes mémorisés.

Les noms des sorts ne passent pas par l'addon : la grille ne transmet que des identifiants, et le Java les traduit avec
les tables du jeu (wago.tools).

### Réglages de WoW nécessaires

- **Mode fenêtré maximisé** : la grille est cherchée à l'écran, elle doit être visible et non recouverte.
- Interface affichée : `Alt+Z` masque aussi la grille, et le Java se met alors en attente.
- Raccourcis des barres d'action : seules les touches `1 2 3 4 5 6 7 8 9 0 ) = Q D R T F G` sont décrites, seules ou
  avec `Maj`, `Ctrl` ou `Alt` (72 combinaisons).

---

## Menu en jeu

Un petit menu, déplaçable par sa barre de titre, réunit les commandes :

- il **s'ouvre au survol** et se referme 1,5 s après la sortie de la souris ; un **clic sur le titre l'épingle** ouvert
  (« épinglé » s'affiche), un autre le libère ;
- une pastille verte ou grise montre l'état de chaque mode, toujours à jour, y compris après une commande `/clk` ; celle
  du titre indique si ClockWork est actif ;
- groupes : **Combat** (activation, aggro, rotation assistée, multi-cibles, mode soigneur, ciblage auto), **Déplacement** (pilote, boucle, ramassage, ajout et
  effacement de points), **Pêche**, **Outils** (débogage, `testsecret`, erreurs) ;
- sous la pêche : **statistiques de la session** (prises sur lancers, poissons échappés, faux clics), d'après le résultat
  de chaque lancer (voir *Pêche : résultat de chaque lancer*) ;
- en bas : spécialisation détectée, version de la grille et blocs en erreur ;
- le **compartiment d'addons** de Blizzard (bouton près de la minicarte) l'affiche ou le masque ;
- position, épinglage et modes (aggro, multi-cibles, rotation assistée, ciblage auto, boucle, débogage) sont **mémorisés** d'une
  session à l'autre (SavedVariable `CLOCKWORK_SETTINGS`). L'activation, le pilote et la pêche repartent éteints, par
  prudence.

## Raccourcis clavier

Dans **Options > Raccourcis > Addons > ClockWork** (aucune touche par défaut, pour ne rien écraser) : activer ou
désactiver ClockWork, pêche automatique, mode soigneur, mode multi-cibles, mode aggro, pilote automatique, ramassage du butin, afficher ou masquer le menu.
Ils font la même chose que les boutons du menu et les commandes `/clk` (`Bindings.xml`, libellés dans `bindings.lua`).

## Commandes en jeu

`/clk` ou `/clockwork`, suivi de :

| Commande | Effet |
|---|---|
| `toggle` | Active ou désactive l'addon. Désactivé, la case (2,13) est éteinte et le Java ne fait rien. |
| `aggro` | Active ou désactive le mode aggro. |
| `assisted` | Active ou désactive la rotation assistée de Blizzard (`C_AssistedCombat`) dans les rotations Lua. |
| `tne` | *Target Nearest Enemy* : le Java appuie sur `Tab` quand il n'a rien à faire. |
| `addwp` / `clearwp` | Ajoute la position actuelle au parcours / vide le parcours (pilote automatique). |
| `05,21-63,30;…` | Ajoute une liste de points de passage (coordonnées de carte). |
| `drive` / `loop` | Pilote automatique : suit le parcours, une fois ou en boucle. Attend la fin d'un repas (buffs Nourriture, Boisson, Rafraîchissement, dans la langue du client). |
| `multi` | Mode multi-cibles (aussi dans le menu) : les rotations répartissent leurs DoT et utilisent leurs sorts de zone. |
| `healer` | Mode soigneur (aussi dans le menu) : le cerveau Java soigne aussi les autres membres. Allumé d'office quand la spécialisation est de soin. |
| `loot` | Ramassage du butin (aussi dans le menu, désactivé par défaut) : après un combat, le Java avance jusqu'à la cible morte (elle est devant) et ouvre son butin. |
| `fish` | Pêche automatique (aussi dans le menu) : le Java pêche tant que la case (12,4) est allumée. |
| `debug` | Mode débogage (journal détaillé dans le chat). |
| `list actions` / `list bindings` / `list spells` | Rapports sur les barres d'action, les raccourcis et les sorts. |
| `testsecret` | **Carte de ce que le client autorise** sur les valeurs secrètes (sections A à G). À lancer en combat contre un mannequin, puis hors combat pour comparer. |
| `errors` / `errors reset` | Blocs de mise à jour de la grille qui ont échoué (voir *Robustesse*). |

Le **mode aggro** (`AGGRO_MOD`, bouton du menu) autorise l'attaque d'une cible qui n'est pas encore en combat.
Sinon, le bot n'agit que hors combat, ou quand le joueur *et* la cible sont en combat.

| Pour… | Aggro | Ciblage auto | Multi-cibles |
|---|---|---|---|
| tuer une cible à la fois, puis la suivante | oui | oui | non |
| tuer tout ce qui est à portée | oui | oui | oui |
| ne combattre que ce qui m'attaque | non | oui | au choix |

---

## Organisation du code

| Fichier | Rôle |
|---|---|
| `core.lua` | Création de la table globale `Clockwork`. |
| `core_functions.lua` | Constantes (`UPDATE_INTERVAL` = 0,2 s, modes) et `createDot`, qui crée une case de la grille. |
| `init_addon.lua` | Grille historique (fond, cases), échelle des pixels, événements, boucle `OnUpdate`. |
| `qrcode_v2.lua` | **Grille v4** : quatre blocs de touches, codage des sorts, historique des lancements. |
| `group.lua` | Membres du groupe ou du raid (bloc 2), mode soigneur, boutons sécurisés de ciblage des membres. |
| `loot.lua` | Ramassage du butin : la cible est-elle un cadavre avec du butin pour le joueur. |
| `fishing.lua` | Résultat de chaque lancer de pêche (prise, échappé, faux clic, rien) et statistiques du menu. |
| `rotations_functions.lua` | `rotation()` (appelle la rotation de la spécialisation, puis l'assistée), `updateUIStatus()` qui remplit la grille, fonctions d'aide sur la cible. |
| `rotation_<classe>.lua` | Rotations Lua historiques, par spécialisation. |
| `rotation_assisted.lua` | Rotation qui suit la recommandation de Blizzard (`C_AssistedCombat.GetNextCastSpell`). |
| `keys_functions.lua` | Correspondance sort → emplacement de barre → raccourci clavier, et allumage d'une touche (mode v1). |
| `coordinates_functions.lua` | Coordonnées de carte du joueur en binaire (pilote automatique). |
| `bindings.lua`, `Bindings.xml` | Raccourcis clavier du joueur (activation, pêche, mode soigneur…) et anciens raccourcis internes (mode v1). Le ciblage des membres est dans `group.lua`. |
| `menu.lua` | Petit menu en jeu (boutons On/Off, Aggro…). |
| `guard.lua` | `Clockwork.guard` : isole chaque bloc de mise à jour (voir *Robustesse*). |
| `secret_tests.lua` | `/clk testsecret`. |
| `spells.lua`, `specializations.lua`, `localization.lua` | Données : sorts, spécialisations, traductions. |
| `logger.lua`, `debug_functions.lua`, `tests.lua` | Journal et outils de débogage. |

---

## Cycle de mise à jour

1. `OnUpdate` est appelé à chaque image. Toutes les **200 ms** (`UPDATE_INTERVAL`), l'addon lance `Clockwork:rotation()`.
2. `rotation()` appelle d'abord `updateUIStatus()`, qui repeint toutes les cases d'état (vie, cible, combat…) puis
   la grille v4 (`updateQrCodeV2`, membres du groupe compris).
3. Il éteint ensuite les touches du mode v1. Si le joueur n'incante pas, n'est pas monté et a le droit d'agir (mode
   aggro, ou joueur et cible en combat, ou hors combat), il lance la rotation Lua de la spécialisation puis la rotation
   assistée. Chacune peut allumer une touche.
4. Les événements complètent l'état :
   - `UNIT_SPELLCAST_SUCCEEDED` (joueur) mémorise l'heure et la cible de chaque lancement (`recordOwnCast`), d'où
     l'historique par touche ;
   - `UPDATE_BINDINGS` recalcule la correspondance raccourci → emplacement ;
   - `DISPLAY_SIZE_CHANGED` / `UI_SCALE_CHANGED` recalculent l'échelle des pixels.

Les événements sont enregistrés un par un dans un `pcall`. Un événement interdit par le client est noté dans
`Clockwork.refusedEvents` (section D de `/clk testsecret`) au lieu de faire échouer le chargement.
`COMBAT_LOG_EVENT_UNFILTERED` en fait partie : il est réservé à l'interface de Blizzard depuis la 12.x.

### Un pixel de jeu = un pixel d'écran

L'interface de WoW mesure toujours **768 unités de haut**, quelle que soit la résolution. Pour qu'une case de la grille
fasse exactement un pixel physique, le cadre principal (sans parent) reçoit l'échelle `768 / hauteur de l'écran en
pixels` (`updatePixelScale`). Sans cela, à 1 080 pixels de haut, chaque case ferait 1,4 pixel et les couleurs se
mélangeraient aux bords. La grille est ancrée en haut à gauche de l'écran ; en fenêtré, elle apparaît à (0, 23) sous la
barre de titre.

---

## La grille

Coordonnées `(x, y)` en pixels depuis le coin haut gauche, `y` vers le bas. Couleurs de 0 à 1 côté Lua, de 0 à 255 côté
Java. Une case « 24 bits » code un entier : `R` octet fort, `G` octet du milieu, `B` octet faible.

```
     0                15 16               31
   0 ┌──────────────────┬──────────────────┐
     │ bloc 1           │ bloc 2           │
     │ sans modificateur│ Maj              │
     │ + état du combat │                  │
  15 ├──────────────────┼──────────────────┤
  16 │ bloc 3           │ bloc 4           │
     │ Ctrl             │ Alt              │
  31 └──────────────────┴──────────────────┘
```

Chaque bloc a le même fond : un cadre **vert** de 16x16 dont l'intérieur est noir, sauf aux coins (repérage par le
Java). Les blocs 2 à 4 reprennent **exactement** les cases de touches du bloc 1, décalées de (16, 0), (0, 16) et
(16, 16). Le préfixe de la combinaison est `""`, `SHIFT-`, `CTRL-` ou `ALT-`. Les touches n'occupent que 54 des 196
cases intérieures d'un bloc : la v4 range le groupe dans les cases libres du bloc 2, et les blocs 3 et 4 restent en
réserve (142 cases libres chacun).

### Touches décrites

Ordre de référence (`Clockwork.KEY_ORDER`, identique côté Java), positions 1 à 18 :

```
position  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18
touche    1  2  3  4  5  6  7  8  9  0  )  =  Q  D  R  T  F  G
```

Pour chaque touche et dans chaque bloc, trois cases :

| Case | Position | Contenu |
|---|---|---|
| **État** | touches 1 à 12 : `(position + 1, 6)` ; touches 13 à 18 : `(position − 11, 12)` | `R` = temps de recharge restant / 60 s (valeur secrète, passée par une courbe), `G` = utilisable (1), inutilisable (0), ou utilisable mais à incantation pendant un déplacement (0,5 : WoW le refuserait ; temps d'incantation actuel, procs compris), `B` = à portée (1), hors de portée (0), sans portée (0,5) |
| **Historique** | touches 1 à 12 : `(position + 1, 9)` ; touches 13 à 18 : `(position − 5, 12)` | `R` = secondes depuis le dernier lancement **sur la cible actuelle** / 60 (1 = jamais ou plus de 60 s ; retenu par GUID de cible, donc retrouvé en revenant sur un ennemi déjà affligé), `G` = proc (bouton en surbrillance) + 2 × buff actif sur le joueur, sur 3 (buff lu hors combat, dernier état connu en combat), `B` = secondes depuis le dernier lancement, toutes cibles / 60 |
| **Sort** (24 bits) | positions 1 à 8 : `(position + 2, 3)` ; 9 à 12 : `(position − 7, 7)` ; 13 à 16 : `(position − 11, 10)` ; 17 et 18 : `(position − 9, 2)` | Identifiant du sort sur la touche (0 = aucun) ; pour un **objet**, 8 388 608 (bit 23) + identifiant de l'objet |

« Sans portée » (0,5) signifie que la portée n'a pas de sens : sort sans cible, ou pas de cible du tout.

**Objets** (potion, pierre de soins, leurre…) : la case du sort porte le bit 23 et l'identifiant de l'objet. La case
d'état garde son sens (recharge, utilisable, portée). Celle d'historique change : `R` = nombre possédé / 255 (charges
comprises, `C_Item.GetItemCount`), `G` = 2/3 si l'aura du sort de l'objet est active sur le joueur, `B` = temps depuis la
dernière utilisation / 60. Une **macro** est décrite par le sort ou l'objet qu'elle affiche (sous-type de
`GetActionInfo`).

### Cases d'état du combat (bloc 1)

| Case | Contenu |
|---|---|
| (0,0) | Coin vert : grille visible (le Java vérifie ce pixel avant tout). |
| (2,2) | En combat (blanc). |
| (3,2) | Incantation en cours (blanc). |
| (6,2) | **Sort recommandé par Blizzard**, 24 bits, dans sa forme de base (`C_Spell.GetBaseSpell`). |
| (7,2) | Direction du personnage sur 16 bits : `R` octet fort, `G` octet faible, 0 à 65 535 pour 0 à 2π. |
| (10,2) | `R` = mode aggro, `G` = cible en combat, `B` = mode multi-cibles. |
| (11,2) | **Compteur de mises à jour**, 24 bits : s'il ne bouge plus, WoW est figé (écran de chargement…). |
| (12,2) | Vie du joueur (`R`, valeur secrète affichée telle quelle). |
| (13,2) | Ressource principale du joueur (`B`, secrète). |
| (2,3) | Nombre d'ennemis en combat d'après les barres de vie : `R` = nombre / 255. |
| (11,3) | **Réaction de la cible** : rouge = hostile, jaune = neutre, vert = amicale, **gris = morte**, noir = pas de cible. |
| (12,3) | Vie de la cible (`R`, secrète). |
| (13,3) | Ressource de la cible (`B`, secrète). |
| (8,13) | **Version de la grille** : `R` = 4 / 255. |
| (2..7,13) | Modes : `toggle` (2), `tne` (3), ajout de point (4), effacement du parcours (5), `drive` (6), `loop` (7). |
| (8,4) | **Forme active** : sort de la forme (druide : félin, ours, sélénien…) sur 24 bits, 0 = aucune. Le sort plutôt que l'index de `GetShapeshiftForm`, qui dépend des talents. |
| (9,4) | **Ressource de classe** : `R` = nombre / 255. Points de combo (voleur, druide), éclats d'âme (démoniste), puissance sacrée (paladin), chi (moine), essence (évocateur), charges arcaniques (mage). |
| (11,13) | `R` = le joueur **se déplace** (`GetUnitSpeed`), `G` = la **cible incante**, `B` = son sort est interruptible (vrai sauf indication contraire). Suivi par les événements d'incantation de la cible et `PLAYER_TARGET_CHANGED`. |
| (12,13) | **Sort incanté par la cible**, 24 bits (0 si aucun ou si l'identifiant est secret). |
| (9,13) | **Sort en cours** d'incantation ou de canalisation, 24 bits (événements `UNIT_SPELLCAST_START` / `CHANNEL_START`), 0 = aucun. |
| (10,13) | `R` = temps restant de l'incantation / 10 s (objet durée de `UnitCastingDuration` / `UnitChannelDuration`, passé par une courbe), `G` = canalisation. |
| (12,4) | **Pêche demandée** au Java (blanc), par `/clk fish` ou le menu. |
| (13,4) | **Garde-fous** : `R` = joueur mort, `G` = cible marquée par un autre joueur (`UnitIsTapDenied`), `B` = sur une monture. Le Java n'agit pas dans ces cas. |
| (10,4) | **Classe** du personnage : `R` = identifiant / 255 (7 = chaman). |
| (11,4) | **Spécialisation** active sur 16 bits : `R` octet fort, `G` octet faible (262 = Élémentaire). Le Java choisit la rotation d'après la classe et la spécialisation. |
| (13,13) | Mode débogage. |
| lignes 7-8 et 10-11 | Coordonnées de carte du joueur en binaire, 20 bits chacune (pixel blanc = 1). |
| (3,1) | `R` = **mode soigneur**, `G` = en raid. |
| (8,1) | **Ramassage** : `R` = mode ramassage, `G` = la cible est un cadavre avec du butin pour le joueur (`CanLootUnit`). |
| (7,1) | **Cible pas devant le joueur** : `R` = un sort vient d'être refusé pour cette raison (« La cible doit être devant vous », ou attaque en mêlée dans la mauvaise direction), il y a moins de 1,5 s. Le Java fait alors demi-tour. |
| (6,1) | **Identifiant de la cible**, 24 bits : les 6 derniers chiffres hexadécimaux de son GUID (numéro propre à chaque monstre), 0 sans cible ou GUID illisible. Le Java reconnaît un ennemi déjà vu (DoT répartis). |
| (5,1) | **Résultat du dernier lancer de pêche** : `R` = compteur de lancers terminés (modulo 256), `G` = résultat (1 prise, 2 échappé, 3 rien à ferrer, 4 rien), voir `fishing.lua`. |
| (4,1) | **Enchantement temporaire de la main droite** (leurre sur la canne à pêche) : `R` = actif, `G` = temps restant / 30 min (`GetWeaponEnchantInfo`). |
| bords (ligne 1, colonne 14, ligne 14, colonne 1) | Libres depuis la v4 (anciennement la vie des membres du groupe), sauf (3,1) à (8,1). |

### Cases « touche à appuyer » (mode v1)

Lignes 4 (`Q D R T F G`, x = 2 à 7) et 5 (`1` à `=`, x = 2 à 13). Une touche allumée par une rotation Lua contient :
`R` = modificateur (1 = Ctrl, 2 = Alt, 4 = Maj), `G` = priorité (0 = éteinte), `B` = durée d'appui / 30 s. Le Java
appuie sur la touche allumée de plus haute priorité. Le cerveau Java ignore ces cases.

---

## Groupe, raid et mode soigneur

`group.lua`, grille v4. Le Java peut soigner n'importe quel membre (règles `on` de ses rotations).

**Emplacements.** En raid, l'emplacement *n* est `raidN`. Sinon (groupe ou seul), l'emplacement 1 est le joueur et 2 à 5
sont `party1` à `party4`.

**Cases des membres**, dans le bloc 2 : membres 1 à 14 en ligne 1 (x = 17 à 30), 15 à 28 en ligne 4, 29 à 40 en ligne 5
(x = 17 à 28).

| Canal | Contenu |
|---|---|
| `R` | Vie en % (`UnitHealthPercent`, valeur secrète transmise telle quelle) ; 0 si mort. |
| `G` | À portée de soin (1), hors de portée (0), inconnu (0,5). `UnitInRange` est secret, mais un `if` l'accepte. |
| `B` | Drapeaux / 255 : 1 existe, 2 mort, 4 déconnecté, 8 c'est le joueur, rôle × 16 (0 aucun, 1 tank, 2 soigneur, 3 dégâts). |

Une case noire (sans le drapeau « existe ») est un emplacement vide.

**Mode soigneur** (`/clk healer`, menu) : case (3,1). Le cerveau Java ne soigne les *autres* membres qu'en mode soigneur,
sauf règle d'urgence (`always`). Il s'allume ou s'éteint d'office quand la spécialisation change, selon son rôle
(Restauration, Sacré… : allumé), puis reste au choix du joueur.

**Ciblage.** `TargetUnit` est protégé : l'addon crée des boutons sécurisés (`SecureActionButtonTemplate`, type
`target`) et leur relie des raccourcis en **surcharge** (`SetOverrideBindingClick`, jamais enregistrés dans la
configuration du joueur) :

| Raccourci | Effet |
|---|---|
| `Alt+Maj+A` à `Alt+Maj+T` | Cibler les membres 1 à 20. |
| `Alt+Ctrl+A` à `Alt+Ctrl+T` | Cibler les membres 21 à 40. |
| `Alt+Maj+U` | Revenir à la cible précédente (`/targetlasttarget`). |

`Alt+Maj+V` est aussi posé en surcharge pour la **course automatique** (`TOGGLEAUTORUN`), dont se sert le pilote
automatique, et `Alt+Maj+L` pour **interagir avec la cible** (`INTERACTTARGET`), dont se sert le ramassage
(`bindings.lua`). Aucun réglage du joueur n'est modifié.

Pour soigner, le Java cible le membre, appuie sur la touche du sort, puis revient à la cible précédente (option
`returnToTarget` de la rotation). Les boutons ne s'appuient que sur la touche enfoncée (`useOnKeyDown`). Unités et
raccourcis ne se modifient que hors combat : un changement de composition en combat est appliqué à la sortie du combat
(`PLAYER_REGEN_ENABLED`).

---

## Pêche : résultat de chaque lancer

`fishing.lua`. Un lancer est une canalisation du joueur pendant que la pêche est demandée. Son résultat est arrêté
1,5 s après la fin de la canalisation, le butin pouvant arriver juste après :

| Résultat | Signal |
|---|---|
| Prise | Butin de pêche ouvert (`LOOT_READY` ou `LOOT_OPENED`, et `IsFishingLoot()`), butin automatique compris. |
| Échappé | Message d'erreur « Votre poisson s'est échappé » (`UI_ERROR_MESSAGE`, `ERR_FISH_ESCAPED`) : clic trop tardif. |
| Rien à ferrer | « Aucun poisson n'a mordu » (`ERR_FISH_NOT_HOOKED`) : clic trop tôt, faux clic. |
| Rien | Fin de la canalisation sans rien de tout cela : pas de clic, ou clic à côté du bouchon. |

Le résultat est publié en (5,1) avec un compteur, pour que le Java l'associe à son clic, et alimente les statistiques
du menu. Aucune de ces informations n'est secrète. Pendant la pêche, la grille est mise à jour même si ClockWork est
éteint : le Java y lit les touches du leurre et de l'appât.

---

## Les valeurs secrètes de la 12.x

Depuis Midnight, le client marque de nombreuses valeurs comme **secrètes** pour le code des addons (code dit
« contaminé », *tainted*). Sur une valeur secrète, un addon peut l'appeler et la transmettre, mais pas l'**examiner** :
pas de calcul, pas de comparaison, pas de clé de table, pas de concaténation. `tostring` renvoie lui-même une chaîne
secrète. L'objectif de Blizzard est d'empêcher les addons de prendre des décisions de combat.

Ce qui reste possible, et sur quoi repose la grille :

- **Passer un secret à un affichage** : `Texture:SetColorTexture`, `SetVertexColor`, `StatusBar:SetValue`,
  `FontString:SetText`. La vie (`UnitHealthPercent(unit, true)`) va directement dans le rouge d'une case : l'addon ne la
  lit jamais, le Java la lit à l'écran.
- **Les objets « durée » et les courbes** : `C_Spell.GetSpellCooldownDuration` rend un objet dont
  `EvaluateRemainingDuration(courbe)` produit un nombre secret de 0 à 1 (courbe 0 → 60 s), passé à `SetColorTexture`.
  C'est ainsi que le temps de recharge arrive dans les cases d'état.
- **Les API non secrètes**, vérifiées en jeu : `IsUsableAction`, `IsActionInRange`, `UnitIsDeadOrGhost`,
  `UnitAffectingCombat`, `UnitReaction`, `UnitGUID("target")`, `GetPlayerFacing`, `C_AssistedCombat.GetNextCastSpell`,
  le `spellId` de `UNIT_SPELLCAST_SUCCEEDED`, les coordonnées de carte.

Ce qui est perdu :

- le **journal de combat** (`COMBAT_LOG_EVENT_UNFILTERED` interdit) ;
- les **auras** (buffs et debuffs) en combat. L'historique des lancements par cible sert d'approximation : « Horion
  lancé sur cette cible il y a 13 s ». La section G de `/clk testsecret` explore une lecture de la vraie durée restante
  via `C_UnitAuras.GetAuraDuration`.

`/clk testsecret` produit le rapport complet : secret ou non, opérations permises, affichages qui acceptent un secret,
restrictions actives (`C_RestrictedActions`), niveau de secret par sort (`C_Secrets`), etc. La documentation des API
vient de `Blizzard_APIDocumentationGenerated` (dépôt `wow-ui-source`, branche `live`). Elle indique pour chaque fonction
`SecretArguments`, `SecretWhen…` et `ConditionalSecret`.

---

## Robustesse et diagnostic

- **`Clockwork.guard(nom, fonction)`** exécute chaque bloc de mise à jour dans un `pcall`. Une erreur (typiquement une
  opération interdite sur un secret) n'arrête pas le reste de la grille. Elle est signalée **une seule fois** dans le
  chat, puis comptée (`/clk errors`).
- **Compteur de mises à jour** (11,2) : le Java ignore une grille figée depuis plus de 1,5 s.
- **Version** (8,13) : un Java récent face à une grille v1 retombe sur le mode historique et le signale.
- Si l'addon ne se charge pas, vérifier le nom du dossier (`ClockWork`, comme le `.toc`). `ADDON_LOADED` compare au nom
  réel fourni par WoW (`local ADDON_NAME = ...`).
