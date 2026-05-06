# Demo.Tests.ps1

BeforeAll {
    $script:strTestRoot = $PSScriptRoot
    $script:strRepositoryRoot = Split-Path -Path $script:strTestRoot -Parent
}

Describe 'MMSMOA demo scripts' {
    It 'Demo1 verifies a prepared artifact without live download' {
        $strArtifactPath = Join-Path -Path $TestDrive -ChildPath 'UniversalMac_26.4.1_25E253_Restore.ipsw'
        [System.IO.File]::WriteAllText($strArtifactPath, 'synthetic ipsw fixture', [System.Text.UTF8Encoding]::new($false))
        $strSha256 = (Get-FileHash -LiteralPath $strArtifactPath -Algorithm SHA256).Hash.ToLowerInvariant()
        $strScriptPath = Join-Path -Path $script:strRepositoryRoot -ChildPath 'examples/MMSMOA-2026/Demo1-Media.ps1'

        $objMedia = & $strScriptPath `
            -CacheRoot $TestDrive `
            -PreparedArtifactPath $strArtifactPath `
            -PreparedArtifactSha256 $strSha256

        $objMedia.Artifacts[0].Prepared | Should -BeTrue
    }

    It 'Demo4 writes redacted Gatekeeper fixture evidence' {
        $strScriptPath = Join-Path -Path $script:strRepositoryRoot -ChildPath 'examples/MMSMOA-2026/Demo4-GatekeeperRollback.ps1'
        $strEvidenceRoot = Join-Path -Path $TestDrive -ChildPath 'evidence'

        $objEvidence = & $strScriptPath -Name 'demo-01' -OutputPath $strEvidenceRoot

        $objEvidence.redactionApplied | Should -BeTrue
        $objEvidence.snapshot | Should -Be 'Broken-Policy-State'
        ($objEvidence.tests | Where-Object { $_.kind -eq 'GatekeeperAssessment' }).expectedFailure | Should -BeTrue
        Test-Path -LiteralPath (Join-Path -Path $strEvidenceRoot -ChildPath "$($objEvidence.runId)/evidence.json") -PathType Leaf | Should -BeTrue
    }

    It 'Invoke-MMSDemo can run the validation segment locally' {
        $strScriptPath = Join-Path -Path $script:strRepositoryRoot -ChildPath 'scripts/Invoke-MMSDemo.ps1'
        $strEvidenceRoot = Join-Path -Path $TestDrive -ChildPath 'orchestrator-evidence'

        $arrResult = @(& $strScriptPath -Demo Validation -VmName 'demo-01' -EvidenceRoot $strEvidenceRoot)

        $arrResult[0].Demo | Should -Be 'Validation'
        $arrResult[0].Status | Should -Be 'Complete'
    }
}
