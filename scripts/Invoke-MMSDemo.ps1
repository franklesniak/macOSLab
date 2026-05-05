#requires -Version 7.4

# .SYNOPSIS
# Runs the MMSMOA macOSLab demo orchestrator.
#
# .DESCRIPTION
# Provides a stage-friendly orchestrator for media verification and
# fixture-backed evidence generation. Live Parallels, UTM, and cloud dry-run
# actions remain owner-validation-boundary tasks.
#
# .PARAMETER Demo
# Demo segment to run.
#
# .PARAMETER VmName
# VM name represented by validation evidence.
#
# .PARAMETER EvidenceRoot
# Evidence output root.
#
# .PARAMETER PreparedArtifactPath
# Existing IPSW path.
#
# .PARAMETER PreparedArtifactSha256
# Expected IPSW SHA-256.
#
# .EXAMPLE
# ./scripts/Invoke-MMSDemo.ps1 -Demo Validation
# # Runs fixture-backed validation evidence generation.
#
# .INPUTS
# None.
#
# .OUTPUTS
# [pscustomobject]. Demo step summary records.
#
# .NOTES
# Version: 0.1.20260505.0
# Positional parameters are not supported.
#
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium', PositionalBinding = $false)]
[OutputType([pscustomobject])]
param(
    [ValidateSet('All', 'Media', 'Parallels', 'UTM', 'Validation')]
    [string]$Demo = 'All',

    [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9._-]{0,62}$')]
    [string]$VmName = 'mms-parallels-01',

    [string]$EvidenceRoot = './_evidence',

    [string]$PreparedArtifactPath = '~/Demo/Installers/UniversalMac_26.4.1_25E253_Restore.ipsw',

    [string]$PreparedArtifactSha256 = '8aa7f7aea6b20d1839d85a0017c9a1472f26c63ad496919f85db988eb01a5c32'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$strScriptRoot = Split-Path -Path $PSCommandPath -Parent
$strRepositoryRoot = Split-Path -Path $strScriptRoot -Parent
$strDemoRoot = Join-Path -Path $strRepositoryRoot -ChildPath 'examples/MMSMOA-2026'
$strDemo1Path = Join-Path -Path $strDemoRoot -ChildPath 'Demo1-Media.ps1'
$strDemo4Path = Join-Path -Path $strDemoRoot -ChildPath 'Demo4-IntuneValidation.ps1'

if (-not $PSCmdlet.ShouldProcess($Demo, 'Run MMSMOA demo orchestrator')) {
    return
}

if ($Demo -in @('All', 'Media')) {
    $objMedia = & $strDemo1Path `
        -PreparedArtifactPath $PreparedArtifactPath `
        -PreparedArtifactSha256 $PreparedArtifactSha256
    [pscustomobject]@{
        Demo = 'Media'
        Status = 'Complete'
        Result = $objMedia
    }
}

if ($Demo -in @('All', 'Parallels')) {
    [pscustomobject]@{
        Demo = 'Parallels'
        Status = 'OwnerValidationBoundary'
        Result = 'Run examples/MMSMOA-2026/Demo2-Parallels.ps1 during the owner live dry run.'
    }
}

if ($Demo -in @('All', 'UTM')) {
    [pscustomobject]@{
        Demo = 'UTM'
        Status = 'ManualProviderSwap'
        Result = 'Use examples/MMSMOA-2026/Demo3-UTM.ps1 after manually creating the documented UTM VM.'
    }
}

if ($Demo -in @('All', 'Validation')) {
    $objEvidence = & $strDemo4Path -Name $VmName -OutputPath $EvidenceRoot
    [pscustomobject]@{
        Demo = 'Validation'
        Status = 'Complete'
        Result = $objEvidence
    }
}
