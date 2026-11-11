## SINDRY:START
## id            : 7c41b0e2-5a3d-4f86-9c17-8b2e6d0a4f53
## lang          : en
## title         : Activate Windows and Office
## desc          : Installs the volume key matching the Windows edition and activates Windows and Office through a KMS server; it replaces the product key and the licence state of both
## category      : apps
## icon          : key-round
## tags          : activation, licence, kms, windows, office
## version       : 1.0
## author        : Venice
## created       : 2026-11-11
## updated       : 2026-11-11
## admin         : true
## risk          : medium
## duration      : medium
## reversible    : false
## interruptible : true
## reboot        : false
## engine        : auto
## scan          : true
## view          : checklist
## panels        : plan progress
## SINDRY:END

## SINDRY:OPTIONS
## Targets      : [multi] What to activate — pick one or both
##   windows    : Windows — installs the volume key of the edition, then activates it
##   office     : Office — activates the installed Click-to-Run Office
## KmsHost      : [string] KMS server — the host that delivers the licence, port 1688
## ReinstallKey : [bool]   Replace the product key — even when the edition is already activated
## SafeTest     : [bool]   Simulate — shows what would be done, changes nothing
## SINDRY:END

## SINDRY:REPORT
## E401 : [error] The Windows edition cannot be identified or has no known volume key — Set the key by hand with slmgr
## E402 : [error] The product key was refused — Run the action again as administrator
## E403 : [error] Windows refused the activation — Check the KMS server address and the network, then try again
## E404 : [error] Office is not installed on this PC — Nothing to activate for Office
## E405 : [error] The Office activation tool is missing — Repair the Office installation, then try again
## E406 : [error] Office is still unlicensed after the attempt — Check the KMS server and the Office edition, then try again
## E407 : [error] The KMS server address is empty — Fill in the KMS server field
## EditionUnknown : [note:warn] This Windows edition has no known volume key: the Windows part will fail.
## OfficeMissing  : [note:info] Office is not installed, so the Office part will be skipped.
## SINDRY:END

## SINDRY:LANG fr
## title          : Activer Windows et Office
## desc           : Installe la cle en volume de l'edition de Windows et active Windows et Office par un serveur KMS ; remplace la cle de produit et l'etat de licence des deux
## Targets        : Que faut-il activer — un seul ou les deux
##   windows      : Windows — installe la cle en volume de l'edition, puis l'active
##   office       : Office — active l'Office Click-to-Run installe
## KmsHost        : Serveur KMS — l'hote qui delivre la licence, port 1688
## ReinstallKey   : Remplacer la cle de produit — meme si l'edition est deja activee
## SafeTest       : Simuler — montre ce qui serait fait, sans rien modifier
## E401           : L'edition de Windows est introuvable ou n'a pas de cle en volume connue — Saisissez la cle a la main avec slmgr
## E402           : La cle de produit a ete refusee — Relancez l'action en administrateur
## E403           : Windows a refuse l'activation — Verifiez l'adresse du serveur KMS et le reseau, puis reessayez
## E404           : Office n'est pas installe sur ce PC — Rien a activer pour Office
## E405           : L'outil d'activation d'Office est absent — Reparez l'installation d'Office, puis reessayez
## E406           : Office reste sans licence apres la tentative — Verifiez le serveur KMS et l'edition d'Office, puis reessayez
## E407           : L'adresse du serveur KMS est vide — Remplissez le champ du serveur KMS
## EditionUnknown : Cette edition de Windows n'a pas de cle en volume connue : la partie Windows echouera.
## OfficeMissing  : Office n'est pas installe, la partie Office sera donc ignoree.
## SINDRY:END

$CONFIG = @{
    Targets      = @("windows", "office")
    KmsHost      = "kms.digiboy.ir"
    ReinstallKey = $false
    SafeTest     = $false
}

# --- Sindry override (ne pas supprimer) ---
if ($env:SINDRY_CONFIG) {
    ($env:SINDRY_CONFIG | ConvertFrom-Json).PSObject.Properties |
        ForEach-Object { $CONFIG[$_.Name] = $_.Value }
}

