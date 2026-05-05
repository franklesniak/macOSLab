#requires -Version 7.4

# .SYNOPSIS
# Runs the MMSMOA UTM provider-swap demo checks.
#
# .DESCRIPTION
# Verifies the prepared media metadata and reports the UTM manual provider-swap
# path. UTM v1 intentionally automates only list, status, start, and stop after
# the VM is manually created from examples/utm/macos-lab-template.utm.json.
#
# .PARAMETER Name
# UTM VM name.
#
# .PARAMETER Version
# macOS version.
#
# .PARAMETER Build
# macOS build.
#
# .PARAMETER CacheRoot
# Media metadata cache root.
#
# .PARAMETER PreparedArtifactPath
# Existing IPSW path.
#
# .PARAMETER PreparedArtifactSha256
# Expected IPSW SHA-256.
#
# .EXAMPLE
# ./examples/MMSMOA-2026/Demo3-UTM.ps1 -WhatIf
# # Shows the top-level UTM demo action without starting or stopping a VM.
#
# .INPUTS
# None.
#
# .OUTPUTS
# [pscustomobject]. UTM provider-swap demo summary.
#
# .NOTES
# Version: 0.1.20260505.0
# Positional parameters are not supported.
#
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium', PositionalBinding = $false)]
[OutputType([pscustomobject])]
param(
    [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9._-]{0,62}$')]
    [string]$Name = 'macOSLab-UTM-Disposable',

    [ValidateNotNullOrEmpty()]
    [string]$Version = '26.4.1',

    [ValidateNotNullOrEmpty()]
    [string]$Build = '25E253',

    [string]$CacheRoot = '~/Demo/Installers',

    [string]$PreparedArtifactPath = '~/Demo/Installers/UniversalMac_26.4.1_25E253_Restore.ipsw',

    [string]$PreparedArtifactSha256 = '8aa7f7aea6b20d1839d85a0017c9a1472f26c63ad496919f85db988eb01a5c32'
)

$ErrorActionPreference = 'Stop'

$strScriptRoot = Split-Path -Path $PSCommandPath -Parent
$strRepositoryRoot = Split-Path -Path (Split-Path -Path $strScriptRoot -Parent) -Parent
$strModuleManifestPath = Join-Path -Path $strRepositoryRoot -ChildPath 'src/Modules/MacLab/MacLab.psd1'
$strTemplatePath = Join-Path -Path $strRepositoryRoot -ChildPath 'examples/utm/macos-lab-template.utm.json'

Import-Module -Name $strModuleManifestPath -Force

if (-not $PSCmdlet.ShouldProcess($Name, 'Run MMSMOA UTM provider-swap demo checks')) {
    return
}

$objMedia = Get-MacLabMedia `
    -Version $Version `
    -Build $Build `
    -ArtifactType Firmware `
    -CacheRoot $CacheRoot `
    -PreparedArtifactPath $PreparedArtifactPath `
    -PreparedArtifactSha256 $PreparedArtifactSha256 `
    -Confirm:$false

$objVm = Get-MacLabVm -Provider UTM -Name $Name

[pscustomobject]@{
    Demo = 'MMSMOA-2026-Demo3-UTM'
    Vm = $objVm
    Media = $objMedia
    TemplatePath = $strTemplatePath
    ManualStepRequired = @(
        'Create the UTM macOS VM manually from the prepared IPSW.',
        'Confirm Apple Virtualization, shared networking, and host-sharing boundaries in UTM.',
        'Use Parallels for automated checkpoint capture/restore in v1.'
    )
}
