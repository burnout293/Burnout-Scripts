<#
    Sindry - 150_PC_DEEP_CLEANUP.ps1
    Nettoyage profond du PC : demarrage, taches planifiees, services orphelins,
    traces de desinstallation, dossiers residuels, extensions shell, peripheriques
    fantomes et caches.
#>

## SINDRY:START
## id            : 4b7e1d92-6a3c-4f58-8e21-9c0d5a7b3f64
## lang          : en
## title         : Deep PC cleanup
## desc          : Clears startup entries, scheduled tasks, orphan services, registry leftovers, leftover folders, shell extensions, ghost devices and caches. Stops a few services for a moment, takes ownership of a few keys, and asks for one restart if a file is locked by Windows
## category      : cleaning
## icon          : broom-sparkles
## tags          : cleanup, bloatware, startup, tasks, services, registry, leftovers, updaters, ghost devices
## version       : 1.0
## author        : Venice
## created       : 2026-10-24
## updated       : 2026-10-24
## admin         : true
## risk          : high
## duration      : slow
## reversible    : false
## interruptible : true
## reboot        : false
## resume        : true
## engine        : auto
## scan          : true
## view          : tree
## chart         : treemap
## panels        : plan progress attention payload
## SINDRY:END

## SINDRY:OPTIONS
## DoStartup         : [bool] [group:StartupGrp] Startup entries — what launches when you sign in
## DoScheduledTasks  : [bool] [group:TasksGrp] Scheduled tasks — background jobs left behind
## DoServices        : [bool] [group:ServicesGrp] Services and drivers — orphan or dead ones only
## DoRegistryLeftovers : [bool] [group:RegistryGrp] Registry leftovers — traces of removed software
## DoLeftoverFolders : [bool] [group:FoldersGrp] Leftover folders — files no program uses
## DoShellExtensions : [bool] [group:ShellGrp] Shell extensions — dead menu entries
## DoGhostDevices    : [bool] [group:DevicesGrp] Ghost devices — hardware no longer plugged in
## DoCaches          : [bool] [group:CachesGrp] Caches and logs — temporary data
## FoundStartup      : [items] Startup entries found
## FoundTasks        : [items] Scheduled tasks found
## FoundServices     : [items] Services and drivers found
## FoundRegistry     : [items] Registry leftovers found
## FoundFolders      : [items] Leftover folders found
## FoundShellExt     : [items] Shell extensions found
## FoundDevices      : [items] Ghost devices found
## FoundCaches       : [items] Caches found
## Aggressivity      : [select] [scan] How far to go — the higher, the more it removes
##   audit           : Audit — report only, nothing is touched
##   prudent         : Prudent — proven orphans only, recycle bin, admin is enough
##   standard        : Standard — disables updaters and telemetry, removes safe leftovers
##   aggressive      : Aggressive — removes updaters, takes ownership, clears vendor packages
##   extreme         : Extreme — SYSTEM, TrustedInstaller, drivers, offline registry
##   maximum         : Maximum — everything Windows allows, including one restart
## ProtectionProfile : [select] [scan] Protection level — what must be spared
##   strict          : Strict — every protection on, the switches below are ignored
##   standard        : Standard — the switches below decide
##   permissive      : Permissive — only vital components stay protected
##   none            : None — everything found can be removed
## ProtectMicrosoftSigned : [bool] [scan] Keep Microsoft-signed files
## ProtectMicrosoftRecent : [bool] [scan] Keep recent Microsoft-signed files
## ProtectWindowsComponents : [bool] [scan] Keep Windows, System32 and WinSxS
## ProtectVCRedist   : [bool] [scan] Keep Visual C++ Redistributables
## ProtectDotNet     : [bool] [scan] Keep .NET Framework and runtime
## ProtectWebView2   : [bool] [scan] Keep Edge WebView2 runtime
## ProtectDirectX    : [bool] [scan] Keep DirectX and graphics runtimes
## ProtectStoreApps  : [bool] [scan] Keep installed Store applications
## ProtectWSL        : [bool] [scan] Keep WSL, Hyper-V and the VM platform
## ProtectGpuDrivers : [bool] [scan] Keep graphics drivers
## ProtectAudioDrivers : [bool] [scan] Keep audio drivers
## ProtectNetworkDrivers : [bool] [scan] Keep network and Wi-Fi drivers
## ProtectPrintDrivers : [bool] [scan] Keep print drivers
## ProtectCriticalServices : [bool] [scan] Keep services Windows cannot live without
## ProtectWindowsUpdate : [bool] [scan] Keep the update pipeline
## ProtectDefender   : [bool] [scan] Keep Defender and the security centre
## ProtectStore      : [bool] [scan] Keep Store and App Installer
## ProtectXboxGaming : [bool] [scan] Keep Xbox and Gaming Services
## ProtectSearchIndex : [bool] [scan] Keep Windows Search
## ProtectNetworkStack : [bool] [scan] Keep Winsock, LSP and network profiles
## ProtectBitLocker  : [bool] [scan] Keep BitLocker and TPM
## ProtectSecureBoot : [bool] [scan] Keep UEFI, Secure Boot and BCD
## ProtectRestorePoints : [bool] [scan] Keep existing restore points
## ProtectEventLogs  : [bool] [scan] Keep event logs
## ProtectHostsFile  : [bool] [scan] Keep the hosts file
## ProtectFirewallRules : [bool] [scan] Keep firewall rules
## ProtectCertificates : [bool] [scan] Keep certificate stores
## ProtectEnvironmentVariables : [bool] [scan] Keep environment variables and PATH
## ProtectFonts      : [bool] [scan] Keep installed fonts
## ProtectScheduledDefaults : [bool] [scan] Keep Windows scheduled tasks
## ProtectActiveSoftware : [bool] [scan] Keep vendors that still have a product installed
## ProtectThirdPartyAV : [bool] [scan] Keep an active third-party antivirus
## ProtectUserConfigs : [bool] [scan] Keep user settings, as opposed to pure cache
## ProtectUserProfiles : [bool] [scan] Keep user profiles, including unloaded ones
## ProtectPinnedFavorites : [bool] [scan] Keep pinned shortcuts and bookmarks
## ProtectPendingReboot : [bool] [scan] Do nothing while a restart is already pending
## AllowAdminElevation : [bool] [scan] Relaunch with administrator rights
## AllowSystemExecution : [bool] [scan] Run the stubborn steps as SYSTEM
## AllowTrustedInstaller : [bool] [scan] Take ownership as TrustedInstaller
## AllowAclRewrite  : [bool] [scan] Take ownership and rewrite access rights
## AllowProcessShutdown : [bool] [scan] Close holding programs through Restart Manager
## AllowLockedDeletion : [bool] [scan] Delete locked files at the next restart
## AllowDriverRemoval : [bool] [scan] Remove ghost drivers with pnputil
## AllowOfflineRegistry : [bool] [scan] Mount the hives of unloaded profiles
## AllowServiceStop  : [bool] [scan] Stop a service for the time of a removal
## AllowDefenderPause : [bool] [scan] Pause real-time protection for a moment
## AllowComponentCleanup : [bool] [scan] Run DISM component cleanup
## AllowWindowsOldRemoval : [bool] [scan] Remove Windows.old
## AllowMidRunRestart : [bool] [scan] Accept one restart in the middle of the run
## AllowToolDownload : [bool] [scan] Download helper tools into the workspace
## AllowRulesDownload : [bool] [scan] Fetch the extra rules file
## MinAgeDays        : [number] [scan] Only touch items older than — in days
## MaxItemsPerList   : [number] [scan] Most items listed per family — keeps the screen readable
## CreateRestorePoint : [bool] Create a restore point first
## ExportRegistryBackup : [bool] Back up every registry key touched
## ExportTaskBackup  : [bool] Back up every task removed
## ExportServiceBackup : [bool] Back up every service touched
## UseRecycleBin     : [bool] Send files to the recycle bin instead of deleting
## KeepWorkspace     : [bool] Keep the workspace after the run
## UseKnowledgeBase  : [bool] Use the built-in knowledge base
## UseExternalRules  : [bool] Use the extra rules file from the project repository
## RulesUrl          : [string] Address of the extra rules file — empty skips it
## ExportReport      : [bool] Write a JSON and an HTML report in the workspace
## DetailedLog       : [bool] Write every action to the log file
## Rollback          : [bool] Restore a previous run instead of cleaning
## RollbackKeepBackups : [bool] Keep the backups after a rollback
## ContinueOnItemError : [bool] Carry on when one item fails
## RetryCount        : [number] [scan] How many times a failed removal is retried
## SafeTest          : [bool] Simulate — shows what would be done, changes nothing
## SINDRY:END

