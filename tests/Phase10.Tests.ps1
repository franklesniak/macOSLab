# Phase10.Tests.ps1

BeforeAll {
    $script:strTestRoot = $PSScriptRoot
    $script:strRepositoryRoot = Split-Path -Path $script:strTestRoot -Parent
    $script:strResetScriptPath = Join-Path -Path $script:strRepositoryRoot -ChildPath 'scripts/Reset-IntuneMacLabDevice.ps1'
    $script:strLogAnalyticsScriptPath = Join-Path -Path $script:strRepositoryRoot -ChildPath 'scripts/Send-LabEventToLogAnalytics.ps1'
}

Describe 'Phase 10 deferred helpers' {
    It 'Produces report-only cloud cleanup guidance without mutation support' {
        $objReport = & $script:strResetScriptPath -VmName 'MMS-MACLAB-001'

        $objReport.mode | Should -Be 'ReportOnly'
        $objReport.mutationAllowed | Should -BeFalse
        $objReport.cloudStateWarning | Should -Match 'VM rollback does not rewind'
        $objReport.candidates.Count | Should -Be 3
        $objReport.candidates.mutationSupportedInV1 | Should -Not -Contain $true
    }

    It 'Produces a disabled-by-default Log Analytics envelope' {
        $objEnvelope = & $script:strLogAnalyticsScriptPath -RunId '2026-05-mms-demo4-001'

        $objEnvelope.mode | Should -Be 'DisabledByDefault'
        $objEnvelope.networkSendAttempted | Should -BeFalse
        $objEnvelope.redactionRequired | Should -BeTrue
    }

    It 'Fails clearly if live Log Analytics sending is requested in v1' {
        {
            & $script:strLogAnalyticsScriptPath -RunId '2026-05-mms-demo4-001' -EnableNetworkSend
        } | Should -Throw -ExpectedMessage '*deferred in v1*'
    }
}
