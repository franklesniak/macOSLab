function Checkpoint-MacLabVm {
    # .SYNOPSIS
    # Captures a named macOS lab VM checkpoint.
    #
    # .DESCRIPTION
    # Phase 2 scaffold for the five-checkpoint model.
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
    # .PARAMETER AllowNonCanonicalCheckpoint
    # Future opt-in for local non-canonical checkpoints.
    #
    # .PARAMETER Description
    # Optional checkpoint description.
    #
    # .PARAMETER RequireCleanShutdown
    # Requires a stopped guest before checkpoint capture when implemented.
    #
    # .EXAMPLE
    # Checkpoint-MacLabVm -Provider Parallels -Name 'demo-01' -CheckpointName 'Pre-Enroll'
    # # Captures the checkpoint after provider implementation lands.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. Checkpoint record after provider implementation.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Positional parameters are not supported.
    #
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium', PositionalBinding = $false)]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet('Parallels', 'UTM', 'Tart')]
        [string]$Provider,

        [Parameter(Mandatory = $true)]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9._-]{0,62}$')]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$CheckpointName,

        [switch]$AllowNonCanonicalCheckpoint,

        [string]$Description,

        [switch]$RequireCleanShutdown
    )

    $arrCanonicalCheckpointName = @(
        'Clean-OS',
        'Pre-Enroll',
        'Post-Enroll-Baseline',
        'Broken-Policy-State',
        'Recovered-Known-Good'
    )

    if ($arrCanonicalCheckpointName -notcontains $CheckpointName -and -not $AllowNonCanonicalCheckpoint) {
        throw "Checkpoint '${CheckpointName}' is not canonical. Use -AllowNonCanonicalCheckpoint for local-only checkpoints."
    }

    if (-not $PSCmdlet.ShouldProcess("${Name}:${CheckpointName}", 'Capture macOS lab VM checkpoint')) {
        return
    }

    switch ($Provider) {
        'Parallels' {
            Checkpoint-MacLabVm_Parallels `
                -Name $Name `
                -CheckpointName $CheckpointName `
                -Description $Description `
                -RequireCleanShutdown:$RequireCleanShutdown `
                -Confirm:$false
        }
        'UTM' {
            Checkpoint-MacLabVm_UTM -Name $Name -CheckpointName $CheckpointName -Confirm:$false
        }
        'Tart' {
            Checkpoint-MacLabVm_Tart -Name $Name -CheckpointName $CheckpointName -Confirm:$false
        }
    }
}
