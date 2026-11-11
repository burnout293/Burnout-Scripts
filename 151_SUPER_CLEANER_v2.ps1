## SINDRY:OPTIONS
## DoStartup         : [bool] [section:WhatToClean] [group:StartupGrp] Startup entries — programs and scripts launched when you sign in
## DoScheduledTasks  : [bool] [section:WhatToClean] [group:TasksGrp] Scheduled tasks — background jobs that software leaves behind
## DoServices        : [bool] [section:WhatToClean] [group:ServicesGrp] Orphan services — always-on programs whose file is gone
## DoRegistryLeftovers : [bool] [section:WhatToClean] [group:RegistryGrp] Registry leftovers — traces of software you removed
## DoLeftoverFolders : [bool] [section:WhatToClean] [group:FoldersGrp] Leftover folders — files no program reads anymore
## DoShellExtensions : [bool] [section:WhatToClean] [group:ShellGrp] Dead menu entries — right-click handlers pointing at nothing
## DoGhostDevices    : [bool] [section:WhatToClean] [group:DevicesGrp] Ghost devices — hardware unplugged long ago
## DoCaches          : [bool] [section:WhatToClean] [group:CachesGrp] Caches and logs — temporary data that rebuilds itself
## FoundStartup      : [items] [section:Items] Startup entries to remove — uncheck one to keep it running
## FoundTasks        : [items] [section:Items] Scheduled tasks to remove — uncheck one to keep it scheduled
## FoundServices     : [items] [section:Items] Services to remove — uncheck one to keep it installed
## FoundRegistry     : [items] [section:Items] Registry keys to remove — uncheck one to keep the trace
## FoundFolders      : [items] [section:Items] Folders to remove — uncheck one to keep its files
## FoundShellExt     : [items] [section:Items] Menu entries to remove — uncheck one to keep the menu item
## FoundDevices      : [items] [section:Items] Ghost devices to remove — uncheck one to keep its driver
## FoundCaches       : [items] [section:Items] Caches to empty — uncheck one to keep its content
## Aggressivity      : [select] [section:Level] [scan] How far to go — higher levels remove more, and undo less
##   audit           : Audit — report only, nothing is touched
##   prudent         : Prudent — proven orphans only, recycle bin, admin is enough
##   standard        : Standard — disables updaters and telemetry, removes safe leftovers
##   aggressive      : Aggressive — removes updaters, takes ownership, clears vendor packages
##   extreme         : Extreme — SYSTEM, TrustedInstaller, drivers, offline registry
##   maximum         : Maximum — everything Windows allows, including one restart
## ProtectionProfile : [select] [section:Level] [scan] Protection level — the master switch for every switch below
##   strict          : Strict — every protection on, the switches below are ignored
##   standard        : Standard — the switches below decide, one by one
##   permissive      : Permissive — only vital components stay protected
##   none            : None — everything found can be removed
## MinAgeDays        : [number] [section:Level] [scan] Minimum age in days — anything touched more recently is skipped
## MaxItemsPerList   : [number] [section:Level] [scan] Items listed per family — lower keeps the screen readable
## AllowMidRunRestart : [bool] [section:Level] [scan] Allow one restart mid-run — the only way past a file Windows holds
## SafeTest          : [bool] [section:Level] Simulate — say what would happen and change nothing at all
## ProtectMicrosoftSigned : [bool] [section:CoreComponents] [scan] Keep Microsoft-signed files — the safest signature to trust
## ProtectMicrosoftRecent : [bool] [section:CoreComponents] [scan] Keep recent Microsoft files — anything signed less than a year ago
## ProtectWindowsComponents : [bool] [section:CoreComponents] [scan] Keep Windows itself — System32, WinSxS and the component store
## ProtectVCRedist   : [bool] [section:CoreComponents] [scan] Keep Visual C++ Redistributables — dozens of programs depend on them
## ProtectDotNet     : [bool] [section:CoreComponents] [scan] Keep .NET Framework and its runtime — removing it breaks whole suites
## ProtectWebView2   : [bool] [section:CoreComponents] [scan] Keep Edge WebView2 — used by countless third-party apps
## ProtectDirectX    : [bool] [section:CoreComponents] [scan] Keep DirectX and graphics runtimes — games and video need them
## ProtectStoreApps  : [bool] [section:CoreComponents] [scan] Keep installed Store applications — they are hard to reinstall by hand
## ProtectWSL        : [bool] [section:CoreComponents] [scan] Keep WSL, Hyper-V and the virtual machine platform
## ProtectGpuDrivers : [bool] [section:Drivers] [scan] Keep graphics drivers — losing them means no display after a restart
## ProtectAudioDrivers : [bool] [section:Drivers] [scan] Keep audio drivers — losing them means silence
## ProtectNetworkDrivers : [bool] [section:Drivers] [scan] Keep network and Wi-Fi drivers — losing them means no connection
## ProtectPrintDrivers : [bool] [section:Drivers] [scan] Keep print drivers — losing them means reinstalling the printer
## ProtectCriticalServices : [bool] [section:WindowsServices] [scan] Keep services Windows cannot live without — RPC, WMI, task scheduler
## ProtectWindowsUpdate : [bool] [section:WindowsServices] [scan] Keep the update pipeline — wuauserv, BITS and their helpers
## ProtectDefender   : [bool] [section:WindowsServices] [scan] Keep Defender and the security centre — never leave yourself bare
## ProtectStore      : [bool] [section:WindowsServices] [scan] Keep the Store and App Installer — they repair the Store apps
## ProtectXboxGaming : [bool] [section:WindowsServices] [scan] Keep Xbox and Gaming Services — Game Pass and most games need them
## ProtectSearchIndex : [bool] [section:WindowsServices] [scan] Keep Windows Search — removing it slows the Start menu badly
## ProtectNetworkStack : [bool] [section:WindowsServices] [scan] Keep Winsock, the LSP chain and the network profiles
## ProtectScheduledDefaults : [bool] [section:WindowsServices] [scan] Keep the tasks Windows schedules itself — leave them alone
## ProtectBitLocker  : [bool] [section:SystemSettings] [scan] Keep BitLocker and the TPM — never break disk encryption by accident
## ProtectSecureBoot : [bool] [section:SystemSettings] [scan] Keep UEFI, Secure Boot and the boot configuration
## ProtectRestorePoints : [bool] [section:SystemSettings] [scan] Keep existing restore points — they are your way back
## ProtectEventLogs  : [bool] [section:SystemSettings] [scan] Keep the event logs — the only record of what happened
## ProtectHostsFile  : [bool] [section:SystemSettings] [scan] Keep the hosts file — blocks and redirects live there
## ProtectFirewallRules : [bool] [section:SystemSettings] [scan] Keep the firewall rules — losing them opens the machine up
## ProtectCertificates : [bool] [section:SystemSettings] [scan] Keep the certificate stores — losing them breaks signed apps
## ProtectEnvironmentVariables : [bool] [section:UserData] [scan] Keep the environment variables and PATH — losing PATH breaks tools
## ProtectFonts      : [bool] [section:UserData] [scan] Keep installed fonts — losing them changes every document
## ProtectUserConfigs : [bool] [section:UserData] [scan] Keep your settings, as opposed to pure cache — no reconfiguration
## ProtectUserProfiles : [bool] [section:UserData] [scan] Keep the user profiles, including those not currently loaded
## ProtectPinnedFavorites : [bool] [section:UserData] [scan] Keep pinned shortcuts and bookmarks — they are your habits
## ProtectActiveSoftware : [bool] [section:UserData] [scan] Keep vendors that still have a product installed — they are not gone
## ProtectThirdPartyAV : [bool] [section:UserData] [scan] Keep an active third-party antivirus — never disable it mid-cleanup
## ProtectPendingReboot : [bool] [section:UserData] [scan] Do nothing while a restart is already pending — results would be muddled
## AllowAdminElevation : [bool] [section:Rights] [scan] Relaunch with administrator rights — one prompt, then silent
## AllowSystemExecution : [bool] [section:Rights] [scan] Run the stubborn steps as SYSTEM — the account that owns the locked files
## AllowTrustedInstaller : [bool] [section:Rights] [scan] Take ownership as TrustedInstaller — for what even SYSTEM cannot touch
## AllowAclRewrite  : [bool] [section:Rights] [scan] Take ownership and rewrite access rights on a stuck item
## AllowProcessShutdown : [bool] [section:Rights] [scan] Close the program holding a file, through Restart Manager
## AllowLockedDeletion : [bool] [section:Rights] [scan] Delete at the next restart what Windows refuses to release now
## AllowDriverRemoval : [bool] [section:Rights] [scan] Remove ghost drivers with pnputil — clears the driver store
## AllowOfflineRegistry : [bool] [section:Rights] [scan] Mount the hives of unloaded profiles to reach their leftovers
## AllowServiceStop  : [bool] [section:Engine] [scan] Stop a service for the time of a removal, then leave it stopped
## AllowDefenderPause : [bool] [section:Engine] [scan] Pause real-time protection for a moment, from the extreme level
## AllowComponentCleanup : [bool] [section:Engine] [scan] Run the DISM component cleanup — big gain, irreversible
## AllowWindowsOldRemoval : [bool] [section:Engine] [scan] Remove Windows.old — the previous installation, tens of gigabytes
## AllowToolDownload : [bool] [section:Engine] [scan] Download helper tools into the workspace — nothing stays on the machine
## AllowRulesDownload : [bool] [section:Engine] [scan] Fetch the extra rules file — skipped entirely when the address is empty
## CreateRestorePoint : [bool] [section:Backups] Create a restore point first — slow, and Windows allows one per day
## ExportRegistryBackup : [bool] [section:Backups] Back up every registry key touched — a single click restores it
## ExportTaskBackup  : [bool] [section:Backups] Back up every task removed, as XML — reimportable by hand
## ExportServiceBackup : [bool] [section:Backups] Back up every service touched, with its original start type
## UseRecycleBin     : [bool] [section:Backups] Send files to the recycle bin — recoverable until you empty it
## KeepWorkspace     : [bool] [section:Backups] Keep the workspace after the run — backups, logs and reports stay
## Rollback          : [bool] [section:Rollback] Undo a previous run instead of cleaning — reads the last backup
## RollbackKeepBackups : [bool] [section:Rollback] Keep the backups after undoing — lets you roll back twice
## ContinueOnItemError : [bool] [section:Rollback] Carry on when one item fails — otherwise the run stops there
## UseKnowledgeBase  : [bool] [section:Rules] Use the built-in knowledge base — works offline, always available
## UseExternalRules  : [bool] [section:Rules] Use the extra rules file from the repository — newer cases, community-fed
## RulesUrl          : [string] [section:Rules] Address of the extra rules file — empty skips it without any error
## ExportReport      : [bool] [section:Output] Write a JSON and an HTML report — JSON to process, HTML to read
## DetailedLog       : [bool] [section:Output] Write every action to the log file — needed to audit a run
## RetryCount        : [number] [section:Output] [scan] Tries before giving up on an item — then the escalation takes over
## SINDRY:END

