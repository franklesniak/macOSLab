@{
    RootModule = 'MacLab.psm1'
    ModuleVersion = '0.1.0'
    GUID = '4d6748ba-859d-4171-9785-889eaabdb048'
    Author = 'Frank Lesniak'
    CompanyName = 'Frank Lesniak'
    Copyright = '(c) 2026 Frank Lesniak. MIT License.'
    Description = 'Reproducible Apple-silicon macOS VM lab for risk-free Intune policy testing. Pin macOS media, build snapshots, enroll, validate FileVault/Defender/PPPC/Gatekeeper, fail safely, roll back, and export redacted evidence.'
    PowerShellVersion = '7.4'
    CompatiblePSEditions = @('Core')
    FunctionsToExport = @(
        'Get-MacLabMedia',
        'New-MacLabVm',
        'Get-MacLabVm',
        'Start-MacLabVm',
        'Stop-MacLabVm',
        'Checkpoint-MacLabVm',
        'Restore-MacLabVmCheckpoint',
        'Remove-MacLabVm',
        'Invoke-MacPolicyValidation',
        'Export-MacLabEvidence'
    )
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('macOS', 'Intune', 'PowerShell', 'Parallels', 'UTM', 'Evidence')
            LicenseUri = 'https://github.com/franklesniak/macOSLab/blob/HEAD/LICENSE'
            ProjectUri = 'https://github.com/franklesniak/macOSLab'
        }
    }
}
