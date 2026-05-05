#requires -Version 7.4

# .SYNOPSIS
# Creates or registers a macOS lab VM through the MacLab module.
#
# .DESCRIPTION
# Thin script wrapper around New-MacLabVm for stage-friendly use.
#
# .PARAMETER Provider
# Hypervisor provider.
#
# .PARAMETER Name
# VM name.
#
# .PARAMETER MediaId
# Media identifier.
#
# .PARAMETER CacheRoot
# Media cache root.
#
# .EXAMPLE
# ./scripts/New-MacVm.ps1 -Provider Parallels -Name demo-01 -MediaId 26.4.1-25E253
# # Creates the provider-backed VM.
#
# .INPUTS
# None.
#
# .OUTPUTS
# [pscustomobject]. VM creation result.
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

    [string]$CacheRoot = '~/Demo/Installers'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$strRepositoryRoot = Split-Path -Path (Split-Path -Path $PSCommandPath -Parent) -Parent
$strModuleManifestPath = Join-Path -Path $strRepositoryRoot -ChildPath 'src/Modules/MacLab/MacLab.psd1'
Import-Module -Name $strModuleManifestPath -Force

if (-not $PSCmdlet.ShouldProcess($Name, 'Create or register macOS lab VM')) {
    return
}

New-MacLabVm -Provider $Provider -Name $Name -MediaId $MediaId -CacheRoot $CacheRoot -Confirm:$false
