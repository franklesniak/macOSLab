# Validation.Tests.ps1

BeforeAll {
    $script:strTestRoot = $PSScriptRoot
    $script:strRepositoryRoot = Split-Path -Path $script:strTestRoot -Parent
    $script:strModuleManifestPath = Join-Path -Path $script:strRepositoryRoot -ChildPath 'src/Modules/MacLab/MacLab.psd1'
    $script:strSchema = Get-Content -LiteralPath (Join-Path -Path $script:strRepositoryRoot -ChildPath 'schemas/evidence-bundle.schema.json') -Raw

    Remove-Module -Name MacLab -Force -ErrorAction SilentlyContinue
    Import-Module -Name $script:strModuleManifestPath -Force
}

AfterAll {
    Remove-Module -Name MacLab -Force -ErrorAction SilentlyContinue
}

Describe 'Invoke-MacPolicyValidation' {
    It 'Parses a FileVault test plan and writes redacted schema-valid evidence' {
        $strOutputRoot = Join-Path -Path $TestDrive -ChildPath 'evidence'
        $strPlanPath = Join-Path -Path $script:strRepositoryRoot -ChildPath 'examples/TestCases/FileVault-Validation.yml'

        $objEvidence = Invoke-MacPolicyValidation `
            -Provider Parallels `
            -Name 'demo-01' `
            -TestPlan $strPlanPath `
            -OutputPath $strOutputRoot `
            -Confirm:$false

        $objEvidence.redactionApplied | Should -BeTrue
        $objEvidence.tests.Count | Should -Be 2
        Test-Json -Json ($objEvidence | ConvertTo-Json -Depth 20) -Schema $script:strSchema | Should -BeTrue

        $strPersistedPath = Join-Path -Path $strOutputRoot -ChildPath "$($objEvidence.runId)/evidence.json"
        Test-Path -LiteralPath $strPersistedPath -PathType Leaf | Should -BeTrue
    }

    It 'Records Defender unhealthy fixture output as a non-terminating failed assertion' {
        $strPlanPath = Join-Path -Path $script:strRepositoryRoot -ChildPath 'examples/TestCases/Defender-Validation.yml'

        $objEvidence = Invoke-MacPolicyValidation `
            -Provider Parallels `
            -Name 'demo-01' `
            -TestPlan $strPlanPath `
            -Confirm:$false

        $objDefenderResult = $objEvidence.tests |
            Where-Object { $_.name -eq 'Defender unhealthy pre-approval state captured from guest' } |
            Select-Object -First 1

        $objDefenderResult.result | Should -Be 'Fail'
        $objDefenderResult.expectedFailure | Should -BeTrue
        ($objEvidence | ConvertTo-Json -Depth 20) | Should -Not -Match '00000000-0000-4000-8000-000000000000'
    }

    It 'Records Defender healthy fixture output as a passing baseline assertion' {
        $strPlanPath = Join-Path -Path $script:strRepositoryRoot -ChildPath 'examples/TestCases/Defender-Validation.yml'

        $objEvidence = Invoke-MacPolicyValidation `
            -Provider Parallels `
            -Name 'demo-01' `
            -TestPlan $strPlanPath `
            -Confirm:$false

        $objDefenderResult = $objEvidence.tests |
            Where-Object { $_.name -eq 'Defender healthy baseline captured from guest' } |
            Select-Object -First 1

        $objDefenderResult.result | Should -Be 'Pass'
        $objDefenderResult.expectedFailure | Should -BeFalse
        $objDefenderResult.evidenceRefs | Should -Contain 'fixtures/mdatp-health-healthy.txt'
        ($objEvidence | ConvertTo-Json -Depth 20) | Should -Not -Match '"org_id"\s*:\s*"[0-9a-f-]{36}"'
        ($objEvidence | ConvertTo-Json -Depth 20) | Should -Not -Match '"edr_machine_id"\s*:\s*"[0-9a-f]{40}"'
    }

    It 'Records Gatekeeper App-Store-only fixture output as an expected app-launch failure' {
        $strPlanPath = Join-Path -Path $script:strRepositoryRoot -ChildPath 'examples/TestCases/Gatekeeper-AppStoreOnly.yml'

        $objEvidence = Invoke-MacPolicyValidation `
            -Provider Parallels `
            -Name 'demo-01' `
            -TestPlan $strPlanPath `
            -Confirm:$false

        $objGatekeeperResult = $objEvidence.tests |
            Where-Object { $_.kind -eq 'GatekeeperAssessment' } |
            Select-Object -First 1
        $objProfileResult = $objEvidence.tests |
            Where-Object { $_.kind -eq 'SystemPolicyControlProfile' } |
            Select-Object -First 1

        $objEvidence.snapshot | Should -Be 'Broken-Policy-State'
        $objGatekeeperResult.result | Should -Be 'Fail'
        $objGatekeeperResult.expectedFailure | Should -BeTrue
        $objGatekeeperResult.evidenceRefs | Should -Contain 'fixtures/gatekeeper-vscode-rejected.txt'
        $objGatekeeperResult.message | Should -Match 'VS Code rejected'
        $objProfileResult.result | Should -Be 'Pass'
        Test-Json -Json ($objEvidence | ConvertTo-Json -Depth 20) -Schema $script:strSchema | Should -BeTrue
    }

    It 'Records Gatekeeper recovered fixture output as accepted after rollback' {
        $strPlanPath = Join-Path -Path $script:strRepositoryRoot -ChildPath 'examples/TestCases/Gatekeeper-Recovered.yml'

        $objEvidence = Invoke-MacPolicyValidation `
            -Provider Parallels `
            -Name 'demo-01' `
            -TestPlan $strPlanPath `
            -Confirm:$false

        $objGatekeeperResult = $objEvidence.tests |
            Where-Object { $_.kind -eq 'GatekeeperAssessment' } |
            Select-Object -First 1

        $objEvidence.snapshot | Should -Be 'Post-Enroll-Baseline'
        $objGatekeeperResult.result | Should -Be 'Pass'
        $objGatekeeperResult.expectedFailure | Should -BeFalse
        $objGatekeeperResult.evidenceRefs | Should -Contain 'fixtures/gatekeeper-vscode-accepted.txt'
        Test-Json -Json ($objEvidence | ConvertTo-Json -Depth 20) -Schema $script:strSchema | Should -BeTrue
    }

    It 'Fails closed when required Graph scopes are missing' {
        $strPlanPath = Join-Path -Path $script:strRepositoryRoot -ChildPath 'examples/TestCases/Compliance-SmokeTest.yml'

        {
            Invoke-MacPolicyValidation -Provider Parallels -Name 'demo-01' -TestPlan $strPlanPath -Confirm:$false
        } | Should -Throw -ExpectedMessage '*Missing required Microsoft Graph scope*'
    }

    It 'Allows expected fixture failures when required Graph scopes are supplied' {
        $strPlanPath = Join-Path -Path $script:strRepositoryRoot -ChildPath 'examples/TestCases/Compliance-SmokeTest.yml'

        $objEvidence = Invoke-MacPolicyValidation `
            -Provider Parallels `
            -Name 'demo-01' `
            -TestPlan $strPlanPath `
            -GraphScope 'DeviceManagementManagedDevices.Read.All' `
            -Confirm:$false

        $objComplianceResult = $objEvidence.tests | Where-Object { $_.kind -eq 'ComplianceState' } | Select-Object -First 1

        $objComplianceResult.result | Should -Be 'Fail'
        $objComplianceResult.expectedFailure | Should -BeTrue
    }

    It 'Rejects Red-bucket plans' {
        $strPlanPath = Join-Path -Path $TestDrive -ChildPath 'red-bucket.yml'
        @(
            'schemaVersion: "1.0"',
            'name: "Red bucket"',
            'fidelity: "Red"',
            'tests:',
            '  - name: "ADE-only assertion"',
            '    kind: "AdeEnrollment"',
            '    result: "Pass"',
            '    expectedFailure: false',
            '    evidenceRefs:'
        ) | Set-Content -LiteralPath $strPlanPath -Encoding utf8

        {
            Invoke-MacPolicyValidation -Provider Parallels -Name 'demo-01' -TestPlan $strPlanPath -Confirm:$false
        } | Should -Throw -ExpectedMessage '*Red-bucket*'
    }
}
