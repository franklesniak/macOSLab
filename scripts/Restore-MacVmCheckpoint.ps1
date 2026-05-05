#requires -Version 7.4

# .SYNOPSIS
# Restores a macOS lab VM checkpoint.
#
# .DESCRIPTION
# Thin script wrapper around Restore-MacLabVmCheckpoint. The cloud-state
# warning is intentionally visible before restore.
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
# ./scripts/Restore-MacVmCheckpoint.ps1 -Provider Parallels -Name demo-01 -CheckpointName Post-Enroll-Baseline
# # Restores the checkpoint after warning about cloud-state boundaries.
#
# .INPUTS
# None.
#
# .OUTPUTS
# [pscustomobject]. Restore result.
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

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$CheckpointName
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$strRepositoryRoot = Split-Path -Path (Split-Path -Path $PSCommandPath -Parent) -Parent
$strModuleManifestPath = Join-Path -Path $strRepositoryRoot -ChildPath 'src/Modules/MacLab/MacLab.psd1'
Import-Module -Name $strModuleManifestPath -Force

Write-Warning 'VM rollback does not rewind Intune, Entra, Defender portal state, audit logs, or reporting history.'

if (-not $PSCmdlet.ShouldProcess("${Name}:${CheckpointName}", 'Restore macOS lab VM checkpoint')) {
    return
}

Restore-MacLabVmCheckpoint `
    -Provider $Provider `
    -Name $Name `
    -CheckpointName $CheckpointName `
    -AcknowledgeCloudStateWarning `
    -Confirm:$false
