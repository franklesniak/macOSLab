function Remove-MacLabVm {
    # .SYNOPSIS
    # Removes a macOS lab VM.
    #
    # .DESCRIPTION
    # Phase 2 scaffold for provider-backed VM removal.
    #
    # .PARAMETER Provider
    # Hypervisor provider.
    #
    # .PARAMETER Name
    # VM name.
    #
    # .PARAMETER RemoveDiskFiles
    # Removes local disk files when implemented.
    #
    # .PARAMETER Force
    # Suppresses extra prompts when implemented and safe.
    #
    # .EXAMPLE
    # Remove-MacLabVm -Provider Parallels -Name 'demo-01'
    # # Removes the VM after provider implementation lands.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. Removal result after provider implementation.
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

        [switch]$RemoveDiskFiles,

        [switch]$Force
    )

    if (-not $PSCmdlet.ShouldProcess($Name, 'Remove macOS lab VM')) {
        return
    }

    switch ($Provider) {
        'Parallels' {
            Remove-MacLabVm_Parallels `
                -Name $Name `
                -RemoveDiskFiles:$RemoveDiskFiles `
                -Force:$Force `
                -Confirm:$false
        }
        'UTM' {
            Remove-MacLabVm_UTM `
                -Name $Name `
                -RemoveDiskFiles:$RemoveDiskFiles `
                -Force:$Force `
                -Confirm:$false
        }
        'Tart' {
            Remove-MacLabVm_Tart -Name $Name -Confirm:$false
        }
    }
}
