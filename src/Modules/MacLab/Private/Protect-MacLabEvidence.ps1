function Protect-MacLabEvidence {
    # .SYNOPSIS
    # Redacts sensitive data from macOS lab evidence.
    #
    # .DESCRIPTION
    # Clones nested evidence data, redacts sensitive field names and value
    # shapes, and stamps redaction metadata before evidence is written.
    #
    # .PARAMETER Evidence
    # In-memory evidence object to redact.
    #
    # .PARAMETER AdditionalSensitiveFieldName
    # Additional field names that callers require redacted.
    #
    # .EXAMPLE
    # Protect-MacLabEvidence -Evidence $objEvidence
    # # Returns a redacted clone.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. Redacted evidence clone.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private helper. Positional parameters are not supported.
    #
    [CmdletBinding(PositionalBinding = $false)]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [object]$Evidence,

        [string[]]$AdditionalSensitiveFieldName = @()
    )

    $arrAdditionalSensitiveFieldName = $AdditionalSensitiveFieldName

    function Test-SensitiveFieldName {
        param([string]$FieldName)

        $arrSensitiveFieldName = @(
            'accessToken',
            'bitLockerRecoveryKey',
            'clientSecret',
            'cloudConfigurationId',
            'deviceId',
            'edrDeviceTag',
            'email',
            'entraDeviceId',
            'hardwareUuid',
            'idToken',
            'intuneDeviceId',
            'intunePolicySetId',
            'license',
            'licenseKey',
            'licenseString',
            'localUser',
            'machineGuid',
            'machineId',
            'macAddress',
            'organizationId',
            'orgId',
            'password',
            'personalRecoveryKey',
            'policySetId',
            'recoveryKey',
            'refreshToken',
            'secret',
            'serialNumber',
            'tenantId',
            'tenantIdentifier',
            'token',
            'upn',
            'userName',
            'uuid',
            'vmUuid'
        ) + $arrAdditionalSensitiveFieldName

        foreach ($strSensitiveFieldName in $arrSensitiveFieldName) {
            if ($FieldName -eq $strSensitiveFieldName -or $FieldName -like "*${strSensitiveFieldName}*") {
                return $true
            }
        }

        return $false
    }

    function Protect-StringValue {
        param(
            [string]$Value,
            [string]$FieldName
        )

        if ($FieldName -and (Test-SensitiveFieldName -FieldName $FieldName)) {
            return '***REDACTED***'
        }

        $strValue = $Value
        $arrPattern = @(
            '\beyJ[A-Za-z0-9_-]*\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\b',
            '\b[A-Z0-9]{4}(?:-[A-Z0-9]{4}){5}\b',
            '\b\d{6}(?:-\d{6}){7}\b',
            '\b[0-9A-Fa-f]{2}[:-][0-9A-Fa-f]{2}[:-][0-9A-Fa-f]{2}[:-][0-9A-Fa-f]{2}[:-][0-9A-Fa-f]{2}[:-][0-9A-Fa-f]{2}\b',
            '\b[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}\b',
            '\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b'
        )

        foreach ($strPattern in $arrPattern) {
            $strValue = [regex]::Replace($strValue, $strPattern, '***REDACTED***', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        }

        $strValue = [regex]::Replace($strValue, '/Users/[^/\s]+', '/Users/***REDACTED***')

        if ($strValue.Length -gt 200 -and $strValue -match '^[A-Za-z0-9+/=_-]{200,}$') {
            Write-Warning "Evidence field '${FieldName}' contains a long high-entropy-looking string after redaction review."
        }

        $strValue
    }

    function Protect-Value {
        param(
            [object]$Value,
            [string]$FieldName
        )

        if ($null -eq $Value) {
            return $null
        }

        if ($Value -is [string]) {
            return Protect-StringValue -Value $Value -FieldName $FieldName
        }

        if ($Value -is [System.ValueType]) {
            return $Value
        }

        if ($Value -is [System.Collections.IDictionary]) {
            $hasRedacted = [ordered]@{}
            foreach ($objKey in $Value.Keys) {
                $strKey = [string]$objKey
                $hasRedacted[$strKey] = Protect-Value -Value $Value[$objKey] -FieldName $strKey
            }

            return [pscustomobject]$hasRedacted
        }

        if ($Value -is [System.Collections.IEnumerable]) {
            $arrRedacted = @(
                foreach ($objItem in $Value) {
                    Protect-Value -Value $objItem -FieldName $FieldName
                }
            )
            return , $arrRedacted
        }

        $hasObject = [ordered]@{}
        foreach ($objProperty in $Value.PSObject.Properties) {
            $hasObject[$objProperty.Name] = Protect-Value -Value $objProperty.Value -FieldName $objProperty.Name
        }

        [pscustomobject]$hasObject
    }

    $objRedactedEvidence = Protect-Value -Value $Evidence -FieldName ''
    $objRedactedEvidence | Add-Member -NotePropertyName redactionApplied -NotePropertyValue $true -Force
    $objRedactedEvidence | Add-Member -NotePropertyName redactionVersion -NotePropertyValue '1.0.0' -Force

    $objRedactedEvidence
}
