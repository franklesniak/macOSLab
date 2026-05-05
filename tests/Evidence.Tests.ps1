# Evidence.Tests.ps1

$script:strTestRoot = $PSScriptRoot
$script:strRepositoryRoot = Split-Path -Path $script:strTestRoot -Parent
$script:strModuleManifestPath = Join-Path -Path $script:strRepositoryRoot -ChildPath 'src/Modules/MacLab/MacLab.psd1'
$script:strEvidenceSchemaPath = Join-Path -Path $script:strRepositoryRoot -ChildPath 'schemas/evidence-bundle.schema.json'

Remove-Module -Name MacLab -Force -ErrorAction SilentlyContinue
Import-Module -Name $script:strModuleManifestPath -Force

AfterAll {
    Remove-Module -Name MacLab -Force -ErrorAction SilentlyContinue
}

Describe 'MacLab evidence redaction' {
    InModuleScope MacLab {
        BeforeEach {
            $script:objSyntheticEvidence = [pscustomobject]@{
                '$schemaVersion' = '1.0.0'
                runId = '2026-05-evidence-test-001'
                createdAt = '2026-05-05T00:00:00Z'
                vmName = 'mms-parallels-01'
                provider = 'Parallels'
                snapshot = 'Post-Enroll-Baseline'
                fidelity = 'Yellow'
                hardwareSignoffRequired = $true
                personalRecoveryKey = 'ABCD-EFGH-IJKL-MNOP-QRST-UVWX'
                graphToken = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxMjMifQ.signature'
                intuneDeviceIdRedacted = '00000000-0000-4000-8000-000000000000'
                notes = 'Synthetic local path /Users/example/MacLab and email admin@example.invalid.'
                providerVersionMatrix = [pscustomobject]@{
                    hostMacOS = '26.4.1'
                    hostMacOSBuild = '25E253'
                    guestMacOS = '26.4.1'
                    guestBuild = '25E253'
                    hostGuestCompatibility = 'same-major-supported'
                    powerShellVersion = '7.4.0'
                    pesterVersion = '5.7.1'
                    intunePolicySetId = 'policy-set-real-looking'
                    providerManualStepGaps = @()
                    providerIsolationState = [pscustomobject]@{
                        hostSharingDisabled = $true
                        sharedClipboardDisabled = $true
                        sharedApplicationsDisabled = $true
                        smartMountDisabled = $true
                        cameraSharingDisabled = $true
                        bluetoothSharingDisabled = $true
                        hostLocationSharingDisabled = $true
                    }
                }
                cloudStateWarning = 'VM rollback does not rewind cloud state.'
                tests = @(
                    [pscustomobject]@{
                        name = 'Nested redaction'
                        kind = 'RedactionVerification'
                        result = 'Pass'
                        expectedFailure = $false
                        evidenceRefs = @()
                        nested = [pscustomobject]@{
                            macAddress = '00:1C:42:00:00:08'
                        }
                    }
                )
            }
        }

        It 'redacts recovery keys, JWTs, identifiers, and nested values without mutating the source' {
            $objRedacted = Protect-MacLabEvidence -Evidence $script:objSyntheticEvidence
            $strJson = $objRedacted | ConvertTo-Json -Depth 20

            $objRedacted.redactionApplied | Should -BeTrue
            $objRedacted.redactionVersion | Should -Be '1.0.0'
            $strJson | Should -Not -Match 'ABCD-EFGH'
            $strJson | Should -Not -Match 'eyJhbGci'
            $strJson | Should -Not -Match '00:1C:42'
            $strJson | Should -Not -Match 'admin@example'
            $strJson | Should -Not -Match '/Users/example'
            $script:objSyntheticEvidence.personalRecoveryKey | Should -Be 'ABCD-EFGH-IJKL-MNOP-QRST-UVWX'
        }

        It 'is idempotent' {
            $objFirstPass = Protect-MacLabEvidence -Evidence $script:objSyntheticEvidence
            $objSecondPass = Protect-MacLabEvidence -Evidence $objFirstPass

            ($objFirstPass | ConvertTo-Json -Depth 20) | Should -Be ($objSecondPass | ConvertTo-Json -Depth 20)
        }

        It 'writes parseable redacted evidence JSON and summary files' {
            $strOutputRoot = Join-Path -Path $TestDrive -ChildPath 'evidence'

            $objWriteResult = Write-EvidenceRecord -Evidence $script:objSyntheticEvidence -OutputRoot $strOutputRoot -Confirm:$false

            Test-Path -LiteralPath $objWriteResult.EvidencePath -PathType Leaf | Should -BeTrue
            Test-Path -LiteralPath $objWriteResult.SummaryPath -PathType Leaf | Should -BeTrue

            $objPersistedEvidence = Get-Content -LiteralPath $objWriteResult.EvidencePath -Raw | ConvertFrom-Json
            $objPersistedEvidence.redactionApplied | Should -BeTrue
            ($objPersistedEvidence | ConvertTo-Json -Depth 20) | Should -Not -Match 'policy-set-real-looking'
        }

        It 'exports a redacted evidence directory bundle' {
            $strEvidenceRoot = Join-Path -Path $TestDrive -ChildPath 'source'
            $objWriteResult = Write-EvidenceRecord -Evidence $script:objSyntheticEvidence -OutputRoot $strEvidenceRoot -Confirm:$false
            $strRawAttachmentPath = Join-Path -Path $objWriteResult.RunRoot -ChildPath 'raw.txt'
            [System.IO.File]::WriteAllText($strRawAttachmentPath, 'token eyJhbGciOiJIUzI1NiJ9.abc.def in text', [System.Text.UTF8Encoding]::new($false))

            $strBundlePath = Join-Path -Path $TestDrive -ChildPath 'bundle'
            $objBundle = Export-MacLabEvidence -EvidenceRoot $strEvidenceRoot -RunId $objWriteResult.RunId -OutputPath $strBundlePath -Confirm:$false

            Test-Path -LiteralPath $objBundle.BundlePath -PathType Container | Should -BeTrue
            Test-Path -LiteralPath (Join-Path -Path $strBundlePath -ChildPath 'MANIFEST.json') -PathType Leaf | Should -BeTrue
            (Get-Content -LiteralPath (Join-Path -Path $strBundlePath -ChildPath 'raw.txt') -Raw) | Should -Not -Match 'eyJhbGci'
        }
    }
}

