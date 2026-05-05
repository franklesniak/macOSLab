#requires -Version 7.4

# .SYNOPSIS
# Removes a macOS lab VM locally.
#
# .DESCRIPTION
# Thin script wrapper around Remove-MacLabVm. Local removal does not remove
# Intune, Entra, or Defender records.
#
# .PARAMETER Provider
# Hypervisor provider.
#
# .PARAMETER Name
# VM name.
#
# .PARAMETER RemoveDiskFiles
# Requests local disk-file removal where the provider supports it.
#
# .PARAMETER Force
# Suppresses extra provider prompts where supported.
#
# .EXAMPLE
# ./scripts/Remove-MacVm.ps1 -Provider Parallels -Name demo-01
# # Removes the local VM after warning about cloud cleanup.
#
# .INPUTS
# None.
#
# .OUTPUTS
# [pscustomobject]. Removal result.
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

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$strRepositoryRoot = Split-Path -Path (Split-Path -Path $PSCommandPath -Parent) -Parent
$strModuleManifestPath = Join-Path -Path $strRepositoryRoot -ChildPath 'src/Modules/MacLab/MacLab.psd1'
Import-Module -Name $strModuleManifestPath -Force

Write-Warning 'Local VM removal does not delete Intune, Entra, Defender portal, audit, or reporting records.'

if (-not $PSCmdlet.ShouldProcess($Name, 'Remove local macOS lab VM')) {
    return
}

Remove-MacLabVm `
    -Provider $Provider `
    -Name $Name `
    -RemoveDiskFiles:$RemoveDiskFiles `
    -Force:$Force `
    -Confirm:$false
