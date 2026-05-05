# .SYNOPSIS
# Runs the macOSLab T-15 readiness gate.
#
# .DESCRIPTION
# Checks host runtime facts, local module import, optional provider tools, optional
# prepared media, and placeholder checkpoint readiness without requiring real
# provider or cloud access in default tests. Live users run the script without
# HostFact; tests can pass HostFact to provide deterministic host facts.
#
# .PARAMETER Provider
# Provider path to check.
#
# .PARAMETER MediaPath
# Optional prepared media path to verify.
#
# .PARAMETER MediaSha256
# Optional expected SHA-256 for MediaPath.
#
# .PARAMETER RequiredCheckpoint
# Checkpoint names expected for rehearsal.
#
# .PARAMETER OutputPath
# Optional JSON output path for readiness evidence.
#
# .PARAMETER HostFact
# Optional test fixture host facts. Supported keys are IsMacOS, Architecture,
# PowerShellVersion, and CommandPath.
#
# .PARAMETER SkipProviderCheck
# Skips provider executable checks.
#
# .PARAMETER SkipMediaCheck
# Skips prepared media existence and checksum checks.
#
# .PARAMETER SkipCheckpointCheck
# Skips checkpoint readiness checks.
#
# .EXAMPLE
# ./scripts/Test-LabReadiness.ps1 -Provider Parallels
# # Runs the local readiness gate for the default Parallels path.
#
# .INPUTS
# None.
#
# .OUTPUTS
# [pscustomobject]. Readiness summary with per-check detail.
#
# .NOTES
# Version: 0.1.20260505.0
# Positional parameters are not supported.
#
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low', PositionalBinding = $false)]
[OutputType([pscustomobject])]
param(
    [ValidateSet('Parallels', 'UTM', 'Tart')]
    [string]$Provider = 'Parallels',

    [string]$MediaPath = '~/Demo/Installers/UniversalMac_26.4.1_25E253_Restore.ipsw',

    [string]$MediaSha256 = '8aa7f7aea6b20d1839d85a0017c9a1472f26c63ad496919f85db988eb01a5c32',

    [string[]]$RequiredCheckpoint = @(
        'Clean-OS',
        'Pre-Enroll',
        'Post-Enroll-Baseline',
        'Broken-Policy-State',
        'Recovered-Known-Good'
    ),

    [string]$OutputPath,

    [hashtable]$HostFact,

    [switch]$SkipProviderCheck,

    [switch]$SkipMediaCheck,

    [switch]$SkipCheckpointCheck
)

Set-StrictMode -Version Latest

$ErrorActionPreference = 'Stop'
$strScriptRoot = $PSScriptRoot
$strRepositoryRoot = Split-Path -Path $strScriptRoot -Parent
$strModuleManifestPath = Join-Path -Path $strRepositoryRoot -ChildPath 'src/Modules/MacLab/MacLab.psd1'
$arrCheck = @()

Import-Module -Name $strModuleManifestPath -Force

$boolIsMacOS = $IsMacOS
$strArchitecture = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture.ToString()
$versionPowerShell = $PSVersionTable.PSVersion
$hashtableCommandPath = @{}

if ($HostFact) {
    if ($HostFact.ContainsKey('IsMacOS')) {
        $boolIsMacOS = [bool]$HostFact['IsMacOS']
    }

    if ($HostFact.ContainsKey('Architecture')) {
        $strArchitecture = [string]$HostFact['Architecture']
    }

    if ($HostFact.ContainsKey('PowerShellVersion')) {
        $versionPowerShell = [version]$HostFact['PowerShellVersion']
    }

    if ($HostFact.ContainsKey('CommandPath')) {
        $hashtableCommandPath = [hashtable]$HostFact['CommandPath']
    }
}

$arrCheck += [pscustomobject]@{
    Name = 'PowerShell 7.4 or newer'
    Category = 'Host'
    Required = $true
    Result = if ($versionPowerShell -ge [version]'7.4') { 'Pass' } else { 'Fail' }
    Detail = "PowerShell $versionPowerShell"
    Remediation = 'Install PowerShell 7.4 or newer.'
}

$arrCheck += [pscustomobject]@{
    Name = 'macOS host'
    Category = 'Host'
    Required = $true
    Result = if ($boolIsMacOS) { 'Pass' } else { 'Fail' }
    Detail = if ($boolIsMacOS) { 'Running on macOS.' } else { 'This host is not macOS.' }
    Remediation = 'Run macOSLab on an Apple-silicon Mac.'
}

$arrCheck += [pscustomobject]@{
    Name = 'Apple silicon architecture'
    Category = 'Host'
    Required = $true
    Result = if ($strArchitecture -eq 'Arm64' -or $strArchitecture -eq 'arm64') { 'Pass' } else { 'Fail' }
    Detail = "Detected architecture: $strArchitecture"
    Remediation = 'Use an Apple-silicon Mac. Intel Mac hosts are out of scope.'
}

$arrCheck += [pscustomobject]@{
    Name = 'MacLab module import'
    Category = 'Module'
    Required = $true
    Result = 'Pass'
    Detail = "Imported module manifest: $strModuleManifestPath"
    Remediation = ''
}