## SINDRY:REPORT
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
## desc          : Nettoie les entrees de demarrage, les taches planifiees, les services orphelins, les traces de desinstallation, les dossiers residuels, les extensions shell, les peripheriques fantomes et les caches. Arrete brievement quelques services, prend possession de quelques cles et demande un redemarrage si un fichier est verrouille par Windows
## DoStartup         : Entrees de demarrage — ce qui se lance a l'ouverture de session
## DoScheduledTasks  : Taches planifiees — travaux de fond laisses par des logiciels
## DoServices        : Services et pilotes — seulement les orphelins ou les morts
## DoRegistryLeftovers : Traces de desinstallation — restes de logiciels retires
## DoLeftoverFolders : Dossiers residuels — fichiers que plus rien n'utilise
## DoShellExtensions : Extensions shell — entrees de menu mortes
## DoGhostDevices    : Peripheriques fantomes — materiel debranche depuis
## DoCaches          : Caches et journaux — donnees temporaires
## FoundStartup      : Entrees de demarrage trouvees
## FoundTasks        : Taches planifiees trouvees
## FoundServices     : Services et pilotes trouves
## FoundRegistry     : Traces de desinstallation trouvees
## FoundFolders      : Dossiers residuels trouves
## FoundShellExt     : Extensions shell trouvees
## FoundDevices      : Peripheriques fantomes trouves
## FoundCaches       : Caches trouves
## Aggressivity      : Jusqu'ou aller — plus haut, plus il retire
##   audit           : Audit — rapport seul, rien n'est touche
##   prudent         : Prudent — seuls les orphelins prouves, corbeille, admin suffisant
##   standard        : Standard — desactive les updaters et la telemetrie, retire les residus sans risque
##   aggressive      : Agressif — retire les updaters, prend possession, nettoie les paquets editeurs
##   extreme         : Extreme — SYSTEM, TrustedInstaller, pilotes, registre hors ligne
##   maximum         : Maximum — tout ce que Windows permet, redemarrage compris
## ProtectionProfile : Niveau de protection — ce qui doit etre epargne
##   strict          : Strict — toutes les protections actives, les interrupteurs sont ignores
##   standard        : Standard — ce sont les interrupteurs ci-dessous qui decident
##   permissive      : Permissif — seuls les composants vitaux restent proteges
##   none            : Aucune — tout ce qui est trouve peut etre retire
## ProtectMicrosoftSigned : Garder les fichiers signes Microsoft
## ProtectMicrosoftRecent : Garder les fichiers signes Microsoft recents
## ProtectWindowsComponents : Garder Windows, System32 et WinSxS
## ProtectVCRedist   : Garder les Visual C++ Redistributables
## ProtectDotNet     : Garder .NET Framework et son moteur
## ProtectWebView2   : Garder Edge WebView2
## ProtectDirectX    : Garder DirectX et les moteurs graphiques
## ProtectStoreApps  : Garder les applications du Store installees
## ProtectWSL        : Garder WSL, Hyper-V et la plateforme de machines virtuelles
## ProtectGpuDrivers : Garder les pilotes graphiques
## ProtectAudioDrivers : Garder les pilotes audio
## ProtectNetworkDrivers : Garder les pilotes reseau et Wi-Fi
## ProtectPrintDrivers : Garder les pilotes d'impression
## ProtectCriticalServices : Garder les services indispensables a Windows
## ProtectWindowsUpdate : Garder la chaine de mise a jour
## ProtectDefender   : Garder Defender et le centre de securite
## ProtectStore      : Garder le Store et App Installer
## ProtectXboxGaming : Garder Xbox et Gaming Services
## ProtectSearchIndex : Garder la recherche Windows
## ProtectNetworkStack : Garder Winsock, les LSP et les profils reseau
## ProtectBitLocker  : Garder BitLocker et le TPM
## ProtectSecureBoot : Garder l'UEFI, le demarrage securise et le BCD
## ProtectRestorePoints : Garder les points de restauration existants
## ProtectEventLogs  : Garder les journaux d'evenements
## ProtectHostsFile  : Garder le fichier hosts
## ProtectFirewallRules : Garder les regles du pare-feu
## ProtectCertificates : Garder les magasins de certificats
## ProtectEnvironmentVariables : Garder les variables d'environnement et le PATH
## ProtectFonts      : Garder les polices installees
## ProtectScheduledDefaults : Garder les taches planifiees de Windows
## ProtectActiveSoftware : Garder les editeurs dont un produit est encore installe
## ProtectThirdPartyAV : Garder un antivirus tiers actif
## ProtectUserConfigs : Garder les reglages utilisateur, par opposition au cache
## ProtectUserProfiles : Garder les profils utilisateurs, y compris non charges
## ProtectPinnedFavorites : Garder les raccourcis epingles et les favoris
## ProtectPendingReboot : Ne rien faire si un redemarrage est deja en attente
## AllowAdminElevation : Relancer avec les droits administrateur
## AllowSystemExecution : Executer en SYSTEM les etapes recalcitrantes
## AllowTrustedInstaller : Prendre possession en TrustedInstaller
## AllowAclRewrite  : Prendre possession et reecrire les droits d'acces
## AllowProcessShutdown : Fermer les programmes qui verrouillent, via Restart Manager
## AllowLockedDeletion : Supprimer les fichiers verrouilles au prochain redemarrage
## AllowDriverRemoval : Retirer les pilotes fantomes avec pnputil
## AllowOfflineRegistry : Monter les ruches des profils non charges
## AllowServiceStop  : Arreter un service le temps d'un retrait
## AllowDefenderPause : Suspendre un instant la protection en temps reel
## AllowComponentCleanup : Lancer le nettoyage de composants DISM
## AllowWindowsOldRemoval : Retirer Windows.old
## AllowMidRunRestart : Accepter un redemarrage au milieu du traitement
## AllowToolDownload : Telecharger les outils d'appoint dans l'espace de travail
## AllowRulesDownload : Recuperer le fichier de regles supplementaires
## MinAgeDays        : Ne toucher qu'aux elements plus vieux que — en jours
## MaxItemsPerList   : Nombre maximal d'elements listes par famille — garde l'ecran lisible
## CreateRestorePoint : Creer d'abord un point de restauration
## ExportRegistryBackup : Sauvegarder chaque cle de registre touchee
## ExportTaskBackup  : Sauvegarder chaque tache retiree
## ExportServiceBackup : Sauvegarder chaque service touche
## UseRecycleBin     : Envoyer les fichiers a la corbeille au lieu de les supprimer
## KeepWorkspace     : Garder l'espace de travail apres le passage
## UseKnowledgeBase  : Utiliser la base de connaissance integree
## UseExternalRules  : Utiliser le fichier de regles supplementaires du depot
## RulesUrl          : Adresse du fichier de regles — vide, il est saute
## ExportReport      : Ecrire un rapport JSON et HTML dans l'espace de travail
## DetailedLog       : Ecrire chaque action dans le journal
## Rollback          : Restaurer un passage precedent au lieu de nettoyer
## RollbackKeepBackups : Garder les sauvegardes apres un retour en arriere
## ContinueOnItemError : Continuer quand un element echoue
## RetryCount        : Nombre de tentatives avant de renoncer a un retrait
## SafeTest          : Simuler — montre ce qui serait fait, sans rien modifier
## StartupGrp  : Entrees de demarrage — ce qui se lance a l'ouverture de session
## TasksGrp    : Taches planifiees — travaux de fond
## ServicesGrp : Services et pilotes — programmes toujours actifs
## RegistryGrp : Traces de desinstallation — restes de logiciels retires
## FoldersGrp  : Dossiers residuels — fichiers que plus rien n'utilise
## ShellGrp    : Extensions shell — entrees de menu et gestionnaires COM
## DevicesGrp  : Peripheriques fantomes — materiel debranche depuis
## CachesGrp   : Caches et journaux — donnees temporaires
## LStartup    : Entree de demarrage
## LTask       : Tache planifiee
## LService    : Service
## LDriver     : Pilote
## LRegistry   : Cle de registre
## LFolder     : Dossier
## LShellExt   : Extension shell
## LDevice     : Peripherique
## LCache      : Cache
## LFamily     : Groupe
## NIntrusive  : Le script arrete un instant quelques services, prend possession de quelques cles protegees et peut demander un redemarrage. Tout est journalise et peut etre annule.
## NBackup     : Un point de restauration et une sauvegarde de chaque cle, tache et service touches sont ecrits avant toute modification.
## NRestart    : Si un fichier est verrouille par Windows, un redemarrage est necessaire : le script reprend tout seul juste apres.
## NRollback   : Relancez le script avec Retour en arriere pour tout remettre en place.
## NRules      : Les regles supplementaires sont recuperees depuis le depot du projet quand l'adresse est renseignee.
## NExtreme    : A ce niveau, le magasin de composants et les anciens fichiers de Windows sont nettoyes : cette partie est irreversible.
## NNoAdmin    : Sans droits administrateur, les elements proteges sont signales mais laisses en place.
## NSafeTest   : Simulation : rien n'est modifie, le script dit seulement ce qu'il ferait.
## NProtected  : Les elements proteges restent en place tant que leur interrupteur n'est pas desactive.
## NAboutOrphan : La cible visee n'existe plus.
## NWhyOrphan  : Plus rien ne peut l'utiliser, il ne fait que ralentir l'ouverture de session ou le demarrage.
## NWarnOrphan : Rien : une entree morte peut etre retiree sans risque.
## NAboutUpdater : Un programme de mise a jour rattache a un logiciel.
## NWhyUpdater : Il tourne a chaque ouverture de session meme quand il n'y a rien a mettre a jour.
## NWarnUpdater : Les mises a jour arrivent toujours, simplement moins souvent.
## NAboutProtected : Un composant encore utilise par Windows ou par un logiciel installe.
## NWhyProtected : Il est propose parce que son proprietaire a disparu, ou parce qu'il fait doublon.
## NWarnProtected : Le retirer peut casser le programme qui s'appuie dessus.
## FreeSpace   : Espace libre sur le disque C:
## ItemsFound  : Elements trouves
## E101 : Droits administrateur requis — acceptez l'invite d'elevation, puis relancez
## E102 : L'espace de travail n'a pas pu etre cree — verifiez l'espace libre sur le disque systeme
## E103 : La base de connaissance integree est illisible — le script se rabat sur les heuristiques
## E104 : Le fichier de regles n'a pas pu etre recupere — la copie en cache, puis la base integree, sont utilisees
## E105 : Un outil d'appoint n'a pas pu etre telecharge — la methode native est utilisee
## E106 : Le point de restauration n'a pas pu etre cree — Windows les limite a un par jour
## E107 : Une sauvegarde n'a pas pu etre ecrite — l'element est laisse en place
## E108 : Acces refuse sur une cle protegee — la prise de possession est retentee, puis le redemarrage
## E109 : Un fichier est encore verrouille — il est supprime au prochain redemarrage
## E110 : Un service n'a pas pu etre arrete — le retrait est retente, puis reporte
## E111 : Une tache planifiee n'a pas pu etre retiree
## E112 : Un service n'a pas pu etre supprime — il est desactive a la place
## E113 : Un pilote n'a pas pu etre retire — un redemarrage est necessaire avant de reessayer
## E114 : Une ruche de profil n'a pas pu etre montee — ce profil est saute
## E115 : Des elements sont encore la apres l'action — relancez le script
## E116 : Le retour en arriere a echoue sur au moins un element
## E117 : Aucune sauvegarde trouvee — rien a restaurer
## E118 : Un redemarrage est deja en attente — les elements sont signales et laisses tranquilles
## E119 : Il reste moins que la marge de securite d'espace libre
## E120 : Un autre nettoyage est deja en cours
## E121 : La tache SYSTEM n'a pas pu etre creee ou lancee
## E122 : La prise de possession TrustedInstaller a echoue — la voie administrateur est utilisee
## E123 : Les droits d'acces d'origine n'ont pas pu etre restaures sur une cle
## W201 : L'elevation a ete refusee — le passage continue sans droits administrateur
## W202 : Un element protege a ete laisse en place par son interrupteur de protection
## W203 : Un element est utilise et a ete saute cette fois
## W204 : L'editeur n'a pas pu etre lu — l'element est signale avec une confiance faible
## SINDRY:END

$CONFIG = @{
    DoStartup            = $true
    DoScheduledTasks     = $true
    DoServices           = $true
    DoRegistryLeftovers  = $true
    DoLeftoverFolders    = $true
    DoShellExtensions    = $true
    DoGhostDevices       = $true
    DoCaches             = $true
    FoundStartup         = @()
    FoundTasks           = @()
    FoundServices        = @()
    FoundRegistry        = @()
    FoundFolders         = @()
    FoundShellExt        = @()
    FoundDevices         = @()
    FoundCaches          = @()
    Aggressivity         = "standard"
    ProtectionProfile    = "standard"
    ProtectMicrosoftSigned = $true
    ProtectMicrosoftRecent = $true
    ProtectWindowsComponents = $true
    ProtectVCRedist      = $true
    ProtectDotNet        = $true
    ProtectWebView2      = $true
    ProtectDirectX       = $true
    ProtectStoreApps     = $true
    ProtectWSL           = $true
    ProtectGpuDrivers    = $true
    ProtectAudioDrivers  = $true
    ProtectNetworkDrivers = $true
    ProtectPrintDrivers  = $true
    ProtectCriticalServices = $true
    ProtectWindowsUpdate = $true
    ProtectDefender      = $true
    ProtectStore         = $true
    ProtectXboxGaming    = $true
    ProtectSearchIndex   = $true
    ProtectNetworkStack  = $true
    ProtectBitLocker     = $true
    ProtectSecureBoot    = $true
    ProtectRestorePoints = $true
    ProtectEventLogs     = $true
    ProtectHostsFile     = $true
    ProtectFirewallRules = $true
    ProtectCertificates  = $true
    ProtectEnvironmentVariables = $true
    ProtectFonts         = $true
    ProtectScheduledDefaults = $true
    ProtectActiveSoftware = $true
    ProtectThirdPartyAV  = $true
    ProtectUserConfigs   = $true
    ProtectUserProfiles  = $true
    ProtectPinnedFavorites = $true
    ProtectPendingReboot = $true
    AllowAdminElevation  = $true
    AllowSystemExecution = $true
    AllowTrustedInstaller = $true
    AllowAclRewrite      = $true
    AllowProcessShutdown = $true
    AllowLockedDeletion  = $true
    AllowDriverRemoval   = $true
    AllowOfflineRegistry = $true
    AllowServiceStop     = $true
    AllowDefenderPause   = $true
    AllowComponentCleanup = $true
    AllowWindowsOldRemoval = $true
    AllowMidRunRestart   = $true
    AllowToolDownload    = $true
    AllowRulesDownload   = $true
    MinAgeDays           = 0
    MaxItemsPerList      = 120
    CreateRestorePoint   = $true
    ExportRegistryBackup = $true
    ExportTaskBackup     = $true
    ExportServiceBackup  = $true
    UseRecycleBin        = $true
    KeepWorkspace        = $false
    UseKnowledgeBase     = $true
    UseExternalRules     = $true
    RulesUrl             = ""
    ExportReport         = $true
    DetailedLog          = $true
    Rollback             = $false
    RollbackKeepBackups  = $false
    ContinueOnItemError  = $true
    RetryCount           = 2
    SafeTest             = $false
}

# --- Sindry override (ne pas supprimer) ---
if ($env:SINDRY_CONFIG) {
    ($env:SINDRY_CONFIG | ConvertFrom-Json).PSObject.Properties |
        ForEach-Object { $CONFIG[$_.Name] = $_.Value }
}

# ==============================================================================
# CHAPITRE 1 - SOMMAIRE
# ==============================================================================
#   1. Sommaire
#   2. Drapeaux internes
#   3. Utilitaires (sortie, chemins, droits, sauvegardes)
#   4. Base de connaissance et heuristiques
#   5. Collecteurs (lecture seule)
#   6. Decision
#   7. Analyse
#   8. Reprise apres redemarrage
#   9. Retour en arriere
#  10. Preparation
#  11. Execution
#  12. Verification et rapport
# ==============================================================================

# ==============================================================================
# CHAPITRE 2 - DRAPEAUX INTERNES
# ==============================================================================
# Tous les comportements du script se reglent ici. Les options de l'interface ne
# sont qu'une facade : elles sont recopiees dans ces drapeaux juste en dessous.
# Modifier un drapeau ici suffit, aucun test n'est ecrit en dur plus bas.

