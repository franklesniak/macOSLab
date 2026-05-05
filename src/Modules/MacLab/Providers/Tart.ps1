[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Provider primitive suffixes are defined by the macOSLab specification.')]
param()

function New-MacLabVm_Tart {
    # .SYNOPSIS
    # Creates a Tart-backed macOS lab VM.
    #
    # .DESCRIPTION
    # Phase 2 provider scaffold. Tart remains a v1 stub unless later owner approval expands it.
    #
    # .PARAMETER Name
    # VM name.
    #
    # .EXAMPLE
    # New-MacLabVm_Tart -Name 'demo-tart-01'
    # # Fails clearly in v1 unless Tart expansion is approved.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. Provider VM record if a later phase implements Tart.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private provider primitive.
    #
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium', PositionalBinding = $false)]
    [OutputType([pscustomobject])]
    param([string]$Name)
    $null = $Name
    if (-not $PSCmdlet.ShouldProcess($Name, 'Create Tart macOS lab VM')) {
        return
    }
    throw [System.NotImplementedException]::new('Tart provider is documented but not implemented in v1. See docs/CI-and-Tart.md.')
}

function Get-MacLabVm_Tart {
    # .SYNOPSIS
    # Gets Tart-backed macOS lab VMs.
    #
    # .DESCRIPTION
    # Phase 2 provider scaffold. Tart remains a v1 stub unless later owner approval expands it.
    #
    # .PARAMETER Name
    # Optional VM name.
    #
    # .EXAMPLE
    # Get-MacLabVm_Tart -Name 'demo-tart-01'
    # # Fails clearly in v1 unless Tart expansion is approved.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. Provider VM record if a later phase implements Tart.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private provider primitive.
    #
    [CmdletBinding(PositionalBinding = $false)]
    [OutputType([pscustomobject])]
    param([string]$Name)
    $null = $Name
    throw [System.NotImplementedException]::new('Tart provider is documented but not implemented in v1. See docs/CI-and-Tart.md.')
}

function Start-MacLabVm_Tart {
    # .SYNOPSIS
    # Starts a Tart-backed macOS lab VM.
    #
    # .DESCRIPTION
    # Phase 2 provider scaffold. Tart remains a v1 stub unless later owner approval expands it.
    #
    # .PARAMETER Name
    # VM name.
    #
    # .EXAMPLE
    # Start-MacLabVm_Tart -Name 'demo-tart-01'
    # # Fails clearly in v1 unless Tart expansion is approved.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. Provider VM state if a later phase implements Tart.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private provider primitive.
    #
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium', PositionalBinding = $false)]
    [OutputType([pscustomobject])]
    param([string]$Name)
    $null = $Name
    if (-not $PSCmdlet.ShouldProcess($Name, 'Start Tart macOS lab VM')) {
        return
    }
    throw [System.NotImplementedException]::new('Tart provider is documented but not implemented in v1. See docs/CI-and-Tart.md.')
}

function Stop-MacLabVm_Tart {
    # .SYNOPSIS
    # Stops a Tart-backed macOS lab VM.
    #
    # .DESCRIPTION
    # Phase 2 provider scaffold. Tart remains a v1 stub unless later owner approval expands it.
    #
    # .PARAMETER Name
    # VM name.
    #
    # .EXAMPLE
    # Stop-MacLabVm_Tart -Name 'demo-tart-01'
    # # Fails clearly in v1 unless Tart expansion is approved.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. Provider VM state if a later phase implements Tart.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private provider primitive.
    #
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium', PositionalBinding = $false)]
    [OutputType([pscustomobject])]
    param([string]$Name)
    $null = $Name
    if (-not $PSCmdlet.ShouldProcess($Name, 'Stop Tart macOS lab VM')) {
        return
    }
    throw [System.NotImplementedException]::new('Tart provider is documented but not implemented in v1. See docs/CI-and-Tart.md.')
}

function Checkpoint-MacLabVm_Tart {
    # .SYNOPSIS
    # Captures a Tart-backed macOS lab VM checkpoint.
    #
    # .DESCRIPTION
    # Phase 2 provider scaffold. Tart remains a v1 stub unless later owner approval expands it.
    #
    # .PARAMETER Name
    # VM name.
    #
    # .PARAMETER CheckpointName
    # Checkpoint name.
    #
    # .EXAMPLE
    # Checkpoint-MacLabVm_Tart -Name 'demo-tart-01' -CheckpointName 'Pre-Enroll'
    # # Fails clearly in v1 unless Tart expansion is approved.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. Provider checkpoint record if a later phase implements Tart.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private provider primitive.
    #
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High', PositionalBinding = $false)]
    [OutputType([pscustomobject])]
    param(
        [string]$Name,
        [string]$CheckpointName
    )
    $null = $Name
    $null = $CheckpointName
    if (-not $PSCmdlet.ShouldProcess("${Name}:${CheckpointName}", 'Capture Tart macOS lab VM checkpoint')) {
        return
    }
    throw [System.NotImplementedException]::new('Tart provider is documented but not implemented in v1. See docs/CI-and-Tart.md.')
}

function Restore-MacLabVmCheckpoint_Tart {
    # .SYNOPSIS
    # Restores a Tart-backed macOS lab VM checkpoint.
    #
    # .DESCRIPTION
    # Phase 2 provider scaffold. Tart remains a v1 stub unless later owner approval expands it.
    #
    # .PARAMETER Name
    # VM name.
    #
    # .PARAMETER CheckpointName
    # Checkpoint name.
    #
    # .EXAMPLE
    # Restore-MacLabVmCheckpoint_Tart -Name 'demo-tart-01' -CheckpointName 'Pre-Enroll'
    # # Fails clearly in v1 unless Tart expansion is approved.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. Provider VM state if a later phase implements Tart.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private provider primitive.
    #
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High', PositionalBinding = $false)]
    [OutputType([pscustomobject])]
    param(
        [string]$Name,
        [string]$CheckpointName
    )
    $null = $Name
    $null = $CheckpointName
    if (-not $PSCmdlet.ShouldProcess("${Name}:${CheckpointName}", 'Restore Tart macOS lab VM checkpoint')) {
        return
    }
    throw [System.NotImplementedException]::new('Tart provider is documented but not implemented in v1. See docs/CI-and-Tart.md.')
}

function Remove-MacLabVm_Tart {
    # .SYNOPSIS
    # Removes a Tart-backed macOS lab VM.
    #
    # .DESCRIPTION
    # Phase 2 provider scaffold. Tart remains a v1 stub unless later owner approval expands it.
    #
    # .PARAMETER Name
    # VM name.
    #
    # .EXAMPLE
    # Remove-MacLabVm_Tart -Name 'demo-tart-01'
    # # Fails clearly in v1 unless Tart expansion is approved.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. Provider removal record if a later phase implements Tart.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private provider primitive.
    #
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High', PositionalBinding = $false)]
    [OutputType([pscustomobject])]
    param([string]$Name)
    $null = $Name
    if (-not $PSCmdlet.ShouldProcess($Name, 'Remove Tart macOS lab VM')) {
        return
    }
    throw [System.NotImplementedException]::new('Tart provider is documented but not implemented in v1. See docs/CI-and-Tart.md.')
}

function Get-ProviderVersion_Tart {
    # .SYNOPSIS
    # Gets Tart provider version information.
    #
    # .DESCRIPTION
    # Captures Tart version information when the optional Tart command is
    # installed. Tart remains a v1 stub for lifecycle operations.
    #
    # .EXAMPLE
    # Get-ProviderVersion_Tart
    # # Gets provider version details after Tart stub implementation.
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

    $objCommand = Get-Command -Name tart -CommandType Application -ErrorAction SilentlyContinue
    if (-not $objCommand) {
        return [pscustomobject]@{
            Provider = 'Tart'
            Installed = $false
            TartPath = $null
            TartVersion = $null
            Implementation = 'StubbedInV1'
            Documentation = 'docs/CI-and-Tart.md'
        }
    }

    $objVersion = Invoke-LoggedCommand -FilePath $objCommand.Source -ArgumentList @('--version') -TimeoutSeconds 60

    [pscustomobject]@{
        Provider = 'Tart'
        Installed = $true
        TartPath = $objCommand.Source
        TartVersion = $objVersion.Stdout.Trim()
        Implementation = 'StubbedInV1'
        Documentation = 'docs/CI-and-Tart.md'
    }
}

function Test-ProviderInstalled_Tart {
    # .SYNOPSIS
    # Tests whether Tart provider tools are installed.
    #
    # .DESCRIPTION
    # Tests whether the optional Tart command is installed. Tart remains a v1
    # lifecycle stub even when the command is present.
    #
    # .EXAMPLE
    # Test-ProviderInstalled_Tart
    # # Tests provider installation after Tart stub implementation.
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

    $null -ne (Get-Command -Name tart -CommandType Application -ErrorAction SilentlyContinue)
}