# ==============================================================================
# SOMMAIRE
#   1. Drapeaux et listes de reference
#   2. Fonctions
#   3. Analyse (mode scan) : on mesure l'etat des licences, sans rien changer
#   4. Preparation : ce qui a ete coche, l'edition, l'Office installe
#   5. Execution : Windows, puis Office
#   6. Journal final et verdict
#
# RESUME
#   Le script ne telecharge rien : il s'appuie sur slmgr.vbs et ospp.vbs, tous
#   deux fournis par Windows et Office. Il installe la cle en volume (GVLK)
#   correspondant a l'edition, regle le serveur KMS, puis demande l'activation.
#   Une activation KMS dure 180 jours et se renouvelle d'elle-meme tant que le
#   serveur repond. Sur une machine deja activee par licence numerique, la cle
#   en volume remplace cette licence : d'ou l'option ReinstallKey, decochee.
#
# SECURITE
#   Aucune valeur n'est executee. Les outils systeme sont appeles par leur
#   chemin complet, et les cles installees sont ecrites en dur dans le script :
#   seuls le serveur KMS et deux booleens viennent de la configuration.
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. DRAPEAUX ET LISTES DE REFERENCE
# ------------------------------------------------------------------------------

# Comparaison de CHAINE, pas de booleen : la valeur arrive par JSON.
$SafeTest = ("$($CONFIG.SafeTest)" -eq 'True')
# Reinstalle la cle en volume meme si l'edition est deja activee.
$ReinstallKey = ("$($CONFIG.ReinstallKey)" -eq 'True')
# Serveur KMS recu, debarrasse de ses espaces de bord.
$KmsHost = "$($CONFIG.KmsHost)".Trim()
# Port KMS impose par Microsoft, jamais autre chose.
$KmsPort = 1688
# Dossier des outils systeme, pour les appeler par leur chemin complet.
$System32 = "$env:SystemRoot\System32"
# Identifiant d'application des licences Windows (SoftwareLicensingProduct).
$WindowsAppId = '55c92734-d682-4d71-983e-d6ec3f16059f'
# Identifiant d'application des licences Office.
$OfficeAppId = '0ff1ce15-a989-479d-af46-f275c6370663'
# Au moins une partie a echoue : le verdict final passe a exit 1.
$failed = $false

# Cles KMS generiques de Windows, par identifiant d'edition. Source : Microsoft.
$WindowsKeys = @{
    'Core'                     = 'TX9XD-98N7V-6WMQ6-BX7FG-H8Q99'
    'CoreN'                    = '3KHY7-WNT83-DGQKR-F7HPR-844BM'
    'CoreSingleLanguage'       = '7HNRX-D7KGG-3K4RQ-4WPJ4-YTDFH'
    'CoreCountrySpecific'      = 'PVMJN-6DFY6-9CCP6-7BKTT-D3WVR'
    'Professional'             = 'W269N-WFGWX-YVC9B-4J6C9-T83GX'
    'ProfessionalN'            = 'MH37W-N47XK-V7XM9-C7227-GCQG9'
    'ProfessionalWorkstation'  = 'NRG8B-VKK3Q-CXVCJ-9G2XF-6Q84J'
    'ProfessionalWorkstationN' = '9FNHH-K3HBT-3W4TD-6383H-6XYWF'
    'Enterprise'               = 'NPPR9-FWDCX-D2C8J-H872K-2YT43'
    'EnterpriseN'              = 'DPH2V-TTNVB-4X9Q3-TJR4H-KHJW4'
    'Education'                = 'NW6C2-QMPVW-D7KKK-3GKT6-VCFB2'
    'EducationN'               = '2WH4N-8QGBV-H22JP-CT43Q-MDWWJ'
    'EnterpriseS'              = 'M7XTQ-FN8P6-TTKYV-9D4CC-J462D'
    'EnterpriseSN'             = '92NFX-8DJQP-P6BBQ-THF9C-7CG2H'
    'IoTEnterprise'            = 'XQQYW-NFFMW-XJPBH-K8732-CKFFD'
}

