function Start-MacLabVm {
    # .SYNOPSIS
    # Starts a macOS lab VM.
    #
    # .DESCRIPTION
    # Phase 2 scaffold for provider-backed VM start behavior.
    #
    # .PARAMETER Provider
    # Hypervisor provider.
    #
    # .PARAMETER Name
    # VM name.
    #
    # .PARAMETER WaitForReady
    # Waits for readiness signals after start when implemented.
    #
    # .EXAMPLE
    # Start-MacLabVm -Provider Parallels -Name 'demo-01'
    # # Starts the VM after provider implementation lands.
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
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low', PositionalBinding = $false)]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet('Parallels', 'UTM', 'Tart')]
        [string]$Provider,

        [Parameter(Mandatory = $true)]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9._-]{0,62}$')]
        [string]$Name,

        [switch]$WaitForReady
    )

    $null = $Provider
    $null = $WaitForReady

    if (-not $PSCmdlet.ShouldProcess($Name, 'Start macOS lab VM')) {
        return
    }

    throw [System.NotImplementedException]::new(
        'Start-MacLabVm is a Phase 2 scaffold stub. Provider lifecycle starts in later phases.'
    )
}
