# Providers.Parallels.Tests.ps1

$script:strTestRoot = $PSScriptRoot
$script:strRepositoryRoot = Split-Path -Path $script:strTestRoot -Parent
$script:strModuleManifestPath = Join-Path -Path $script:strRepositoryRoot -ChildPath 'src/Modules/MacLab/MacLab.psd1'

Remove-Module -Name MacLab -Force -ErrorAction SilentlyContinue
Import-Module -Name $script:strModuleManifestPath -Force

AfterAll {
    Remove-Module -Name MacLab -Force -ErrorAction SilentlyContinue
}

Describe 'MacLab Parallels provider' {
    InModuleScope MacLab {
        BeforeEach {
            $script:arrParallelsCommand = @()
            $script:strParallelsNameList = "demo-01`n"
            $script:strParallelsInfo = @'
Name: demo-01
State: stopped
Type: APPLE_VZ_VM
OS: macosx
CPU(s): 4
Memory: 8192 MB
HDD 0: 128 GB
MAC address: 00:1C:42:00:00:08
Automatic sharing cameras: off
Automatic sharing bluetooth: off
Automatic sharing smart cards: off
Automatic sharing gamepads: off
Host Shared Folders: off
Host-defined sharing: off
Shared Profile: off
Share apps from Mac: off
Share apps to Mac: off
SmartMount: off
Shared Clipboard: off
Shared Cloud: off
Share host location: off
'@
            $script:strParallelsSnapshotJson = @'
{
  "snapshot-guid-1": {
    "name": "Pre-Enroll",
    "date": "2026-05-05T16:30:00Z",
    "state": "poweroff",
    "current": true,
    "parent": ""
  }
}
'@

            Mock Get-Command -MockWith {
                param(
                    [string]$Name,
                    [string]$CommandType
                )

                $null = $CommandType
                [pscustomobject]@{
                    Name = $Name
                    Source = "/usr/local/bin/${Name}"
                }
            } -ParameterFilter { $Name -in @('prlctl', 'prlsrvctl') }

            Mock Invoke-LoggedCommand -MockWith {
                param(
                    [string]$FilePath,
                    [string[]]$ArgumentList,
                    [int]$TimeoutSeconds,
                    [string[]]$SensitiveArgumentPattern,
                    [string]$StandardInputText
                )

                $null = $TimeoutSeconds
                $null = $SensitiveArgumentPattern
                $null = $StandardInputText
                $script:arrParallelsCommand += ($ArgumentList -join ' ')
                $strCommand = $ArgumentList -join ' '
                $intExitCode = 0
                $strStdout = ''
                $strStderr = ''

                switch -Regex ($strCommand) {
                    '^--version$' {
                        $strStdout = 'prlctl version 26.3.2 (57398)'
                    }
                    '^info$' {
                        $strStdout = 'Parallels Desktop 26.3.2-57398'
                    }
                    '^list -a --output name --no-header$' {
                        $strStdout = $script:strParallelsNameList
                    }
                    '^list -i ' {
                        $strStdout = $script:strParallelsInfo
                    }
                    '^snapshot-list .* --json$' {
                        $strStdout = $script:strParallelsSnapshotJson
                    }
                    '^stop ' {
                        $intExitCode = 255
                        $strStderr = 'Operation canceled'
                    }
                    default {
                        $strStdout = ''
                    }
                }

                [pscustomobject]@{
                    FilePath = $FilePath
                    DisplayCommand = (($FilePath, $ArgumentList) -join ' ')
                    ExitCode = $intExitCode
                    TimedOut = $false
                    StartedAt = '2026-05-05T00:00:00.0000000Z'
                    DurationMs = 1
                    Stdout = $strStdout
                    Stderr = $strStderr
                }
            }
        }

        It 'detects installed Parallels tools and captures version data' {
            Test-ProviderInstalled_Parallels | Should -BeTrue

            $objVersion = Get-ProviderVersion_Parallels

            $objVersion.Installed | Should -BeTrue
            $objVersion.PrlctlVersion | Should -Be 'prlctl version 26.3.2 (57398)'
            $objVersion.Edition | Should -Be 'Unknown'
        }

        It 'uses reliable names-only inventory and returns isolation status' {
            $objVm = Get-MacLabVm_Parallels -Name 'demo-01'

            $objVm.Provider | Should -Be 'Parallels'
            $objVm.Name | Should -Be 'demo-01'
            $objVm.State | Should -Be 'stopped'
            $objVm.Isolation.Ready | Should -BeTrue
            $script:arrParallelsCommand | Should -Contain 'list -a --output name --no-header'
        }

        It 'restores a checkpoint by provider snapshot ID, not friendly name' {
            $objVm = Restore-MacLabVmCheckpoint_Parallels -Name 'demo-01' -CheckpointName 'Pre-Enroll' -Confirm:$false

            $objVm.RestoredFromCheckpoint | Should -Be 'Pre-Enroll'
            $objVm.RestoredFromProviderSnapshotId | Should -Be 'snapshot-guid-1'
            $script:arrParallelsCommand | Should -Contain 'snapshot-switch demo-01 --id snapshot-guid-1 --skip-resume'
        }

        It 'accepts a nonzero stop exit when final VM state is stopped' {
            $objVm = Stop-MacLabVm_Parallels -Name 'demo-01' -Confirm:$false

            $objVm.State | Should -Be 'stopped'
            $script:arrParallelsCommand | Should -Contain 'stop demo-01'
        }

        It 'runs the verified hardening order before trusting final facts' {
            $objIsolation = Invoke-MacLabParallelsHardening -Name 'demo-01'

            $objIsolation.Ready | Should -BeTrue
            $script:arrParallelsCommand[0] | Should -Be 'set demo-01 --isolate-vm on'
            $script:arrParallelsCommand | Should -Contain 'set demo-01 --share-host-location off'
            $script:arrParallelsCommand | Should -Contain 'set demo-01 --auto-share-gamepad off'
        }

        It 'rejects guest macOS majors higher than the host by default' {
            {
                Get-MacLabParallelsCompatibility -HostVersion '25.6.0' -GuestVersion '26.4.1'
            } | Should -Throw -ExpectedMessage '*higher than host*'
        }
    }
}
