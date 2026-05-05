function Stop-MacLabVm {
    # .SYNOPSIS
    # Stops a macOS lab VM.
    #
    # .DESCRIPTION
    # Phase 2 scaffold for provider-backed VM stop behavior.
    #
    # .PARAMETER Provider
    # Hypervisor provider.
    #
    # .PARAMETER Name
    # VM name.
    #
    # .PARAMETER Force
    # Requests a forced power-off when implemented.
    #
    # .EXAMPLE
    # Stop-MacLabVm -Provider Parallels -Name 'demo-01'
    # # Stops the VM after provider implementation lands.
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
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium', PositionalBinding = $false)]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet('Parallels', 'UTM', 'Tart')]
        [string]$Provider,

        [Parameter(Mandatory = $true)]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9._-]{0,62}$')]
        [string]$Name,

        [switch]$Force
    )

    $null = $Provider
    $null = $Force

    if (-not $PSCmdlet.ShouldProcess($Name, 'Stop macOS lab VM')) {
        return
    }

    throw [System.NotImplementedException]::new(
        'Stop-MacLabVm is a Phase 2 scaffold stub. Provider lifecycle starts in later phases.'
    )
}
