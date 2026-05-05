[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Provider primitive suffixes are defined by the macOSLab specification.')]
param()

function New-MacLabVm_UTM {
    # .SYNOPSIS
    # Creates or registers a UTM-backed macOS lab VM.
    #
    # .DESCRIPTION
    # Phase 2 provider scaffold. Phase 6 keeps UTM creation manual-step-required unless later evidence proves safe automation.
    #
    # .PARAMETER Name
    # VM name.
    #
    # .EXAMPLE
    # New-MacLabVm_UTM -Name 'demo-utm-01'
    # # Reports the UTM creation path after Phase 6 implementation.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. Provider VM record after implementation.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private provider primitive.
    #
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium', PositionalBinding = $false)]
    [OutputType([pscustomobject])]
    param([string]$Name)
    $null = $Name
    if (-not $PSCmdlet.ShouldProcess($Name, 'Create or register UTM macOS lab VM')) {
        return
    }
    throw [System.NotImplementedException]::new('UTM VM creation is a Phase 2 scaffold stub. Phase 6 implements this primitive as manual-step-required unless proven safe.')
}

function Get-MacLabVm_UTM {
    # .SYNOPSIS
    # Gets UTM-backed macOS lab VMs.
    #
    # .DESCRIPTION
    # Phase 2 provider scaffold. Phase 6 implements UTM inventory.
    #
    # .PARAMETER Name
    # Optional VM name.
    #
    # .EXAMPLE
    # Get-MacLabVm_UTM -Name 'demo-utm-01'
    # # Gets the VM after Phase 6 implementation.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. Provider VM record after implementation.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private provider primitive.
    #
    [CmdletBinding(PositionalBinding = $false)]
    [OutputType([pscustomobject])]
    param([string]$Name)
    $null = $Name
    throw [System.NotImplementedException]::new('UTM inventory is a Phase 2 scaffold stub. Phase 6 implements this primitive.')
}

function Start-MacLabVm_UTM {
    # .SYNOPSIS
    # Starts a UTM-backed macOS lab VM.
    #
    # .DESCRIPTION
    # Phase 2 provider scaffold. Phase 6 implements proven UTM lifecycle behavior.
    #
    # .PARAMETER Name
    # VM name.
    #
    # .EXAMPLE
    # Start-MacLabVm_UTM -Name 'demo-utm-01'
    # # Starts the VM after Phase 6 implementation.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. Provider VM state after implementation.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private provider primitive.
    #
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium', PositionalBinding = $false)]
    [OutputType([pscustomobject])]
    param([string]$Name)
    $null = $Name
    if (-not $PSCmdlet.ShouldProcess($Name, 'Start UTM macOS lab VM')) {
        return
    }
    throw [System.NotImplementedException]::new('UTM start is a Phase 2 scaffold stub. Phase 6 implements this primitive.')
}

function Stop-MacLabVm_UTM {
    # .SYNOPSIS
    # Stops a UTM-backed macOS lab VM.
    #
    # .DESCRIPTION
    # Phase 2 provider scaffold. Phase 6 implements proven UTM lifecycle behavior.
    #
    # .PARAMETER Name
    # VM name.
    #
    # .EXAMPLE
    # Stop-MacLabVm_UTM -Name 'demo-utm-01'
    # # Stops the VM after Phase 6 implementation.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. Provider VM state after implementation.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private provider primitive.
    #
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium', PositionalBinding = $false)]
    [OutputType([pscustomobject])]
    param([string]$Name)
    $null = $Name
    if (-not $PSCmdlet.ShouldProcess($Name, 'Stop UTM macOS lab VM')) {
        return
    }
    throw [System.NotImplementedException]::new('UTM stop is a Phase 2 scaffold stub. Phase 6 implements this primitive.')
}

function Checkpoint-MacLabVm_UTM {
    # .SYNOPSIS
    # Captures a UTM-backed macOS lab VM checkpoint.
    #
    # .DESCRIPTION
    # Phase 2 provider scaffold. Phase 6 treats UTM checkpoints as manual-step-required unless proven safe.
    #
    # .PARAMETER Name
    # VM name.
    #
    # .PARAMETER CheckpointName
    # Checkpoint name.
    #
    # .EXAMPLE
    # Checkpoint-MacLabVm_UTM -Name 'demo-utm-01' -CheckpointName 'Pre-Enroll'
    # # Reports manual-step-required behavior after Phase 6 implementation.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. Provider checkpoint record after implementation.
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
    if (-not $PSCmdlet.ShouldProcess("${Name}:${CheckpointName}", 'Capture UTM macOS lab VM checkpoint')) {
        return
    }
    throw [System.NotImplementedException]::new('UTM checkpoint capture is a Phase 2 scaffold stub. Phase 6 documents this gap.')
}

function Restore-MacLabVmCheckpoint_UTM {
    # .SYNOPSIS
    # Restores a UTM-backed macOS lab VM checkpoint.
    #
    # .DESCRIPTION
    # Phase 2 provider scaffold. Phase 6 treats UTM checkpoint restore as manual-step-required unless proven safe.
    #
    # .PARAMETER Name
    # VM name.
    #
    # .PARAMETER CheckpointName
    # Checkpoint name.
    #
    # .EXAMPLE
    # Restore-MacLabVmCheckpoint_UTM -Name 'demo-utm-01' -CheckpointName 'Pre-Enroll'
    # # Reports manual-step-required behavior after Phase 6 implementation.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. Provider VM state after implementation.
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
    if (-not $PSCmdlet.ShouldProcess("${Name}:${CheckpointName}", 'Restore UTM macOS lab VM checkpoint')) {
        return
    }
    throw [System.NotImplementedException]::new('UTM checkpoint restore is a Phase 2 scaffold stub. Phase 6 documents this gap.')
}

function Remove-MacLabVm_UTM {
    # .SYNOPSIS
    # Removes a UTM-backed macOS lab VM.
    #
    # .DESCRIPTION
    # Phase 2 provider scaffold. Phase 6 keeps destructive UTM delete outside the default demo path.
    #
    # .PARAMETER Name
    # VM name.
    #
    # .EXAMPLE
    # Remove-MacLabVm_UTM -Name 'demo-utm-01'
    # # Reports delete behavior after Phase 6 implementation.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. Provider removal record after implementation.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private provider primitive.
    #
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High', PositionalBinding = $false)]
    [OutputType([pscustomobject])]
    param([string]$Name)
    $null = $Name
    if (-not $PSCmdlet.ShouldProcess($Name, 'Remove UTM macOS lab VM')) {
        return
    }
    throw [System.NotImplementedException]::new('UTM removal is a Phase 2 scaffold stub. Phase 6 documents safe limits for this primitive.')
}

function Get-ProviderVersion_UTM {
    # .SYNOPSIS
    # Gets UTM provider version information.
    #
    # .DESCRIPTION
    # Phase 2 provider scaffold. Phase 6 implements UTM version capture.
    #
    # .EXAMPLE
    # Get-ProviderVersion_UTM
    # # Gets provider version details after Phase 6 implementation.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. Provider version record after implementation.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private provider primitive.
    #
    [CmdletBinding(PositionalBinding = $false)]
    [OutputType([pscustomobject])]
    param()
    throw [System.NotImplementedException]::new('UTM version capture is a Phase 2 scaffold stub. Phase 6 implements this primitive.')
}

function Test-ProviderInstalled_UTM {
    # .SYNOPSIS
    # Tests whether UTM provider tools are installed.
    #
    # .DESCRIPTION
    # Phase 2 provider scaffold. Phase 6 implements UTM installation detection.
    #
    # .EXAMPLE
    # Test-ProviderInstalled_UTM
    # # Tests provider installation after Phase 6 implementation.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [bool]. Provider installation state after implementation.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private provider primitive.
    #
    [CmdletBinding(PositionalBinding = $false)]
    [OutputType([bool])]
    param()
    return $false
}