Describe 'MacLab evidence schema examples' {
    It 'Accepts valid evidence examples and rejects invalid examples' {
        $strRepositoryRoot = Split-Path -Path $PSScriptRoot -Parent
        $strEvidenceSchemaPath = Join-Path -Path $strRepositoryRoot -ChildPath 'schemas/evidence-bundle.schema.json'
        $strSchema = Get-Content -LiteralPath $strEvidenceSchemaPath -Raw
        $arrValidExample = @(Get-ChildItem -LiteralPath (Join-Path -Path $strRepositoryRoot -ChildPath 'schemas/examples/evidence-bundle/valid') -Filter '*.json')
        $arrInvalidExample = @(Get-ChildItem -LiteralPath (Join-Path -Path $strRepositoryRoot -ChildPath 'schemas/examples/evidence-bundle/invalid') -Filter '*.json')

        foreach ($objValidExample in $arrValidExample) {
            $strJson = Get-Content -LiteralPath $objValidExample.FullName -Raw
            Test-Json -Json $strJson -Schema $strSchema | Should -BeTrue
        }

        foreach ($objInvalidExample in $arrInvalidExample) {
            $strJson = Get-Content -LiteralPath $objInvalidExample.FullName -Raw
            Test-Json -Json $strJson -Schema $strSchema -ErrorAction SilentlyContinue | Should -BeFalse
        }
    }
}
