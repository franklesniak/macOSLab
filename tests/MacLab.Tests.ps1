# MacLab.Tests.ps1

BeforeAll {
    $script:strTestRoot = $PSScriptRoot
    $script:strRepositoryRoot = Split-Path -Path $script:strTestRoot -Parent
    $script:strModuleManifestPath = Join-Path -Path $script:strRepositoryRoot -ChildPath 'src/Modules/MacLab/MacLab.psd1'
    $script:arrExpectedCommandName = @(
        'Checkpoint-MacLabVm',
        'Export-MacLabEvidence',
        'Get-MacLabMedia',
        'Get-MacLabVm',
        'Invoke-MacPolicyValidation',
        'New-MacLabVm',
        'Remove-MacLabVm',
        'Restore-MacLabVmCheckpoint',
        'Start-MacLabVm',
        'Stop-MacLabVm'
    )

    Remove-Module -Name MacLab -Force -ErrorAction SilentlyContinue
}

AfterAll {
    Remove-Module -Name MacLab -Force -ErrorAction SilentlyContinue
}

Describe 'MacLab module manifest' {
    It 'Has the expected manifest path' {
        Test-Path -LiteralPath $script:strModuleManifestPath -PathType Leaf | Should -BeTrue
    }

    It 'Passes Test-ModuleManifest with the approved identity' {
        $objManifest = Test-ModuleManifest -Path $script:strModuleManifestPath

        $objManifest.Name | Should -Be 'MacLab'
        $objManifest.Guid.Guid | Should -Be '4d6748ba-859d-4171-9785-889eaabdb048'
        $objManifest.Version.ToString() | Should -Be '0.1.0'
        $objManifest.PowerShellVersion.ToString() | Should -Be '7.4'
    }

    It 'Declares exactly the approved public functions' {
        $objManifestData = Import-PowerShellDataFile -Path $script:strModuleManifestPath
        $arrActualCommandName = @($objManifestData.FunctionsToExport | Sort-Object)
        $arrExpectedCommandName = @($script:arrExpectedCommandName | Sort-Object)

        ($arrActualCommandName -join ',') | Should -Be ($arrExpectedCommandName -join ',')
    }
}

Describe 'MacLab module import' {
    BeforeAll {
        Import-Module -Name $script:strModuleManifestPath -Force
    }

    It 'Imports the module from the manifest' {
        $objModule = Get-Module -Name MacLab

        $objModule | Should -Not -BeNullOrEmpty
        $objModule.Path | Should -Be (Join-Path -Path (Split-Path -Path $script:strModuleManifestPath -Parent) -ChildPath 'MacLab.psm1')
    }

    It 'Exports exactly the approved public commands' {
        $arrActualCommandName = @(
            Get-Command -Module MacLab -CommandType Function |
                Select-Object -ExpandProperty Name |
                Sort-Object
        )
        $arrExpectedCommandName = @($script:arrExpectedCommandName | Sort-Object)

        ($arrActualCommandName -join ',') | Should -Be ($arrExpectedCommandName -join ',')
    }

    It 'Does not export private helpers or provider primitives' {
        $arrExportedCommandName = @(
            Get-Command -Module MacLab -CommandType Function |
                Select-Object -ExpandProperty Name
        )

        $arrExportedCommandName | Should -Not -Contain 'Protect-MacLabEvidence'
        $arrExportedCommandName | Should -Not -Contain 'New-MacLabVm_Parallels'
        $arrExportedCommandName | Should -Not -Contain 'Test-ProviderInstalled_Tart'
    }
}

Describe 'MacLab public command metadata' {
    BeforeAll {
        Import-Module -Name $script:strModuleManifestPath -Force
    }

    It 'Provides help for every public command' {
        foreach ($strCommandName in $script:arrExpectedCommandName) {
            $objHelp = Get-Help -Name $strCommandName -Full

            $objHelp.Synopsis | Should -Not -BeNullOrEmpty
            $objHelp.Description | Should -Not -BeNullOrEmpty
            $objHelp.Examples | Should -Not -BeNullOrEmpty
        }
    }

    It 'Declares output types for every public command' {
        foreach ($strCommandName in $script:arrExpectedCommandName) {
            $objCommand = Get-Command -Name $strCommandName -Module MacLab

            $objCommand.OutputType | Should -Not -BeNullOrEmpty
        }
    }

    It 'Supports WhatIf for side-effecting public commands' {
        $arrShouldProcessCommand = @(
            {
                Get-MacLabMedia -Version '26.4.1' -Build '25E253' -WhatIf
            },
            {
                New-MacLabVm -Provider Parallels -Name 'demo-01' -MediaId '26.4.1-25E253' -WhatIf
            },
            {
                Start-MacLabVm -Provider Parallels -Name 'demo-01' -WhatIf
            },
            {
                Stop-MacLabVm -Provider Parallels -Name 'demo-01' -WhatIf
            },
            {
                Checkpoint-MacLabVm -Provider Parallels -Name 'demo-01' -CheckpointName 'Pre-Enroll' -WhatIf
            },
            {
                Restore-MacLabVmCheckpoint -Provider Parallels -Name 'demo-01' -CheckpointName 'Pre-Enroll' -AcknowledgeCloudStateWarning -WhatIf
            },
            {
                Remove-MacLabVm -Provider Parallels -Name 'demo-01' -WhatIf
            },
            {
                Invoke-MacPolicyValidation -Provider Parallels -Name 'demo-01' -TestPlan './examples/TestCases/Gatekeeper-AppStoreOnly.yml' -WhatIf
            },
            {
                Export-MacLabEvidence -RunId '2026-05-mms-demo4-001' -OutputPath './_bundle' -WhatIf
            }
        )

        foreach ($scriptBlockCommand in $arrShouldProcessCommand) {
            $scriptBlockCommand | Should -Not -Throw
        }
    }
}

Describe 'MacLab provider validation behavior' {
    BeforeAll {
        Import-Module -Name $script:strModuleManifestPath -Force
    }

    It 'Fails clearly when explicit Parallels inventory tooling is missing' {
        {
            Get-MacLabVm -Provider Parallels
        } | Should -Throw -ExpectedMessage '*prlctl was not found*'
    }

    It 'Rejects invalid VM names before provider dispatch' {
        {
            New-MacLabVm -Provider Parallels -Name '../bad' -MediaId '26.4.1-25E253' -Confirm:$false
        } | Should -Throw
    }

    It 'Rejects non-canonical checkpoint names by default' {
        {
            Checkpoint-MacLabVm -Provider Parallels -Name 'demo-01' -CheckpointName 'Almost-Enrolled' -Confirm:$false
        } | Should -Throw
    }
}
