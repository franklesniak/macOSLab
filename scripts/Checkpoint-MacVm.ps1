#requires -Version 7.4

# .SYNOPSIS
# Captures a macOS lab VM checkpoint.
#
# .DESCRIPTION
# Thin script wrapper around Checkpoint-MacLabVm for stage-friendly use.
#
# .PARAMETER Provider
# Hypervisor provider.
#
# .PARAMETER Name
# VM name.
#
# .PARAMETER CheckpointName
# Checkpoint name.
#
# .EXAMPLE
# ./scripts/Checkpoint-MacVm.ps1 -Provider Parallels -Name demo-01 -CheckpointName Clean-OS
# # Captures the checkpoint.
#
# .INPUTS
# None.
#
# .OUTPUTS
# [pscustomobject]. Checkpoint result.
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
    [string]$CheckpointName
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$strRepositoryRoot = Split-Path -Path (Split-Path -Path $PSCommandPath -Parent) -Parent
$strModuleManifestPath = Join-Path -Path $strRepositoryRoot -ChildPath 'src/Modules/MacLab/MacLab.psd1'
Import-Module -Name $strModuleManifestPath -Force

if (-not $PSCmdlet.ShouldProcess("${Name}:${CheckpointName}", 'Capture macOS lab VM checkpoint')) {
    return
}

Checkpoint-MacLabVm -Provider $Provider -Name $Name -CheckpointName $CheckpointName -RequireCleanShutdown -Confirm:$false
