function Get-MacLabVm {
    # .SYNOPSIS
    # Lists or describes macOS lab VMs.
    #
    # .DESCRIPTION
    # Phase 2 scaffold for provider-backed VM inventory. The implemented command
    # will query installed providers and return structured VM records.
    #
    # .PARAMETER Provider
    # Optional hypervisor provider filter.
    #
    # .PARAMETER Name
    # Optional VM name filter.
    #
    # .EXAMPLE
    # Get-MacLabVm -Provider Parallels
    # # Lists Parallels lab VMs after provider implementation lands.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. VM inventory records after provider implementation.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Positional parameters are not supported.
    #
    [CmdletBinding(PositionalBinding = $false)]
    [OutputType([pscustomobject])]
    param(
        [ValidateSet('Parallels', 'UTM', 'Tart')]
        [string]$Provider,

        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9._-]{0,62}$')]
        [string]$Name
    )

    $null = $Provider
    $null = $Name

    throw [System.NotImplementedException]::new(
        'Get-MacLabVm is a Phase 2 scaffold stub. Provider inventory starts in later phases.'
    )
}
