#requires -Version 7.4

# .SYNOPSIS
# Runs the MMSMOA Gatekeeper rollback demo step.
#
# .DESCRIPTION
# Splits Demo 4 into a stage-start checklist and fixture-backed validation
# steps. StartCloudSync emits the manual live-cloud checklist. Broken and
# Recovered run the Gatekeeper validation plans, emit redacted evidence, and
# keep Graph and live-cloud calls out of default local validation.
#
# .PARAMETER Stage
# Demo 4 stage to run. StartCloudSync emits the manual start checklist,
# Broken validates the App-Store-only failure evidence, and Recovered validates
# the post-rollback evidence.
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
# .PARAMETER GatekeeperPolicyDisplayName
# Lab-only Gatekeeper policy display name shown in the StartCloudSync checklist.
#
# .PARAMETER GraphScope
# Microsoft Graph scopes declared for the fixture plan.
#
# .EXAMPLE
# ./examples/MMSMOA-2026/Demo4-GatekeeperRollback.ps1 -Stage StartCloudSync
# # Prints the manual live Intune start checklist.
#
# .EXAMPLE
# ./examples/MMSMOA-2026/Demo4-GatekeeperRollback.ps1 -Stage Broken -Name demo-01
# # Runs fixture-backed Gatekeeper validation and writes redacted evidence.
#
# .EXAMPLE
# ./examples/MMSMOA-2026/Demo4-GatekeeperRollback.ps1 -Stage Recovered -Name demo-01
# # Runs fixture-backed post-rollback validation and writes redacted evidence.
#
# .INPUTS
# None.
#
# .OUTPUTS
# [pscustomobject]. Stage checklist or redacted evidence.
#
# .NOTES
# Version: 0.1.20260507.0
# Positional parameters are not supported.
#
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium', PositionalBinding = $false)]
[OutputType([pscustomobject])]
param(
    [ValidateSet('StartCloudSync', 'Broken', 'Recovered')]
    [string]$Stage = 'Broken',

    [ValidateSet('Parallels', 'UTM', 'Tart')]
    [string]$Provider = 'Parallels',

    [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9._-]{0,62}$')]
    [string]$Name = 'mms-parallels-01',

    [string]$TestPlan,

    [string]$OutputPath = './_evidence',

    [ValidateNotNullOrEmpty()]
    [string]$GatekeeperPolicyDisplayName = 'MacLab - Gatekeeper - App Store Only',

    [string[]]$GraphScope = @()
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$strScriptRoot = Split-Path -Path $PSCommandPath -Parent
$strRepositoryRoot = Split-Path -Path (Split-Path -Path $strScriptRoot -Parent) -Parent
$strModuleManifestPath = Join-Path -Path $strRepositoryRoot -ChildPath 'src/Modules/MacLab/MacLab.psd1'
$strDefaultBrokenTestPlan = Join-Path -Path $strRepositoryRoot -ChildPath 'examples/TestCases/Gatekeeper-AppStoreOnly.yml'
$strDefaultRecoveredTestPlan = Join-Path -Path $strRepositoryRoot -ChildPath 'examples/TestCases/Gatekeeper-Recovered.yml'
$strResolvedTestPlan = if ($TestPlan) {
    $TestPlan
} elseif ($Stage -eq 'Recovered') {
    $strDefaultRecoveredTestPlan
} else {
    $strDefaultBrokenTestPlan
}

Import-Module -Name $strModuleManifestPath -Force

if (-not $PSCmdlet.ShouldProcess($Name, "Run MMSMOA Gatekeeper rollback demo ${Stage} step")) {
    return
}

if ($Stage -eq 'StartCloudSync') {
    [pscustomobject]@{
        Demo = 'MMSMOA-2026-Demo4-GatekeeperRollback'
        Stage = $Stage
        VmName = $Name
        StartCheckpoint = 'Post-Enroll-Baseline'
        GatekeeperPolicyDisplayName = $GatekeeperPolicyDisplayName
        CompanyPortalAction = 'Check Status'
        BakeWindow = '10-15 minutes'
        NextScript = './examples/MMSMOA-2026/Demo3-UTM.ps1'
        ResumeScript = './examples/MMSMOA-2026/Demo4-GatekeeperRollback.ps1 -Stage Broken'
        FallbackCheckpoint = 'Broken-Policy-State'
        ManualSteps = [string[]]@(
            "Start from the prepared enrolled Demo 4 VM at Post-Enroll-Baseline.",
            "Confirm Visual Studio Code is installed but has not been launched before the break policy lands.",
            "Optionally confirm baseline acceptance with spctl --assess -vv '/Applications/Visual Studio Code.app'.",
            "Assign or sync the lab-only Gatekeeper policy '${GatekeeperPolicyDisplayName}'.",
            "In Company Portal, run Check Status.",
            "Leave the VM alone while Demo 3 runs.",
            "Resume Demo 4 once after the bake window and attempt the first Visual Studio Code launch.",
            "If the policy did not land, say so and use Broken-Policy-State."
        )
    }
    return
}

Invoke-MacPolicyValidation `
    -Provider $Provider `
    -Name $Name `
    -TestPlan $strResolvedTestPlan `
    -OutputPath $OutputPath `
    -GraphScope $GraphScope `
    -Confirm:$false
