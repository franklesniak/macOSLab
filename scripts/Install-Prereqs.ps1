# .SYNOPSIS
# Reports macOSLab host prerequisites.
#
# .DESCRIPTION
# Produces a prerequisite checklist without running risky installer commands.
# This script is intentionally advisory in v1: it tells the operator what must
# be present and where to install it rather than mutating the host.
#
# .PARAMETER IncludeOptional
# Includes optional or deferred prerequisites in the report.
#
# .PARAMETER OutputPath
# Optional JSON output path for the prerequisite report.
#
# .EXAMPLE
# ./scripts/Install-Prereqs.ps1
# # Prints required prerequisite status and install guidance.
#
# .INPUTS
# None.
#
# .OUTPUTS
# [pscustomobject]. Prerequisite report.
#
# .NOTES
# Version: 0.1.20260505.0
# Positional parameters are not supported.
#
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low', PositionalBinding = $false)]
[OutputType([pscustomobject])]
param(
    [switch]$IncludeOptional,

    [string]$OutputPath
)

Set-StrictMode -Version Latest

$ErrorActionPreference = 'Stop'
$strScriptRoot = $PSScriptRoot
$strRepositoryRoot = Split-Path -Path $strScriptRoot -Parent
$strModuleManifestPath = Join-Path -Path $strRepositoryRoot -ChildPath 'src/Modules/MacLab/MacLab.psd1'

Import-Module -Name $strModuleManifestPath -Force

$arrPrerequisite = @(
    [pscustomobject]@{
        Name = 'Apple-silicon Mac'
        Required = $true
        Installed = $IsMacOS -and ([System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture.ToString() -in @('Arm64', 'arm64'))
        Guidance = 'Use an Apple-branded Apple-silicon Mac. Intel and non-macOS hosts are out of scope.'
    },
    [pscustomobject]@{
        Name = 'PowerShell 7.4+'
        Required = $true
        Installed = $PSVersionTable.PSVersion -ge [version]'7.4'
        Guidance = 'Install PowerShell 7.4 or newer from Microsoft or Homebrew.'
    },
    [pscustomobject]@{
        Name = 'Git'
        Required = $true
        Installed = $null -ne (Get-Command -Name git -ErrorAction SilentlyContinue)
        Guidance = 'Install Git before cloning or updating the repository.'
    },
    [pscustomobject]@{
        Name = 'Node.js and npm'
        Required = $true
        Installed = ($null -ne (Get-Command -Name node -ErrorAction SilentlyContinue)) -and ($null -ne (Get-Command -Name npm -ErrorAction SilentlyContinue))
        Guidance = 'Install Node.js 20 or newer for markdownlint tooling.'
    },
    [pscustomobject]@{
        Name = 'pre-commit'
        Required = $true
        Installed = $null -ne (Get-Command -Name pre-commit -ErrorAction SilentlyContinue)
        Guidance = 'Install pre-commit for repository validation hooks.'
    },
    [pscustomobject]@{
        Name = 'mist-cli'
        Required = $true
        Installed = $null -ne (Get-Command -Name mist -ErrorAction SilentlyContinue)
        Guidance = 'Install mist-cli before Phase 4 media acquisition validation.'
    },
    [pscustomobject]@{
        Name = 'Parallels CLI'
        Required = $true
        Installed = ($null -ne (Get-Command -Name prlctl -ErrorAction SilentlyContinue)) -and ($null -ne (Get-Command -Name prlsrvctl -ErrorAction SilentlyContinue))
        Guidance = 'Install Parallels Desktop and confirm prlctl/prlsrvctl are available.'
    },
    [pscustomobject]@{
        Name = 'UTM'
        Required = $false
        Installed = Test-Path -LiteralPath '/Applications/UTM.app/Contents/MacOS/utmctl' -PathType Leaf
        Guidance = 'Install UTM for the documented/manual provider-swap path.'
    },
    [pscustomobject]@{
        Name = 'Tart'
        Required = $false
        Installed = $null -ne (Get-Command -Name tart -ErrorAction SilentlyContinue)
        Guidance = 'Tart remains a v1 stub unless later owner approval expands it.'
    }
)

if (-not $IncludeOptional) {
    $arrPrerequisite = @($arrPrerequisite | Where-Object { $_.Required })
}

$arrMissingRequired = @($arrPrerequisite | Where-Object { $_.Required -and -not $_.Installed })
$objReport = [pscustomobject]@{
    GeneratedAt = (Get-Date).ToUniversalTime().ToString('o')
    Overall = if ($arrMissingRequired.Count -eq 0) { 'Pass' } else { 'Fail' }
    Prerequisites = $arrPrerequisite
}

if ($OutputPath) {
    $strOutputPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputPath)
    $strOutputDirectory = Split-Path -Path $strOutputPath -Parent

    if ($strOutputDirectory -and -not (Test-Path -LiteralPath $strOutputDirectory -PathType Container)) {
        [void][System.IO.Directory]::CreateDirectory($strOutputDirectory)
    }

    if ($PSCmdlet.ShouldProcess($strOutputPath, 'Write prerequisite JSON')) {
        $strJson = $objReport | ConvertTo-Json -Depth 6
        [System.IO.File]::WriteAllText($strOutputPath, $strJson, [System.Text.UTF8Encoding]::new($false))
    }
}

$objReport