## SINDRY:REPORT
## WhatToClean : [section] What gets cleaned — pick the families to look at
## Items       : [section] Items found — uncheck anything you want to keep
## Level       : [section] How far to go — aggressiveness, age and protection
## CoreComponents : [section] Essential components — what Windows and your software cannot lose
## Drivers     : [section] Drivers — hardware and devices
## WindowsServices : [section] Windows and its services — updates, Defender, Store
## SystemSettings : [section] System settings — restore, logs, network, certificates
## UserData    : [section] Your data — profiles, settings and installed software
## Rights      : [section] Action rights — how far the script may go
## Engine      : [section] Engine — helper tools and special operations
## Backups     : [section] Backups — what is set aside before acting
## Rollback    : [section] Rollback — undo a previous run
## Rules       : [section] Knowledge base — what is used to recognise bloat
## Output      : [section] Display and report — what you get at the end
## StartupGrp  : [group] Startup entries — what runs when you sign in
## TasksGrp    : [group] Scheduled tasks — background jobs
## ServicesGrp : [group] Services and drivers — always-on programs
## RegistryGrp : [group] Registry leftovers — traces of removed software
## FoldersGrp  : [group] Leftover folders — files no program uses anymore
## ShellGrp    : [group] Shell extensions — menu entries and COM handlers
## DevicesGrp  : [group] Ghost devices — hardware that is no longer connected
## CachesGrp   : [group] Caches and logs — temporary data
## LStartup    : Startup entry
## LTask       : Scheduled task
## LService    : Service
## LDriver     : Driver
## LRegistry   : Registry key
## LFolder     : Folder
## LShellExt   : Shell extension
## LDevice     : Device
## LCache      : Cache
## LFamily     : Group
## NIntrusive  : [note:warn] This script stops some services for a moment, takes ownership of a few protected keys and may ask for one restart. Everything is logged and can be undone.
## NBackup     : [note:info] A restore point and a backup of every key, task and service touched are written before anything changes.
## NRestart    : [note:warn] If a file is locked by Windows, one restart is needed: the script resumes by itself right after.
## NRollback   : [note:info] Run the script again with Rollback on to put everything back.
## NRules      : [note:info] Extra rules are fetched from the project repository when the address is set.
## NExtreme    : [note:warn] At this level the component store and old Windows files are cleaned: that part cannot be undone.
## NNoAdmin    : [note:warn] Without administrator rights, protected items are reported but left in place.
## NSafeTest   : [note:info] Simulation: nothing is changed, the script only says what it would do.
## NProtected  : [note:info] Protected items stay in place unless their switch is turned off.
## NAboutOrphan : [note:info] The target it points at no longer exists.
## NWhyOrphan  : [note:info] Nothing can use it anymore, so it only slows down sign-in or boot.
## NWarnOrphan : [note:warn] Nothing: a dead entry is safe to remove.
## NAboutUpdater : [note:info] An updater that belongs to a program.
## NWhyUpdater : [note:info] It runs at every sign-in even when there is nothing to update.
## NWarnUpdater : [note:warn] Updates still arrive, just less often.
## NAboutProtected : [note:info] A component Windows or an installed program still uses.
## NWhyProtected : [note:info] It is proposed because its owner is gone, or because it duplicates something.
## NWarnProtected : [note:warn] Removing it can break the program that relies on it.
## FreeSpace   : Free space on drive C:
## ItemsFound  : Items found
## E101 : [error] Administrator rights are required — accept the elevation prompt, then run again
## E102 : [error] The workspace could not be created — check the free space on the system drive
## E103 : [error] The built-in knowledge base could not be read — the script falls back to heuristics
## E104 : [error] The extra rules file could not be fetched — the cached copy, then the built-in base, is used
## E105 : [error] A helper tool could not be downloaded — the native method is used instead
## E106 : [error] The restore point could not be created — Windows throttles them to one per day
## E107 : [error] A backup could not be written — the item is left in place
## E108 : [error] Access denied on a protected key — take ownership is retried, then the restart
## E109 : [error] A file is still locked — it is deleted at the next restart
## E110 : [error] A service could not be stopped — the removal is retried, then postponed
## E111 : [error] A scheduled task could not be removed
## E112 : [error] A service could not be deleted — it is disabled instead
## E113 : [error] A driver could not be removed — a restart is needed before retrying
## E114 : [error] A profile hive could not be mounted — that profile is skipped
## E115 : [error] Some items are still there after the action — run the script again
## E116 : [error] The rollback failed on at least one item
## E117 : [error] No backup was found — nothing to roll back
## E118 : [error] A restart is already pending — the items are reported and left alone
## E119 : [error] Less than the safety margin of free space is left
## E120 : [error] Another cleanup is already running
## E121 : [error] The SYSTEM task could not be created or run
## E122 : [error] TrustedInstaller ownership failed — the administrator path is used instead
## E123 : [error] The original access rights could not be restored on a key
## W201 : [error] Elevation was refused — the run carries on without administrator rights
## W202 : [error] A protected item was left in place by its protection switch
## W203 : [error] An item is in use and was skipped this time
## W204 : [error] The publisher could not be read — the item is reported with low confidence
## SINDRY:END

