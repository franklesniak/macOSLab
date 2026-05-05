[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Provider primitive suffixes are defined by the macOSLab specification.')]
param()

function Get-MacLabUtmctlPath {
    # .SYNOPSIS
    # Resolves the utmctl command path.
    #
    # .DESCRIPTION
    # Resolves the verified UTM application-bundle command path first, then
    # falls back to PATH discovery for test and nonstandard installations.
    #
    # .EXAMPLE
    # Get-MacLabUtmctlPath
    # # Returns the utmctl executable path.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [string]. Resolved utmctl path.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private helper. Positional parameters are not supported.
    #
    [CmdletBinding(PositionalBinding = $false)]
    [OutputType([string])]
    param()

    $strBundleCommandPath = '/Applications/UTM.app/Contents/MacOS/utmctl'
    if (Test-Path -LiteralPath $strBundleCommandPath -PathType Leaf) {
        return $strBundleCommandPath
    }

    $objCommand = Get-Command -Name utmctl -CommandType Application -ErrorAction SilentlyContinue
    if ($objCommand) {
        return $objCommand.Source
    }

    throw 'utmctl was not found. Install UTM or create the documented UTM VM manually before using the UTM provider.'
}

function Invoke-MacLabUtmctl {
    # .SYNOPSIS
    # Runs utmctl with structured capture.
    #
    # .DESCRIPTION
    # Runs utmctl through the shared command runner. Callers still inspect
    # command output and final status because utmctl can return exit code 0
    # while printing an operational error.
    #
    # .PARAMETER ArgumentList
    # Arguments to pass to utmctl.
    #
    # .PARAMETER TimeoutSeconds
    # Maximum runtime in seconds.
    #
    # .PARAMETER AllowNonZeroExit
    # Allows a nonzero exit code so the caller can classify a manual gap.
    #
    # .EXAMPLE
    # Invoke-MacLabUtmctl -ArgumentList @('status', 'demo-utm-01')
    # # Captures a UTM status command.
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

        [switch]$AllowNonZeroExit
    )

    $strCommandPath = Get-MacLabUtmctlPath
    $objCommand = Invoke-LoggedCommand -FilePath $strCommandPath -ArgumentList $ArgumentList -TimeoutSeconds $TimeoutSeconds

    if ($objCommand.TimedOut) {
        throw "utmctl command timed out: $($objCommand.DisplayCommand)"
    }

    if ($objCommand.ExitCode -ne 0 -and -not $AllowNonZeroExit) {
        throw "utmctl command failed with exit code $($objCommand.ExitCode): $($objCommand.DisplayCommand)"
    }

    $objCommand
}

function Get-MacLabUtmManualStepRequiredMessage {
    # .SYNOPSIS
    # Gets a UTM manual-step-required message.
    #
    # .DESCRIPTION
    # Centralizes the v1 UTM manual boundary so unsupported primitives report
    # consistent guidance.
    #
    # .PARAMETER Primitive
    # Provider primitive name.
    #
    # .EXAMPLE
    # Get-MacLabUtmManualStepRequiredMessage -Primitive 'checkpoint'
    # # Returns the manual-step-required checkpoint message.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [string]. Manual-step-required message.
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
        [string]$Primitive
    )

    "UTM ${Primitive} requires a manual step in v1. Use examples/utm/macos-lab-template.utm.json and examples/MMSMOA-2026/Demo3-UTM.ps1; top-level utmctl help does not prove safe automation for this primitive."
}

function ConvertFrom-MacLabUtmList {
    # .SYNOPSIS
    # Parses utmctl list output.
    #
    # .DESCRIPTION
    # Parses the table-oriented utmctl list output into VM name and status
    # records. Names in this lab are constrained to avoid spaces.
    #
    # .PARAMETER ListText
    # Text emitted by utmctl list.
    #
    # .EXAMPLE
    # ConvertFrom-MacLabUtmList -ListText $text
    # # Returns parsed UTM inventory rows.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. Parsed inventory rows.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private helper. Positional parameters are not supported.
    #
    [CmdletBinding(PositionalBinding = $false)]
    [OutputType([pscustomobject])]
    param([string]$ListText)

    foreach ($strLine in ($ListText -split '\r?\n')) {
        $strTrimmedLine = $strLine.Trim()
        if (-not $strTrimmedLine -or $strTrimmedLine -match '^(UUID|Name|---)') {
            continue
        }

        if ($strTrimmedLine -match '^\S+\s+(started|stopped|paused)\s+([A-Za-z0-9][A-Za-z0-9._-]{0,62})$') {
            [pscustomobject]@{
                Name = $Matches[2]
                Status = $Matches[1]
            }
            continue
        }

        if ($strTrimmedLine -match '^([A-Za-z0-9][A-Za-z0-9._-]{0,62})\s+(started|stopped|paused)$') {
            [pscustomobject]@{
                Name = $Matches[1]
                Status = $Matches[2]
            }
        }
    }
}

