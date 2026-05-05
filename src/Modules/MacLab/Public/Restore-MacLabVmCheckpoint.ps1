function Restore-MacLabVmCheckpoint {
    # .SYNOPSIS
    # Restores a macOS lab VM checkpoint.
    #
    # .DESCRIPTION
    # Phase 2 scaffold for checkpoint restore. The implemented command will warn
    # that VM rollback does not rewind cloud state.
    #
    # .PARAMETER Provider
    # Hypervisor provider.
    #
    # .PARAMETER Name
    # VM name.
    #
    # .PARAMETER CheckpointName
    # Canonical checkpoint name.
    #
    # .PARAMETER AcknowledgeCloudStateWarning
    # Acknowledges cloud-state rollback limits for unattended restore.
    #
    # .EXAMPLE
    # Restore-MacLabVmCheckpoint -Provider Parallels -Name 'demo-01' -CheckpointName 'Post-Enroll-Baseline' -AcknowledgeCloudStateWarning
    # # Restores the checkpoint after provider implementation lands.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. VM state after provider implementation.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Positional parameters are not supported.
    #
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High', PositionalBinding = $false)]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet('Parallels', 'UTM', 'Tart')]
        [string]$Provider,

        [Parameter(Mandatory = $true)]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9._-]{0,62}$')]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Clean-OS', 'Pre-Enroll', 'Post-Enroll-Baseline', 'Broken-Policy-State', 'Recovered-Known-Good')]
        [string]$CheckpointName,

        [switch]$AcknowledgeCloudStateWarning
    )

    if (-not $AcknowledgeCloudStateWarning) {
        throw 'Restore does not rewind Intune, Entra, Defender, or other cloud state. Re-run with -AcknowledgeCloudStateWarning after confirming the rollback boundary.'
    }

    if (-not $PSCmdlet.ShouldProcess("${Name}:${CheckpointName}", 'Restore macOS lab VM checkpoint')) {
        return
    }

    if ($Provider -ne 'Parallels') {
        throw [System.NotImplementedException]::new(
            "Provider '${Provider}' checkpoint restore is implemented in a later phase."
        )
    }

    Restore-MacLabVmCheckpoint_Parallels -Name $Name -CheckpointName $CheckpointName -Confirm:$false
}