if ($SkipProviderCheck) {
    $arrCheck += [pscustomobject]@{
        Name = "${Provider} provider tools"
        Category = 'Provider'
        Required = $true
        Result = 'Skipped'
        Detail = 'Provider checks skipped by caller.'
        Remediation = 'Run without -SkipProviderCheck before live rehearsal.'
    }
} else {
    $arrProviderCommand = switch ($Provider) {
        'Parallels' { @('prlctl', 'prlsrvctl') }
        'UTM' { @('/Applications/UTM.app/Contents/MacOS/utmctl') }
        'Tart' { @('tart') }
    }

    foreach ($strCommandName in $arrProviderCommand) {
        $boolCommandAvailable = $false
        $strCommandDetail = ''

        if ($hashtableCommandPath.ContainsKey($strCommandName)) {
            $boolCommandAvailable = [bool]$hashtableCommandPath[$strCommandName]
            $strCommandDetail = "Fixture availability for ${strCommandName}: $boolCommandAvailable"
        } elseif (Test-Path -LiteralPath $strCommandName -PathType Leaf) {
            $boolCommandAvailable = $true
            $strCommandDetail = "Found provider executable at $strCommandName"
        } else {
            $objCommand = Get-Command -Name $strCommandName -ErrorAction SilentlyContinue
            $boolCommandAvailable = $null -ne $objCommand
            $strCommandDetail = if ($objCommand) { "Found provider executable at $($objCommand.Source)" } else { "Provider executable not found: $strCommandName" }
        }

        $arrCheck += [pscustomobject]@{
            Name = "${Provider} command ${strCommandName}"
            Category = 'Provider'
            Required = $Provider -ne 'Tart'
            Result = if ($boolCommandAvailable) { 'Pass' } elseif ($Provider -eq 'Tart') { 'Warn' } else { 'Fail' }
            Detail = $strCommandDetail
            Remediation = if ($Provider -eq 'Tart') { 'Tart is a v1 stub unless later approved.' } else { "Install or expose ${strCommandName} before live rehearsal." }
        }
    }
}

if ($SkipMediaCheck) {
    $arrCheck += [pscustomobject]@{
        Name = 'Prepared media'
        Category = 'Media'
        Required = $true
        Result = 'Skipped'
        Detail = 'Media checks skipped by caller.'
        Remediation = 'Run without -SkipMediaCheck before live rehearsal.'
    }
} else {
    $strExpandedMediaPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($MediaPath)
    $boolMediaExists = Test-Path -LiteralPath $strExpandedMediaPath -PathType Leaf
    $strMediaResult = 'Fail'
    $strMediaDetail = "Prepared media not found at $strExpandedMediaPath"

    if ($boolMediaExists) {
        $strActualHash = (Get-FileHash -LiteralPath $strExpandedMediaPath -Algorithm SHA256).Hash.ToLowerInvariant()
        if ($strActualHash -eq $MediaSha256.ToLowerInvariant()) {
            $strMediaResult = 'Pass'
            $strMediaDetail = "Prepared media exists and SHA-256 matches at $strExpandedMediaPath"
        } else {
            $strMediaDetail = "Prepared media SHA-256 mismatch at $strExpandedMediaPath"
        }
    }

    $arrCheck += [pscustomobject]@{
        Name = 'Prepared media'
        Category = 'Media'
        Required = $true
        Result = $strMediaResult
        Detail = $strMediaDetail
        Remediation = 'Verify the prepared IPSW path and checksum before VM creation.'
    }
}

if ($SkipCheckpointCheck) {
    $arrCheck += [pscustomobject]@{
        Name = 'Required checkpoints'
        Category = 'Checkpoint'
        Required = $true
        Result = 'Skipped'
        Detail = 'Checkpoint checks skipped by caller.'
        Remediation = 'Run provider-backed checkpoint checks before live rehearsal.'
    }
} else {
    $arrCheck += [pscustomobject]@{
        Name = 'Required checkpoints'
        Category = 'Checkpoint'
        Required = $true
        Result = 'Warn'
        Detail = "Checkpoint enumeration is provider-backed and starts in later phases. Expected checkpoints: $($RequiredCheckpoint -join ', ')"
        Remediation = 'Verify canonical checkpoints after provider implementation.'
    }
}

$arrRequiredCheck = @($arrCheck | Where-Object { $_.Required })
$arrFailedRequiredCheck = @($arrRequiredCheck | Where-Object { $_.Result -eq 'Fail' })
$arrWarningCheck = @($arrCheck | Where-Object { $_.Result -eq 'Warn' })
$strOverall = if ($arrFailedRequiredCheck.Count -gt 0) {
    'Fail'
} elseif ($arrWarningCheck.Count -gt 0) {
    'Warn'
} else {
    'Pass'
}

$objReadiness = [pscustomobject]@{
    GeneratedAt = (Get-Date).ToUniversalTime().ToString('o')
    Provider = $Provider
    Overall = $strOverall
    Checks = $arrCheck
}

if ($OutputPath) {
    $strOutputPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputPath)
    $strOutputDirectory = Split-Path -Path $strOutputPath -Parent

    if ($strOutputDirectory -and -not (Test-Path -LiteralPath $strOutputDirectory -PathType Container)) {
        [void][System.IO.Directory]::CreateDirectory($strOutputDirectory)
    }

    if ($PSCmdlet.ShouldProcess($strOutputPath, 'Write readiness JSON')) {
        $strJson = $objReadiness | ConvertTo-Json -Depth 8
        [System.IO.File]::WriteAllText($strOutputPath, $strJson, [System.Text.UTF8Encoding]::new($false))
    }
}

$objReadiness
