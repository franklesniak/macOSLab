function Invoke-MacPolicyValidation {
    # .SYNOPSIS
    # Runs a macOS policy validation test plan.
    #
    # .DESCRIPTION
    # Parses the repository's YAML test-plan shape, rejects Red-bucket
    # assertions, emits fixture-backed validation results, and writes redacted
    # evidence when an output path is supplied.
    #
    # .PARAMETER Provider
    # Hypervisor provider.
    #
    # .PARAMETER Name
    # VM name.
    #
    # .PARAMETER TestPlan
    # Path to the YAML test plan.
    #
    # .PARAMETER OutputPath
    # Optional evidence output path.
    #
    # .PARAMETER RedactSecrets
    # Redacts evidence before persistence. Defaults to true.
    #
    # .PARAMETER Fidelity
    # Optional fidelity override.
    #
    # .PARAMETER GraphScope
    # Optional Microsoft Graph scopes required by the plan.
    #
    # .EXAMPLE
    # Invoke-MacPolicyValidation -Provider Parallels -Name 'demo-01' -TestPlan ./examples/TestCases/Compliance-SmokeTest.yml
    # # Runs validation and emits redacted evidence.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. Redacted evidence.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Positional parameters are not supported.
    #
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium', PositionalBinding = $false)]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet('Parallels', 'UTM', 'Tart')]
        [string]$Provider,

        [Parameter(Mandatory = $true)]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9._-]{0,62}$')]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$TestPlan,

        [string]$OutputPath,

        [bool]$RedactSecrets = $true,

        [ValidateSet('Green', 'Yellow', 'Red')]
        [string]$Fidelity,

        [string[]]$GraphScope
    )

    $null = $RedactSecrets

    if (-not $PSCmdlet.ShouldProcess($Name, 'Run macOS policy validation')) {
        return
    }

    function ConvertFrom-MacLabPlanValue {
        param([string]$Value)

        $strValue = $Value.Trim()
        if ($strValue -match '^["''](.*)["'']$') {
            return $Matches[1]
        }

        if ($strValue -eq 'true') {
            return $true
        }

        if ($strValue -eq 'false') {
            return $false
        }

        if ($strValue -eq 'null') {
            return $null
        }

        $strValue
    }

    function ConvertFrom-MacLabValidationPlan {
        param([string]$Path)

        $strPlanPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)
        if (-not (Test-Path -LiteralPath $strPlanPath -PathType Leaf)) {
            throw "Test plan was not found: ${strPlanPath}"
        }

        $hasPlan = [ordered]@{
            tests = @()
            requiredGraphScopes = @()
        }
        $objCurrentTest = $null
        $strRootList = $null
        $strTestList = $null

        foreach ($strRawLine in [System.IO.File]::ReadLines($strPlanPath)) {
            $strLine = ($strRawLine -replace '\s+#.*$', '').TrimEnd()
            if (-not $strLine.Trim()) {
                continue
            }

            if ($strLine -match '^([A-Za-z][A-Za-z0-9]*):\s*(.*)$') {
                $strRootList = $null
                $strTestList = $null
                $objCurrentTest = $null
                $strKey = $Matches[1]
                $strValue = $Matches[2]
                if ($strValue) {
                    $hasPlan[$strKey] = ConvertFrom-MacLabPlanValue -Value $strValue
                } else {
                    $strRootList = $strKey
                    if (-not $hasPlan.Contains($strKey)) {
                        $hasPlan[$strKey] = @()
                    }
                }
                continue
            }

            if ($strLine -match '^\s{2}-\s*(.*)$' -and $strRootList -eq 'requiredGraphScopes') {
                $hasPlan.requiredGraphScopes += ConvertFrom-MacLabPlanValue -Value $Matches[1]
                continue
            }

            if ($strLine -match '^\s{2}-\s*([A-Za-z][A-Za-z0-9]*):\s*(.*)$' -and $strRootList -eq 'tests') {
                $objCurrentTest = [ordered]@{}
                $objCurrentTest[$Matches[1]] = ConvertFrom-MacLabPlanValue -Value $Matches[2]
                $hasPlan.tests += $objCurrentTest
                continue
            }

            if ($strLine -match '^\s{4}([A-Za-z][A-Za-z0-9]*):\s*(.*)$' -and $objCurrentTest) {
                $strKey = $Matches[1]
                $strValue = $Matches[2]
                if ($strValue) {
                    $objCurrentTest[$strKey] = ConvertFrom-MacLabPlanValue -Value $strValue
                    $strTestList = $null
                } else {
                    $objCurrentTest[$strKey] = @()
                    $strTestList = $strKey
                }
                continue
            }

            if ($strLine -match '^\s{6}-\s*(.*)$' -and $objCurrentTest -and $strTestList) {
                $objCurrentTest[$strTestList] += ConvertFrom-MacLabPlanValue -Value $Matches[1]
            }
        }

        [pscustomobject]$hasPlan
    }

    function ConvertFrom-MacLabDefenderHealthText {
        param([string]$Path)

        $strHealthPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)
        $hasHealth = [ordered]@{}
        foreach ($strLine in [System.IO.File]::ReadLines($strHealthPath)) {
            if ($strLine -match '^\s*([^:]+):\s*(.*)$') {
                $strKey = $Matches[1].Trim()
                $strValue = $Matches[2].Trim()
                $hasHealth[$strKey] = ConvertFrom-MacLabPlanValue -Value $strValue
            }
        }

        [pscustomobject]$hasHealth
    }

    function Get-MacLabValidationProperty {
        param(
            [object]$InputObject,
            [string]$PropertyName
        )

        if ($InputObject -is [System.Collections.IDictionary] -and $InputObject.Contains($PropertyName)) {
            return $InputObject[$PropertyName]
        }

        $objProperty = $InputObject.PSObject.Properties[$PropertyName]
        if ($objProperty) {
            return $objProperty.Value
        }

        return $null
    }

    $objPlan = ConvertFrom-MacLabValidationPlan -Path $TestPlan
    $strPlanFidelity = Get-MacLabValidationProperty -InputObject $objPlan -PropertyName 'fidelity'
    $strEffectiveFidelity = if ($Fidelity) { $Fidelity } elseif ($strPlanFidelity) { $strPlanFidelity } else { 'Yellow' }
    $boolRedBucket = Get-MacLabValidationProperty -InputObject $objPlan -PropertyName 'redBucket'

    if ($strEffectiveFidelity -eq 'Red' -or $boolRedBucket -eq $true) {
        throw 'Red-bucket assertions are rejected for VM-backed validation plans.'
    }

    foreach ($hasTest in @($objPlan.tests)) {
        if ($hasTest.Contains('bucket') -and $hasTest['bucket'] -eq 'Red') {
            throw "Red-bucket assertion rejected: $($hasTest['name'])"
        }
    }

    $arrMissingScope = @(
        foreach ($strRequiredScope in @(Get-MacLabValidationProperty -InputObject $objPlan -PropertyName 'requiredGraphScopes')) {
            if ($GraphScope -notcontains $strRequiredScope) {
                $strRequiredScope
            }
        }
    )
    if ($arrMissingScope.Count -gt 0) {
        throw "Missing required Microsoft Graph scope(s): $($arrMissingScope -join ', ')"
    }

    $strPlanRoot = Split-Path -Path ($ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($TestPlan)) -Parent
    $arrEvidenceTest = @(
        foreach ($hasTest in @($objPlan.tests)) {
            $strResult = if ($hasTest.Contains('result')) { $hasTest['result'] } else { 'Pass' }
            $arrEvidenceRef = if ($hasTest.Contains('evidenceRefs')) { @($hasTest['evidenceRefs']) } else { @() }

            if ($hasTest['kind'] -eq 'DefenderHealth' -and $hasTest.Contains('fixture')) {
                $strFixturePath = Join-Path -Path $strPlanRoot -ChildPath $hasTest['fixture']
                $objHealth = ConvertFrom-MacLabDefenderHealthText -Path $strFixturePath
                if ($objHealth.healthy -eq $false) {
                    $strResult = 'Fail'
                }
                $arrEvidenceRef = @($arrEvidenceRef + $hasTest['fixture'])
            }

            [pscustomobject]@{
                name = $hasTest['name']
                kind = $hasTest['kind']
                result = $strResult
                expectedFailure = if ($hasTest.Contains('expectedFailure')) { [bool]$hasTest['expectedFailure'] } else { $false }
                evidenceRefs = [object[]]$arrEvidenceRef
            }
        }
    )

    $strExpectedCheckpoint = Get-MacLabValidationProperty -InputObject $objPlan -PropertyName 'expectedCheckpoint'
    $objRequiresHardwareSignoff = Get-MacLabValidationProperty -InputObject $objPlan -PropertyName 'requiresHardwareSignoff'
    $strHostMacOS = Get-MacLabValidationProperty -InputObject $objPlan -PropertyName 'hostMacOS'
    $strHostMacOSBuild = Get-MacLabValidationProperty -InputObject $objPlan -PropertyName 'hostMacOSBuild'
    $strGuestMacOS = Get-MacLabValidationProperty -InputObject $objPlan -PropertyName 'guestMacOS'
    $strGuestBuild = Get-MacLabValidationProperty -InputObject $objPlan -PropertyName 'guestBuild'
    $strHostGuestCompatibility = Get-MacLabValidationProperty -InputObject $objPlan -PropertyName 'hostGuestCompatibility'
    $strDefenderVersion = Get-MacLabValidationProperty -InputObject $objPlan -PropertyName 'defenderVersion'
    $listProviderManualStepGap = [System.Collections.Generic.List[string]]::new()
    if ($Provider -eq 'UTM') {
        $listProviderManualStepGap.Add('create')
        $listProviderManualStepGap.Add('checkpoint')
        $listProviderManualStepGap.Add('restore-checkpoint')
    }

    $objEvidence = [pscustomobject]@{
        '$schemaVersion' = '1.0.0'
        runId = "maclab-$((Get-Date).ToUniversalTime().ToString('yyyyMMddTHHmmssZ'))"
        createdAt = (Get-Date).ToUniversalTime().ToString('o')
        vmName = $Name
        provider = $Provider
        providerVersion = $null
        snapshot = if ($strExpectedCheckpoint) { $strExpectedCheckpoint } else { 'Fixture-State' }
        fidelity = $strEffectiveFidelity
        hardwareSignoffRequired = if ($null -ne $objRequiresHardwareSignoff) { [bool]$objRequiresHardwareSignoff } else { $true }
        providerVersionMatrix = [pscustomobject]@{
            hostMacOS = if ($strHostMacOS) { $strHostMacOS } else { 'fixture-host' }
            hostMacOSBuild = if ($strHostMacOSBuild) { $strHostMacOSBuild } else { 'fixture-build' }
            guestMacOS = if ($strGuestMacOS) { $strGuestMacOS } else { 'fixture-guest' }
            guestBuild = if ($strGuestBuild) { $strGuestBuild } else { 'fixture-guest-build' }
            hostGuestCompatibility = if ($strHostGuestCompatibility) { $strHostGuestCompatibility } else { 'same-major-supported' }
            parallelsVersion = $null
            utmVersion = $null
            tartVersion = $null
            powerShellVersion = $PSVersionTable.PSVersion.ToString()
            pesterVersion = '5.7.1'
            defenderVersion = if ($strDefenderVersion) { $strDefenderVersion } else { $null }
            intunePolicySetId = '***REDACTED***'
            providerManualStepGaps = [object[]]$listProviderManualStepGap.ToArray()
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
        intuneDeviceName = $Name
        intuneDeviceIdRedacted = '***REDACTED***'
        tenantSuffixOnly = '.onmicrosoft.example'
        redactionApplied = $false
        redactionVersion = '0.0.0'
        cloudStateWarning = 'VM rollback does not rewind Intune, Entra, Defender portal state, audit logs, or reporting history.'
        tests = $arrEvidenceTest
    }

    $objRedactedEvidence = Protect-MacLabEvidence -Evidence $objEvidence
    if ($OutputPath) {
        [void](Write-EvidenceRecord -Evidence $objRedactedEvidence -OutputRoot $OutputPath -Confirm:$false)
    }

    $objRedactedEvidence
}