function Get-MacLabUtmStatus {
    # .SYNOPSIS
    # Gets UTM VM status.
    #
    # .DESCRIPTION
    # Runs `utmctl status` and normalizes the observed started, paused, and
    # stopped states.
    #
    # .PARAMETER Name
    # VM name.
    #
    # .EXAMPLE
    # Get-MacLabUtmStatus -Name 'demo-utm-01'
    # # Returns the normalized VM status.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. UTM status record.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private helper. Positional parameters are not supported.
    #
    [CmdletBinding(PositionalBinding = $false)]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory = $true)]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9._-]{0,62}$')]
        [string]$Name
    )

    $objCommand = Invoke-MacLabUtmctl -ArgumentList @('status', $Name) -AllowNonZeroExit
    $strCombinedOutput = "$($objCommand.Stdout)`n$($objCommand.Stderr)"
    $strStatus = $null

    if ($strCombinedOutput -match '(started|stopped|paused)') {
        $strStatus = $Matches[1]
    }

    [pscustomobject]@{
        Provider = 'UTM'
        Name = $Name
        Status = $strStatus
        ExitCode = $objCommand.ExitCode
        ProviderMessage = $strCombinedOutput.Trim()
    }
}

function ConvertTo-MacLabUtmVmRecord {
    # .SYNOPSIS
    # Builds a UTM VM record.
    #
    # .DESCRIPTION
    # Normalizes UTM status and provider-version details into the common VM
    # inventory shape while marking unsupported capabilities explicitly.
    #
    # .PARAMETER Name
    # VM name.
    #
    # .PARAMETER Status
    # Optional status value.
    #
    # .EXAMPLE
    # ConvertTo-MacLabUtmVmRecord -Name 'demo-utm-01' -Status 'stopped'
    # # Returns a normalized UTM VM record.
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
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9._-]{0,62}$')]
        [string]$Name,

        [string]$Status
    )

    $strStatus = if ($Status) { $Status } else { (Get-MacLabUtmStatus -Name $Name).Status }

    [pscustomobject]@{
        Provider = 'UTM'
        Name = $Name
        State = $strStatus
        MediaId = $null
        SizingProfile = $null
        CpuCount = $null
        MemoryMB = $null
        DiskGB = $null
        MacAddress = $null
        LastSeenAt = (Get-Date).ToUniversalTime().ToString('o')
        Snapshots = @()
        Capabilities = [pscustomobject]@{
            CanCreateVm = $false
            CanStartVm = $true
            CanStopVm = $true
            CanCheckpoint = $false
            CanRestoreCheckpoint = $false
            CanListSnapshots = $false
            SupportsTemplateImport = $false
        }
        ProviderVersion = Get-ProviderVersion_UTM
        ManualStepRequired = @(
            'create',
            'import',
            'export',
            'checkpoint',
            'restore-checkpoint',
            'guest-file-transfer',
            'guest-command-execution',
            'ip-address',
            'delete'
        )
    }
}

function New-MacLabVm_UTM {
    # .SYNOPSIS
    # Reports UTM manual VM creation requirements.
    #
    # .DESCRIPTION
    # UTM VM creation remains a documented manual provider-swap step in v1
    # because the verified utmctl surface does not advertise create or import.
    #
    # .PARAMETER Name
    # VM name.
    #
    # .PARAMETER MediaId
    # Media identifier for the manually created VM.
    #
    # .EXAMPLE
    # New-MacLabVm_UTM -Name 'demo-utm-01' -MediaId '26.4.1-25E253'
    # # Fails with manual-step-required guidance.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. No object is emitted when manual creation is required.
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

        [string]$MediaId
    )

    $null = $MediaId
    if (-not $PSCmdlet.ShouldProcess($Name, 'Create or register UTM macOS lab VM')) {
        return
    }

    throw (Get-MacLabUtmManualStepRequiredMessage -Primitive 'VM creation')
}

