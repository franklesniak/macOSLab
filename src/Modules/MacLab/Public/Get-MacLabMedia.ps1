function Get-MacLabMedia {
    # .SYNOPSIS
    # Discovers and caches pinned macOS media.
    #
    # .DESCRIPTION
    # Uses prepared media when supplied and verified, or invokes mist-cli for
    # live media discovery/download on macOS hosts.
    #
    # .PARAMETER Version
    # macOS marketing version to discover or acquire.
    #
    # .PARAMETER Build
    # Optional macOS build number. When supplied, build is the stronger match key.
    #
    # .PARAMETER Architecture
    # Target architecture. V1 supports arm64.
    #
    # .PARAMETER Source
    # Media source. V1 supports Mist.
    #
    # .PARAMETER ArtifactType
    # Artifact type to discover or acquire.
    #
    # .PARAMETER CacheRoot
    # Local cache root for media metadata and artifacts.
    #
    # .PARAMETER Force
    # Redownload or refresh cached media when implementation is complete.
    #
    # .PARAMETER PreparedArtifactPath
    # Existing restore image or install artifact to verify and reuse.
    #
    # .PARAMETER PreparedArtifactSha256
    # Expected SHA-256 for PreparedArtifactPath.
    #
    # .PARAMETER RedactSecrets
    # Preserves the module-wide evidence posture. Defaults to true.
    #
    # .EXAMPLE
    # Get-MacLabMedia -Version '26.4.1' -Build '25E253'
    # # Discovers or acquires media metadata.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. Media metadata.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Positional parameters are not supported.
    #
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low', PositionalBinding = $false)]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Version,

        [string]$Build,

        [ValidateSet('arm64')]
        [string]$Architecture = 'arm64',

        [ValidateSet('Mist')]
        [string]$Source = 'Mist',

        [ValidateSet('Installer', 'Firmware', 'Both')]
        [string]$ArtifactType = 'Both',

        [string]$CacheRoot = '~/Demo/Installers',

        [switch]$Force,

        [string]$PreparedArtifactPath,

        [string]$PreparedArtifactSha256,

        [bool]$RedactSecrets = $true
    )

    $null = $Architecture
    $null = $Force
    $null = $RedactSecrets

    if (-not $PSCmdlet.ShouldProcess($Version, 'Discover or cache macOS media')) {
        return
    }

    $strCacheRoot = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($CacheRoot)
    [void][System.IO.Directory]::CreateDirectory($strCacheRoot)

    $strMediaId = if ($Build) { "${Version}-${Build}" } else { $Version }
    $strMetadataPath = Join-Path -Path $strCacheRoot -ChildPath "${strMediaId}.metadata.json"
    $dateAcquired = (Get-Date).ToUniversalTime().ToString('o')
    $arrArtifact = @()
    $arrCommand = @()

    if ($PreparedArtifactPath) {
        $strPreparedArtifactPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($PreparedArtifactPath)

        if (-not (Test-Path -LiteralPath $strPreparedArtifactPath -PathType Leaf)) {
            throw "Prepared artifact was not found: ${strPreparedArtifactPath}"
        }

        $strActualSha256 = (Get-FileHash -LiteralPath $strPreparedArtifactPath -Algorithm SHA256).Hash.ToLowerInvariant()

        if ($PreparedArtifactSha256 -and $strActualSha256 -ne $PreparedArtifactSha256.ToLowerInvariant()) {
            throw "Prepared artifact SHA-256 mismatch for ${strPreparedArtifactPath}."
        }

        $objPreparedFile = Get-Item -LiteralPath $strPreparedArtifactPath
        $arrArtifact += [pscustomobject]@{
            ArtifactType = if ($strPreparedArtifactPath.EndsWith('.ipsw', [System.StringComparison]::OrdinalIgnoreCase)) { 'Firmware' } else { $ArtifactType }
            Path = $strPreparedArtifactPath
            Sha256 = $strActualSha256
            SizeBytes = $objPreparedFile.Length
            Prepared = $true
        }
    } else {
        if (-not $IsMacOS) {
            throw 'mist-cli media acquisition requires macOS. Use -PreparedArtifactPath for fixture or already-downloaded media verification on non-macOS hosts.'
        }

        $objMistCommand = Get-Command -Name mist -ErrorAction SilentlyContinue
        if (-not $objMistCommand) {
            throw 'mist-cli was not found. Install mist before live media acquisition.'
        }

        $strFirmwareName = if ($Build) {
            "UniversalMac_${Version}_${Build}_Restore.ipsw"
        } else {
            "UniversalMac_${Version}_Restore.ipsw"
        }
        $strMistExportPath = Join-Path -Path $strCacheRoot -ChildPath "${strMediaId}.mist-download.json"

        if ($ArtifactType -in @('Firmware', 'Both')) {
            $arrArgument = @(
                'download',
                'firmware',
                $Version,
                '--compatible',
                '--output-directory',
                $strCacheRoot,
                '--firmware-name',
                $strFirmwareName,
                '--export',
                $strMistExportPath,
                '--no-ansi'
            )
            $objCommand = Invoke-LoggedCommand -FilePath $objMistCommand.Source -ArgumentList $arrArgument -TimeoutSeconds 21600
            $arrCommand += $objCommand

            if ($objCommand.ExitCode -ne 0 -or $objCommand.TimedOut) {
                throw "mist firmware download failed. Exit code: $($objCommand.ExitCode)."
            }

            $strFirmwarePath = Join-Path -Path $strCacheRoot -ChildPath $strFirmwareName
            if (-not (Test-Path -LiteralPath $strFirmwarePath -PathType Leaf)) {
                throw "mist reported success but expected firmware was not found: ${strFirmwarePath}"
            }

            $objFirmwareFile = Get-Item -LiteralPath $strFirmwarePath
            $arrArtifact += [pscustomobject]@{
                ArtifactType = 'Firmware'
                Path = $strFirmwarePath
                Sha256 = (Get-FileHash -LiteralPath $strFirmwarePath -Algorithm SHA256).Hash.ToLowerInvariant()
                SizeBytes = $objFirmwareFile.Length
                Prepared = $false
            }
        }

        if ($ArtifactType -in @('Installer', 'Both')) {
            $strInstallerExportPath = Join-Path -Path $strCacheRoot -ChildPath "${strMediaId}.mist-installers.json"
            $objCommand = Invoke-LoggedCommand -FilePath $objMistCommand.Source -ArgumentList @('list', 'installer', '--compatible', '--export', $strInstallerExportPath, '--no-ansi') -TimeoutSeconds 900
            $arrCommand += $objCommand
        }
    }

    $objMetadata = [pscustomobject]@{
        MediaId = $strMediaId
        Version = $Version
        Build = $Build
        Architecture = $Architecture
        Source = $Source
        ArtifactType = $ArtifactType
        CacheRoot = $strCacheRoot
        AcquiredAt = $dateAcquired
        MetadataJsonPath = $strMetadataPath
        Artifacts = $arrArtifact
        Commands = @($arrCommand | ForEach-Object {
                [pscustomobject]@{
                    DisplayCommand = $_.DisplayCommand
                    ExitCode = $_.ExitCode
                    TimedOut = $_.TimedOut
                    DurationMs = $_.DurationMs
                }
            })
    }

    $strJson = $objMetadata | ConvertTo-Json -Depth 8
    [System.IO.File]::WriteAllText($strMetadataPath, $strJson, [System.Text.UTF8Encoding]::new($false))

    $objMetadata
}
