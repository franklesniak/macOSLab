[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Provider primitive suffixes are defined by the macOSLab specification.')]
param()

function Get-MacLabParallelsCommandPath {
    # .SYNOPSIS
    # Resolves a Parallels command path.
    #
    # .DESCRIPTION
    # Resolves an installed Parallels command to its executable path and fails
    # clearly when the command is absent.
    #
    # .PARAMETER CommandName
    # Parallels command name.
    #
    # .EXAMPLE
    # Get-MacLabParallelsCommandPath -CommandName 'prlctl'
    # # Returns the resolved prlctl path.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [string]. Resolved command path.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private helper. Positional parameters are not supported.
    #
    [CmdletBinding(PositionalBinding = $false)]
    [OutputType([string])]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$CommandName
    )

    $objCommand = Get-Command -Name $CommandName -CommandType Application -ErrorAction SilentlyContinue

    if (-not $objCommand) {
        throw "${CommandName} was not found. Install Parallels Desktop before using the Parallels provider."
    }

    $objCommand.Source
}

function Invoke-MacLabParallelsCommand {
    # .SYNOPSIS
    # Runs prlctl with structured capture.
    #
    # .DESCRIPTION
    # Runs prlctl through the shared command runner and enforces the expected
    # exit-code behavior unless a lifecycle caller needs to verify final state
    # after a nonzero provider return.
    #
    # .PARAMETER ArgumentList
    # Arguments to pass to prlctl.
    #
    # .PARAMETER TimeoutSeconds
    # Maximum runtime in seconds.
    #
    # .PARAMETER AllowNonZeroExit
    # Allows a nonzero exit code so the caller can verify final VM state.
    #
    # .PARAMETER StandardInputText
    # Optional stdin text.
    #
    # .EXAMPLE
    # Invoke-MacLabParallelsCommand -ArgumentList @('list', '-a', '--output', 'name', '--no-header')
    # # Captures a names-only VM inventory.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. Command execution record.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private helper. Positional parameters are not supported.
    #
    [CmdletBinding(PositionalBinding = $false)]
    [OutputType([pscustomobject])]
    param(
        [string[]]$ArgumentList = @(),

        [ValidateRange(1, 86400)]
        [int]$TimeoutSeconds = 300,

        [switch]$AllowNonZeroExit,

        [string]$StandardInputText
    )

    $strCommandPath = Get-MacLabParallelsCommandPath -CommandName 'prlctl'
    $objCommand = Invoke-LoggedCommand `
        -FilePath $strCommandPath `
        -ArgumentList $ArgumentList `
        -TimeoutSeconds $TimeoutSeconds `
        -StandardInputText $StandardInputText

    if ($objCommand.TimedOut) {
        throw "Parallels command timed out: $($objCommand.DisplayCommand)"
    }

    if ($objCommand.ExitCode -ne 0 -and -not $AllowNonZeroExit) {
        throw "Parallels command failed with exit code $($objCommand.ExitCode): $($objCommand.DisplayCommand)"
    }

    $objCommand
}

function ConvertFrom-MacLabParallelsInfo {
    # .SYNOPSIS
    # Parses prlctl list information.
    #
    # .DESCRIPTION
    # Converts the colon-delimited `prlctl list -i` output into normalized key
    # and value facts.
    #
    # .PARAMETER InfoText
    # Text emitted by `prlctl list -i`.
    #
    # .EXAMPLE
    # ConvertFrom-MacLabParallelsInfo -InfoText "State: stopped"
    # # Returns a hashtable with a State key.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [hashtable]. Parsed facts.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private helper. Positional parameters are not supported.
    #
    [CmdletBinding(PositionalBinding = $false)]
    [OutputType([hashtable])]
    param([string]$InfoText)

    $hasFact = [ordered]@{}

    foreach ($strLine in ($InfoText -split '\r?\n')) {
        if ($strLine -match '^\s*([^:]+):\s*(.*)$') {
            $hasFact[$Matches[1].Trim()] = $Matches[2].Trim()
        }
    }

    $hasFact
}

