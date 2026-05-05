Set-StrictMode -Version Latest

$script:MacLabModuleRoot = $PSScriptRoot
$script:MacLabExportedFunctionName = @(
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

foreach ($strSourceFolderName in @('Private', 'Providers', 'Public')) {
    $strSourceFolderPath = Join-Path -Path $script:MacLabModuleRoot -ChildPath $strSourceFolderName

    if (-not (Test-Path -LiteralPath $strSourceFolderPath -PathType Container)) {
        throw "Required MacLab source folder was not found: ${strSourceFolderPath}"
    }

    $arrSourceFile = @(
        Get-ChildItem -LiteralPath $strSourceFolderPath -Filter '*.ps1' -File |
            Sort-Object -Property Name
    )

    foreach ($objSourceFile in $arrSourceFile) {
        . $objSourceFile.FullName
    }
}

Export-ModuleMember -Function $script:MacLabExportedFunctionName
