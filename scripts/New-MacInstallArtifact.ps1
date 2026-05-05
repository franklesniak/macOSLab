# .SYNOPSIS
# Gets or verifies a macOS installer artifact for macOSLab.
#
# .DESCRIPTION
# Thin stage-friendly wrapper around Get-MacLabMedia with ArtifactType Installer.
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
# Existing installer artifact to verify and reuse.
#
# .PARAMETER PreparedArtifactSha256
# Expected SHA-256 for the prepared artifact.
#
# .EXAMPLE
# ./scripts/New-MacInstallArtifact.ps1 -Version '26.4.1' -Build '25E253'
# # Discovers or records an installer artifact.
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
    ArtifactType = 'Installer'
    CacheRoot = $CacheRoot
    PreparedArtifactPath = $PreparedArtifactPath
    PreparedArtifactSha256 = $PreparedArtifactSha256
}

if ($PSCmdlet.ShouldProcess($Version, 'Get macOS installer artifact')) {
    Get-MacLabMedia @hashtableParameter
}