function Get-MacLabParallelsInfoValue {
    # .SYNOPSIS
    # Gets a Parallels fact value by candidate key.
    #
    # .DESCRIPTION
    # Looks up the first present key from a candidate list so callers can
    # tolerate small provider-output label differences.
    #
    # .PARAMETER Fact
    # Parsed provider facts.
    #
    # .PARAMETER Key
    # Candidate fact keys.
    #
    # .EXAMPLE
    # Get-MacLabParallelsInfoValue -Fact $facts -Key @('State')
    # # Returns the VM state when present.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [string]. Fact value or null.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private helper. Positional parameters are not supported.
    #
    [CmdletBinding(PositionalBinding = $false)]
    [OutputType([string])]
    param(
        [Parameter(Mandatory = $true)]
        [hashtable]$Fact,

        [Parameter(Mandatory = $true)]
        [string[]]$Key
    )

    foreach ($strKey in $Key) {
        if ($Fact.Contains($strKey)) {
            return [string]$Fact[$strKey]
        }
    }

    return $null
}

function ConvertTo-MacLabInteger {
    # .SYNOPSIS
    # Converts a provider text value to an integer.
    #
    # .DESCRIPTION
    # Extracts the leading integer from provider text such as "8192 MB".
    #
    # .PARAMETER Value
    # Provider text value.
    #
    # .EXAMPLE
    # ConvertTo-MacLabInteger -Value '8192 MB'
    # # Returns 8192.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [int]. Parsed integer or null.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private helper. Positional parameters are not supported.
    #
    [CmdletBinding(PositionalBinding = $false)]
    [OutputType([int])]
    param([string]$Value)

    if ($Value -match '(\d+)') {
        return [int]$Matches[1]
    }

    return $null
}

function Get-MacLabParallelsVmName {
    # .SYNOPSIS
    # Lists Parallels VM names.
    #
    # .DESCRIPTION
    # Uses the verified names-only output shape instead of `prlctl list -a
    # --name`, which can return tabular columns on current Parallels builds.
    #
    # .EXAMPLE
    # Get-MacLabParallelsVmName
    # # Returns registered VM names.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [string]. VM names.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private helper. Positional parameters are not supported.
    #
    [CmdletBinding(PositionalBinding = $false)]
    [OutputType([string])]
    param()

    $objCommand = Invoke-MacLabParallelsCommand -ArgumentList @('list', '-a', '--output', 'name', '--no-header')

    foreach ($strLine in ($objCommand.Stdout -split '\r?\n')) {
        $strName = $strLine.Trim()
        if ($strName) {
            $strName
        }
    }
}

function Get-MacLabParallelsVmFact {
    # .SYNOPSIS
    # Gets parsed facts for a Parallels VM.
    #
    # .DESCRIPTION
    # Runs `prlctl list -i` and parses the resulting provider facts.
    #
    # .PARAMETER Name
    # VM name.
    #
    # .EXAMPLE
    # Get-MacLabParallelsVmFact -Name 'demo-01'
    # # Returns parsed VM facts.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [hashtable]. Parsed provider facts.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private helper. Positional parameters are not supported.
    #
    [CmdletBinding(PositionalBinding = $false)]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name
    )

    $objCommand = Invoke-MacLabParallelsCommand -ArgumentList @('list', '-i', $Name)
    ConvertFrom-MacLabParallelsInfo -InfoText $objCommand.Stdout
}

function Get-MacLabParallelsSnapshot {
    # .SYNOPSIS
    # Lists Parallels snapshots.
    #
    # .DESCRIPTION
    # Parses the verified `prlctl snapshot-list --json` output where the root
    # object is keyed by provider snapshot ID.
    #
    # .PARAMETER Name
    # VM name.
    #
    # .EXAMPLE
    # Get-MacLabParallelsSnapshot -Name 'demo-01'
    # # Returns parsed snapshot records.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. Snapshot records.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private helper. Positional parameters are not supported.
    #
    [CmdletBinding(PositionalBinding = $false)]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name
    )

    $objCommand = Invoke-MacLabParallelsCommand -ArgumentList @('snapshot-list', $Name, '--json')
    if ([string]::IsNullOrWhiteSpace($objCommand.Stdout)) {
        return
    }

    $objJson = $objCommand.Stdout | ConvertFrom-Json -AsHashtable
    if (-not $objJson) {
        return
    }

    foreach ($strId in $objJson.Keys) {
        $hasSnapshot = $objJson[$strId]
        [pscustomobject]@{
            Provider = 'Parallels'
            VmName = $Name
            Id = $strId
            Name = [string]$hasSnapshot['name']
            CreatedAt = [string]$hasSnapshot['date']
            State = [string]$hasSnapshot['state']
            Current = [bool]$hasSnapshot['current']
            Parent = [string]$hasSnapshot['parent']
        }
    }
}