## SINDRY:LANG fr
## title         : Nettoyage profond du PC
## desc          : Nettoie les entrées de démarrage, les tâches planifiées, les services orphelins, les traces de désinstallation, les dossiers résiduels, les extensions shell, les périphériques fantômes et les caches. Arrête brièvement quelques services, prend possession de quelques clés et demande un redémarrage si un fichier est verrouillé par Windows
## WhatToClean : Ce qui est nettoyé — choisissez les familles à examiner
## Items       : Éléments trouvés — décochez ce que vous voulez garder
## Level       : Jusqu'où aller — agressivité, ancienneté et protection
## CoreComponents : Composants essentiels — ce que Windows et vos logiciels ne peuvent pas perdre
## Drivers     : Pilotes — matériel et périphériques
## WindowsServices : Windows et ses services — mises à jour, Defender, Store
## SystemSettings : Réglages système — restauration, journaux, réseau, certificats
## UserData    : Vos données — profils, réglages et logiciels installés
## Rights      : Droits d'action — jusqu'où le script a le droit d'aller
## Engine      : Moteur — outils d'appoint et opérations spéciales
## Backups     : Sauvegardes — ce qui est mis de côté avant d'agir
## Rollback    : Retour en arrière — annuler un passage précédent
## Rules       : Base de connaissance — ce qui sert à reconnaître un parasite
## Output      : Affichage et rapport — ce que vous obtenez à la fin
## DoStartup         : Entrées de démarrage — programmes et scripts lancés à l'ouverture de session
## DoScheduledTasks  : Tâches planifiées — travaux de fond laissés par des logiciels
## DoServices        : Services orphelins — programmes toujours actifs dont le fichier a disparu
## DoRegistryLeftovers : Traces de désinstallation — restes de logiciels que vous avez retirés
## DoLeftoverFolders : Dossiers résiduels — fichiers que plus aucun programme ne lit
## DoShellExtensions : Entrées de menu mortes — gestionnaires de clic droit qui ne pointent plus nulle part
## DoGhostDevices    : Périphériques fantômes — matériel débranché depuis longtemps
## DoCaches          : Caches et journaux — données temporaires qui se reconstruisent
## FoundStartup      : Entrées de démarrage à retirer — décochez-en une pour la garder active
## FoundTasks        : Tâches planifiées à retirer — décochez-en une pour la garder planifiée
## FoundServices     : Services à retirer — décochez-en un pour le garder installé
## FoundRegistry     : Clés de registre à retirer — décochez-en une pour garder la trace
## FoundFolders      : Dossiers à retirer — décochez-en un pour garder ses fichiers
## FoundShellExt     : Entrées de menu à retirer — décochez-en une pour garder l'entrée
## FoundDevices      : Périphériques fantômes à retirer — décochez-en un pour garder son pilote
## FoundCaches       : Caches à vider — décochez-en un pour garder son contenu
## Aggressivity      : Jusqu'où aller — plus le niveau est haut, plus il retire, et moins il peut revenir en arrière
##   audit           : Audit — rapport seul, rien n'est touché
##   prudent         : Prudent — seuls les orphelins prouvés, corbeille, administrateur suffisant
##   standard        : Standard — désactive les updaters et la télémétrie, retire les résidus sans risque
##   aggressive      : Agressif — retire les updaters, prend possession, nettoie les paquets éditeurs
##   extreme         : Extrême — SYSTEM, TrustedInstaller, pilotes, registre hors ligne
##   maximum         : Maximum — tout ce que Windows permet, redémarrage compris
## ProtectionProfile : Niveau de protection — l'interrupteur maître de tous ceux du dessous
##   strict          : Strict — toutes les protections actives, les interrupteurs du dessous sont ignorés
##   standard        : Standard — les interrupteurs du dessous décident, un par un
##   permissive      : Permissif — seuls les composants vitaux restent protégés
##   none            : Aucune — tout ce qui est trouvé peut être retiré
## MinAgeDays        : Âge minimal en jours — tout ce qui a été touché plus récemment est sauté
## MaxItemsPerList   : Éléments listés par famille — plus bas, l'écran reste lisible
## AllowMidRunRestart : Autoriser un redémarrage en cours de route — le seul moyen de passer un fichier tenu par Windows
## SafeTest          : Simuler — dit ce qui serait fait, sans rien modifier du tout
## ProtectMicrosoftSigned : Garder les fichiers signés Microsoft — la signature la plus sûre
## ProtectMicrosoftRecent : Garder les fichiers Microsoft récents — tout ce qui est signé depuis moins d'un an
## ProtectWindowsComponents : Garder Windows lui-même — System32, WinSxS et le magasin de composants
## ProtectVCRedist   : Garder les Visual C++ Redistributables — des dizaines de programmes en dépendent
## ProtectDotNet     : Garder .NET Framework et son moteur — le retirer casse des suites entières
## ProtectWebView2   : Garder Edge WebView2 — utilisé par d'innombrables applications tierces
## ProtectDirectX    : Garder DirectX et les moteurs graphiques — jeux et vidéo en ont besoin
## ProtectStoreApps  : Garder les applications du Store installées — difficiles à réinstaller à la main
## ProtectWSL        : Garder WSL, Hyper-V et la plateforme de machines virtuelles
## ProtectGpuDrivers : Garder les pilotes graphiques — les perdre, c'est plus d'affichage après un redémarrage
## ProtectAudioDrivers : Garder les pilotes audio — les perdre, c'est le silence
## ProtectNetworkDrivers : Garder les pilotes réseau et Wi-Fi — les perdre, c'est plus de connexion
## ProtectPrintDrivers : Garder les pilotes d'impression — les perdre, c'est réinstaller l'imprimante
## ProtectCriticalServices : Garder les services indispensables à Windows — RPC, WMI, planificateur de tâches
## ProtectWindowsUpdate : Garder la chaîne de mise à jour — wuauserv, BITS et leurs auxiliaires
## ProtectDefender   : Garder Defender et le centre de sécurité — ne jamais se retrouver à nu
## ProtectStore      : Garder le Store et App Installer — ils réparent les applications du Store
## ProtectXboxGaming : Garder Xbox et Gaming Services — le Game Pass et la plupart des jeux en ont besoin
## ProtectSearchIndex : Garder la recherche Windows — la retirer ralentit fortement le menu Démarrer
## ProtectNetworkStack : Garder Winsock, la chaîne LSP et les profils réseau
## ProtectScheduledDefaults : Garder les tâches que Windows planifie lui-même — on n'y touche pas
## ProtectBitLocker  : Garder BitLocker et le TPM — ne jamais casser le chiffrement du disque par accident
## ProtectSecureBoot : Garder l'UEFI, le démarrage sécurisé et la configuration d'amorçage
## ProtectRestorePoints : Garder les points de restauration existants — c'est votre chemin de retour
## ProtectEventLogs  : Garder les journaux d'événements — la seule trace de ce qui s'est passé
## ProtectHostsFile  : Garder le fichier hosts — blocages et redirections y vivent
## ProtectFirewallRules : Garder les règles du pare-feu — les perdre ouvre la machine
## ProtectCertificates : Garder les magasins de certificats — les perdre casse les applications signées
## ProtectEnvironmentVariables : Garder les variables d'environnement et le PATH — perdre le PATH casse les outils
## ProtectFonts      : Garder les polices installées — les perdre change tous les documents
## ProtectUserConfigs : Garder vos réglages, par opposition au cache pur — aucune reconfiguration
## ProtectUserProfiles : Garder les profils utilisateurs, y compris ceux qui ne sont pas chargés
## ProtectPinnedFavorites : Garder les raccourcis épinglés et les favoris — ce sont vos habitudes
## ProtectActiveSoftware : Garder les éditeurs dont un produit est encore installé — ils ne sont pas partis
## ProtectThirdPartyAV : Garder un antivirus tiers actif — ne jamais le désactiver en pleine passe
## ProtectPendingReboot : Ne rien faire si un redémarrage est déjà en attente — les résultats seraient brouillés
## AllowAdminElevation : Relancer avec les droits administrateur — une invite, puis plus rien
## AllowSystemExecution : Exécuter en SYSTEM les étapes récalcitrantes — le compte qui possède les fichiers verrouillés
## AllowTrustedInstaller : Prendre possession en TrustedInstaller — pour ce que même SYSTEM ne touche pas
## AllowAclRewrite  : Prendre possession et réécrire les droits d'accès sur un élément bloqué
## AllowProcessShutdown : Fermer le programme qui tient un fichier, via Restart Manager
## AllowLockedDeletion : Supprimer au prochain redémarrage ce que Windows refuse de lâcher maintenant
## AllowDriverRemoval : Retirer les pilotes fantômes avec pnputil — nettoie le magasin de pilotes
## AllowOfflineRegistry : Monter les ruches des profils non chargés pour atteindre leurs résidus
## AllowServiceStop  : Arrêter un service le temps d'un retrait, puis le laisser arrêté
## AllowDefenderPause : Suspendre un instant la protection en temps réel, à partir du niveau extrême
## AllowComponentCleanup : Lancer le nettoyage de composants DISM — gros gain, irréversible
## AllowWindowsOldRemoval : Retirer Windows.old — l'installation précédente, des dizaines de gigaoctets
## AllowToolDownload : Télécharger les outils d'appoint dans l'espace de travail — rien ne reste sur la machine
## AllowRulesDownload : Récupérer le fichier de règles supplémentaires — sauté quand l'adresse est vide
## CreateRestorePoint : Créer d'abord un point de restauration — lent, et Windows n'en autorise qu'un par jour
## ExportRegistryBackup : Sauvegarder chaque clé de registre touchée — un clic suffit à la restaurer
## ExportTaskBackup  : Sauvegarder chaque tâche retirée, en XML — réimportable à la main
## ExportServiceBackup : Sauvegarder chaque service touché, avec son type de démarrage d'origine
## UseRecycleBin     : Envoyer les fichiers à la corbeille — récupérables jusqu'au vidage
## KeepWorkspace     : Garder l'espace de travail après le passage — sauvegardes, journaux et rapports restent
## Rollback          : Annuler un passage précédent au lieu de nettoyer — relit la dernière sauvegarde
## RollbackKeepBackups : Garder les sauvegardes après l'annulation — permet d'annuler deux fois
## ContinueOnItemError : Continuer quand un élément échoue — sinon le passage s'arrête là
## UseKnowledgeBase  : Utiliser la base de connaissance intégrée — fonctionne hors ligne, toujours disponible
## UseExternalRules  : Utiliser le fichier de règles du dépôt — cas plus récents, alimentés par la communauté
## RulesUrl          : Adresse du fichier de règles — vide, il est sauté sans aucune erreur
## ExportReport      : Écrire un rapport JSON et HTML — JSON à traiter, HTML à lire
## DetailedLog       : Écrire chaque action dans le journal — nécessaire pour auditer un passage
## RetryCount        : Tentatives avant de renoncer à un élément — ensuite l'escalade prend le relais
## StartupGrp  : Entrées de démarrage — ce qui se lance à l'ouverture de session
## TasksGrp    : Tâches planifiées — travaux de fond
## ServicesGrp : Services et pilotes — programmes toujours actifs
## RegistryGrp : Traces de désinstallation — restes de logiciels retirés
## FoldersGrp  : Dossiers résiduels — fichiers que plus rien n'utilise
## ShellGrp    : Extensions shell — entrées de menu et gestionnaires COM
## DevicesGrp  : Périphériques fantômes — matériel débranché depuis
## CachesGrp   : Caches et journaux — données temporaires
## LStartup    : Entrée de démarrage
## LTask       : Tâche planifiée
## LService    : Service
## LDriver     : Pilote
## LRegistry   : Clé de registre
## LFolder     : Dossier
## LShellExt   : Extension shell
## LDevice     : Périphérique
## LCache      : Cache
## LFamily     : Groupe
## NIntrusive  : Le script arrête un instant quelques services, prend possession de quelques clés protégées et peut demander un redémarrage. Tout est journalisé et peut être annulé.
## NBackup     : Un point de restauration et une sauvegarde de chaque clé, tâche et service touchés sont écrits avant toute modification.
## NRestart    : Si un fichier est verrouillé par Windows, un redémarrage est nécessaire : le script reprend tout seul juste après.
## NRollback   : Relancez le script avec Retour en arrière pour tout remettre en place.
## NRules      : Les règles supplémentaires sont récupérées depuis le dépôt du projet quand l'adresse est renseignée.
## NExtreme    : À ce niveau, le magasin de composants et les anciens fichiers de Windows sont nettoyés : cette partie est irréversible.
## NNoAdmin    : Sans droits administrateur, les éléments protégés sont signalés mais laissés en place.
## NSafeTest   : Simulation : rien n'est modifié, le script dit seulement ce qu'il ferait.
## NProtected  : Les éléments protégés restent en place tant que leur interrupteur n'est pas désactivé.
## NAboutOrphan : La cible visée n'existe plus.
## NWhyOrphan  : Plus rien ne peut l'utiliser, il ne fait que ralentir l'ouverture de session ou le démarrage.
## NWarnOrphan : Rien : une entrée morte peut être retirée sans risque.
## NAboutUpdater : Un programme de mise à jour rattaché à un logiciel.
## NWhyUpdater : Il tourne à chaque ouverture de session même quand il n'y a rien à mettre à jour.
## NWarnUpdater : Les mises à jour arrivent toujours, simplement moins souvent.
## NAboutProtected : Un composant encore utilisé par Windows ou par un logiciel installé.
## NWhyProtected : Il est proposé parce que son propriétaire a disparu, ou parce qu'il fait doublon.
## NWarnProtected : Le retirer peut casser le programme qui s'appuie dessus.
## FreeSpace   : Espace libre sur le disque C:
## ItemsFound  : Éléments trouvés
## E101 : Droits administrateur requis — acceptez l'invite d'élévation, puis relancez
## E102 : L'espace de travail n'a pas pu être créé — vérifiez l'espace libre sur le disque système
## E103 : La base de connaissance intégrée est illisible — le script se rabat sur les heuristiques
## E104 : Le fichier de règles n'a pas pu être récupéré — la copie en cache, puis la base intégrée, sont utilisées
## E105 : Un outil d'appoint n'a pas pu être téléchargé — la méthode native est utilisée
## E106 : Le point de restauration n'a pas pu être créé — Windows les limite à un par jour
## E107 : Une sauvegarde n'a pas pu être écrite — l'élément est laissé en place
## E108 : Accès refusé sur une clé protégée — la prise de possession est retentée, puis le redémarrage
## E109 : Un fichier est encore verrouillé — il est supprimé au prochain redémarrage
## E110 : Un service n'a pas pu être arrêté — le retrait est retenté, puis reporté
## E111 : Une tâche planifiée n'a pas pu être retirée
## E112 : Un service n'a pas pu être supprimé — il est désactivé à la place
## E113 : Un pilote n'a pas pu être retiré — un redémarrage est nécessaire avant de réessayer
## E114 : Une ruche de profil n'a pas pu être montée — ce profil est sauté
## E115 : Des éléments sont encore là après l'action — relancez le script
## E116 : Le retour en arrière a échoué sur au moins un élément
## E117 : Aucune sauvegarde trouvée — rien à restaurer
## E118 : Un redémarrage est déjà en attente — les éléments sont signalés et laissés tranquilles
## E119 : Il reste moins que la marge de sécurité d'espace libre
## E120 : Un autre nettoyage est déjà en cours
## E121 : La tâche SYSTEM n'a pas pu être créée ou lancée
## E122 : La prise de possession TrustedInstaller a échoué — la voie administrateur est utilisée
## E123 : Les droits d'accès d'origine n'ont pas pu être restaurés sur une clé
## W201 : L'élévation a été refusée — le passage continue sans droits administrateur
## W202 : Un élément protégé a été laissé en place par son interrupteur de protection
## W203 : Un élément est utilisé et a été sauté cette fois
## W204 : L'éditeur n'a pas pu être lu — l'élément est signalé avec une confiance faible
## SINDRY:END