function Export-MacLabEvidence {
    # .SYNOPSIS
    # Exports a macOS lab evidence run.
    #
    # .DESCRIPTION
    # Re-runs redaction and exports a portable evidence directory or zip bundle.
    #
    # .PARAMETER Name
    # Optional VM or run name filter.
    #
    # .PARAMETER RunId
    # Optional evidence run identifier.
    #
    # .PARAMETER EvidenceRoot
    # Root folder containing evidence runs.
    #
    # .PARAMETER OutputPath
    # Destination path for the exported evidence bundle.
    #
    # .PARAMETER Format
    # Export format.
    #
    # .PARAMETER RedactSecrets
    # Redacts evidence before export. Defaults to true.
    #
    # .EXAMPLE
    # Export-MacLabEvidence -RunId '2026-05-mms-demo4-001' -OutputPath ./_bundle
    # # Exports the redacted evidence run.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. Bundle metadata.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Positional parameters are not supported.
    #
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low', PositionalBinding = $false)]
    [OutputType([pscustomobject])]
    param(
        [string]$Name,

        [string]$RunId,

        [string]$EvidenceRoot,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputPath,

        [ValidateSet('Directory', 'Zip')]
        [string]$Format = 'Directory',

        [bool]$RedactSecrets = $true
    )

    $null = $RedactSecrets

    if (-not $PSCmdlet.ShouldProcess($OutputPath, 'Export macOS lab evidence')) {
        return
    }

    function Get-EvidenceRunDirectory {
        param(
            [string]$Root,
            [string]$RequestedRunId,
            [string]$RequestedName
        )

        if ($RequestedRunId) {
            $strRequestedRunPath = Join-Path -Path $Root -ChildPath $RequestedRunId
            if (-not (Test-Path -LiteralPath $strRequestedRunPath -PathType Container)) {
                throw "Evidence run '${RequestedRunId}' was not found under ${Root}."
            }

            return $strRequestedRunPath
        }

        $arrRunDirectory = @(Get-ChildItem -LiteralPath $Root -Directory | Sort-Object -Property LastWriteTimeUtc -Descending)
        if ($RequestedName) {
            $arrRunDirectory = @(
                foreach ($objDirectory in $arrRunDirectory) {
                    $strEvidencePath = Join-Path -Path $objDirectory.FullName -ChildPath 'evidence.json'
                    if (-not (Test-Path -LiteralPath $strEvidencePath -PathType Leaf)) {
                        continue
                    }

                    $objEvidence = Get-Content -LiteralPath $strEvidencePath -Raw | ConvertFrom-Json
                    if ($objEvidence.vmName -eq $RequestedName -or $objEvidence.name -eq $RequestedName) {
                        $objDirectory
                    }
                }
            )
        }

        if ($arrRunDirectory.Count -eq 0) {
            throw "No matching evidence runs were found under ${Root}."
        }

        $arrRunDirectory[0].FullName
    }

    function Copy-RedactedEvidenceFile {
        param(
            [string]$SourcePath,
            [string]$DestinationPath
        )

        [void][System.IO.Directory]::CreateDirectory((Split-Path -Path $DestinationPath -Parent))
        $strExtension = [System.IO.Path]::GetExtension($SourcePath)

        if ($strExtension -eq '.json') {
            $objJson = Get-Content -LiteralPath $SourcePath -Raw | ConvertFrom-Json
            $objRedactedJson = Protect-MacLabEvidence -Evidence $objJson
            $strJson = ($objRedactedJson | ConvertTo-Json -Depth 20) -replace "`r`n", "`n"
            [System.IO.File]::WriteAllText($DestinationPath, $strJson + "`n", [System.Text.UTF8Encoding]::new($false))
            return
        }

        $strContent = Get-Content -LiteralPath $SourcePath -Raw
        $objRedactedText = Protect-MacLabEvidence -Evidence ([pscustomobject]@{ content = $strContent })
        [System.IO.File]::WriteAllText($DestinationPath, $objRedactedText.content, [System.Text.UTF8Encoding]::new($false))
    }

    $strEvidenceRoot = if ($EvidenceRoot) {
        $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($EvidenceRoot)
    } else {
        $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath('./evidence')
    }

    if (-not (Test-Path -LiteralPath $strEvidenceRoot -PathType Container)) {
        throw "Evidence root was not found: ${strEvidenceRoot}"
    }

    $strRunDirectory = Get-EvidenceRunDirectory -Root $strEvidenceRoot -RequestedRunId $RunId -RequestedName $Name
    $strResolvedOutputPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputPath)

    if (Test-Path -LiteralPath $strResolvedOutputPath) {
        throw "Output path already exists: ${strResolvedOutputPath}"
    }

    $strBundleDirectory = if ($Format -eq 'Directory') {
        $strResolvedOutputPath
    } else {
        Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath "maclab-evidence-$([System.Guid]::NewGuid().ToString('n'))"
    }
    [void][System.IO.Directory]::CreateDirectory($strBundleDirectory)

    foreach ($objFile in Get-ChildItem -LiteralPath $strRunDirectory -File -Recurse) {
        $strRelativePath = [System.IO.Path]::GetRelativePath($strRunDirectory, $objFile.FullName)
        $strDestinationPath = Join-Path -Path $strBundleDirectory -ChildPath $strRelativePath
        Copy-RedactedEvidenceFile -SourcePath $objFile.FullName -DestinationPath $strDestinationPath
    }

    $arrManifestFile = @(
        foreach ($objFile in Get-ChildItem -LiteralPath $strBundleDirectory -File -Recurse) {
            $strRelativePath = [System.IO.Path]::GetRelativePath($strBundleDirectory, $objFile.FullName)
            [pscustomobject]@{
                path = $strRelativePath
                sha256 = (Get-FileHash -LiteralPath $objFile.FullName -Algorithm SHA256).Hash.ToLowerInvariant()
            }
        }
    )
    $objManifest = [pscustomobject]@{
        bundleCreatedAt = (Get-Date).ToUniversalTime().ToString('o')
        sourceRunDirectory = $strRunDirectory
        redactionApplied = $true
        files = $arrManifestFile
    }
    $strManifestPath = Join-Path -Path $strBundleDirectory -ChildPath 'MANIFEST.json'
    $strManifestJson = ($objManifest | ConvertTo-Json -Depth 10) -replace "`r`n", "`n"
    [System.IO.File]::WriteAllText($strManifestPath, $strManifestJson + "`n", [System.Text.UTF8Encoding]::new($false))

    $strBundlePath = $strBundleDirectory
    if ($Format -eq 'Zip') {
        Compress-Archive -LiteralPath (Join-Path -Path $strBundleDirectory -ChildPath '*') -DestinationPath $strResolvedOutputPath
        $strBundlePath = $strResolvedOutputPath
    }

    [pscustomobject]@{
        BundlePath = $strBundlePath
        RunId = Split-Path -Path $strRunDirectory -Leaf
        RedactionApplied = $true
        BundleSha256 = if ($Format -eq 'Zip') { (Get-FileHash -LiteralPath $strResolvedOutputPath -Algorithm SHA256).Hash.ToLowerInvariant() } else { $null }
        ManifestPath = $strManifestPath
    }
}