function Test-MacLabParallelsIsolation {
    # .SYNOPSIS
    # Tests parsed Parallels isolation facts.
    #
    # .DESCRIPTION
    # Compares final `prlctl list -i` facts against the lab's required
    # host-integration disabled state.
    #
    # .PARAMETER Fact
    # Parsed provider facts.
    #
    # .EXAMPLE
    # Test-MacLabParallelsIsolation -Fact $facts
    # # Returns isolation readiness details.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. Isolation readiness record.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private helper. Positional parameters are not supported.
    #
    [CmdletBinding(PositionalBinding = $false)]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory = $true)]
        [hashtable]$Fact
    )

    $arrRequiredField = @(
        'Automatic sharing cameras',
        'Automatic sharing bluetooth',
        'Automatic sharing smart cards',
        'Automatic sharing gamepads',
        'Host Shared Folders',
        'Host-defined sharing',
        'Shared Profile',
        'Share apps from Mac',
        'Share apps to Mac',
        'SmartMount',
        'Shared Clipboard',
        'Shared Cloud',
        'Share host location'
    )

    $arrCheck = foreach ($strField in $arrRequiredField) {
        $strActual = Get-MacLabParallelsInfoValue -Fact $Fact -Key @($strField)
        [pscustomobject]@{
            Field = $strField
            Expected = 'off'
            Actual = $strActual
            Pass = ($strActual -and $strActual -eq 'off')
        }
    }

    [pscustomobject]@{
        Ready = -not ($arrCheck | Where-Object { -not $_.Pass })
        RequiredSettings = @($arrCheck)
    }
}

function Get-MacLabParallelsHostVersion {
    # .SYNOPSIS
    # Gets the host macOS version.
    #
    # .DESCRIPTION
    # Reads the host macOS product version for the Apple Virtualization
    # host/guest compatibility check.
    #
    # .EXAMPLE
    # Get-MacLabParallelsHostVersion
    # # Returns the macOS product version on a macOS host.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [string]. macOS product version.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private helper. Positional parameters are not supported.
    #
    [CmdletBinding(PositionalBinding = $false)]
    [OutputType([string])]
    param()

    if (-not $IsMacOS) {
        throw 'The Parallels provider requires a macOS host for live VM operations.'
    }

    $objCommand = Invoke-LoggedCommand -FilePath '/usr/bin/sw_vers' -ArgumentList @('-productVersion')
    if ($objCommand.ExitCode -ne 0 -or $objCommand.TimedOut) {
        throw 'Unable to read the host macOS version with sw_vers.'
    }

    $objCommand.Stdout.Trim()
}

function Get-MacLabParallelsCompatibility {
    # .SYNOPSIS
    # Classifies host and guest macOS compatibility.
    #
    # .DESCRIPTION
    # Applies the ADR-0011 policy: same-major guests are supported, lower guest
    # majors are best effort, and higher guest majors are rejected by default.
    #
    # .PARAMETER HostVersion
    # Host macOS version.
    #
    # .PARAMETER GuestVersion
    # Guest macOS version.
    #
    # .EXAMPLE
    # Get-MacLabParallelsCompatibility -HostVersion '26.4.1' -GuestVersion '26.4.1'
    # # Returns same-major-supported.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. Compatibility record.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private helper. Positional parameters are not supported.
    #
    [CmdletBinding(PositionalBinding = $false)]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$HostVersion,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$GuestVersion
    )

    $intHostMajor = ConvertTo-MacLabInteger -Value $HostVersion
    $intGuestMajor = ConvertTo-MacLabInteger -Value $GuestVersion

    if ($null -eq $intHostMajor -or $null -eq $intGuestMajor) {
        throw "Unable to classify host/guest compatibility for host '${HostVersion}' and guest '${GuestVersion}'."
    }

    if ($intGuestMajor -gt $intHostMajor) {
        throw "Guest macOS major version ${intGuestMajor} is higher than host macOS major version ${intHostMajor}; rejecting by default."
    }

    [pscustomobject]@{
        HostVersion = $HostVersion
        GuestVersion = $GuestVersion
        Classification = if ($intGuestMajor -eq $intHostMajor) { 'same-major-supported' } else { 'documented-cross-major-best-effort' }
    }
}

