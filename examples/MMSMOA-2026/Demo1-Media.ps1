#requires -Version 7.4

# .SYNOPSIS
# Runs the MMSMOA media verification demo step.
#
# .DESCRIPTION
# Verifies and reuses the prepared macOS restore image for the MMSMOA demo
# path. The default path and checksum match the owner-provided prepared IPSW,
# so this script does not start a new media download when that file is valid.
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
# ./examples/MMSMOA-2026/Demo1-Media.ps1 -WhatIf
# # Shows the media verification action.
#
# .INPUTS
# None.
#
# .OUTPUTS
# [pscustomobject]. Media metadata.
#
# .NOTES
# Version: 0.1.20260505.0
# Positional parameters are not supported.
#
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low', PositionalBinding = $false)]
[OutputType([pscustomobject])]
param(
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

if (-not $PSCmdlet.ShouldProcess($PreparedArtifactPath, 'Verify prepared MMSMOA macOS media')) {
    return
}

Get-MacLabMedia `
    -Version $Version `
    -Build $Build `
    -ArtifactType Firmware `
    -CacheRoot $CacheRoot `
    -PreparedArtifactPath $PreparedArtifactPath `
    -PreparedArtifactSha256 $PreparedArtifactSha256 `
    -Confirm:$false