# --- Espace de travail et outils -------------------------------------------
$WorkspaceRoot      = "$env:SystemDrive\Temp\SindryCleanup"   # racine de travail
$WorkspaceFallbacks = @("$env:TEMP\SindryCleanup", "$env:ProgramData\SindryCleanup")  # replis
$KeepWorkspace      = $false                                  # garder l'espace apres coup
$DownloadTools      = $true                                   # telecharger les outils d'appoint
$ToolAutoruns       = $true                                   # utiliser autorunsc quand il est la
$ToolPsexec         = $true                                   # utiliser PsExec pour SYSTEM
$ToolSevenZip       = $true                                   # utiliser 7z quand il est la
$ToolsUrlBase       = "https://live.sysinternals.com"         # source des outils Sysinternals
$CleanToolsAfter    = $true                                   # effacer les outils en fin de course

# --- Collecte : ce que chaque collecteur va chercher ------------------------
$CollectRunKeys          = $true   # cles Run et RunOnce
$CollectStartupFolders   = $true   # dossiers Demarrage utilisateur et machine
$CollectUserTasks        = $true   # taches planifiees de l'utilisateur
$CollectSystemTasks      = $true   # taches planifiees machine
$CollectServices         = $true   # services
$CollectDrivers          = $true   # pilotes noyau
$CollectUninstallKeys    = $true   # cles de desinstallation
$CollectInstallerProducts = $true  # produits MSI orphelins
$CollectAppDataFolders   = $true   # dossiers residuels AppData et LocalAppData
$CollectProgramDataFolders = $true # dossiers residuels ProgramData
$CollectProgramFilesFolders = $true # dossiers residuels Program Files
$CollectShellHandlers    = $true   # gestionnaires de menu contextuel
$CollectComHandlers      = $true   # gestionnaires COM orphelins
$CollectGhostDevices     = $true   # peripheriques deconnectes
$CollectCaches           = $true   # caches et journaux
$CollectOtherProfiles    = $true   # profils utilisateurs non charges
$CollectWindowsOld       = $true   # Windows.old

# --- Analyse ----------------------------------------------------------------
$AnalyzeCheckSignature   = $true   # lire la signature Authenticode
$AnalyzeCheckLastAccess  = $false  # lire la derniere utilisation (couteux)
$AnalyzeDetectUpdaters   = $true   # reperer les updaters sans produit parent
$AnalyzeDetectDuplicates = $true   # reperer les doublons fonctionnels
$AnalyzeDetectEmptyUninstall = $true  # reperer les cles de desinstallation vides
$ScoreKnownVendorBoost   = 25      # bonus quand l'editeur est dans la base
$ScoreThresholdReport    = 20      # en dessous, l'element n'est que signale
$ScoreThresholdClean     = 40      # au dessus, l'element est propose au nettoyage

# --- Action -----------------------------------------------------------------
$ActVerifyAfterAction    = $true   # reverifier chaque cible apres coup
$ActUseRestartManager    = $true   # fermer les programmes qui verrouillent
$ActUseDelayedDelete     = $true   # suppression differee au redemarrage
$ActDeleteToRecycleBin   = $true   # corbeille plutot que suppression
$ActDisableInsteadOfDelete = $true # desactiver un service avant de le supprimer
$ActStopServiceBeforeDelete = $true # arreter un service avant de le toucher
$ActBackupBeforeWrite    = $true   # sauvegarder avant toute ecriture

# --- Robustesse -------------------------------------------------------------
$RetryCount              = 2       # tentatives avant de renoncer
$RetryDelayMs            = 250     # attente entre deux tentatives
$TimeoutSystemTaskSeconds = 180    # delai maximal d'une tache SYSTEM
$TimeoutToolSeconds      = 120     # delai maximal d'un outil externe
$MutexName               = "Global\SindryDeepCleanup"  # verrou d'instance unique
$AbortOnLowDiskPercent   = 3       # marge d'espace libre sur le disque systeme

# --- Base de connaissance ---------------------------------------------------
$KbUseEmbedded           = $true   # base integree
$KbCacheTtlDays          = 7       # duree de vie du cache de regles
$KbVerifyHash            = $true   # verifier l'empreinte du fichier de regles
$KbOfflineOnly           = $false  # ne jamais sortir sur le reseau
$KbUnknownReport         = $true   # exporter les cas non reconnus
$KbMaxRules              = 5000    # nombre maximal de regles chargees

# --- Sortie -----------------------------------------------------------------
$OutVerbose              = $true   # journal detaille
$OutShowFreed            = $true   # annoncer l'espace libere
$OutGroupByDomain        = $true   # grouper le journal par domaine
$OutMaxLogLines          = 400     # nombre maximal de lignes de journal par domaine
$OutExportJson           = $true   # rapport JSON
$OutExportHtml           = $true   # rapport HTML

# --- Garde-fous -------------------------------------------------------------
$GuardProtectedPaths     = $true   # ne jamais viser Windows, Program Files, une racine
$GuardRunningInstallers  = $true   # ne rien toucher pendant une installation
$GuardSystemDrive        = $true   # exiger que le disque systeme existe
$MaxItemsTotal           = 350     # nombre maximal d'elements annonces au total
$MaxScanSeconds          = 900     # au dela, l'analyse s'arrete proprement

# --- Niveaux d'agressivite (index 0 a 5) ------------------------------------
$LevelNames              = @('audit', 'prudent', 'standard', 'aggressive', 'extreme', 'maximum')
$Level                   = 2       # recalcule depuis l'option, prudent par defaut

# --- Correspondance protection -> option ------------------------------------
$ProtectionMap = @{
    'microsoftsigned' = 'ProtectMicrosoftSigned'
    'microsoftrecent' = 'ProtectMicrosoftRecent'
    'windows'         = 'ProtectWindowsComponents'
    'vcpp'            = 'ProtectVCRedist'
    'dotnet'          = 'ProtectDotNet'
    'webview2'        = 'ProtectWebView2'
    'directx'         = 'ProtectDirectX'
    'storeapps'       = 'ProtectStoreApps'
    'wsl'             = 'ProtectWSL'
    'gpudrivers'      = 'ProtectGpuDrivers'
    'audiodrivers'    = 'ProtectAudioDrivers'
    'networkdrivers'  = 'ProtectNetworkDrivers'
    'printdrivers'    = 'ProtectPrintDrivers'
    'criticalservices' = 'ProtectCriticalServices'
    'windowsupdate'   = 'ProtectWindowsUpdate'
    'defender'        = 'ProtectDefender'
    'store'           = 'ProtectStore'
    'xboxgaming'      = 'ProtectXboxGaming'
    'searchindex'     = 'ProtectSearchIndex'
    'networkstack'    = 'ProtectNetworkStack'
    'bitlocker'       = 'ProtectBitLocker'
    'secureboot'      = 'ProtectSecureBoot'
    'restorepoints'   = 'ProtectRestorePoints'
    'eventlogs'       = 'ProtectEventLogs'
    'hostsfile'       = 'ProtectHostsFile'
    'firewallrules'   = 'ProtectFirewallRules'
    'certificates'    = 'ProtectCertificates'
    'environment'     = 'ProtectEnvironmentVariables'
    'fonts'           = 'ProtectFonts'
    'scheduleddefaults' = 'ProtectScheduledDefaults'
    'activesoftware'  = 'ProtectActiveSoftware'
    'thirdpartyav'    = 'ProtectThirdPartyAV'
    'userconfigs'     = 'ProtectUserConfigs'
    'userprofiles'    = 'ProtectUserProfiles'
    'pinned'          = 'ProtectPinnedFavorites'
    'pendingreboot'   = 'ProtectPendingReboot'
}
$VitalProtections = @(
    'ProtectWindowsComponents', 'ProtectCriticalServices', 'ProtectVCRedist',
    'ProtectDotNet', 'ProtectBitLocker', 'ProtectSecureBoot', 'ProtectMicrosoftSigned'
)

# --- Listes de reference, modifiables sans toucher au reste -----------------
$CriticalServices = @(
    'RpcSs', 'RpcEptMapper', 'DcomLaunch', 'BrokerInfrastructure', 'Power',
    'PlugPlay', 'ProfSvc', 'SamSs', 'Schedule', 'Winmgmt', 'EventLog', 'gpsvc',
    'Themes', 'AudioSrv', 'AudioEndpointBuilder', 'Dhcp', 'Dnscache', 'nsi',
    'CryptSvc', 'LanmanWorkstation', 'LanmanServer', 'UserManager', 'StateRepository'
)
$UpdaterPatterns = @('*update*', '*updater*', '*autoupdate*', '*scheduler*', '*agent*')
$KnownUpdaterNames = @(
    'GoogleUpdateTaskMachineCore', 'GoogleUpdateTaskMachineUA', 'MicrosoftEdgeUpdateTaskMachineCore',
    'MicrosoftEdgeUpdateTaskMachineUA', 'Adobe Acrobat Update Task', 'AdobeARMservice',
    'Opera scheduled Autoupdate', 'BraveSoftwareUpdateTaskMachineUA', 'Dropbox Update Task',
    'CCleaner Update', 'MicrosoftTeamsUpdate', 'EpicGamesLauncher', 'Steam Client Bootstrapper'
)
$VendorFolders = @(
    'Webroot', 'WRData', 'Adobe', 'Adobe Systems', 'AdobeARM', 'OneDrive', 'McAfee',
    'Norton', 'Symantec', 'AVG', 'Avast', 'Avira', 'Kaspersky', 'ESET', 'Malwarebytes',
    'CCleaner', 'Piriform', 'Dropbox', 'Spotify', 'iTunes', 'Apple', 'QuickTime',
    'Java', 'Oracle', 'Realtek', 'Dell', 'HP', 'Hewlett-Packard', 'Lenovo', 'ASUS',
    'Acer', 'MSI', 'Samsung', 'Toshiba', 'WildTangent', 'Ask', 'Conduit', 'Babylon'
)
$NeverDeleteNames = @(
    'Microsoft', 'Windows', 'WindowsApps', 'Windows Defender', 'Packages', 'Temp',
    'System32', 'SysWOW64', 'WinSxS', 'Common Files', 'InstallShield Installation Information'
)

# --- Lecture des options vers les drapeaux ----------------------------------
$SafeTest            = ("$($CONFIG.SafeTest)" -eq 'True')            # simulation
$DetailedLog         = ("$($CONFIG.DetailedLog)" -eq 'True')         # journal detaille
$UseRecycleBin       = ("$($CONFIG.UseRecycleBin)" -eq 'True')       # corbeille
$AllowAclRewrite     = ("$($CONFIG.AllowAclRewrite)" -eq 'True')     # prise de possession
$AllowSystem         = ("$($CONFIG.AllowSystemExecution)" -eq 'True') # execution SYSTEM
$AllowDelayed        = ("$($CONFIG.AllowLockedDeletion)" -eq 'True') # suppression differee
$AllowDriverRemoval  = ("$($CONFIG.AllowDriverRemoval)" -eq 'True')  # pilotes fantomes
$AllowRestart        = ("$($CONFIG.AllowMidRunRestart)" -eq 'True')  # redemarrage du milieu
$AllowTools          = ("$($CONFIG.AllowToolDownload)" -eq 'True')   # outils d'appoint
$AllowRules          = ("$($CONFIG.AllowRulesDownload)" -eq 'True')  # regles distantes
$DoRollback          = ("$($CONFIG.Rollback)" -eq 'True')            # mode retour en arriere
$ContinueOnError     = ("$($CONFIG.ContinueOnItemError)" -eq 'True') # ne pas s'arreter
$CreateRestorePoint  = ("$($CONFIG.CreateRestorePoint)" -eq 'True')  # point de restauration
$ExportReport        = ("$($CONFIG.ExportReport)" -eq 'True')        # rapport final
$KeepWorkspace       = ("$($CONFIG.KeepWorkspace)" -eq 'True')       # garder l'espace
$Profile             = "$($CONFIG.ProtectionProfile)"                # profil de protection
$RetryCount          = [int]$CONFIG.RetryCount                       # tentatives
$MinAgeDays          = [int]$CONFIG.MinAgeDays                       # anciennete minimale
$MaxItemsPerList     = [int]$CONFIG.MaxItemsPerList                  # borne d'affichage
$RulesUrl            = "$($CONFIG.RulesUrl)"                         # adresse des regles
if ($RetryCount -lt 0) { $RetryCount = 0 }
if ($RetryCount -gt 10) { $RetryCount = 10 }
if ($MinAgeDays -lt 0) { $MinAgeDays = 0 }
if ($MinAgeDays -gt 3650) { $MinAgeDays = 3650 }
if ($MaxItemsPerList -lt 20) { $MaxItemsPerList = 20 }
if ($MaxItemsPerList -gt 400) { $MaxItemsPerList = 400 }
for ($i = 0; $i -lt $LevelNames.Count; $i++) {
    if ($LevelNames[$i] -eq "$($CONFIG.Aggressivity)") { $Level = $i }
}

