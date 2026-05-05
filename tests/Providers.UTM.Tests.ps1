# Providers.UTM.Tests.ps1

$script:strTestRoot = $PSScriptRoot
$script:strRepositoryRoot = Split-Path -Path $script:strTestRoot -Parent
$script:strModuleManifestPath = Join-Path -Path $script:strRepositoryRoot -ChildPath 'src/Modules/MacLab/MacLab.psd1'

Remove-Module -Name MacLab -Force -ErrorAction SilentlyContinue
Import-Module -Name $script:strModuleManifestPath -Force

AfterAll {
    Remove-Module -Name MacLab -Force -ErrorAction SilentlyContinue
}

Describe 'MacLab UTM provider' {
    InModuleScope MacLab {
        BeforeEach {
            $script:arrUtmCommand = @()
            $script:strUtmStatus = 'stopped'
            $script:strUtmList = @'
UUID                                  Status   Name
00000000-0000-0000-0000-000000000000  stopped  demo-utm-01
'@

            Mock Test-Path -MockWith {
                $true
            } -ParameterFilter { $LiteralPath -eq '/Applications/UTM.app/Contents/MacOS/utmctl' }

            Mock Invoke-LoggedCommand -MockWith {
                param(
                    [string]$FilePath,
                    [string[]]$ArgumentList,
                    [int]$TimeoutSeconds
                )

                $null = $FilePath
                $null = $TimeoutSeconds
                $script:arrUtmCommand += ($ArgumentList -join ' ')
                $strCommand = $ArgumentList -join ' '
                $strStdout = ''
                $strStderr = ''

                switch -Regex ($strCommand) {
                    '^version$' {
                        $strStdout = '4.7.5'
                    }
                    '^list$' {
                        $strStdout = $script:strUtmList
                    }
                    '^status ' {
                        $strStdout = $script:strUtmStatus
                    }
                    '^start ' {
                        if ($script:strUtmStatus -eq 'started') {
                            $strStdout = 'Operation not available'
                        } else {
                            $script:strUtmStatus = 'started'
                        }
                    }
                    '^stop ' {
                        $script:strUtmStatus = 'stopped'
                    }
                    default {
                        $strStdout = ''
                    }
                }

                [pscustomobject]@{
                    FilePath = '/Applications/UTM.app/Contents/MacOS/utmctl'
                    DisplayCommand = "/Applications/UTM.app/Contents/MacOS/utmctl ${strCommand}"
                    ExitCode = 0
                    TimedOut = $false
                    StartedAt = '2026-05-05T00:00:00.0000000Z'
                    DurationMs = 1
                    Stdout = $strStdout
                    Stderr = $strStderr
                }
            }
        }

        It 'detects UTM and captures utmctl version' {
            Test-ProviderInstalled_UTM | Should -BeTrue

            $objVersion = Get-ProviderVersion_UTM

            $objVersion.Installed | Should -BeTrue
            $objVersion.UtmctlVersion | Should -Be '4.7.5'
        }

        It 'lists UTM VMs with explicit manual capability gaps' {
            $objVm = Get-MacLabVm_UTM -Name 'demo-utm-01'

            $objVm.Provider | Should -Be 'UTM'
            $objVm.Name | Should -Be 'demo-utm-01'
            $objVm.State | Should -Be 'stopped'
            $objVm.Capabilities.CanStartVm | Should -BeTrue
            $objVm.Capabilities.CanCheckpoint | Should -BeFalse
            $objVm.ManualStepRequired | Should -Contain 'checkpoint'
        }

        It 'starts from stopped state and verifies final status' {
            $objVm = Start-MacLabVm_UTM -Name 'demo-utm-01' -Confirm:$false

            $objVm.State | Should -Be 'started'
            $script:arrUtmCommand | Should -Contain 'start demo-utm-01'
            $script:arrUtmCommand | Should -Contain 'status demo-utm-01'
        }

        It 'accepts operation-not-available output when final status is already started' {
            $script:strUtmStatus = 'started'

            $objVm = Start-MacLabVm_UTM -Name 'demo-utm-01' -Confirm:$false

            $objVm.State | Should -Be 'started'
        }

        It 'stops and verifies final status' {
            $script:strUtmStatus = 'started'

            $objVm = Stop-MacLabVm_UTM -Name 'demo-utm-01' -Confirm:$false

            $objVm.State | Should -Be 'stopped'
            $script:arrUtmCommand | Should -Contain 'stop demo-utm-01'
        }

        It 'keeps creation and checkpointing manual-step-required in v1' {
            {
                New-MacLabVm -Provider UTM -Name 'demo-utm-01' -MediaId '26.4.1-25E253' -Confirm:$false
            } | Should -Throw -ExpectedMessage '*manual step*'

            {
                Checkpoint-MacLabVm_UTM -Name 'demo-utm-01' -CheckpointName 'Pre-Enroll' -Confirm:$false
            } | Should -Throw -ExpectedMessage '*manual step*'
        }
    }
}

Describe 'MacLab Tart provider stub' {
    InModuleScope MacLab {
        BeforeEach {
            Mock Get-Command -MockWith {
                param([string]$Name)

                [pscustomobject]@{
                    Name = $Name
                    Source = "/usr/local/bin/${Name}"
                }
            } -ParameterFilter { $Name -eq 'tart' }

            Mock Invoke-LoggedCommand -MockWith {
                [pscustomobject]@{
                    FilePath = '/usr/local/bin/tart'
                    DisplayCommand = '/usr/local/bin/tart --version'
                    ExitCode = 0
                    TimedOut = $false
                    StartedAt = '2026-05-05T00:00:00.0000000Z'
                    DurationMs = 1
                    Stdout = '2.22.0'
                    Stderr = ''
                }
            }
        }

        It 'detects Tart but reports lifecycle as stubbed in v1' {
            Test-ProviderInstalled_Tart | Should -BeTrue

            $objVersion = Get-ProviderVersion_Tart

            $objVersion.Installed | Should -BeTrue
            $objVersion.TartVersion | Should -Be '2.22.0'
            $objVersion.Implementation | Should -Be 'StubbedInV1'
        }

        It 'fails mutating Tart primitives with the v1 stub message' {
            {
                Start-MacLabVm_Tart -Name 'demo-tart-01' -Confirm:$false
            } | Should -Throw -ExpectedMessage '*not implemented in v1*'
        }
    }
}