# Cles KMS generiques d'Office, par identifiant de produit Click-to-Run.
# Les abonnements Microsoft 365 n'en ont pas : ils s'activent sans cle.
$OfficeKeys = @{
    'ProPlus2021Volume'   = 'FXYTK-NJJ8C-GB6DW-3DYQT-6F7TH'
    'ProPlus2021Retail'   = 'FXYTK-NJJ8C-GB6DW-3DYQT-6F7TH'
    'ProPlus2019Volume'   = 'FXYTK-NJJ8C-GB6DW-3DYQT-6F7TH'
    'ProPlus2019Retail'   = 'FXYTK-NJJ8C-GB6DW-3DYQT-6F7TH'
    'ProPlusRetail'       = 'XQNVK-8JYDB-WJ9W3-YJ8YR-WFG99'
    'Standard2021Volume'  = 'KDX7X-BNVR8-TXXGX-4Q7Y8-78VT3'
    'Standard2021Retail'  = 'KDX7X-BNVR8-TXXGX-4Q7Y8-78VT3'
    'Standard2019Volume'  = 'KDX7X-BNVR8-TXXGX-4Q7Y8-78VT3'
    'Standard2019Retail'  = 'KDX7X-BNVR8-TXXGX-4Q7Y8-78VT3'
    'StandardRetail'      = 'JNRGM-WHDWX-FJJG3-K47QV-DRTFM'
}

# ------------------------------------------------------------------------------
# 2. FONCTIONS
# ------------------------------------------------------------------------------

# Ecrit le detail d'une erreur attrapee, en mode diagnostic seulement (SINDRY_DIAG=1).
# Recoit l'enregistrement d'erreur ($_) ; ne renvoie rien.
function Write-Diag($Erreur) {
    if ($env:SINDRY_DIAG -ne '1') { return }
    $e = $Erreur.Exception
    Write-Host ("[LOG] Diag {0} HResult=0x{1:X8}" -f $e.GetType().FullName, $e.HResult)
    Write-Host "[LOG] Diag $($Erreur.CategoryInfo)"
    Write-Host "[LOG] Diag $($Erreur.InvocationInfo.PositionMessage -replace '\s+', ' ')"
    if ($e.InnerException) { Write-Host "[LOG] Diag Inner: $($e.InnerException.Message)" }
}

# Lit l'identifiant de l'edition de Windows dans le registre.
# Ne recoit rien ; renvoie l'identifiant, ou une chaine vide si la lecture echoue.
function Get-WindowsEdition {
    $key = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
    try {
        $item = Get-ItemProperty -LiteralPath $key -Name 'EditionID' -ErrorAction Stop
    } catch {
        Write-Host "[ERR] E401 $key\EditionID : $($_.Exception.GetType().Name) - $($_.Exception.Message)"
        Write-Diag $_
        return ''
    }
    return "$($item.EditionID)"
}

# Lit l'etat de licence Windows : 1 vaut active, tout le reste non.
# Ne recoit rien ; renvoie un entier.
function Get-WindowsLicenseStatus {
    try {
        $product = Get-CimInstance -ClassName SoftwareLicensingProduct `
            -Filter "PartialProductKey IS NOT NULL" -ErrorAction Stop |
            Where-Object { $_.ApplicationId -eq $WindowsAppId } | Select-Object -First 1
    } catch {
        Write-Diag $_
        return 0
    }
    if (-not $product) { return 0 }
    return [int]$product.LicenseStatus
}

# Dit si au moins un produit Office est licencie.
# Ne recoit rien ; renvoie $true ou $false.
function Test-OfficeLicensed {
    try {
        $product = Get-CimInstance -ClassName SoftwareLicensingProduct `
            -Filter "PartialProductKey IS NOT NULL" -ErrorAction Stop |
            Where-Object { $_.ApplicationId -eq $OfficeAppId -and $_.LicenseStatus -eq 1 } |
            Select-Object -First 1
    } catch {
        Write-Diag $_
        return $false
    }
    return [bool]$product
}