# ==============================================================================
# CHAPITRE 3 - UTILITAIRES
# ==============================================================================

$RelayFile   = $env:SINDRY_CLEANUP_RELAY    # fichier de relais quand on s'eleve
$ScriptId    = '4b7e1d92-6a3c-4f58-8e21-9c0d5a7b3f64'  # identifiant, pour le registre
$RunStamp    = (Get-Date).ToString('yyyyMMdd-HHmmss')   # horodatage du passage
$RunFolder   = ''                                       # dossier du passage
$BackupDir   = ''                                       # sous-dossier des sauvegardes
$LogFile     = ''                                       # fichier de journal
$ReportFile  = ''                                       # fichier de rapport JSON
$ReportHtml  = ''                                       # fichier de rapport HTML
$PendingFile = ''                                       # liste des suppressions differees
$LastRunFile = ''                                       # pointeur vers le dernier passage
$FreedBytes  = [long]0                                  # octets reellement liberes
$ErrorCount  = 0                                        # nombre d'erreurs affichees
$Residual    = 0                                        # elements encore presents a la fin

# Ecrit une ligne de sortie, et la recopie dans le relais si on est un enfant.
function Write-Line([string]$Text) {
    Write-Host $Text
    if ($RelayFile) {
        try { Add-Content -LiteralPath $RelayFile -Value $Text -Encoding UTF8 -ErrorAction SilentlyContinue } catch { }
    }
    if ($LogFile -and $DetailedLog) {
        try { Add-Content -LiteralPath $LogFile -Value $Text -Encoding UTF8 -ErrorAction SilentlyContinue } catch { }
    }
}

# Ecrit une erreur codee et incremente le compteur.
function Write-Err([string]$Code, [string]$Detail) {
    $script:ErrorCount++
    Write-Line "[ERR] $Code $Detail"
}

# Ecrit un avertissement code.
function Write-WarnCode([string]$Code, [string]$Detail) {
    Write-Line "[WARN] $Code $Detail"
}

# Renvoie $true si le processus est administrateur.
function Test-IsAdmin {
    $id = [Security.Principal.WindowsIdentity]::GetCurrent()
    $p = New-Object Security.Principal.WindowsPrincipal($id)
    return $p.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Renvoie la valeur booleenne d'une option, quel que soit le chemin emprunte.
function Get-Opt([string]$Key) {
    return ("$($CONFIG[$Key])" -eq 'True')
}

# Verifie qu'une protection est active, selon le profil et son interrupteur.
function Test-Protected([string]$Kind) {
    if ($Profile -eq 'strict') { return $true }
    if ($Profile -eq 'none') { return $false }
    $opt = $ProtectionMap[$Kind]
    if (-not $opt) { return $false }
    if ($Profile -eq 'permissive') {
        if ($VitalProtections -contains $opt) { return $true }
    }
    return (Get-Opt $opt)
}

# Nettoie une chaine pour qu'elle tienne dans un champ de sortie.
function Clean-Text([string]$Text) {
    if (-not $Text) { return '' }
    $t = $Text -replace '"', ''
    $t = $t -replace '\s+', ' '
    if ($t.Length -gt 120) { $t = $t.Substring(0, 120) }
    return $t.Trim()
}

# Construit un identifiant stable a partir de deux chaines qui ne bougent pas.
function New-StableId([string]$Prefix, [string]$A, [string]$B) {
    $raw = "$A|$B"
    $hash = [long]7
    foreach ($ch in $raw.ToCharArray()) {
        $hash = (($hash * 31) + [int]$ch) % 1000000007
    }
    $slug = ($A -replace '[^\w.-]', '-')
    if ($slug.Length -gt 56) { $slug = $slug.Substring(0, 56) }
    return "$Prefix-$slug-$hash"
}

# Renvoie la taille en octets d'un fichier ou d'un dossier.
function Get-PathSize([string]$Path) {
    $item = Get-Item -LiteralPath $Path -Force -ErrorAction SilentlyContinue
    if (-not $item) { return [long]0 }
    if (-not $item.PSIsContainer) { return [long]$item.Length }
    $m = Get-ChildItem -LiteralPath $Path -Recurse -File -Force -ErrorAction SilentlyContinue |
         Measure-Object -Property Length -Sum
    return [long]$m.Sum
}

# Extrait le chemin d'executable d'une ligne de commande, guillemets compris.
function Get-ExeFromCommand([string]$Command) {
    if (-not $Command) { return '' }
    $c = $Command.Trim()
    if ($c.StartsWith('"')) {
        $end = $c.IndexOf('"', 1)
        if ($end -gt 1) { return $c.Substring(1, $end - 1) }
    }
    $space = $c.IndexOf(' ')
    if ($space -gt 0) { $c = $c.Substring(0, $space) }
    $c = $c -replace '^\\\?\?\\', ''
    return $c.Trim()
}

# Developpe les variables d'environnement presentes dans une commande.
function Expand-Command([string]$Command) {
    if (-not $Command) { return '' }
    return [Environment]::ExpandEnvironmentVariables($Command)
}

# Renvoie l'editeur signataire d'un fichier, ou une chaine vide.
function Get-Publisher([string]$Path) {
    if (-not $Path) { return '' }
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return '' }
    try {
        $sig = Get-AuthenticodeSignature -LiteralPath $Path -ErrorAction Stop
        if ($sig -and $sig.SignerCertificate) { return $sig.SignerCertificate.Subject }
    } catch { }
    return ''
}

