# .SYNOPSIS
# Gets or verifies a macOS restore image for macOSLab.
#
# .DESCRIPTION
# Thin stage-friendly wrapper around Get-MacLabMedia with ArtifactType Firmware.
#
# .PARAMETER Version
# macOS marketing version.
#
# .PARAMETER Build
# Optional macOS build number.
#
# .PARAMETER CacheRoot
# Media cache root.
#
# .PARAMETER PreparedArtifactPath
# Existing restore image to verify and reuse.
#
# .PARAMETER PreparedArtifactSha256
# Expected SHA-256 for the prepared restore image.
#
# .EXAMPLE
# ./scripts/Get-MacOSRestoreImage.ps1 -Version '26.4.1' -Build '25E253' -PreparedArtifactPath '~/Demo/Installers/UniversalMac_26.4.1_25E253_Restore.ipsw' -PreparedArtifactSha256 '8aa7f7aea6b20d1839d85a0017c9a1472f26c63ad496919f85db988eb01a5c32'
# # Verifies and records the prepared restore image.
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
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$Version,

    [string]$Build,

    [string]$CacheRoot = '~/Demo/Installers',

    [string]$PreparedArtifactPath,

    [string]$PreparedArtifactSha256
)

Set-StrictMode -Version Latest

$ErrorActionPreference = 'Stop'
$strScriptRoot = $PSScriptRoot
$strRepositoryRoot = Split-Path -Path $strScriptRoot -Parent
$strModuleManifestPath = Join-Path -Path $strRepositoryRoot -ChildPath 'src/Modules/MacLab/MacLab.psd1'

Import-Module -Name $strModuleManifestPath -Force

$hashtableParameter = @{
    Version = $Version
    Build = $Build
    ArtifactType = 'Firmware'
    CacheRoot = $CacheRoot
    PreparedArtifactPath = $PreparedArtifactPath
    PreparedArtifactSha256 = $PreparedArtifactSha256
}

if ($PSCmdlet.ShouldProcess($Version, 'Get macOS restore image')) {
    Get-MacLabMedia @hashtableParameter
}
