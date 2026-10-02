@echo off
rem Synchronise l'addon vers le dossier AddOns de WoW (miroir : les fichiers retirés du dépôt sont retirés du jeu).
rem Usage : deploy.cmd [dossier AddOns]   puis /reload en jeu.

setlocal
set "ADDONS=%~1"
if "%ADDONS%"=="" set "ADDONS=E:\Perso\World of Warcraft\_retail_\Interface\AddOns"

robocopy "%~dp0." "%ADDONS%\ClockWork" /MIR /NJH /NP /NDL ^
    /XD .git .idea .vscode ^
    /XF .gitignore .gitattributes .editorconfig deploy.cmd "QR Code.ods" wp.txt *.iml

rem robocopy : 0 à 7 = succès, 8 et plus = erreur
if %ERRORLEVEL% GEQ 8 (
    echo Echec de la synchronisation vers "%ADDONS%\ClockWork"
    exit /b 1
)
echo ClockWork synchronise vers "%ADDONS%\ClockWork"
exit /b 0
