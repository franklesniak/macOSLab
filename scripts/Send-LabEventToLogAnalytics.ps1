# .SYNOPSIS
# Prepares a disabled-by-default Log Analytics event envelope.
#
# .DESCRIPTION
# Creates a local event envelope that documents the future Log Analytics
# ingestion shape. V1 does not send events to Azure Monitor. Passing
# EnableNetworkSend fails clearly so the optional Phase 10 boundary remains
# explicit and no default workflow requires cloud credentials.
#
# .PARAMETER RunId
# Optional evidence run identifier.
#
# .PARAMETER EventType
# Event type label for the local envelope.
#
# .PARAMETER EvidencePath
# Optional path to a local redacted evidence bundle or evidence JSON file.
#
# .PARAMETER OutputPath
# Optional JSON envelope output path.
#
# .PARAMETER EnableNetworkSend
# Attempts to enable network sending. This is intentionally unsupported in v1.
#
# .EXAMPLE
# ./scripts/Send-LabEventToLogAnalytics.ps1 -RunId '2026-05-mms-demo4-001'
# # Produces a local disabled-by-default event envelope.
#
# .INPUTS
# None.
#
# .OUTPUTS
# [pscustomobject]. Disabled-by-default Log Analytics event envelope.
#
# .NOTES
# Version: 0.1.20260505.0
# Positional parameters are not supported.
#
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low', PositionalBinding = $false)]
[OutputType([pscustomobject])]
param(
    [string]$RunId = 'fixture-run',

    [ValidateSet('EvidenceSummary', 'Readiness', 'DemoEvent')]
    [string]$EventType = 'EvidenceSummary',

    [string]$EvidencePath,

    [string]$OutputPath,

    [switch]$EnableNetworkSend
)

Set-StrictMode -Version Latest

$strScriptRoot = Split-Path -Path $MyInvocation.MyCommand.Path -Parent
$strRepositoryRoot = Split-Path -Path $strScriptRoot -Parent
$strModuleManifestPath = Join-Path -Path $strRepositoryRoot -ChildPath 'src/Modules/MacLab/MacLab.psd1'
Import-Module -Name $strModuleManifestPath -Force

if ($EnableNetworkSend) {
    throw 'Live Log Analytics ingestion is deferred in v1 and requires a later owner-approved Phase 10 change.'
}

$arrRequiredEnvironmentVariable = @(
    'MACLAB_LOG_ANALYTICS_DCE_ENDPOINT',
    'MACLAB_LOG_ANALYTICS_DCR_ID',
    'MACLAB_LOG_ANALYTICS_STREAM_NAME',
    'MACLAB_LOG_ANALYTICS_TENANT_ID',
    'MACLAB_LOG_ANALYTICS_CLIENT_ID'
)

$arrConfiguredEnvironmentVariableName = @(
    foreach ($strEnvironmentVariableName in $arrRequiredEnvironmentVariable) {
        if ([Environment]::GetEnvironmentVariable($strEnvironmentVariableName)) {
            $strEnvironmentVariableName
        }
    }
)

$objEnvelope = [pscustomobject]@{
    schemaVersion = '1.0.0'
    mode = 'DisabledByDefault'
    eventType = $EventType
    runId = $RunId
    createdAt = (Get-Date).ToUniversalTime().ToString('o')
    evidencePath = if ($EvidencePath) { $EvidencePath } else { $null }
    redactionRequired = $true
    networkSendAttempted = $false
    configuredEnvironmentVariableNames = $arrConfiguredEnvironmentVariableName
    requiredEnvironmentVariableNames = $arrRequiredEnvironmentVariable
    disabledReason = 'Live ingestion is deferred in v1. Export redacted evidence locally instead.'
}

if ($OutputPath) {
    $strOutputPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputPath)
    $strOutputDirectory = Split-Path -Path $strOutputPath -Parent
    if ($strOutputDirectory) {
        [void][System.IO.Directory]::CreateDirectory($strOutputDirectory)
    }

    if ($PSCmdlet.ShouldProcess($strOutputPath, 'Write disabled Log Analytics event envelope')) {
        $utf8NoBomEncoding = [System.Text.UTF8Encoding]::new($false)
        $strJson = $objEnvelope | ConvertTo-Json -Depth 10
        [System.IO.File]::WriteAllText($strOutputPath, $strJson, $utf8NoBomEncoding)
    }
}

$objEnvelope