# Renvoie $true si le chemin est un emplacement a ne pas supprimer tel quel.
function Test-ProtectedPath([string]$Path) {
    if (-not $GuardProtectedPaths) { return $false }
    try { $p = [IO.Path]::GetFullPath($Path).TrimEnd('\') } catch { return $true }
    $root = [IO.Path]::GetPathRoot($p).TrimEnd('\')
    if ($p -eq $root) { return $true }
    $crit = @($env:SystemRoot, $env:ProgramFiles, ${env:ProgramFiles(x86)}, $env:ProgramData, $env:USERPROFILE) |
            Where-Object { $_ }
    foreach ($c in $crit) {
        try { $cc = [IO.Path]::GetFullPath($c).TrimEnd('\') } catch { continue }
        if ($p -eq $cc) { return $true }
    }
    return $false
}

# Renvoie $true si le chemin pointe sous un emplacement protege.
function Test-UnderProtected([string]$Path) {
    try { $p = [IO.Path]::GetFullPath($Path).TrimEnd('\') } catch { return $true }
    $crit = @($env:SystemRoot, $env:ProgramFiles, ${env:ProgramFiles(x86)}, $env:ProgramData) | Where-Object { $_ }
    foreach ($c in $crit) {
        try { $cc = [IO.Path]::GetFullPath($c).TrimEnd('\') } catch { continue }
        if ($p.StartsWith("$cc\", 'OrdinalIgnoreCase')) { return $true }
    }
    return $false
}

# Renvoie $true si le chemin est plus vieux que le seuil demande.
function Test-OldEnough([string]$Path) {
    if ($MinAgeDays -le 0) { return $true }
    $item = Get-Item -LiteralPath $Path -Force -ErrorAction SilentlyContinue
    if (-not $item) { return $true }
    $stamp = $item.LastWriteTime
    if ($AnalyzeCheckLastAccess) { $stamp = $item.LastAccessTime }
    return ((New-TimeSpan -Start $stamp -End (Get-Date)).TotalDays -ge $MinAgeDays)
}

# ==============================================================================
# CHAPITRE 4 - BASE DE CONNAISSANCE ET HEURISTIQUES
# ==============================================================================

# Base integree : editeurs connus, leurs traces typiques, leur verdict.
$KnowledgeBase = @{
    'webroot' = @{
        Name = 'Webroot'; Verdict = 'residue'
        Tasks = @('Webroot*', 'WR*', '*Webroot*')
        Services = @('WRSVC', 'WRCoreService', 'WRkrn', 'wrkrn', 'WRBoot')
        Keys = @('HKLM:\SOFTWARE\WRData', 'HKLM:\SOFTWARE\WOW6432Node\WRData', 'HKLM:\SOFTWARE\Webroot')
        Folders = @("$env:ProgramData\WRData", "$env:ProgramFiles\Webroot", "${env:ProgramFiles(x86)}\Webroot")
    }
    'adobe' = @{
        Name = 'Adobe'; Verdict = 'updater'
        Tasks = @('Adobe Acrobat Update Task', 'Adobe ARM*', 'Adobe Flash*', '*Adobe*Update*')
        Services = @('AdobeARMservice', 'AdobeUpdateService', 'AGSService', 'AGMService')
        Keys = @('HKLM:\SOFTWARE\Adobe', 'HKCU:\SOFTWARE\Adobe')
        Folders = @("$env:ProgramData\Adobe", "$env:LOCALAPPDATA\Adobe", "$env:ProgramFiles\Adobe")
    }
    'onedrive' = @{
        Name = 'OneDrive'; Verdict = 'keep'
        Tasks = @('*OneDrive*')
        Services = @()
        Keys = @('HKCU:\SOFTWARE\Microsoft\OneDrive')
        Folders = @("$env:LOCALAPPDATA\Microsoft\OneDrive", "$env:ProgramFiles\Microsoft OneDrive")
    }
    'mcafee' = @{
        Name = 'McAfee'; Verdict = 'residue'
        Tasks = @('McAfee*', '*McAfee*')
        Services = @('McAPExe', 'McAfee*', 'mcafee*')
        Keys = @('HKLM:\SOFTWARE\McAfee', 'HKLM:\SOFTWARE\WOW6432Node\McAfee')
        Folders = @("$env:ProgramData\McAfee", "$env:ProgramFiles\McAfee")
    }
    'norton' = @{
        Name = 'Norton'; Verdict = 'residue'
        Tasks = @('Norton*', '*Norton*')
        Services = @('Norton*', 'NAVENG', 'NAVEX15')
        Keys = @('HKLM:\SOFTWARE\Symantec', 'HKLM:\SOFTWARE\Norton')
        Folders = @("$env:ProgramData\Norton", "$env:ProgramFiles\Norton Security")
    }
    'avast' = @{
        Name = 'Avast'; Verdict = 'residue'
        Tasks = @('Avast*', '*Avast*')
        Services = @('avast!*', 'Avast*')
        Keys = @('HKLM:\SOFTWARE\AVAST Software')
        Folders = @("$env:ProgramData\AVAST Software", "$env:ProgramFiles\AVAST Software")
    }
    'avg' = @{
        Name = 'AVG'; Verdict = 'residue'
        Tasks = @('AVG*', '*AVG*')
        Services = @('AVG*')
        Keys = @('HKLM:\SOFTWARE\AVG')
        Folders = @("$env:ProgramData\AVG", "$env:ProgramFiles\AVG")
    }
    'ccleaner' = @{
        Name = 'CCleaner'; Verdict = 'updater'
        Tasks = @('CCleaner*', 'Piriform*')
        Services = @()
        Keys = @('HKLM:\SOFTWARE\Piriform', 'HKCU:\SOFTWARE\Piriform')
        Folders = @("$env:ProgramFiles\CCleaner", "$env:ProgramData\Piriform")
    }
    'java' = @{
        Name = 'Java'; Verdict = 'updater'
        Tasks = @('*Java*Update*', '*jusched*')
        Services = @('JavaQuickStarterService')
        Keys = @('HKLM:\SOFTWARE\JavaSoft', 'HKLM:\SOFTWARE\WOW6432Node\JavaSoft')
        Folders = @("$env:ProgramFiles\Java", "$env:ProgramData\Oracle")
    }
    'dropbox' = @{
        Name = 'Dropbox'; Verdict = 'updater'
        Tasks = @('Dropbox*')
        Services = @('DbxSvc')
        Keys = @('HKCU:\SOFTWARE\Dropbox')
        Folders = @("$env:LOCALAPPDATA\Dropbox", "$env:ProgramFiles\Dropbox")
    }
    'oem' = @{
        Name = 'OEM utilities'; Verdict = 'residue'
        Tasks = @('Dell*', 'HP*', 'Lenovo*', 'ASUS*', 'Acer*', 'MSI*', 'Samsung*', 'Toshiba*')
        Services = @('Dell*', 'HP*', 'Lenovo*', 'Asus*')
        Keys = @()
        Folders = @()
    }
    'updatergeneric' = @{
        Name = 'Updater'; Verdict = 'updater'
        Tasks = $UpdaterPatterns
        Services = @()
        Keys = @()
        Folders = @()
    }
}

# Cherche une correspondance dans la base a partir d'un nom.
function Get-KnowledgeMatch([string]$Text) {
    if (-not $Text) { return $null }
    foreach $k in $KnowledgeBase.Keys {
        $entry = $KnowledgeBase[$k]
        if ($Text -like "*$($entry.Name)*") { return $entry }
    }
    return $null
}

# Score de nuisance : plus il est haut, plus l'element est propose au nettoyage.
function Get-NuisanceScore($Item) {
    $score = 0
    switch ($Item.Reason) {
        'target-missing'    { $score += 60 }
        'product-missing'   { $score += 55 }
        'empty-uninstall'   { $score += 45 }
        'duplicate'         { $score += 35 }
        'updater-no-parent' { $score += 30 }
        'vendor-residue'    { $score += 40 }
        'shell-dead'        { $score += 50 }
        'ghost-device'      { $score += 25 }
        'cache'             { $score += 10 }
    }
    if ($Item.KnownVendor) { $score += $ScoreKnownVendorBoost }
    if ($Item.Protected)   { $score -= 20 }
    if ($score -lt 0) { $score = 0 }
    return $score
}

# ==============================================================================
# CHAPITRE 5 - COLLECTEURS (lecture seule)
# ==============================================================================

# Cree un objet d'element homogene, avec son identifiant stable et ses textes.
function New-Finding {
    param(
        [string]$Domain, [string]$Family, [string]$Name, [string]$Path,
        [string]$Kind, [string]$Label, [string]$Publisher, [string]$Reason,
        [string]$Confidence, [string]$Risk, [string]$Action, [string]$Target,
        [string]$Extra, [long]$Size, [string]$Locked, [bool]$Protected,
        [bool]$KnownVendor, [string]$About, [string]$Why, [string]$Warn
    )
    $fam = if ($Family) { Clean-Text $Family } else { 'Other' }
    return [pscustomobject]@{
        Id          = (New-StableId $Domain $Name $Path)
        Domain      = $Domain
        Family      = $fam
        FamilySafe  = ($fam -replace '[^\w.-]', '-')
        Name        = Clean-Text $Name
        Path        = Clean-Text $Path
        Kind        = $Kind
        Label       = $Label
        Publisher   = Clean-Text $Publisher
        Reason      = $Reason
        Confidence  = $Confidence
        Risk        = $Risk
        Action      = $Action
        Target      = $Target
        Extra       = $Extra
        Size        = $Size
        Locked      = $Locked
        Protected   = $Protected
        KnownVendor = $KnownVendor
        About       = $About
        Why         = $Why
        Warn        = $Warn
        Score       = 0
    }
}

# --- Demarrage ---------------------------------------------------------------

# Collecte les entrees de demarrage : Run, RunOnce et dossiers Demarrage.
function Get-StartupFindings {
    $out = @()
    if (-not $CollectRunKeys) { return $out }
    $keys = @(
        @{ K = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run'; N = 'HKLM' }
        @{ K = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce'; N = 'HKLM-RunOnce' }
        @{ K = 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run'; N = 'HKLM32' }
        @{ K = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run'; N = 'HKCU' }
        @{ K = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce'; N = 'HKCU-RunOnce' }
    )
    foreach ($entry in $keys) {
        $props = Get-ItemProperty -LiteralPath $entry.K -ErrorAction SilentlyContinue
        if (-not $props) { continue }
        foreach ($p in $props.PSObject.Properties) {
            if ($p.Name -like 'PS*') { continue }
            $cmd = Expand-Command "$($p.Value)"
            $exe = Get-ExeFromCommand $cmd
            $exists = $false
            if ($exe) { $exists = Test-Path -LiteralPath $exe -PathType Leaf }
            if ($exists) { continue }
            $pub = Get-Publisher $exe
            $out += New-Finding -Domain 'startup' -Family $entry.N -Name $p.Name -Path $exe `
                -Kind 'startup' -Label 'LStartup' -Publisher $pub -Reason 'target-missing' `
                -Confidence 'high' -Risk 'medium' -Action 'remove-value' -Target "$($entry.K)|$($p.Name)" `
                -Extra $cmd -Size 0 -Locked '' -Protected $false -KnownVendor $false `
                -About 'NAboutOrphan' -Why 'NWhyOrphan' -Warn 'NWarnOrphan'
        }
    }
    if (-not $CollectStartupFolders) { return $out }
    $folders = @(
        [Environment]::GetFolderPath('Startup'),
        [Environment]::GetFolderPath('CommonStartup')
    ) | Where-Object { $_ -and (Test-Path -LiteralPath $_) }
    $shell = $null
    try { $shell = New-Object -ComObject WScript.Shell } catch { }
    foreach ($f in $folders) {
        foreach ($lnk in Get-ChildItem -LiteralPath $f -Force -ErrorAction SilentlyContinue) {
            if ($lnk.Extension -notin @('.lnk', '.url', '.exe', '.cmd', '.bat')) { continue }
            $target = $lnk.FullName
            if ($lnk.Extension -eq '.lnk' -and $shell) {
                try { $target = $shell.CreateShortcut($lnk.FullName).TargetPath } catch { }
            }
            if ($target -and (Test-Path -LiteralPath $target -PathType Leaf)) { continue }
            $out += New-Finding -Domain 'startup' -Family 'Startup folder' -Name $lnk.BaseName -Path $lnk.FullName `
                -Kind 'file' -Label 'LStartup' -Publisher '' -Reason 'target-missing' `
                -Confidence 'high' -Risk 'medium' -Action 'remove-file' -Target $lnk.FullName `
                -Extra '' -Size (Get-PathSize $lnk.FullName) -Locked '' -Protected $false -KnownVendor $false `
                -About 'NAboutOrphan' -Why 'NWhyOrphan' -Warn 'NWarnOrphan'
        }
    }
    return $out
}

# --- Taches planifiees -------------------------------------------------------

# Collecte les taches planifiees dont le programme n'existe plus.
function Get-TaskFindings {
    $out = @()
    if (-not $CollectServices) { return $out }
    $tasks = @()
    try { $tasks = Get-ScheduledTask -ErrorAction Stop } catch { return $out }
    foreach ($t in $tasks) {
        if ($t.TaskPath -like '\Microsoft\Windows\*' -and (Test-Protected 'scheduleddefaults')) { continue }
        $exe = ''
        foreach ($a in $t.Actions) {
            if ($a.Execute) { $exe = Expand-Command "$($a.Execute)"; break }
        }
        if (-not $exe) { continue }
        if ($exe -match '^(svchost|rundll32|cmd|wscript|cscript)\.exe$') { continue }
        if (Test-Path -LiteralPath $exe -PathType Leaf) { continue }
        $out += New-Finding -Domain 'tasks' -Family ($t.TaskPath.Trim('\')) -Name $t.TaskName `
            -Path $exe -Kind 'task' -Label 'LTask' -Publisher '' -Reason 'target-missing' `
            -Confidence 'high' -Risk 'medium' -Action 'remove-task' -Target "$($t.TaskPath)|$($t.TaskName)" `
            -Extra '' -Size 0 -Locked '' -Protected $false -KnownVendor $false `
            -About 'NAboutOrphan' -Why 'NWhyOrphan' -Warn 'NWarnOrphan'
    }
    return $out
}

# --- Services et pilotes -----------------------------------------------------

# Collecte les services dont le binaire n'existe plus.
function Get-ServiceFindings {
    $out = @()
    if (-not $CollectServices) { return $out }
    $svcs = Get-CimInstance -ClassName Win32_Service -ErrorAction SilentlyContinue
    foreach ($s in $svcs) {
        if ($CriticalServices -contains $s.Name -and (Test-Protected 'criticalservices')) { continue }
        $exe = Get-ExeFromCommand (Expand-Command "$($s.PathName)")
        if (-not $exe) { continue }
        if ($exe -match '^(svchost|rundll32)\.exe$') { continue }
        if (Test-Path -LiteralPath $exe -PathType Leaf) { continue }
        $out += New-Finding -Domain 'services' -Family 'Services' -Name $s.Name -Path $exe `
            -Kind 'service' -Label 'LService' -Publisher '' -Reason 'target-missing' `
            -Confidence 'high' -Risk 'medium' -Action 'remove-service' -Target $s.Name `
            -Extra "$($s.DisplayName)" -Size 0 -Locked '' -Protected $false -KnownVendor $false `
            -About 'NAboutOrphan' -Why 'NWhyOrphan' -Warn 'NWarnOrphan'
    }
    if (-not $CollectDrivers) { return $out }
    $drv = Get-CimInstance -ClassName Win32_SystemDriver -ErrorAction SilentlyContinue
    foreach ($d in $drv) {
        $exe = Get-ExeFromCommand (Expand-Command "$($d.PathName)")
        if (-not $exe) { continue }
        if (Test-Path -LiteralPath $exe -PathType Leaf) { continue }
        $out += New-Finding -Domain 'services' -Family 'Drivers' -Name $d.Name -Path $exe `
            -Kind 'driver' -Label 'LDriver' -Publisher '' -Reason 'target-missing' `
            -Confidence 'high' -Risk 'medium' -Action 'remove-service' -Target $d.Name `
            -Extra "$($d.DisplayName)" -Size 0 -Locked '' -Protected $false -KnownVendor $false `
            -About 'NAboutOrphan' -Why 'NWhyOrphan' -Warn 'NWarnOrphan'
    }
    return $out
}

# --- Traces de desinstallation ----------------------------------------------

# Collecte les cles de desinstallation devenues vides ou sans cible.
function Get-RegistryFindings {
    $out = @()
    if (-not $CollectUninstallKeys) { return $out }
    $roots = @(
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall',
        'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall',
        'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall'
    )
    $seen = @{}
    foreach ($root in $roots) {
        if (-not (Test-Path -LiteralPath $root)) { continue }
        foreach ($k in Get-ChildItem -LiteralPath $root -ErrorAction SilentlyContinue) {
            $p = Get-ItemProperty -LiteralPath $k.PSPath -ErrorAction SilentlyContinue
            if (-not $p) { continue }
            $name = "$($p.DisplayName)"
            if (-not $name) { $name = $k.PSChildName }
            if ($name -like 'Update for*' -or $name -like 'Security Update*') { continue }
            $loc = "$($p.InstallLocation)"
            $un = Expand-Command "$($p.UninstallString)"
            $reason = ''
            if ($loc -and -not (Test-Path -LiteralPath $loc)) { $reason = 'target-missing' }
            elseif ($AnalyzeDetectEmptyUninstall -and -not $un -and -not $loc) { $reason = 'empty-uninstall' }
            elseif ($un) {
                $exe = Get-ExeFromCommand $un
                if ($exe -and -not (Test-Path -LiteralPath $exe -PathType Leaf)) { $reason = 'product-missing' }
            }
            if (-not $reason) { continue }
            $pub = "$($p.Publisher)"
            $known = $null
            if ($UseKnowledgeBase) { $known = Get-KnowledgeMatch $pub }
            if ($pub -match 'Microsoft' -and (Test-Protected 'microsoftsigned')) { continue }
            $out += New-Finding -Domain 'registry' -Family 'Uninstall' -Name $name -Path $k.PSPath `
                -Kind 'registry' -Label 'LRegistry' -Publisher $pub -Reason $reason `
                -Confidence 'medium' -Risk 'low' -Action 'remove-key' -Target $k.PSPath `
                -Extra '' -Size 0 -Locked '' -Protected $false -KnownVendor ([bool]$known) `
                -About 'NAboutOrphan' -Why 'NWhyOrphan' -Warn 'NWarnOrphan'
        }
    }
    return $out
}

# --- Dossiers residuels ------------------------------------------------------

# Collecte les dossiers d'editeurs dont plus aucun produit n'est installe.
function Get-FolderFindings {
    $out = @()
    if (-not $CollectAppDataFolders -and -not $CollectProgramDataFolders) { return $out }
    $roots = @()
    if ($CollectProgramDataFolders) { $roots += @{ P = $env:ProgramData; F = 'ProgramData' } }
    if ($CollectAppDataFolders) {
        $roots += @{ P = $env:LOCALAPPDATA; F = 'LocalAppData' }
        $roots += @{ P = $env:APPDATA; F = 'Roaming' }
    }
    if ($CollectProgramFilesFolders) {
        $roots += @{ P = $env:ProgramFiles; F = 'Program Files' }
        if (${env:ProgramFiles(x86)}) { $roots += @{ P = ${env:ProgramFiles(x86)}; F = 'Program Files 32' } }
    }
    foreach ($r in $roots) {
        if (-not $r.P -or -not (Test-Path -LiteralPath $r.P)) { continue }
        foreach ($d in Get-ChildItem -LiteralPath $r.P -Directory -Force -ErrorAction SilentlyContinue) {
            if ($NeverDeleteNames -contains $d.Name) { continue }
            if (Test-ProtectedPath $d.FullName) { continue }
            $match = $null
            foreach ($v in $VendorFolders) {
                if ($d.Name -like "*$v*") { $match = $v; break }
            }
            if (-not $match) { continue }
            $inUse = $false
            foreach ($sub in Get-ChildItem -LiteralPath $d.FullName -Recurse -File -Force -ErrorAction SilentlyContinue |
                             Select-Object -First 40) {
                if ($sub.Extension -in @('.exe', '.dll')) { $inUse = $true; break }
            }
            if ($inUse) { continue }
            if (-not (Test-OldEnough $d.FullName)) { continue }
            $out += New-Finding -Domain 'folders' -Family $r.F -Name $d.Name -Path $d.FullName `
                -Kind 'folder' -Label 'LFolder' -Publisher $match -Reason 'vendor-residue' `
                -Confidence 'medium' -Risk 'low' -Action 'remove-path' -Target $d.FullName `
                -Extra '' -Size (Get-PathSize $d.FullName) -Locked '' -Protected $false -KnownVendor $true `
                -About 'NAboutOrphan' -Why 'NWhyOrphan' -Warn 'NWarnOrphan'
        }
    }
    return $out
}

# --- Extensions shell --------------------------------------------------------

# Collecte les gestionnaires de menu contextuel dont la DLL a disparu.
function Get-ShellFindings {
    $out = @()
    if (-not $CollectShellHandlers) { return $out }
    $bases = @(
        'HKLM:\SOFTWARE\Classes\*\shellex\ContextMenuHandlers',
        'HKLM:\SOFTWARE\Classes\Directory\shellex\ContextMenuHandlers',
        'HKLM:\SOFTWARE\Classes\Directory\Background\shellex\ContextMenuHandlers',
        'HKLM:\SOFTWARE\Classes\Folder\shellex\ContextMenuHandlers',
        'HKLM:\SOFTWARE\Classes\AllFilesystemObjects\shellex\ContextMenuHandlers'
    )
    foreach ($b in $bases) {
        if (-not (Test-Path -LiteralPath $b)) { continue }
        foreach ($h in Get-ChildItem -LiteralPath $b -ErrorAction SilentlyContinue) {
            $clsid = "$((Get-ItemProperty -LiteralPath $h.PSPath -ErrorAction SilentlyContinue).'(default)')"
            if (-not $clsid) { continue }
            $dll = ''
            foreach ($ip in @("HKLM:\SOFTWARE\Classes\CLSID\$clsid\InprocServer32", "HKLM:\SOFTWARE\Classes\WOW6432Node\CLSID\$clsid\InprocServer32")) {
                if (Test-Path -LiteralPath $ip) {
                    $dll = Expand-Command "$((Get-ItemProperty -LiteralPath $ip -ErrorAction SilentlyContinue).'(default)')"
                    if ($dll) { break }
                }
            }
            if (-not $dll) { continue }
            if (Test-Path -LiteralPath $dll -PathType Leaf) { continue }
            $out += New-Finding -Domain 'shell' -Family 'Context menu' -Name $h.PSChildName -Path $dll `
                -Kind 'registry' -Label 'LShellExt' -Publisher '' -Reason 'shell-dead' `
                -Confidence 'medium' -Risk 'low' -Action 'remove-key' -Target $h.PSPath `
                -Extra $clsid -Size 0 -Locked '' -Protected $false -KnownVendor $false `
                -About 'NAboutOrphan' -Why 'NWhyOrphan' -Warn 'NWarnOrphan'
        }
    }
    return $out
}

# --- Peripheriques fantomes --------------------------------------------------

# Collecte les peripheriques deconnectes qui gardent leur pilote.
function Get-DeviceFindings {
    $out = @()
    if (-not $CollectGhostDevices) { return $out }
    $devs = @()
    try { $devs = Get-PnpDevice -ErrorAction Stop } catch { return $out }
    foreach ($d in $devs) {
        if ($d.Status -ne 'Unknown') { continue }
        if (-not $d.InstanceId) { continue }
        $out += New-Finding -Domain 'devices' -Family 'Disconnected' -Name $d.FriendlyName `
            -Path $d.InstanceId -Kind 'driver' -Label 'LDevice' -Publisher '' -Reason 'ghost-device' `
            -Confidence 'medium' -Risk 'low' -Action 'remove-device' -Target $d.InstanceId `
            -Extra "$($d.Class)" -Size 0 -Locked '' -Protected $false -KnownVendor $false `
            -About 'NAboutOrphan' -Why 'NWhyOrphan' -Warn 'NWarnOrphan'
    }
    return $out
}

# --- Caches et journaux ------------------------------------------------------

# Liste des caches connus, avec leur famille et leur libelle.
function Get-CacheTargets {
    return @(
        @{ N = 'User temp';          P = $env:TEMP;                                             F = 'Temp' }
        @{ N = 'Windows temp';       P = "$env:SystemRoot\Temp";                                F = 'Temp' }
        @{ N = 'Windows Update cache'; P = "$env:SystemRoot\SoftwareDistribution\Download";     F = 'Updates' }
        @{ N = 'Delivery Optimization'; P = "$env:SystemRoot\SoftwareDistribution\DeliveryOptimization"; F = 'Updates' }
        @{ N = 'Internet cache';     P = "$env:LOCALAPPDATA\Microsoft\Windows\INetCache";       F = 'Explorer' }
        @{ N = 'Thumbnail cache';    P = "$env:LOCALAPPDATA\Microsoft\Windows\Explorer";        F = 'Explorer' }
        @{ N = 'Crash dumps';        P = "$env:LOCALAPPDATA\CrashDumps";                        F = 'Logs' }
        @{ N = 'CBS logs';           P = "$env:SystemRoot\Logs\CBS";                            F = 'Logs' }
        @{ N = 'Windows Update logs'; P = "$env:SystemRoot\Logs\WindowsUpdate";                 F = 'Logs' }
    )
}

# Construit les elements de cache a partir de la liste ci-dessus.
function Get-CacheFindings {
    $out = @()
    if (-not $CollectCaches) { return $out }
    foreach ($c in Get-CacheTargets) {
        if (-not $c.P -or -not (Test-Path -LiteralPath $c.P)) { continue }
        $size = Get-PathSize $c.P
        if ($size -le 0) { continue }
        $locked = ''
        if ($c.N -like '*Update*') {
            $svc = Get-Service -Name wuauserv -ErrorAction SilentlyContinue
            if ($svc -and $svc.Status -eq 'Running') { $locked = 'open' }
        }
        $out += New-Finding -Domain 'caches' -Family $c.F -Name $c.N -Path $c.P `
            -Kind 'folder' -Label 'LCache' -Publisher '' -Reason 'cache' `
            -Confidence 'high' -Risk 'low' -Action 'clear-path' -Target $c.P `
            -Extra '' -Size $size -Locked $locked -Protected $false -KnownVendor $false `
            -About 'NAboutOrphan' -Why 'NWhyOrphan' -Warn 'NWarnOrphan'
    }
    return $out
}

# Appelle tous les collecteurs actifs et renvoie un objet par domaine.
function Get-AllFindings {
    $map = [ordered]@{
        startup  = @{ Opt = 'DoStartup';           List = 'FoundStartup';  Fn = ${function:Get-StartupFindings} }
        tasks    = @{ Opt = 'DoScheduledTasks';    List = 'FoundTasks';    Fn = ${function:Get-TaskFindings} }
        services = @{ Opt = 'DoServices';          List = 'FoundServices'; Fn = ${function:Get-ServiceFindings} }
        registry = @{ Opt = 'DoRegistryLeftovers'; List = 'FoundRegistry'; Fn = ${function:Get-RegistryFindings} }
        folders  = @{ Opt = 'DoLeftoverFolders';   List = 'FoundFolders';  Fn = ${function:Get-FolderFindings} }
        shell    = @{ Opt = 'DoShellExtensions';   List = 'FoundShellExt'; Fn = ${function:Get-ShellFindings} }
        devices  = @{ Opt = 'DoGhostDevices';      List = 'FoundDevices';  Fn = ${function:Get-DeviceFindings} }
        caches   = @{ Opt = 'DoCaches';            List = 'FoundCaches';   Fn = ${function:Get-CacheFindings} }
    }
    $result = @{}
    foreach ($k in $map.Keys) {
        if (-not (Get-Opt $map[$k].Opt)) { $result[$k] = @(); continue }
        $items = @()
        try { $items = & $map[$k].Fn } catch { $items = @() }
        foreach ($i in $items) {
            if ($i.Protected) { $i.Confidence = 'low' }
            $i.Score = Get-NuisanceScore $i
        }
        $result[$k] = @($items | Where-Object { $_.Score -ge $ScoreThresholdReport })
    }
    return $result
}

# ==============================================================================
# CHAPITRE 6 - OUTILS ET SYSTEME
# ==============================================================================

# Prepare l'espace de travail, avec repli si la racine n'est pas inscriptible.
function Initialize-Workspace {
    $candidates = @($WorkspaceRoot) + $WorkspaceFallbacks
    foreach ($c in $candidates) {
        try {
            if (-not (Test-Path -LiteralPath $c)) { New-Item -ItemType Directory -Path $c -Force -ErrorAction Stop | Out-Null }
            $probe = Join-Path $c 'probe.tmp'
            Set-Content -LiteralPath $probe -Value 'ok' -Encoding ASCII -ErrorAction Stop
            Remove-Item -LiteralPath $probe -Force -ErrorAction SilentlyContinue
            $script:RunFolder = Join-Path $c $RunStamp
            New-Item -ItemType Directory -Path $script:RunFolder -Force -ErrorAction Stop | Out-Null
            $script:BackupDir  = Join-Path $script:RunFolder 'backup'
            New-Item -ItemType Directory -Path $script:BackupDir -Force | Out-Null
            $script:LogFile    = Join-Path $script:RunFolder 'cleanup.log'
            $script:ReportFile = Join-Path $script:RunFolder 'report.json'
            $script:ReportHtml = Join-Path $script:RunFolder 'report.html'
            $script:PendingFile = Join-Path $script:RunFolder 'pending.json'
            $script:LastRunFile = Join-Path $c 'last-run.txt'
            return $true
        } catch { continue }
    }
    return $false
}

# Telecharge un outil d'appoint, en silence, et renvoie son chemin ou une chaine vide.
function Get-HelperTool([string]$Name) {
    if (-not $AllowTools -or $KbOfflineOnly) { return '' }
    $dest = Join-Path $RunFolder "tools\$Name"
    if (Test-Path -LiteralPath $dest) { return $dest }
    try {
        New-Item -ItemType Directory -Path (Split-Path -Parent $dest) -Force | Out-Null
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri "$ToolsUrlBase/$Name" -OutFile $dest -UseBasicParsing -TimeoutSec $TimeoutToolSeconds
        if (Test-Path -LiteralPath $dest) { return $dest }
    } catch { }
    return ''
}

# Ecrit un petit script et le fait tourner en SYSTEM par une tache planifiee.
function Invoke-AsSystem([string]$Tag, [string[]]$Lines) {
    if (-not $AllowSystem) { return $false }
    $jobName = "SindryCleanup_$Tag"
    $jobFile = Join-Path $RunFolder "sys_$Tag.ps1"
    $outFile = Join-Path $RunFolder "sys_$Tag.out"
    $doneFile = Join-Path $RunFolder "sys_$Tag.done"
    Remove-Item -LiteralPath $doneFile -Force -ErrorAction SilentlyContinue
    $body = @()
    $body += '$ErrorActionPreference = "SilentlyContinue"'
    $body += $Lines
    $body += "Set-Content -LiteralPath '$doneFile' -Value 'done' -Encoding ASCII"
    Set-Content -LiteralPath $jobFile -Value $body -Encoding UTF8
    $ps = "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"
    $cmd = "`"$ps`" -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$jobFile`" > `"$outFile`" 2>&1"
    & "$env:SystemRoot\System32\schtasks.exe" /create /tn $jobName /tr $cmd /sc ONCE /st 00:00 /ru SYSTEM /f | Out-Null
    & "$env:SystemRoot\System32\schtasks.exe" /run /tn $jobName | Out-Null
    $waited = 0
    while (-not (Test-Path -LiteralPath $doneFile) -and $waited -lt $TimeoutSystemTaskSeconds) {
        Start-Sleep -Seconds 1
        $waited++
    }
    & "$env:SystemRoot\System32\schtasks.exe" /delete /tn $jobName /f | Out-Null
    $ok = Test-Path -LiteralPath $doneFile
    if (-not $ok) { Write-Err 'E121' "system task $Tag timed out" }
    return $ok
}

# ==============================================================================
# CHAPITRE 7 - ELEVATION
# ==============================================================================

$IsAdmin = Test-IsAdmin

if (-not $IsAdmin -and (Get-Opt 'AllowAdminElevation') -and -not $RelayFile) {
    Write-Line "[INFO] Elevating to administrator"
    $relay = Join-Path $env:TEMP "sindry_cleanup_relay_$PID.txt"
    Remove-Item -LiteralPath $relay -Force -ErrorAction SilentlyContinue
    $env:SINDRY_CLEANUP_RELAY = $relay
    $hostExe = (Get-Process -Id $PID).Path
    $argList = @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-WindowStyle', 'Hidden', '-File', "`"$PSCommandPath`"")
    try {
        $proc = Start-Process -FilePath $hostExe -ArgumentList $argList -Verb RunAs -WindowStyle Hidden -Wait -PassThru
        if (Test-Path -LiteralPath $relay) {
            foreach ($l in (Get-Content -LiteralPath $relay -ErrorAction SilentlyContinue)) { Write-Host $l }
        }
        exit $proc.ExitCode
    } catch {
        Write-WarnCode 'W201' "$($_.Exception.Message)"
        $env:SINDRY_CLEANUP_RELAY = ''
    }
}

# ==============================================================================
# CHAPITRE 8 - ANALYSE (lecture seule)
# ==============================================================================

if ($env:SINDRY_MODE -eq 'scan') {
    Write-Line "[STEP] 1/3 Scanning startup entries, tasks and services"
    if (-not (Initialize-Workspace)) { Write-Err 'E102' 'no writable workspace' }
    $all = Get-AllFindings

    Write-Line "[NOTE] NIntrusive DoStartup"
    Write-Line "[NOTE] NBackup DoScheduledTasks"
    Write-Line "[NOTE] NRestart DoLeftoverFolders"
    Write-Line "[NOTE] NProtected ProtectMicrosoftSigned"
    if ($Level -ge 4) { Write-Line "[NOTE] NExtreme AllowComponentCleanup" }
    if (-not $IsAdmin) { Write-Line "[NOTE] NNoAdmin DoServices" }

    Write-Line "[STEP] 2/3 Reporting what was found"
    $map = [ordered]@{
        startup  = @{ Opt = 'DoStartup';           List = 'FoundStartup';  Ch = 'Startup' }
        tasks    = @{ Opt = 'DoScheduledTasks';    List = 'FoundTasks';    Ch = 'Tasks' }
        services = @{ Opt = 'DoServices';          List = 'FoundServices'; Ch = 'Services' }
        registry = @{ Opt = 'DoRegistryLeftovers'; List = 'FoundRegistry'; Ch = 'Registry' }
        folders  = @{ Opt = 'DoLeftoverFolders';   List = 'FoundFolders';  Ch = 'Folders' }
        shell    = @{ Opt = 'DoShellExtensions';   List = 'FoundShellExt'; Ch = 'Shell' }
        devices  = @{ Opt = 'DoGhostDevices';      List = 'FoundDevices';  Ch = 'Devices' }
        caches   = @{ Opt = 'DoCaches';            List = 'FoundCaches';   Ch = 'Caches' }
    }
    $emitted = 0
    foreach ($k in $map.Keys) {
        $items = $all[$k]
        $bytes = [long](($items | Measure-Object -Property Size -Sum).Sum)
        Write-Line "[FIND] $($map[$k].Opt) size=$bytes count=$($items.Count)"
        $seen = @{}
        $n = 0
        foreach ($it in ($items | Sort-Object -Property @{E='Score';D=$true}, Family, Name)) {
            if ($n -ge $MaxItemsPerList -or $emitted -ge $MaxItemsTotal) { break }
            $famId = "$($it.Domain)-fam-$($it.FamilySafe)"
            if (-not $seen.ContainsKey($famId)) {
                $seen[$famId] = $true
                Write-Line "[ITEM] $($map[$k].List) id=$famId kind=folder label=LFamily name=""$($it.Family)"" confidence=high"
            }
            $lock = if ($it.Locked) { " locked=$($it.Locked)" } else { '' }
            Write-Line "[ITEM] $($map[$k].List) id=$($it.Id) parent=$famId kind=$($it.Kind) label=$($it.Label) name=""$($it.Name)"" path=""$($it.Path)"" publisher=""$($it.Publisher)"" size=$($it.Size) confidence=$($it.Confidence) risk=$($it.Risk) about=$($it.About) why=$($it.Why) warn=$($it.Warn)$lock"
            if ($OutVerbose) { Write-Line "[LOG] $($map[$k].Ch) $($it.Name) [$($it.Reason)]" }
            $n++
            $emitted++
        }
    }

    Write-Line "[STEP] 3/3 Measuring the disk"
    $drive = Get-PSDrive -Name ($env:SystemDrive.TrimEnd(':'))
    $pct = 0
    if ($drive -and ($drive.Used + $drive.Free) -gt 0) {
        $pct = [math]::Round(100 * $drive.Free / ($drive.Used + $drive.Free))
    }
    $health = 'ok'
    if ($pct -lt 10) { $health = 'crit' } elseif ($pct -lt 20) { $health = 'warn' }
    Write-Line "[METRIC] FreeSpace value=$pct unit=pct health=$health max=100"
    Write-Line "[METRIC] ItemsFound value=$emitted unit=count"
    Write-Line "[DONE] Analysis done"
    exit 0
}

# ==============================================================================
# CHAPITRE 9 - REPRISE APRES REDEMARRAGE
# ==============================================================================
# Sindry redemarre, relance le script avec SINDRY_RESUME, et la meme configuration.
# Aucune option secrete : ces branches ne lisent que $CONFIG et le fichier des
# suppressions differees. Chaque phase peut etre rejouee sans dommage.

# Phase unique : les fichiers qui etaient verrouilles avant le redemarrage.
if ($env:SINDRY_RESUME -eq 'post-reboot-clean') {
    if (-not (Initialize-Workspace)) { Write-Err 'E102' 'no writable workspace' }
    if (-not (Test-Path -LiteralPath $PendingFile)) {
        Write-Line "[INFO] Nothing was pending"
        Write-Line "[DONE] Done"
        exit 0
    }
    $pending = @()
    try { $pending = @(Get-Content -LiteralPath $PendingFile -Raw | ConvertFrom-Json) } catch { $pending = @() }
    Write-Line "[STEP] 1/2 Removing what the restart released"
    $done = 0
    foreach ($p in $pending) {
        if (-not $p) { continue }
        if (-not (Test-Path -LiteralPath "$($p.Path)")) { $done++; continue }
        try {
            Remove-Item -LiteralPath "$($p.Path)" -Recurse -Force -ErrorAction Stop
            $done++
        } catch {
            Write-WarnCode 'W203' "$($p.Path)"
        }
    }
    Write-Line "[OK]   $done of $($pending.Count) released"
    Write-Line "[CKPT] Deferred removals done"
    Write-Line "[STEP] 2/2 Verifying"
    $left = 0
    foreach ($p in $pending) {
        if ($p -and (Test-Path -LiteralPath "$($p.Path)")) { $left++ }
    }
    if ($left -gt 0) { Write-WarnCode 'E115' "$left path(s) still present" }
    Write-Line "[DONE] Done"
    if ($left -gt 0) { exit 1 }
    exit 0
}

# ==============================================================================
# CHAPITRE 10 - PREPARATION
# ==============================================================================

$mutex = New-Object System.Threading.Mutex($false, $MutexName)
$hasLock = $mutex.WaitOne(0)
if (-not $hasLock) { Write-Err 'E120' "another run holds $MutexName" }

if (-not (Initialize-Workspace)) {
    Write-Err 'E102' 'no writable workspace'
    exit 1
}

$drive = Get-PSDrive -Name ($env:SystemDrive.TrimEnd(':'))
if ($GuardSystemDrive -and -not $drive) { Write-Err 'E119' 'system drive missing'; exit 1 }
if ($drive -and ($drive.Free / 1GB) -lt $AbortOnLowDiskPercent) {
    Write-WarnCode 'E119' "less than $AbortOnLowDiskPercent GB free"
}

if (Test-Path -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending') {
    if (Get-Opt 'ProtectPendingReboot') { Write-WarnCode 'E118' 'a restart is already pending' }
}

if (Test-Path -LiteralPath $LastRunFile) {
    $script:PreviousRun = (Get-Content -LiteralPath $LastRunFile -Raw -ErrorAction SilentlyContinue)
}
Set-Content -LiteralPath $LastRunFile -Value $RunFolder -Encoding ASCII -ErrorAction SilentlyContinue

Write-Line "[INFO] Workspace: $RunFolder"
Write-Line "[INFO] Level: $($LevelNames[$Level]) / protection: $Profile"

# --- Retour en arriere -------------------------------------------------------
if ($DoRollback) {
    Write-Line "[STEP] 1/1 Rolling back the previous run"
    if (-not $script:PreviousRun -or -not (Test-Path -LiteralPath (Join-Path $script:PreviousRun 'backup'))) {
        Write-Err 'E117' 'no backup folder found'
        exit 1
    }
    $bad = 0
    $bk = Join-Path $script:PreviousRun 'backup'
    foreach ($reg in Get-ChildItem -LiteralPath $bk -Filter '*.reg' -ErrorAction SilentlyContinue) {
        $target = $reg.BaseName -replace '_', ':'
        & "$env:SystemRoot\System32\reg.exe" import "$($reg.FullName)" | Out-Null
        if ($LASTEXITCODE -ne 0) { $bad++ }
    }
    foreach ($xml in Get-ChildItem -LiteralPath $bk -Filter '*.xml' -ErrorAction SilentlyContinue) {
        try {
            $t = Get-ScheduledTask -TaskName $xml.BaseName -ErrorAction SilentlyContinue
            if ($t) { Unregister-ScheduledTask -TaskName $xml.BaseName -Confirm:$false -ErrorAction Stop }
            Register-ScheduledTask -Xml (Get-Content -LiteralPath $xml.FullName -Raw) -TaskName $xml.BaseName -Force | Out-Null
        } catch { $bad++ }
    }
    if (-not (Get-Opt 'RollbackKeepBackups')) {
        Remove-Item -LiteralPath $bk -Recurse -Force -ErrorAction SilentlyContinue
    }
    Write-Line "[CKPT] Rollback done"
    if ($bad -gt 0) { Write-Err 'E116' "$bad item(s) failed"; exit 1 }
    Write-Line "[DONE] Rolled back"
    exit 0
}

# --- Simulation : on annonce sans rien faire ---------------------------------
if ($SafeTest -and $Level -eq 0) {
    Write-Line "[INFO] SafeTest - audit level, nothing will change"
}

# ==============================================================================
# CHAPITRE 11 - EXECUTION
# ==============================================================================

# Fonctions d'action : suppression robuste, avec escalade et report au redemarrage.

# Active la suppression differee au redemarrage, par MoveFileEx.
function Invoke-DelayedDelete([string]$Path) {
    if (-not $AllowDelayed -or -not $ActUseDelayedDelete) { return $false }
    try {
        if (-not ('Sindry.Native' -as [type])) {
            Add-Type -Namespace Sindry -Name Native -MemberDefinition @'
[System.Runtime.InteropServices.DllImport("kernel32.dll", SetLastError=true, CharSet=System.Runtime.InteropServices.CharSet.Unicode)]
public static extern bool MoveFileEx(string lpExistingFileName, string lpNewFileName, int dwFlags);
'@
        }
        $null = [Sindry.Native]::MoveFileEx($Path, $null, 4)
        return $true
    } catch { return $false }
}

# Ajoute un chemin a la liste des suppressions differees.
function Add-Pending([string]$Path) {
    $list = @()
    if (Test-Path -LiteralPath $PendingFile) {
        try { $list = @(Get-Content -LiteralPath $PendingFile -Raw | ConvertFrom-Json) } catch { $list = @() }
    }
    $list += [pscustomobject]@{ Path = $Path }
    $list | ConvertTo-Json -Depth 3 | Set-Content -LiteralPath $PendingFile -Encoding UTF8
}

# Supprime un chemin, en escaladant : direct, prise de possession, puis report.
function Remove-PathRobust([string]$Path, [string]$Kind) {
    if (-not (Test-Path -LiteralPath $Path)) { return [long]0 }
    $size = Get-PathSize $Path
    if ($SafeTest) { return $size }
    for ($i = 0; $i -le $RetryCount; $i++) {
        try { Remove-Item -LiteralPath $Path -Recurse -Force -ErrorAction Stop; return $size } catch { }
        Start-Sleep -Milliseconds $RetryDelayMs
    }
    if ($AllowAclRewrite -and -not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        & "$env:SystemRoot\System32\takeown.exe" /f "$Path" /r /d Y 2>$null | Out-Null
        & "$env:SystemRoot\System32\icacls.exe" "$Path" /grant '*S-1-5-32-544:(F)' /t /c /q 2>$null | Out-Null
        try { Remove-Item -LiteralPath $Path -Recurse -Force -ErrorAction Stop; return $size } catch { }
    }
    if ($AllowAclRewrite -and (Test-Path -LiteralPath $Path -PathType Leaf)) {
        & "$env:SystemRoot\System32\takeown.exe" /f "$Path" 2>$null | Out-Null
        try { Remove-Item -LiteralPath $Path -Force -ErrorAction Stop; return $size } catch { }
    }
    if (Invoke-DelayedDelete $Path) {
        Add-Pending $Path
        Write-WarnCode 'E109' "$Path deferred to the next restart"
        return -1
    }
    Write-WarnCode 'W203' "$Path still in use"
    return -2
}

# Supprime une cle de registre, en prenant possession si besoin.
function Remove-KeyRobust([string]$Key) {
    if (-not (Test-Path -LiteralPath $Key)) { return $true }
    if ($SafeTest) { return $true }
    if ($ExportReport -and $ActBackupBeforeWrite -and (Get-Opt 'ExportRegistryBackup')) {
        try {
            $safe = ($Key -replace '[\\/:*?"<>|]', '_')
            & "$env:SystemRoot\System32\reg.exe" export "$($Key -replace '^HK', 'HK')" "$BackupDir\$safe.reg" /y 2>$null | Out-Null
        } catch { Write-WarnCode 'E107' $Key }
    }
    for ($i = 0; $i -le $RetryCount; $i++) {
        try { Remove-Item -LiteralPath $Key -Recurse -Force -ErrorAction Stop; return $true } catch { }
        Start-Sleep -Milliseconds $RetryDelayMs
    }
    Write-WarnCode 'E108' $Key
    return $false
}

# Supprime une tache planifiee, en la sauvegardant d'abord.
function Remove-TaskRobust([string]$TaskPath, [string]$TaskName) {
    if ($SafeTest) { return $true }
    try {
        if (Get-Opt 'ExportTaskBackup') {
            try {
                $xml = Export-ScheduledTask -TaskName $TaskName -TaskPath $TaskPath -ErrorAction Stop
                Set-Content -LiteralPath (Join-Path $BackupDir "$TaskName.xml") -Value $xml -Encoding UTF8
            } catch { Write-WarnCode 'E107' $TaskName }
        }
        Unregister-ScheduledTask -TaskName $TaskName -TaskPath $TaskPath -Confirm:$false -ErrorAction Stop
        return $true
    } catch {
        Write-WarnCode 'E111' $TaskName
        return $false
    }
}

# Arrete puis supprime un service ; le desactive si la suppression echoue.
function Remove-ServiceRobust([string]$Name) {
    if ($SafeTest) { return $true }
    if ($ActStopServiceBeforeDelete -and (Get-Opt 'AllowServiceStop')) {
        try { Stop-Service -Name $Name -Force -ErrorAction Stop } catch { Write-WarnCode 'E110' $Name }
    }
    & "$env:SystemRoot\System32\sc.exe" delete $Name 2>$null | Out-Null
    if ($LASTEXITCODE -eq 0) { return $true }
    if ($ActDisableInsteadOfDelete) {
        & "$env:SystemRoot\System32\sc.exe" config $Name start= disabled 2>$null | Out-Null
        if ($LASTEXITCODE -eq 0) { return $true }
    }
    Write-WarnCode 'E112' $Name
    return $false
}

# Vide le contenu d'un dossier de cache sans supprimer le dossier lui-meme.
function Clear-FolderContent([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path)) { return [long]0 }
    if ($SafeTest) { return (Get-PathSize $Path) }
    $freed = [long]0
    foreach ($f in Get-ChildItem -LiteralPath $Path -Force -ErrorAction SilentlyContinue) {
        $size = Get-PathSize $f.FullName
        try {
            Remove-Item -LiteralPath $f.FullName -Recurse -Force -ErrorAction Stop
            $freed += $size
        } catch { }
    }
    return $freed
}

# --- Deroulement --------------------------------------------------------------

$all = Get-AllFindings
$plan = [ordered]@{
    startup  = @{ List = 'FoundStartup';  Ch = 'Startup' }
    tasks    = @{ List = 'FoundTasks';    Ch = 'Tasks' }
    services = @{ List = 'FoundServices'; Ch = 'Services' }
    registry = @{ List = 'FoundRegistry'; Ch = 'Registry' }
    shell    = @{ List = 'FoundShellExt'; Ch = 'Shell' }
    devices  = @{ List = 'FoundDevices';  Ch = 'Devices' }
    caches   = @{ List = 'FoundCaches';   Ch = 'Caches' }
    folders  = @{ List = 'FoundFolders';  Ch = 'Folders' }
}

# Selection recue : uniquement des identifiants, utilises comme cles.
$selected = @{}
foreach ($k in $plan.Keys) {
    $selected[$k] = @($CONFIG[$plan[$k].List] | ForEach-Object { "$_" })
}

$total = 0
foreach ($k in $plan.Keys) { $total += @($all[$k] | Where-Object { $selected[$k] -contains $_.Id }).Count }

if ($total -eq 0) {
    Write-Line "[INFO] Nothing selected"
    Write-Line "[DONE] Nothing to do"
    exit 0
}

$step = 0

# --- Sauvegardes --------------------------------------------------------------
if ($CreateRestorePoint -and $Level -ge 1) {
    Write-Line "[STEP] 1/$($total + 2) Preparing"
    if (-not $SafeTest) {
        try {
            Enable-ComputerRestore -Drive "$env:SystemDrive\" -ErrorAction SilentlyContinue
            Checkpoint-Computer -Description 'Sindry deep cleanup' -RestorePointType 'MODIFY_SETTINGS' -ErrorAction Stop
        } catch { Write-WarnCode 'E106' "$($_.Exception.Message)" }
    }
} else {
    Write-Line "[STEP] 1/$($total + 2) Preparing"
}
Write-Line "[CKPT] Backups ready"

# --- Retraits a chaud ---------------------------------------------------------
foreach ($k in @('startup', 'tasks', 'services', 'registry', 'shell', 'devices')) {
    $items = @($all[$k] | Where-Object { $selected[$k] -contains $_.Id })
    foreach ($it in $items) {
        $step++
        Write-Line "[STEP] $step/$($total + 2) $($it.Name)"
        $ok = $false
        switch ($it.Action) {
            'remove-value' {
                if ($SafeTest) { $ok = $true }
                else {
                    $parts = $it.Target -split '\|'
                    try { Remove-ItemProperty -LiteralPath $parts[0] -Name $parts[1] -Force -ErrorAction Stop; $ok = $true }
                    catch { Write-WarnCode 'E108' $it.Target }
                }
            }
            'remove-file'  { $ok = ((Remove-PathRobust $it.Target $it.Kind) -ge 0) }
            'remove-path'  { $ok = ((Remove-PathRobust $it.Target $it.Kind) -ge 0) }
            'remove-key'   { $ok = Remove-KeyRobust $it.Target }
            'remove-task'  {
                $parts = $it.Target -split '\|'
                $ok = Remove-TaskRobust $parts[0] $parts[1]
            }
            'remove-service' { $ok = Remove-ServiceRobust $it.Target }
            'remove-device' {
                if ($SafeTest) { $ok = $true }
                elseif (-not $AllowDriverRemoval) { $ok = $true }
                else {
                    & "$env:SystemRoot\System32\pnputil.exe" /remove-device "$($it.Target)" 2>$null | Out-Null
                    if ($LASTEXITCODE -eq 0) { $ok = $true } else { Write-WarnCode 'E113' $it.Target }
                }
            }
        }
        if ($ok) { if ($OutVerbose) { Write-Line "[OK]   $($it.Name)" } }
        elseif (-not $ContinueOnError) { Write-Line "[WARN] stopping after $($it.Name)"; break }
    }
    Write-Line "[CKPT] $($plan[$k].Ch) done"
}

# --- Caches -------------------------------------------------------------------
foreach ($it in @($all['caches'] | Where-Object { $selected['caches'] -contains $_.Id })) {
    $step++
    Write-Line "[STEP] $step/$($total + 2) $($it.Name)"
    $before = Get-PathSize $it.Target
    $null = Clear-FolderContent $it.Target
    if (-not $SafeTest) { $FreedBytes += $before }
}
Write-Line "[CKPT] Caches done"

# --- Dossiers residuels, ceux qui demandent un redemarrage en dernier ----------
$pendingCount = 0
foreach ($it in @($all['folders'] | Where-Object { $selected['folders'] -contains $_.Id })) {
    $step++
    Write-Line "[STEP] $step/$($total + 2) $($it.Name)"
    $res = Remove-PathRobust $it.Target $it.Kind
    if ($res -eq -1) { $pendingCount++ }
}
Write-Line "[CKPT] Folders done"

# --- Espace libere ------------------------------------------------------------
if (-not $SafeTest) {
    foreach ($it in @($all.Values | ForEach-Object { $_ })) { }
}

# --- Redemarrage du milieu ----------------------------------------------------
if ($pendingCount -gt 0 -and $AllowRestart -and -not $SafeTest -and $Level -ge 2) {
    Write-Line "[INFO] $pendingCount path(s) wait for a restart"
    Write-Line "[RESTART] post-reboot-clean"
    exit 3010
}
if ($pendingCount -gt 0 -and $SafeTest) {
    Write-Line "[INFO] SafeTest - would ask for a restart, then resume at post-reboot-clean"
}

# ==============================================================================
# CHAPITRE 12 - VERIFICATION ET RAPPORT
# ==============================================================================

Write-Line "[STEP] $($total + 1)/$($total + 2) Verifying"
if ($ActVerifyAfterAction -and -not $SafeTest) {
    $after = Get-AllFindings
    foreach ($k in $plan.Keys) {
        foreach ($it in @($all[$k] | Where-Object { $selected[$k] -contains $_.Id })) {
            $still = @($after[$k] | Where-Object { $_.Id -eq $it.Id })
            if ($still.Count -gt 0 -and $it.Action -ne 'remove-value') { $script:Residual++ }
        }
    }
    if ($Residual -gt 0) { Write-WarnCode 'E115' "$Residual item(s) still present" }
}

Write-Line "[STEP] $($total + 2)/$($total + 2) Reporting"
if ($OutShowFreed) { Write-Line "[FREED] $FreedBytes" }

if ($ExportReport -and -not $SafeTest) {
    try {
        $rows = @()
        foreach ($k in $plan.Keys) {
            foreach ($it in @($all[$k] | Where-Object { $selected[$k] -contains $_.Id })) {
                $rows += [pscustomobject]@{
                    Domain = $it.Domain; Name = $it.Name; Path = $it.Path
                    Reason = $it.Reason; Action = $it.Action; Size = $it.Size
                }
            }
        }
        $payload = [pscustomobject]@{
            Run = $RunStamp; Level = $LevelNames[$Level]; Profile = $Profile
            FreedBytes = $FreedBytes; Items = $rows
        }
        if ($OutExportJson) { $payload | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $ReportFile -Encoding UTF8 }
        if ($OutExportHtml) {
            $html = @('<html><head><meta charset="utf-8"><title>Deep cleanup</title></head><body>')
            $html += "<h1>Deep cleanup - $RunStamp</h1>"
            $html += "<p>Level: $($LevelNames[$Level]) - Protection: $Profile - Freed: $FreedBytes bytes</p><table border=1><tr><th>Domain</th><th>Name</th><th>Path</th><th>Reason</th></tr>"
            foreach ($r in $rows) { $html += "<tr><td>$($r.Domain)</td><td>$($r.Name)</td><td>$($r.Path)</td><td>$($r.Reason)</td></tr>" }
            $html += '</table></body></html>'
            Set-Content -LiteralPath $ReportHtml -Value $html -Encoding UTF8
        }
        Write-Line "[INFO] Report: $ReportHtml"
    } catch { Write-WarnCode 'E107' 'report' }
}

# --- Nettoyage de l'espace de travail ----------------------------------------
if (-not $KeepWorkspace -and -not $SafeTest) {
    try {
        if (Test-Path -LiteralPath $RunFolder) {
            Get-ChildItem -LiteralPath $RunFolder -Directory -ErrorAction SilentlyContinue |
                Where-Object { $_.Name -eq 'tools' -and $CleanToolsAfter } |
                ForEach-Object { Remove-Item -LiteralPath $_.FullName -Recurse -Force -ErrorAction SilentlyContinue }
        }
    } catch { }
}

if ($hasLock) { $mutex.ReleaseMutex() }

if ($Residual -gt 0) {
    Write-Line "[DONE] Done, with items to review"
    exit 1
}
Write-Line "[DONE] Done"
exit 0