# Cherche l'installation Click-to-Run d'Office et son outil d'activation ospp.vbs.
# Ne recoit rien ; renvoie un objet (Ospp, Products) ou $null si Office est absent.
function Get-OfficeInfo {
    $roots = @(
        'HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration',
        'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Office\ClickToRun\Configuration'
    )
    foreach ($root in $roots) {
        $conf = Get-ItemProperty -LiteralPath $root -ErrorAction SilentlyContinue
        if (-not $conf -or -not $conf.InstallationPath) { continue }
        $ospp = Join-Path $conf.InstallationPath 'Office16\ospp.vbs'
        if (-not (Test-Path -LiteralPath $ospp)) { continue }
        $products = @("$($conf.ProductReleaseIds)" -split ',' |
            ForEach-Object { $_.Trim() } | Where-Object { $_ })
        return [pscustomobject]@{ Ospp = $ospp; Products = $products }
    }
    return $null
}

# Active Windows : cle en volume de l'edition, serveur KMS, puis activation.
# Recoit l'identifiant d'edition ; renvoie 0 en cas de succes, 1 sinon.
function Invoke-WindowsActivation([string]$Edition) {
    $key = $WindowsKeys[$Edition]
    if (-not $key) {
        Write-Host "[ERR] E401 edition '$Edition' has no known volume key"
        return 1
    }
    $licensed = ((Get-WindowsLicenseStatus) -eq 1)
    if ($licensed -and -not $ReinstallKey) {
        Write-Host "[INFO] Windows is already activated - key left in place"
    } else {
        & "$System32\cscript.exe" //nologo "$System32\slmgr.vbs" /ipk $key | Out-Null
        if ($LASTEXITCODE -ne 0) {
            Write-Host "[ERR] E402 slmgr /ipk returned $LASTEXITCODE for edition $Edition"
            return 1
        }
        Write-Host "[OK]   Volume key installed for edition $Edition"
        Write-Host "[LOG] Licence key installed for $Edition"
    }
    & "$System32\cscript.exe" //nologo "$System32\slmgr.vbs" /sethst $KmsHost | Out-Null
    & "$System32\cscript.exe" //nologo "$System32\slmgr.vbs" /setprt $KmsPort | Out-Null
    & "$System32\cscript.exe" //nologo "$System32\slmgr.vbs" /ato | Out-Null
    if ((Get-WindowsLicenseStatus) -eq 1) {
        Write-Host "[OK]   Windows is activated"
        return 0
    }
    Write-Host "[ERR] E403 slmgr /ato left the Windows licence inactive on $KmsHost"
    return 1
}

# Active Office produit par produit, avec ospp.vbs.
# Recoit l'objet rendu par Get-OfficeInfo ; renvoie 0 en cas de succes, 1 sinon.
function Invoke-OfficeActivation($Office) {
    if (-not $Office) {
        Write-Host "[ERR] E404 Office is not installed"
        return 1
    }
    if (-not (Test-Path -LiteralPath $Office.Ospp)) {
        Write-Host "[ERR] E405 ospp.vbs missing under the Office installation"
        return 1
    }
    foreach ($product in $Office.Products) {
        $key = $OfficeKeys[$product]
        if ($key) {
            & "$System32\cscript.exe" //nologo $Office.Ospp "/inpkey:$key" | Out-Null
            Write-Host "[OK]   Volume key installed for $product"
        } else {
            Write-Host "[WARN] No volume key known for $product - activating without one"
        }
        & "$System32\cscript.exe" //nologo $Office.Ospp "/sethst:$KmsHost" | Out-Null
        & "$System32\cscript.exe" //nologo $Office.Ospp "/setprt:$KmsPort" | Out-Null
        & "$System32\cscript.exe" //nologo $Office.Ospp '/act' | Out-Null
        Write-Host "[LOG] Licence activation sent for $product"
    }
    if (Test-OfficeLicensed) {
        Write-Host "[OK]   Office is activated"
        return 0
    }
    Write-Host "[ERR] E406 Office is still unlicensed after the attempt on $KmsHost"
    return 1
}

# ==============================================================================
# 3. ANALYSE - on lit l'etat des licences, on ne modifie RIEN
# ==============================================================================