function Get-MacLabParallelsArtifact {
    # .SYNOPSIS
    # Selects a Parallels restore artifact.
    #
    # .DESCRIPTION
    # Selects the firmware IPSW artifact from media metadata produced by
    # Get-MacLabMedia.
    #
    # .PARAMETER MediaMetadata
    # Media metadata object.
    #
    # .EXAMPLE
    # Get-MacLabParallelsArtifact -MediaMetadata $metadata
    # # Returns the firmware artifact metadata.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. Artifact metadata.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private helper. Positional parameters are not supported.
    #
    [CmdletBinding(PositionalBinding = $false)]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory = $true)]
        [pscustomobject]$MediaMetadata
    )

    $arrArtifact = @($MediaMetadata.Artifacts)
    $objArtifact = $arrArtifact |
        Where-Object { $_.ArtifactType -eq 'Firmware' -or $_.Path -match '\.ipsw$' } |
        Select-Object -First 1

    if (-not $objArtifact) {
        throw "Media '${($MediaMetadata.MediaId)}' does not contain a Parallels-compatible IPSW firmware artifact."
    }

    if (-not (Test-Path -LiteralPath $objArtifact.Path -PathType Leaf)) {
        throw "Parallels restore image was not found: $($objArtifact.Path)"
    }

    $objArtifact
}

function Invoke-MacLabParallelsHardening {
    # .SYNOPSIS
    # Applies Parallels isolation settings.
    #
    # .DESCRIPTION
    # Applies the owner-verified hardening sequence: isolate first, reapply
    # individual host-sharing disables, then rely on final parsed facts as the
    # source of truth.
    #
    # .PARAMETER Name
    # VM name.
    #
    # .EXAMPLE
    # Invoke-MacLabParallelsHardening -Name 'demo-01'
    # # Applies Parallels host-integration hardening.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. Isolation readiness record.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private helper. Positional parameters are not supported.
    #
    [CmdletBinding(PositionalBinding = $false)]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name
    )

    $arrHardeningCommand = @(
        [pscustomobject]@{ ArgumentList = @('--isolate-vm', 'on') },
        [pscustomobject]@{ ArgumentList = @('--shf-host', 'off') },
        [pscustomobject]@{ ArgumentList = @('--shf-host-defined', 'off') },
        [pscustomobject]@{ ArgumentList = @('--shf-host-automount', 'off') },
        [pscustomobject]@{ ArgumentList = @('--shf-guest', 'off') },
        [pscustomobject]@{ ArgumentList = @('--shf-guest-automount', 'off') },
        [pscustomobject]@{ ArgumentList = @('--shared-profile', 'off') },
        [pscustomobject]@{ ArgumentList = @('--sh-app-host-to-guest', 'off') },
        [pscustomobject]@{ ArgumentList = @('--sh-app-guest-to-host', 'off') },
        [pscustomobject]@{ ArgumentList = @('--smart-mount', 'off') },
        [pscustomobject]@{ ArgumentList = @('--shared-clipboard', 'off') },
        [pscustomobject]@{ ArgumentList = @('--shared-cloud', 'off') },
        [pscustomobject]@{ ArgumentList = @('--auto-share-camera', 'off') },
        [pscustomobject]@{ ArgumentList = @('--auto-share-smart-card', 'off') },
        [pscustomobject]@{ ArgumentList = @('--auto-share-gamepad', 'off') },
        [pscustomobject]@{ ArgumentList = @('--share-host-location', 'off') }
    )

    foreach ($objHardeningCommand in $arrHardeningCommand) {
        [void](Invoke-MacLabParallelsCommand -ArgumentList (@('set', $Name) + $objHardeningCommand.ArgumentList))
    }

    $hasFact = Get-MacLabParallelsVmFact -Name $Name
    $objIsolation = Test-MacLabParallelsIsolation -Fact $hasFact

    if (-not $objIsolation.Ready) {
        $arrFailedField = @(
            $objIsolation.RequiredSettings |
                Where-Object { -not $_.Pass } |
                ForEach-Object { "$($_.Field)=$($_.Actual)" }
        )
        throw "Parallels VM isolation is not ready after hardening: $($arrFailedField -join ', ')"
    }

    $objIsolation
}