function Get-MacLabVm_UTM {
    # .SYNOPSIS
    # Gets UTM-backed macOS lab VMs.
    #
    # .DESCRIPTION
    # Lists registered UTM VMs or returns status for a specific VM using the
    # owner-verified utmctl lifecycle surface.
    #
    # .PARAMETER Name
    # Optional VM name.
    #
    # .EXAMPLE
    # Get-MacLabVm_UTM -Name 'demo-utm-01'
    # # Gets a UTM-backed VM status record.
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

    if ($Name) {
        $objStatus = Get-MacLabUtmStatus -Name $Name
        ConvertTo-MacLabUtmVmRecord -Name $Name -Status $objStatus.Status
        return
    }

    $objCommand = Invoke-MacLabUtmctl -ArgumentList @('list')
    $arrVm = @(ConvertFrom-MacLabUtmList -ListText $objCommand.Stdout)
    foreach ($objVm in $arrVm) {
        ConvertTo-MacLabUtmVmRecord -Name $objVm.Name -Status $objVm.Status
    }
}

function Start-MacLabVm_UTM {
    # .SYNOPSIS
    # Starts or resumes a UTM-backed macOS lab VM.
    #
    # .DESCRIPTION
    # Runs the verified `utmctl start` path and verifies final started status,
    # including the observed case where utmctl prints an operational message
    # while still returning exit code 0.
    #
    # .PARAMETER Name
    # VM name.
    #
    # .PARAMETER WaitForReady
    # Reserved for future guest readiness checks.
    #
    # .EXAMPLE
    # Start-MacLabVm_UTM -Name 'demo-utm-01'
    # # Starts or resumes a UTM-backed VM.
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
    if (-not $PSCmdlet.ShouldProcess($Name, 'Start UTM macOS lab VM')) {
        return
    }

    $objCommand = Invoke-MacLabUtmctl -ArgumentList @('start', $Name) -TimeoutSeconds 900 -AllowNonZeroExit
    $objVm = ConvertTo-MacLabUtmVmRecord -Name $Name

    if ($objVm.State -ne 'started') {
        throw "UTM VM '${Name}' did not reach started state. Exit code: $($objCommand.ExitCode). Output: $($objCommand.Stdout)$($objCommand.Stderr)"
    }

    $objVm
}

function Stop-MacLabVm_UTM {
    # .SYNOPSIS
    # Stops a UTM-backed macOS lab VM.
    #
    # .DESCRIPTION
    # Runs the verified `utmctl stop` path and verifies final stopped status.
    #
    # .PARAMETER Name
    # VM name.
    #
    # .PARAMETER Force
    # Present for the common provider contract. UTM v1 does not add an extra
    # force flag to the verified stop command.
    #
    # .EXAMPLE
    # Stop-MacLabVm_UTM -Name 'demo-utm-01'
    # # Stops a UTM-backed VM.
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

    $null = $Force
    if (-not $PSCmdlet.ShouldProcess($Name, 'Stop UTM macOS lab VM')) {
        return
    }

    $objCommand = Invoke-MacLabUtmctl -ArgumentList @('stop', $Name) -TimeoutSeconds 900 -AllowNonZeroExit
    $objVm = ConvertTo-MacLabUtmVmRecord -Name $Name

    if ($objVm.State -ne 'stopped') {
        throw "UTM VM '${Name}' did not reach stopped state. Exit code: $($objCommand.ExitCode). Output: $($objCommand.Stdout)$($objCommand.Stderr)"
    }

    $objVm
}

function Checkpoint-MacLabVm_UTM {
    # .SYNOPSIS
    # Reports UTM checkpoint manual requirements.
    #
    # .DESCRIPTION
    # UTM checkpoint capture is manual-step-required in v1 because the verified
    # utmctl surface does not advertise snapshot primitives.
    #
    # .PARAMETER Name
    # VM name.
    #
    # .PARAMETER CheckpointName
    # Checkpoint name.
    #
    # .EXAMPLE
    # Checkpoint-MacLabVm_UTM -Name 'demo-utm-01' -CheckpointName 'Pre-Enroll'
    # # Fails with manual-step-required guidance.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. No object is emitted when manual checkpointing is required.
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
        [string]$CheckpointName
    )

    if (-not $PSCmdlet.ShouldProcess("${Name}:${CheckpointName}", 'Capture UTM macOS lab VM checkpoint')) {
        return
    }

    throw (Get-MacLabUtmManualStepRequiredMessage -Primitive 'checkpoint capture')
}

