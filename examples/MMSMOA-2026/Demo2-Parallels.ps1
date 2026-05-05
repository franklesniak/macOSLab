#requires -Version 7.4

# .SYNOPSIS
# Runs the MMSMOA Parallels demo setup path.
#
# .DESCRIPTION
# Verifies the prepared macOS restore image, creates a Parallels-backed lab VM,
# applies provider hardening through the module, and captures the Clean-OS
# checkpoint. The script uses the already-downloaded owner demo IPSW by default.
#
# .PARAMETER Name
# Demo VM name.
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
# ./examples/MMSMOA-2026/Demo2-Parallels.ps1 -WhatIf
# # Shows the top-level demo action without creating a VM.
#
# .INPUTS
# None.
#
# .OUTPUTS
# [pscustomobject]. Demo setup summary.
#
# .NOTES
# Version: 0.1.20260505.0
# Positional parameters are not supported.
#
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High', PositionalBinding = $false)]
[OutputType([pscustomobject])]
param(
    [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9._-]{0,62}$')]
    [string]$Name = 'macOSLab-MMSMOA-Demo2',

    [ValidateNotNullOrEmpty()]
    [string]$Version = '26.4.1',

    [ValidateNotNullOrEmpty()]
    [string]$Build = '25E253',

    [string]$CacheRoot = '~/Demo/Installers',

    [string]$PreparedArtifactPath = '~/Demo/Installers/UniversalMac_26.4.1_25E253_Restore.ipsw',

    [string]$PreparedArtifactSha256 = '8aa7f7aea6b20d1839d85a0017c9a1472f26c63ad496919f85db988eb01a5c32'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$strScriptRoot = Split-Path -Path $PSCommandPath -Parent
$strRepositoryRoot = Split-Path -Path (Split-Path -Path $strScriptRoot -Parent) -Parent
$strModuleManifestPath = Join-Path -Path $strRepositoryRoot -ChildPath 'src/Modules/MacLab/MacLab.psd1'

Import-Module -Name $strModuleManifestPath -Force

if (-not $PSCmdlet.ShouldProcess($Name, 'Run MMSMOA Parallels demo path')) {
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

$objVm = New-MacLabVm `
    -Provider Parallels `
    -Name $Name `
    -MediaId $objMedia.MediaId `
    -CacheRoot $CacheRoot `
    -Confirm:$false

$objCheckpoint = Checkpoint-MacLabVm `
    -Provider Parallels `
    -Name $Name `
    -CheckpointName 'Clean-OS' `
    -Description 'MMSMOA Demo 2 clean isolated Parallels baseline.' `
    -RequireCleanShutdown `
    -Confirm:$false

[pscustomobject]@{
    Demo = 'MMSMOA-2026-Demo2-Parallels'
    Vm = $objVm
    Checkpoint = $objCheckpoint
    Media = $objMedia
}