function ConvertTo-MacLabParallelsVmRecord {
    # .SYNOPSIS
    # Builds a Parallels VM record.
    #
    # .DESCRIPTION
    # Normalizes provider facts, snapshots, version data, and isolation details
    # into the public VM record shape.
    #
    # .PARAMETER Name
    # VM name.
    #
    # .PARAMETER MediaId
    # Media identifier.
    #
    # .PARAMETER SizingProfile
    # Sizing profile.
    #
    # .PARAMETER Compatibility
    # Host/guest compatibility record.
    #
    # .EXAMPLE
    # ConvertTo-MacLabParallelsVmRecord -Name 'demo-01'
    # # Returns a normalized provider record.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. Normalized VM record.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private helper. Positional parameters are not supported.
    #
    [CmdletBinding(PositionalBinding = $false)]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [string]$MediaId,

        [string]$SizingProfile,

        [pscustomobject]$Compatibility
    )

    $hasFact = Get-MacLabParallelsVmFact -Name $Name
    $objIsolation = Test-MacLabParallelsIsolation -Fact $hasFact
    $arrSnapshot = @(Get-MacLabParallelsSnapshot -Name $Name)
    $objVersion = Get-ProviderVersion_Parallels

    [pscustomobject]@{
        Provider = 'Parallels'
        Name = $Name
        State = Get-MacLabParallelsInfoValue -Fact $hasFact -Key @('State')
        MediaId = $MediaId
        SizingProfile = $SizingProfile
        CpuCount = ConvertTo-MacLabInteger -Value (Get-MacLabParallelsInfoValue -Fact $hasFact -Key @('CPU(s)', 'CPUs', 'CPU'))
        MemoryMB = ConvertTo-MacLabInteger -Value (Get-MacLabParallelsInfoValue -Fact $hasFact -Key @('Memory', 'RAM'))
        DiskGB = ConvertTo-MacLabInteger -Value (Get-MacLabParallelsInfoValue -Fact $hasFact -Key @('HDD 0', 'Hard disk', 'Disk'))
        MacAddress = Get-MacLabParallelsInfoValue -Fact $hasFact -Key @('MAC address', 'MAC')
        LastSeenAt = (Get-Date).ToUniversalTime().ToString('o')
        Snapshots = $arrSnapshot
        Capabilities = [pscustomobject]@{
            CanCreateVm = $true
            CanStartVm = $true
            CanStopVm = $true
            CanCheckpoint = $true
            CanRestoreCheckpoint = $true
            CanListSnapshots = $true
            SupportsTemplateImport = $false
        }
        ProviderVersion = $objVersion
        Compatibility = $Compatibility
        Isolation = $objIsolation
        RawFacts = [pscustomobject]$hasFact
    }
}

function New-MacLabVm_Parallels {
    # .SYNOPSIS
    # Creates a Parallels-backed macOS lab VM.
    #
    # .DESCRIPTION
    # Creates a stopped Apple Virtualization macOS VM from a verified IPSW,
    # applies the lab hardening sequence, verifies final isolation state, and
    # returns a normalized VM record.
    #
    # .PARAMETER Name
    # VM name.
    #
    # .PARAMETER MediaMetadata
    # Media metadata produced by Get-MacLabMedia.
    #
    # .PARAMETER SizingProfile
    # Sizing profile.
    #
    # .PARAMETER VmRoot
    # Optional VM root path. Parallels Desktop controls the default VM home in v1.
    #
    # .PARAMETER HostMacOSVersion
    # Optional host macOS version override for tests.
    #
    # .EXAMPLE
    # New-MacLabVm_Parallels -Name 'demo-01' -MediaMetadata $metadata
    # # Creates and hardens a Parallels macOS lab VM.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. Provider VM record.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private provider primitive.
    #
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium', PositionalBinding = $false)]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory = $true)]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9._-]{0,62}$')]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [pscustomobject]$MediaMetadata,

        [ValidateSet('Baseline', 'Performance')]
        [string]$SizingProfile = 'Baseline',

        [string]$VmRoot,

        [string]$HostMacOSVersion
    )

    $null = $VmRoot
    $objArtifact = Get-MacLabParallelsArtifact -MediaMetadata $MediaMetadata
    $strHostVersion = if ($HostMacOSVersion) { $HostMacOSVersion } else { Get-MacLabParallelsHostVersion }
    $objCompatibility = Get-MacLabParallelsCompatibility -HostVersion $strHostVersion -GuestVersion $MediaMetadata.Version
    $arrVmName = @(Get-MacLabParallelsVmName)

    if ($arrVmName -contains $Name) {
        throw "A Parallels VM named '${Name}' already exists."
    }

    if (-not $PSCmdlet.ShouldProcess($Name, 'Create Parallels macOS lab VM')) {
        return
    }

    [void](Invoke-MacLabParallelsCommand -ArgumentList @('create', $Name, '-o', 'macos', '--restore-image', $objArtifact.Path) -TimeoutSeconds 21600)
    [void](Invoke-MacLabParallelsHardening -Name $Name)

    ConvertTo-MacLabParallelsVmRecord `
        -Name $Name `
        -MediaId $MediaMetadata.MediaId `
        -SizingProfile $SizingProfile `
        -Compatibility $objCompatibility
}

