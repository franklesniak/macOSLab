function New-MacLabVm {
    # .SYNOPSIS
    # Creates or registers a macOS lab VM.
    #
    # .DESCRIPTION
    # Phase 2 scaffold for provider-backed VM creation. The implemented command
    # will dispatch to Parallels, UTM, or Tart according to provider capability.
    #
    # .PARAMETER Provider
    # Hypervisor provider.
    #
    # .PARAMETER Name
    # Cross-provider-safe VM name.
    #
    # .PARAMETER MediaId
    # Media identifier produced by Get-MacLabMedia.
    #
    # .PARAMETER CacheRoot
    # Media metadata cache root.
    #
    # .PARAMETER SizingProfile
    # Named sizing profile.
    #
    # .PARAMETER VmRoot
    # Optional VM storage root.
    #
    # .PARAMETER RedactSecrets
    # Preserves the module-wide evidence posture. Defaults to true.
    #
    # .EXAMPLE
    # New-MacLabVm -Provider Parallels -Name 'demo-01' -MediaId '26.4.1-25E253'
    # # Creates the VM after provider implementation lands.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. VM creation result after provider implementation.
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
        [string]$MediaId,

        [string]$CacheRoot,

        [ValidateSet('Baseline', 'Performance')]
        [string]$SizingProfile = 'Baseline',

        [string]$VmRoot,

        [bool]$RedactSecrets = $true
    )

    $null = $RedactSecrets

    if (-not $PSCmdlet.ShouldProcess($Name, 'Create or register macOS lab VM')) {
        return
    }

    if ($Provider -ne 'Parallels') {
        throw [System.NotImplementedException]::new(
            "Provider '${Provider}' VM creation is implemented in a later phase."
        )
    }

    $strCacheRoot = if ($CacheRoot) {
        $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($CacheRoot)
    } else {
        $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath('~/Demo/Installers')
    }
    $strMetadataPath = Join-Path -Path $strCacheRoot -ChildPath "${MediaId}.metadata.json"

    if (-not (Test-Path -LiteralPath $strMetadataPath -PathType Leaf)) {
        throw "Media metadata was not found for '${MediaId}': ${strMetadataPath}"
    }

    $objMediaMetadata = Get-Content -LiteralPath $strMetadataPath -Raw | ConvertFrom-Json

    New-MacLabVm_Parallels `
        -Name $Name `
        -MediaMetadata $objMediaMetadata `
        -SizingProfile $SizingProfile `
        -VmRoot $VmRoot `
        -Confirm:$false
}
