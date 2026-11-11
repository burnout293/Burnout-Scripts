## SINDRY:START
## id            : b7e41c02-9a3f-4d18-8c6e-5f2a0d71b9e4
## lang          : en
## title         : Disable Windows protections for cracks
## desc          : Turns off Defender, SmartScreen, Smart App Control and folder protection so cracks and KMS run
## category      : 
## icon          : shield-off
## tags          : defender, smartscreen, uac, kms, crack
## version       : 1.0
## author        : burnout293
## created       : 2026-10-25
## updated       : 2026-10-25
## admin         : true
## risk          : medium
## duration      : fast
## reversible    : true
## interruptible : true
## reboot        : false
## engine        : auto
## scan          : true
## SINDRY:END

## SINDRY:OPTIONS
## DefenderMode     : [select] [section:Defender] Defender handling — how real-time protection is switched off
##   permanent    : [group:Defender] Permanent — writes the policy key, survives reboots and Defender updates
##   temporary    : [group:Defender] Temporary — preference only, Windows may switch it back on
## DefenderCloud    : [bool]   [section:Defender] Also disable cloud protection — MAPS, sample submission and block-at-first-sight
## TamperProtection : [bool]   [section:Defender] Disable Tamper Protection — lets scripts change Defender settings without the app
## SmartScreen      : [bool]   [section:Browsing] Disable SmartScreen — Explorer and Store warnings on unknown programs
## EdgeSmartscreen  : [bool]   [section:Browsing] Disable Edge SmartScreen — reputation checks inside the browser
## SmartAppControl  : [bool]   [section:Browsing] Disable Smart App Control — Windows 11 only, blocks unsigned apps
## FolderAccess     : [bool]   [section:Browsing] Disable Controlled Folder Access — stops blocking programs writing to Documents
## UacLow           : [bool]   [section:Uac] Lower UAC to the minimum — no secure desktop, prompts appear as a normal window
## RestoreDefaults  : [bool]   [section:Other] Restore Windows defaults — put every protection back as it was
## SafeTest         : [bool]   [section:Other] Simulate — shows what would be done, changes nothing
## SINDRY:END

## SINDRY:REPORT
## Defender    : [section] Defender — real-time and cloud protection
## Browsing    : [section] Browsing — SmartScreen and folder protection
## Uac         : [section] User account control
## Other       : [section] Other
## State       : State
## E101        : [error] Defender policy key could not be written — Run the action again as administrator
## E102        : [error] Defender preference could not be changed — Defender service may be stopped, start it and retry
## E103        : [error] A registry value could not be written — Restart the PC, then run the action again
## E201        : [error] Tamper Protection is on and refused the change — turn it off in the Windows Security app, then retry
## W301        : [error] Smart App Control is only available on Windows 11 — the setting was skipped
## SINDRY:END

## SINDRY:LANG fr
## title            : Désactiver les protections Windows pour les cracks
## desc             : Coupe Defender, SmartScreen, Smart App Control et la protection des dossiers pour laisser passer cracks et KMS
## DefenderMode     : Traitement de Defender — comment la protection en temps réel est coupée
##   permanent      : Permanent — écrit la clé de stratégie, survit aux redémarrages et aux mises à jour de Defender
##   temporary      : Temporaire — préférence seule, Windows peut le rallumer tout seul
## DefenderCloud    : Couper aussi la protection cloud — MAPS, envoi d'échantillons et blocage au premier regard
## TamperProtection : Désactiver la Protection contre les altérations — permet aux scripts de changer Defender sans passer par l'app
## SmartScreen      : Désactiver SmartScreen — avertissements de l'Explorateur et du Store sur les programmes inconnus
## EdgeSmartscreen  : Désactiver SmartScreen dans Edge — vérifications de réputation dans le navigateur
## SmartAppControl  : Désactiver Smart App Control — Windows 11 seulement, bloque les applications non signées
## FolderAccess     : Désactiver le contrôle intelligent des dossiers — arrête de bloquer les programmes qui écrivent dans Documents
## UacLow           : Baisser l'UAC au minimum — plus d'écran sécurisé, les invitations s'affichent comme une fenêtre normale
## RestoreDefaults  : Rétablir les réglages Windows — remet chaque protection comme avant
## SafeTest         : Simuler — montre ce qui serait fait, sans rien modifier
## Defender         : Defender — protection en temps réel et cloud
## Browsing         : Navigation — SmartScreen et protection des dossiers
## Uac              : Contrôle du compte utilisateur
## Other            : Autres
## State            : État
## E101             : La clé de stratégie Defender n'a pas pu être écrite — Relancez l'action en administrateur
## E102             : La préférence Defender n'a pas pu être changée — Le service Defender est peut-être arrêté, démarrez-le et réessayez
## E103             : Une valeur de registre n'a pas pu être écrite — Redémarrez le PC, puis relancez l'action
## E201             : La Protection contre les altérations est active et a refusé le changement — désactivez-la dans l'app Sécurité Windows, puis réessayez
## W301             : Smart App Control n'existe que sur Windows 11 — le réglage a été ignoré
## SINDRY:END

# ==============================================================================
# Script de reference : couper les protections Windows qui genent un crack
# d'Office, de Windows ou un activateur KMS.
#
# Deux passages, comme tout script analysable :
#   1. ANALYSE (SINDRY_MODE=scan) : on lit l'etat de chaque protection, on
#      decrit, on ne modifie RIEN.
#   2. ACTION : Sindry relance avec ce qui a ete coche. Le script ne fait que ca.
# Seul, en double-clic, il agit avec ses valeurs par defaut.
# ==============================================================================

\$CONFIG = @{
    DefenderMode     = "permanent"
    DefenderCloud    = \$true
    TamperProtection = \$true
    SmartScreen      = \$true
    EdgeSmartscreen  = \$true
    SmartAppControl  = \$true
    FolderAccess     = \$true
    UacLow           = \$false
    RestoreDefaults  = \$false
    SafeTest         = \$false
}

# --- Sindry override (ne pas supprimer) ---
if (\$env:SINDRY_CONFIG) {
    (\$env:SINDRY_CONFIG | ConvertFrom-Json).PSObject.Properties |
        ForEach-Object { $CONFIG[$_.Name] = \$_.Value }
}

# ==============================================================================
# Chapitre 1 - Variables
# ==============================================================================

# Comparaison de CHAINE, pas de booleen : la valeur arrive par JSON et peut
# valoir \$true, "True" ou 1 selon le chemin emprunte.
$SafeTest        = ("$(\$CONFIG.SafeTest)" -eq 'True')
$RestoreDefaults = ("$(\$CONFIG.RestoreDefaults)" -eq 'True')
$doCloud         = ("$(\$CONFIG.DefenderCloud)" -eq 'True')
$doTamper        = ("$(\$CONFIG.TamperProtection)" -eq 'True')
$doSmartScreen   = ("$(\$CONFIG.SmartScreen)" -eq 'True')
$doEdgeSS        = ("$(\$CONFIG.EdgeSmartscreen)" -eq 'True')
$doSAC           = ("$(\$CONFIG.SmartAppControl)" -eq 'True')
$doFolder        = ("$(\$CONFIG.FolderAccess)" -eq 'True')
$doUac           = ("$(\$CONFIG.UacLow)" -eq 'True')

# Mode Defender retenu : 'permanent' (strategie)