function Get-MacLabVm_Parallels {
    # .SYNOPSIS
    # Gets Parallels-backed macOS lab VMs.
    #
    # .DESCRIPTION
    # Lists Parallels VMs using reliable names-only output and returns
    # normalized VM records.
    #
    # .PARAMETER Name
    # Optional VM name.
    #
    # .EXAMPLE
    # Get-MacLabVm_Parallels -Name 'demo-01'
    # # Gets a Parallels-backed VM.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. Provider VM record.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private provider primitive.
    #
    [CmdletBinding(PositionalBinding = $false)]
    [OutputType([pscustomobject])]
    param(
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9._-]{0,62}$')]
        [string]$Name
    )

    $arrVmName = @(Get-MacLabParallelsVmName)
    if ($Name) {
        $arrVmName = @($arrVmName | Where-Object { $_ -eq $Name })
    }

    foreach ($strName in $arrVmName) {
        ConvertTo-MacLabParallelsVmRecord -Name $strName
    }
}

function Start-MacLabVm_Parallels {
    # .SYNOPSIS
    # Starts a Parallels-backed macOS lab VM.
    #
    # .DESCRIPTION
    # Starts the VM and verifies the final provider state instead of relying
    # only on command exit status.
    #
    # .PARAMETER Name
    # VM name.
    #
    # .PARAMETER WaitForReady
    # Reserved for future guest readiness checks.
    #
    # .EXAMPLE
    # Start-MacLabVm_Parallels -Name 'demo-01'
    # # Starts a Parallels-backed VM.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. Provider VM state.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private provider primitive.
    #
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low', PositionalBinding = $false)]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory = $true)]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9._-]{0,62}$')]
        [string]$Name,

        [switch]$WaitForReady
    )

    $null = $WaitForReady

    if (-not $PSCmdlet.ShouldProcess($Name, 'Start Parallels macOS lab VM')) {
        return
    }

    [void](Invoke-MacLabParallelsCommand -ArgumentList @('start', $Name) -TimeoutSeconds 900)
    $objVm = ConvertTo-MacLabParallelsVmRecord -Name $Name

    if ($objVm.State -ne 'running') {
        throw "Parallels VM '${Name}' did not reach running state. Final state: $($objVm.State)"
    }

    $objVm
}

function Stop-MacLabVm_Parallels {
    # .SYNOPSIS
    # Stops a Parallels-backed macOS lab VM.
    #
    # .DESCRIPTION
    # Stops the VM and verifies final stopped state, including the owner-observed
    # case where prlctl returned nonzero even though the VM stopped.
    #
    # .PARAMETER Name
    # VM name.
    #
    # .PARAMETER Force
    # Requests a forced power-off.
    #
    # .EXAMPLE
    # Stop-MacLabVm_Parallels -Name 'demo-01'
    # # Stops a Parallels-backed VM.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. Provider VM state.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private provider primitive.
    #
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium', PositionalBinding = $false)]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory = $true)]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9._-]{0,62}$')]
        [string]$Name,

        [switch]$Force
    )

    if (-not $PSCmdlet.ShouldProcess($Name, 'Stop Parallels macOS lab VM')) {
        return
    }

    $arrArgument = @('stop', $Name)
    if ($Force) {
        $arrArgument += '--kill'
    }

    $objCommand = Invoke-MacLabParallelsCommand -ArgumentList $arrArgument -TimeoutSeconds 900 -AllowNonZeroExit
    $objVm = ConvertTo-MacLabParallelsVmRecord -Name $Name

    if ($objVm.State -ne 'stopped') {
        throw "Parallels VM '${Name}' did not reach stopped state. Exit code: $($objCommand.ExitCode). Final state: $($objVm.State)"
    }

    $objVm
}

