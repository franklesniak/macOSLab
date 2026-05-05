# Media.Tests.ps1

BeforeAll {
    $script:strTestRoot = $PSScriptRoot
    $script:strRepositoryRoot = Split-Path -Path $script:strTestRoot -Parent
    $script:strModuleManifestPath = Join-Path -Path $script:strRepositoryRoot -ChildPath 'src/Modules/MacLab/MacLab.psd1'
    $script:strRestoreScriptPath = Join-Path -Path $script:strRepositoryRoot -ChildPath 'scripts/Get-MacOSRestoreImage.ps1'

    Import-Module -Name $script:strModuleManifestPath -Force
}

Describe 'Get-MacLabMedia prepared artifact path' {
    BeforeEach {
        $script:strTempRoot = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath ([System.Guid]::NewGuid().ToString())
        [void][System.IO.Directory]::CreateDirectory($script:strTempRoot)
        $script:strArtifactPath = Join-Path -Path $script:strTempRoot -ChildPath 'UniversalMac_26.4.1_25E253_Restore.ipsw'
        [System.IO.File]::WriteAllText($script:strArtifactPath, 'synthetic ipsw fixture', [System.Text.UTF8Encoding]::new($false))
        $script:strArtifactSha256 = (Get-FileHash -LiteralPath $script:strArtifactPath -Algorithm SHA256).Hash.ToLowerInvariant()
        $script:strCacheRoot = Join-Path -Path $script:strTempRoot -ChildPath 'cache'
    }

    AfterEach {
        if (Test-Path -LiteralPath $script:strTempRoot) {
            Remove-Item -LiteralPath $script:strTempRoot -Recurse -Force
        }
    }

    It 'Returns deterministic metadata and writes a metadata sidecar' {
        $objMetadata = Get-MacLabMedia -Version '26.4.1' -Build '25E253' -ArtifactType Firmware -CacheRoot $script:strCacheRoot -PreparedArtifactPath $script:strArtifactPath -PreparedArtifactSha256 $script:strArtifactSha256

        $objMetadata.MediaId | Should -Be '26.4.1-25E253'
        $objMetadata.Artifacts[0].Prepared | Should -BeTrue
        $objMetadata.Artifacts[0].Sha256 | Should -Be $script:strArtifactSha256
        Test-Path -LiteralPath $objMetadata.MetadataJsonPath -PathType Leaf | Should -BeTrue
    }

    It 'Fails closed when the prepared artifact checksum does not match' {
        {
            Get-MacLabMedia -Version '26.4.1' -Build '25E253' -ArtifactType Firmware -CacheRoot $script:strCacheRoot -PreparedArtifactPath $script:strArtifactPath -PreparedArtifactSha256 '0000000000000000000000000000000000000000000000000000000000000000'
        } | Should -Throw -ExpectedMessage '*SHA-256 mismatch*'
    }

    It 'Allows the restore-image script to reuse prepared media' {
        $objMetadata = & $script:strRestoreScriptPath -Version '26.4.1' -Build '25E253' -CacheRoot $script:strCacheRoot -PreparedArtifactPath $script:strArtifactPath -PreparedArtifactSha256 $script:strArtifactSha256

        $objMetadata.Artifacts[0].ArtifactType | Should -Be 'Firmware'
        $objMetadata.Artifacts[0].Prepared | Should -BeTrue
    }
}
