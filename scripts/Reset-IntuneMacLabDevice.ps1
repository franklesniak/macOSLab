# .SYNOPSIS
# Reports possible stale cloud records for a macOSLab VM.
#
# .DESCRIPTION
# Produces a report-only cleanup plan for Intune, Entra, and Defender records
# that may no longer match a restored or deleted local VM. V1 never retires,
# wipes, soft-deletes, hard-deletes, or otherwise mutates cloud objects.
#
# .PARAMETER VmName
# Lab VM name used in local provider and evidence records.
#
# .PARAMETER IntuneDeviceName
# Optional lab-only Intune device name. Defaults to VmName.
#
# .PARAMETER TenantSuffixOnly
# Optional tenant suffix for human review. Use only a suffix or placeholder,
# not a full tenant ID or secret-bearing value.
#
# .PARAMETER OutputPath
# Optional JSON report output path.
#
# .PARAMETER IncludeGraphCommandExamples
# Includes non-mutating Graph command examples for manual operator review.
#
# .EXAMPLE
# ./scripts/Reset-IntuneMacLabDevice.ps1 -VmName 'MMS-MACLAB-001'
# # Produces a report-only cleanup plan for the lab VM.
#
# .INPUTS
# None.
#
# .OUTPUTS
# [pscustomobject]. Report-only cleanup plan.
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
    [string]$VmName,

    [string]$IntuneDeviceName,

    [string]$TenantSuffixOnly = '.onmicrosoft.example',

    [string]$OutputPath,

    [switch]$IncludeGraphCommandExamples
)

Set-StrictMode -Version Latest

$strScriptRoot = Split-Path -Path $MyInvocation.MyCommand.Path -Parent
$strRepositoryRoot = Split-Path -Path $strScriptRoot -Parent
$strModuleManifestPath = Join-Path -Path $strRepositoryRoot -ChildPath 'src/Modules/MacLab/MacLab.psd1'
Import-Module -Name $strModuleManifestPath -Force

$strCloudStateWarning = 'VM rollback does not rewind Intune, Entra, Defender portal state, audit logs, or reporting history.'
$strEffectiveIntuneDeviceName = if ($IntuneDeviceName) { $IntuneDeviceName } else { $VmName }
$arrGraphCommandExample = @()

if ($IncludeGraphCommandExamples) {
    $arrGraphCommandExample = @(
        "Get-MgDeviceManagementManagedDevice -Filter ""deviceName eq '${strEffectiveIntuneDeviceName}'""",
        "Get-MgDevice -Filter ""displayName eq '${strEffectiveIntuneDeviceName}'"""
    )
}

$arrCandidate = @(
    [pscustomobject]@{
        plane = 'Intune'
        candidateKind = 'managedDevice'
        matchHint = 'deviceName'
        portalPath = 'Intune admin center > Devices > All devices'
        whyItMayBeStale = 'The VM checkpoint may have been restored after the cloud device record advanced.'
        mutationSupportedInV1 = $false
        manualAction = 'Review the lab-only device record, then retire or delete manually only after confirming scope.'
    },
    [pscustomobject]@{
        plane = 'Entra'
        candidateKind = 'device'
        matchHint = 'displayName'
        portalPath = 'Microsoft Entra admin center > Devices > All devices'
        whyItMayBeStale = 'Device registration state may not match the restored local VM identity.'
        mutationSupportedInV1 = $false
        manualAction = 'Review the lab-only Entra device object before any manual cleanup.'
    },
    [pscustomobject]@{
        plane = 'Defender'
        candidateKind = 'machine'
        matchHint = 'deviceName'
        portalPath = 'Microsoft Defender portal > Assets > Devices'
        whyItMayBeStale = 'Defender machine timeline and reporting history continue after local VM rollback.'
        mutationSupportedInV1 = $false
        manualAction = 'Review the lab-only Defender device record and portal timeline before cleanup.'
    }
)

$objReport = [pscustomobject]@{
    schemaVersion = '1.0.0'
    mode = 'ReportOnly'
    createdAt = (Get-Date).ToUniversalTime().ToString('o')
    vmName = $VmName
    intuneDeviceName = $strEffectiveIntuneDeviceName
    tenantSuffixOnly = $TenantSuffixOnly
    mutationAllowed = $false
    cloudStateWarning = $strCloudStateWarning
    candidates = $arrCandidate
    graphCommandExamples = $arrGraphCommandExample
    nextStep = 'Manually verify candidates in the portal before any cloud-side cleanup. V1 does not mutate cloud records.'
}

if ($OutputPath) {
    $strOutputPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputPath)
    $strOutputDirectory = Split-Path -Path $strOutputPath -Parent
    if ($strOutputDirectory) {
        [void][System.IO.Directory]::CreateDirectory($strOutputDirectory)
    }

    if ($PSCmdlet.ShouldProcess($strOutputPath, 'Write report-only cloud cleanup plan')) {
        $utf8NoBomEncoding = [System.Text.UTF8Encoding]::new($false)
        $strJson = $objReport | ConvertTo-Json -Depth 10
        [System.IO.File]::WriteAllText($strOutputPath, $strJson, $utf8NoBomEncoding)
    }
}

$objReport