function Checkpoint-MacLabVm_Parallels {
    # .SYNOPSIS
    # Captures a Parallels-backed macOS lab VM checkpoint.
    #
    # .DESCRIPTION
    # Creates a named Parallels snapshot and returns the provider snapshot ID
    # resolved from `snapshot-list --json`.
    #
    # .PARAMETER Name
    # VM name.
    #
    # .PARAMETER CheckpointName
    # Checkpoint name.
    #
    # .PARAMETER Description
    # Optional checkpoint description.
    #
    # .PARAMETER RequireCleanShutdown
    # Requires the VM to be stopped before snapshot capture.
    #
    # .EXAMPLE
    # Checkpoint-MacLabVm_Parallels -Name 'demo-01' -CheckpointName 'Pre-Enroll'
    # # Captures a Parallels checkpoint.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. Provider checkpoint record.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private provider primitive.
    #
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium', PositionalBinding = $false)]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory = $true)]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9._-]{0,62}$')]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$CheckpointName,

        [string]$Description,

        [switch]$RequireCleanShutdown
    )

    $objVm = ConvertTo-MacLabParallelsVmRecord -Name $Name
    if ($RequireCleanShutdown -and $objVm.State -ne 'stopped') {
        throw "Checkpoint '${CheckpointName}' requires a stopped VM. Current state: $($objVm.State)"
    }

    if (-not $PSCmdlet.ShouldProcess("${Name}:${CheckpointName}", 'Capture Parallels macOS lab VM checkpoint')) {
        return
    }

    $arrArgument = @('snapshot', $Name, '--name', $CheckpointName)
    if ($Description) {
        $arrArgument += @('--description', $Description)
    }

    [void](Invoke-MacLabParallelsCommand -ArgumentList $arrArgument -TimeoutSeconds 3600)
    $objSnapshot = @(Get-MacLabParallelsSnapshot -Name $Name | Where-Object { $_.Name -eq $CheckpointName } | Select-Object -First 1)

    if (-not $objSnapshot) {
        throw "Parallels snapshot '${CheckpointName}' was not found after creation."
    }

    $objSnapshot
}

function Restore-MacLabVmCheckpoint_Parallels {
    # .SYNOPSIS
    # Restores a Parallels-backed macOS lab VM checkpoint.
    #
    # .DESCRIPTION
    # Resolves the friendly checkpoint name to the provider snapshot ID, then
    # restores using `snapshot-switch --id <provider-id> --skip-resume`.
    #
    # .PARAMETER Name
    # VM name.
    #
    # .PARAMETER CheckpointName
    # Checkpoint name.
    #
    # .EXAMPLE
    # Restore-MacLabVmCheckpoint_Parallels -Name 'demo-01' -CheckpointName 'Pre-Enroll'
    # # Restores a Parallels checkpoint by provider snapshot ID.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. Provider VM state.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private provider primitive.
    #
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High', PositionalBinding = $false)]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory = $true)]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9._-]{0,62}$')]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$CheckpointName
    )

    $objSnapshot = @(Get-MacLabParallelsSnapshot -Name $Name | Where-Object { $_.Name -eq $CheckpointName } | Select-Object -First 1)
    if (-not $objSnapshot) {
        throw "Parallels checkpoint '${CheckpointName}' was not found for VM '${Name}'."
    }

    if (-not $PSCmdlet.ShouldProcess("${Name}:${CheckpointName}", 'Restore Parallels macOS lab VM checkpoint')) {
        return
    }

    [void](Invoke-MacLabParallelsCommand -ArgumentList @('snapshot-switch', $Name, '--id', $objSnapshot.Id, '--skip-resume') -TimeoutSeconds 3600)
    $objVm = ConvertTo-MacLabParallelsVmRecord -Name $Name
    $objVm | Add-Member -NotePropertyName RestoredFromCheckpoint -NotePropertyValue $CheckpointName -Force
    $objVm | Add-Member -NotePropertyName RestoredFromProviderSnapshotId -NotePropertyValue $objSnapshot.Id -Force
    $objVm | Add-Member -NotePropertyName RestoredAt -NotePropertyValue (Get-Date).ToUniversalTime().ToString('o') -Force
    $objVm
}