if ($env:SINDRY_MODE -eq 'scan') {
    Write-Host "[STEP] 1/3 Reading the Windows licence state"
    $edition = Get-WindowsEdition
    if ((Get-WindowsLicenseStatus) -eq 1) {
        Write-Host "[FIND] Targets.windows state=ok"
    } else {
        Write-Host "[FIND] Targets.windows state=todo"
    }
    if (-not $WindowsKeys.ContainsKey($edition)) {
        Write-Host "[FIND] Targets.windows checked=false"
        Write-Host "[NOTE] EditionUnknown Targets.windows"
    }

    Write-Host "[STEP] 2/3 Looking for Office"
    $office = Get-OfficeInfo
    if ($office) {
        if (Test-OfficeLicensed) {
            Write-Host "[FIND] Targets.office state=ok"
        } else {
            Write-Host "[FIND] Targets.office state=todo"
        }
    } else {
        Write-Host "[FIND] Targets.office state=todo checked=false"
        Write-Host "[NOTE] OfficeMissing Targets.office"
    }

    Write-Host "[STEP] 3/3 Measuring done"
    exit 0
}

# ==============================================================================
# 4. PREPARATION
# ==============================================================================

# Ce qui a ete coche, ramene a deux booleens lisibles.
$targets = @($CONFIG.Targets | ForEach-Object { "$_" })
$doWindows = ($targets -contains 'windows')
$doOffice = ($targets -contains 'office')

if (-not $KmsHost) {
    Write-Host "[ERR] E407 the KMS server address is empty"
    exit 1
}

$total = [int]$doWindows + [int]$doOffice
if ($total -eq 0) {
    Write-Host "[WARN] Nothing is selected - enable Windows, Office, or both"
    Write-Host "[DONE] Nothing to do"
    exit 0
}

# Edition lue une seule fois, et Office cherche seulement s'il est demande.
$edition = Get-WindowsEdition
$officeInfo = $null
if ($doOffice) { $officeInfo = Get-OfficeInfo }

Write-Host "[INFO] KMS server : $KmsHost (port $KmsPort)"
if ($doWindows) { Write-Host "[INFO] Windows    : edition $edition" }
if ($doOffice -and $officeInfo) { Write-Host "[INFO] Office     : $($officeInfo.Products -join ', ')" }
Write-Host "[INFO] An activation through KMS lasts 180 days and renews itself."

# ==============================================================================
# 5. EXECUTION
# ==============================================================================

$step = 0

if ($doWindows) {
    $step++
    Write-Host "[STEP] $step/$total Activating Windows"
    if ($SafeTest) {
        if ($WindowsKeys[$edition]) {
            Write-Host "[INFO] SafeTest - would install key $($WindowsKeys[$edition]), set the host to $KmsHost and activate"
        } else {
            Write-Host "[INFO] SafeTest - edition $edition has no known key, activation would fail"
        }
    } else {
        if ((Invoke-WindowsActivation $edition) -ne 0) { $failed = $true }
    }
    Write-Host "[CKPT] Windows part finished - safe to interrupt from here"
}

if ($doOffice) {
    $step++
    Write-Host "[STEP] $step/$total Activating Office"
    if ($SafeTest) {
        if ($officeInfo) {
            Write-Host "[INFO] SafeTest - would set the host to $KmsHost and activate $($officeInfo.Products -join ', ')"
        } else {
            Write-Host "[INFO] SafeTest - Office is not installed, nothing would be done"
        }
    } else {
        if ((Invoke-OfficeActivation $officeInfo) -ne 0) { $failed = $true }
    }
    Write-Host "[CKPT] Office part finished"
}

# ==============================================================================
# 6. JOURNAL FINAL ET VERDICT
# ==============================================================================

Write-Host "[INFO] Windows licence state : $(if ((Get-WindowsLicenseStatus) -eq 1) { 'activated' } else { 'not activated' })"
if ($doOffice) {
    Write-Host "[INFO] Office licence state  : $(if (Test-OfficeLicensed) { 'activated' } else { 'not activated' })"
}

if ($failed) {
    Write-Host "[DONE] Finished with errors"
    exit 1
}

Write-Host "[DONE] Activation finished"
exit 0