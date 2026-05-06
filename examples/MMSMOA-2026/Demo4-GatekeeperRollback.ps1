#requires -Version 7.4

# .SYNOPSIS
# Runs the MMSMOA fixture-backed Gatekeeper rollback demo step.
#
# .DESCRIPTION
# Runs the Gatekeeper App-Store-only validation plan, emits redacted evidence,
# and keeps Graph and live-cloud calls out of default local validation.
#
# .PARAMETER Provider
# Hypervisor provider represented by the evidence.
#
# .PARAMETER Name
# VM name represented by the evidence.
#
# .PARAMETER TestPlan
# Validation plan path.
#
# .PARAMETER OutputPath
# Evidence output root.
#
# .PARAMETER GraphScope
# Microsoft Graph scopes declared for the fixture plan.
#
# .EXAMPLE
# ./examples/MMSMOA-2026/Demo4-GatekeeperRollback.ps1 -Name demo-01
# # Runs fixture-backed Gatekeeper validation and writes redacted evidence.
#
# .INPUTS
# None.
#
# .OUTPUTS
# [pscustomobject]. Redacted evidence.
#
# .NOTES
# Version: 0.1.20260506.0
# Positional parameters are not supported.
#
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium', PositionalBinding = $false)]
[OutputType([pscustomobject])]
param(
    [ValidateSet('Parallels', 'UTM', 'Tart')]
    [string]$Provider = 'Parallels',

    [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9._-]{0,62}$')]
    [string]$Name = 'mms-parallels-01',

    [string]$TestPlan,

    [string]$OutputPath = './_evidence',

    [string[]]$GraphScope = @()
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$strScriptRoot = Split-Path -Path $PSCommandPath -Parent
$strRepositoryRoot = Split-Path -Path (Split-Path -Path $strScriptRoot -Parent) -Parent
$strModuleManifestPath = Join-Path -Path $strRepositoryRoot -ChildPath 'src/Modules/MacLab/MacLab.psd1'
$strDefaultTestPlan = Join-Path -Path $strRepositoryRoot -ChildPath 'examples/TestCases/Gatekeeper-AppStoreOnly.yml'
$strResolvedTestPlan = if ($TestPlan) { $TestPlan } else { $strDefaultTestPlan }

Import-Module -Name $strModuleManifestPath -Force

if (-not $PSCmdlet.ShouldProcess($Name, 'Run MMSMOA Gatekeeper rollback demo step')) {
    return
}

Invoke-MacPolicyValidation `
    -Provider $Provider `
    -Name $Name `
    -TestPlan $strResolvedTestPlan `
    -OutputPath $OutputPath `
    -GraphScope $GraphScope `
    -Confirm:$false