function Remove-MacLabVm_Parallels {
    # .SYNOPSIS
    # Removes a Parallels-backed macOS lab VM.
    #
    # .DESCRIPTION
    # Removes a registered Parallels VM after ShouldProcess approval and feeds
    # the owner-verified confirmation input to the provider prompt.
    #
    # .PARAMETER Name
    # VM name.
    #
    # .PARAMETER RemoveDiskFiles
    # Records the caller's intent. Parallels delete removes the VM registration
    # and associated local VM files for the verified command surface.
    #
    # .PARAMETER Force
    # Suppresses additional caller prompts after ShouldProcess.
    #
    # .EXAMPLE
    # Remove-MacLabVm_Parallels -Name 'demo-01'
    # # Removes a Parallels-backed VM after confirmation.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. Provider removal record.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private provider primitive.
    #
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High', PositionalBinding = $false)]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory = $true)]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9._-]{0,62}$')]
        [string]$Name,

        [switch]$RemoveDiskFiles,

        [switch]$Force
    )

    $null = $Force
    $arrBeforeName = @(Get-MacLabParallelsVmName)
    if ($arrBeforeName -notcontains $Name) {
        throw "Parallels VM '${Name}' was not found."
    }

    if (-not $PSCmdlet.ShouldProcess($Name, 'Remove Parallels macOS lab VM')) {
        return
    }

    [void](Invoke-MacLabParallelsCommand -ArgumentList @('delete', $Name) -TimeoutSeconds 1800 -StandardInputText "y`n")
    $arrAfterName = @(Get-MacLabParallelsVmName)

    [pscustomobject]@{
        Provider = 'Parallels'
        Name = $Name
        Removed = $arrAfterName -notcontains $Name
        RemoveDiskFiles = [bool]$RemoveDiskFiles
        RemovedAt = (Get-Date).ToUniversalTime().ToString('o')
    }
}

function Get-ProviderVersion_Parallels {
    # .SYNOPSIS
    # Gets Parallels provider version information.
    #
    # .DESCRIPTION
    # Captures prlctl and prlsrvctl version details, while treating edition as
    # unknown unless the command output exposes a parseable edition string.
    #
    # .EXAMPLE
    # Get-ProviderVersion_Parallels
    # # Gets provider version details.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. Provider version record.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private provider primitive.
    #
    [CmdletBinding(PositionalBinding = $false)]
    [OutputType([pscustomobject])]
    param()

    $objPrlctl = Get-Command -Name prlctl -CommandType Application -ErrorAction SilentlyContinue
    $objPrlsrvctl = Get-Command -Name prlsrvctl -CommandType Application -ErrorAction SilentlyContinue

    if (-not $objPrlctl -or -not $objPrlsrvctl) {
        return [pscustomobject]@{
            Provider = 'Parallels'
            Installed = $false
            PrlctlPath = if ($objPrlctl) { $objPrlctl.Source } else { $null }
            PrlsrvctlPath = if ($objPrlsrvctl) { $objPrlsrvctl.Source } else { $null }
            PrlctlVersion = $null
            DesktopVersion = $null
            Edition = 'Unknown'
        }
    }

    $objPrlctlVersion = Invoke-LoggedCommand -FilePath $objPrlctl.Source -ArgumentList @('--version') -TimeoutSeconds 60
    $objServerInfo = Invoke-LoggedCommand -FilePath $objPrlsrvctl.Source -ArgumentList @('info') -TimeoutSeconds 60
    $strCombinedOutput = "$($objPrlctlVersion.Stdout)`n$($objServerInfo.Stdout)"
    $strEdition = 'Unknown'

    if ($strCombinedOutput -match '(?im)\b(Standard|Pro|Business)\b') {
        $strEdition = $Matches[1]
    }

    [pscustomobject]@{
        Provider = 'Parallels'
        Installed = $true
        PrlctlPath = $objPrlctl.Source
        PrlsrvctlPath = $objPrlsrvctl.Source
        PrlctlVersion = $objPrlctlVersion.Stdout.Trim()
        DesktopVersion = ($objServerInfo.Stdout -split '\r?\n' | Where-Object { $_ -match 'Parallels Desktop' } | Select-Object -First 1)
        Edition = $strEdition
    }
}

function Test-ProviderInstalled_Parallels {
    # .SYNOPSIS
    # Tests whether Parallels provider tools are installed.
    #
    # .DESCRIPTION
    # Returns true only when both prlctl and prlsrvctl are available.
    #
    # .EXAMPLE
    # Test-ProviderInstalled_Parallels
    # # Tests provider installation.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [bool]. Provider installation state.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private provider primitive.
    #
    [CmdletBinding(PositionalBinding = $false)]
    [OutputType([bool])]
    param()

    $boolPrlctlInstalled = $null -ne (Get-Command -Name prlctl -CommandType Application -ErrorAction SilentlyContinue)
    $boolPrlsrvctlInstalled = $null -ne (Get-Command -Name prlsrvctl -CommandType Application -ErrorAction SilentlyContinue)

    $boolPrlctlInstalled -and $boolPrlsrvctlInstalled
}