function Restore-MacLabVmCheckpoint_UTM {
    # .SYNOPSIS
    # Reports UTM checkpoint restore manual requirements.
    #
    # .DESCRIPTION
    # UTM checkpoint restore is manual-step-required in v1 because the verified
    # utmctl surface does not advertise snapshot restore primitives.
    #
    # .PARAMETER Name
    # VM name.
    #
    # .PARAMETER CheckpointName
    # Checkpoint name.
    #
    # .EXAMPLE
    # Restore-MacLabVmCheckpoint_UTM -Name 'demo-utm-01' -CheckpointName 'Pre-Enroll'
    # # Fails with manual-step-required guidance.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. No object is emitted when manual restore is required.
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

    if (-not $PSCmdlet.ShouldProcess("${Name}:${CheckpointName}", 'Restore UTM macOS lab VM checkpoint')) {
        return
    }

    throw (Get-MacLabUtmManualStepRequiredMessage -Primitive 'checkpoint restore')
}

function Remove-MacLabVm_UTM {
    # .SYNOPSIS
    # Reports UTM deletion limits.
    #
    # .DESCRIPTION
    # UTM delete is not automated in v1 because verified help describes delete
    # as having no confirmation and safe file-removal semantics were not proven.
    #
    # .PARAMETER Name
    # VM name.
    #
    # .PARAMETER RemoveDiskFiles
    # Common provider contract parameter. UTM v1 does not automate deletion.
    #
    # .PARAMETER Force
    # Common provider contract parameter. UTM v1 does not automate deletion.
    #
    # .EXAMPLE
    # Remove-MacLabVm_UTM -Name 'demo-utm-01'
    # # Fails with manual-step-required guidance.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. No object is emitted when manual deletion is required.
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

    $null = $RemoveDiskFiles
    $null = $Force
    if (-not $PSCmdlet.ShouldProcess($Name, 'Remove UTM macOS lab VM')) {
        return
    }

    throw 'UTM delete has no provider confirmation in the verified utmctl help and is not automated in v1. Delete only disposable UTM VMs manually after cloud cleanup planning.'
}

function Get-ProviderVersion_UTM {
    # .SYNOPSIS
    # Gets UTM provider version information.
    #
    # .DESCRIPTION
    # Captures utmctl version information where UTM is installed.
    #
    # .EXAMPLE
    # Get-ProviderVersion_UTM
    # # Gets UTM version details.
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

    if (-not (Test-ProviderInstalled_UTM)) {
        return [pscustomobject]@{
            Provider = 'UTM'
            Installed = $false
            UtmctlPath = $null
            UtmctlVersion = $null
            AppVersion = $null
        }
    }

    $strUtmctlPath = Get-MacLabUtmctlPath
    $objCommand = Invoke-LoggedCommand -FilePath $strUtmctlPath -ArgumentList @('version') -TimeoutSeconds 60

    [pscustomobject]@{
        Provider = 'UTM'
        Installed = $true
        UtmctlPath = $strUtmctlPath
        UtmctlVersion = $objCommand.Stdout.Trim()
        AppVersion = $objCommand.Stdout.Trim()
    }
}

function Test-ProviderInstalled_UTM {
    # .SYNOPSIS
    # Tests whether UTM provider tools are installed.
    #
    # .DESCRIPTION
    # Returns true when the verified app-bundle utmctl path or a PATH-resolved
    # utmctl command exists.
    #
    # .EXAMPLE
    # Test-ProviderInstalled_UTM
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

    $strBundleCommandPath = '/Applications/UTM.app/Contents/MacOS/utmctl'
    if (Test-Path -LiteralPath $strBundleCommandPath -PathType Leaf) {
        return $true
    }

    $null -ne (Get-Command -Name utmctl -CommandType Application -ErrorAction SilentlyContinue)
}
