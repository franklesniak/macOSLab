function Write-EvidenceRecord {
    # .SYNOPSIS
    # Writes a redacted macOS lab evidence record.
    #
    # .DESCRIPTION
    # Redacts evidence, writes deterministic JSON and summary text, verifies
    # redaction state, and returns file paths plus checksums.
    #
    # .PARAMETER Evidence
    # Redacted evidence object to write.
    #
    # .PARAMETER OutputRoot
    # Root folder where evidence runs are stored.
    #
    # .EXAMPLE
    # Write-EvidenceRecord -Evidence $objEvidence -OutputRoot ./_evidence
    # # Writes redacted evidence.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. Evidence file metadata.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private helper. Positional parameters are not supported.
    #
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low', PositionalBinding = $false)]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [object]$Evidence,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputRoot
    )

    if (-not $PSCmdlet.ShouldProcess($OutputRoot, 'Write macOS lab evidence record')) {
        return
    }

    function Get-EvidencePropertyValue {
        param(
            [object]$InputObject,
            [string]$PropertyName
        )

        if ($null -eq $InputObject) {
            return $null
        }

        $objProperty = $InputObject.PSObject.Properties[$PropertyName]
        if ($objProperty) {
            return $objProperty.Value
        }

        return $null
    }

    $objRedactedEvidence = Protect-MacLabEvidence -Evidence $Evidence

    if (-not (Get-EvidencePropertyValue -InputObject $objRedactedEvidence -PropertyName 'redactionApplied')) {
        throw 'Evidence redaction failed closed because redactionApplied was not true.'
    }

    $strRunId = Get-EvidencePropertyValue -InputObject $objRedactedEvidence -PropertyName 'runId'
    if (-not $strRunId) {
        $strRunId = (Get-Date).ToUniversalTime().ToString('yyyyMMddTHHmmssZ')
        $objRedactedEvidence | Add-Member -NotePropertyName runId -NotePropertyValue $strRunId -Force
    }

    $strOutputRoot = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputRoot)
    $strRunRoot = Join-Path -Path $strOutputRoot -ChildPath $strRunId
    [void][System.IO.Directory]::CreateDirectory($strRunRoot)

    $strEvidencePath = Join-Path -Path $strRunRoot -ChildPath 'evidence.json'
    $strSummaryPath = Join-Path -Path $strRunRoot -ChildPath 'evidence.summary.txt'
    $strProviderVersionMatrixPath = Join-Path -Path $strRunRoot -ChildPath 'provider-version-matrix.json'

    $strEvidenceJson = ($objRedactedEvidence | ConvertTo-Json -Depth 20) -replace "`r`n", "`n"
    [System.IO.File]::WriteAllText($strEvidencePath, $strEvidenceJson + "`n", [System.Text.UTF8Encoding]::new($false))

    $objProviderVersionMatrix = Get-EvidencePropertyValue -InputObject $objRedactedEvidence -PropertyName 'providerVersionMatrix'
    if ($objProviderVersionMatrix) {
        $strMatrixJson = ($objProviderVersionMatrix | ConvertTo-Json -Depth 10) -replace "`r`n", "`n"
        [System.IO.File]::WriteAllText($strProviderVersionMatrixPath, $strMatrixJson + "`n", [System.Text.UTF8Encoding]::new($false))
    }

    $strSummary = @(
        "Run ID: ${strRunId}",
        "Created At: $(Get-EvidencePropertyValue -InputObject $objRedactedEvidence -PropertyName 'createdAt')",
        "VM Name: $(Get-EvidencePropertyValue -InputObject $objRedactedEvidence -PropertyName 'vmName')",
        "Provider: $(Get-EvidencePropertyValue -InputObject $objRedactedEvidence -PropertyName 'provider')",
        "Fidelity: $(Get-EvidencePropertyValue -InputObject $objRedactedEvidence -PropertyName 'fidelity')",
        "Redaction Applied: $(Get-EvidencePropertyValue -InputObject $objRedactedEvidence -PropertyName 'redactionApplied')"
    ) -join "`n"
    [System.IO.File]::WriteAllText($strSummaryPath, $strSummary + "`n", [System.Text.UTF8Encoding]::new($false))

    [pscustomobject]@{
        RunId = $strRunId
        RunRoot = $strRunRoot
        EvidencePath = $strEvidencePath
        SummaryPath = $strSummaryPath
        ProviderVersionMatrixPath = if (Test-Path -LiteralPath $strProviderVersionMatrixPath -PathType Leaf) { $strProviderVersionMatrixPath } else { $null }
        EvidenceSha256 = (Get-FileHash -LiteralPath $strEvidencePath -Algorithm SHA256).Hash.ToLowerInvariant()
        SummarySha256 = (Get-FileHash -LiteralPath $strSummaryPath -Algorithm SHA256).Hash.ToLowerInvariant()
        RedactionApplied = $true
    }
}
