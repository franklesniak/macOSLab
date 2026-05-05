# Readiness.Tests.ps1

BeforeAll {
    $script:strTestRoot = $PSScriptRoot
    $script:strRepositoryRoot = Split-Path -Path $script:strTestRoot -Parent
    $script:strReadinessScriptPath = Join-Path -Path $script:strRepositoryRoot -ChildPath 'scripts/Test-LabReadiness.ps1'
    $script:strPrerequisiteScriptPath = Join-Path -Path $script:strRepositoryRoot -ChildPath 'scripts/Install-Prereqs.ps1'
}

Describe 'Test-LabReadiness.ps1' {
    It 'Returns Pass for fixture host facts when optional live checks are skipped' {
        $hashtableHostFact = @{
            IsMacOS = $true
            Architecture = 'arm64'
            PowerShellVersion = '7.4.0'
        }

        $objResult = & $script:strReadinessScriptPath -HostFact $hashtableHostFact -SkipProviderCheck -SkipMediaCheck -SkipCheckpointCheck

        $objResult.Overall | Should -Be 'Pass'
        @($objResult.Checks | Where-Object { $_.Result -eq 'Fail' }).Count | Should -Be 0
    }

    It 'Fails when host facts are not macOS Apple silicon' {
        $hashtableHostFact = @{
            IsMacOS = $false
            Architecture = 'X64'
            PowerShellVersion = '7.4.0'
        }

        $objResult = & $script:strReadinessScriptPath -HostFact $hashtableHostFact -SkipProviderCheck -SkipMediaCheck -SkipCheckpointCheck

        $objResult.Overall | Should -Be 'Fail'
        @($objResult.Checks | Where-Object { $_.Result -eq 'Fail' }).Count | Should -Be 2
    }

    It 'Fails closed when prepared media hash does not match' {
        $hashtableHostFact = @{
            IsMacOS = $true
            Architecture = 'arm64'
            PowerShellVersion = '7.4.0'
        }
        $strTempFile = [System.IO.Path]::GetTempFileName()
        [System.IO.File]::WriteAllText($strTempFile, 'synthetic media placeholder', [System.Text.UTF8Encoding]::new($false))

        try {
            $objResult = & $script:strReadinessScriptPath -HostFact $hashtableHostFact -SkipProviderCheck -SkipCheckpointCheck -MediaPath $strTempFile -MediaSha256 '0000000000000000000000000000000000000000000000000000000000000000'

            $objResult.Overall | Should -Be 'Fail'
            ($objResult.Checks | Where-Object { $_.Name -eq 'Prepared media' }).Result | Should -Be 'Fail'
        } finally {
            Remove-Item -LiteralPath $strTempFile -Force
        }
    }
}

Describe 'Install-Prereqs.ps1' {
    It 'Returns a prerequisite report without installing tools' {
        $objResult = & $script:strPrerequisiteScriptPath

        $objResult.Prerequisites | Should -Not -BeNullOrEmpty
        ($objResult.Prerequisites | Where-Object { $_.Name -eq 'PowerShell 7.4+' }).Installed | Should -BeTrue
    }
}
