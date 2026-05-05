function Invoke-LoggedCommand {
    # .SYNOPSIS
    # Runs an external command with structured capture.
    #
    # .DESCRIPTION
    # Runs an external command with bounded timeout handling and returns stdout,
    # stderr, exit code, duration, and a redacted display command.
    #
    # .PARAMETER FilePath
    # External executable path.
    #
    # .PARAMETER ArgumentList
    # Argument list to pass to the executable.
    #
    # .PARAMETER TimeoutSeconds
    # Maximum command runtime in seconds.
    #
    # .PARAMETER SensitiveArgumentPattern
    # Optional regex patterns for arguments that must be redacted in logs.
    #
    # .EXAMPLE
    # Invoke-LoggedCommand -FilePath '/usr/bin/sw_vers' -ArgumentList @('-productVersion')
    # # Runs the command and captures structured output.
    #
    # .INPUTS
    # None.
    #
    # .OUTPUTS
    # [pscustomobject]. Command execution record.
    #
    # .NOTES
    # Version: 0.1.20260505.0
    # Private helper. Positional parameters are not supported.
    #
    [CmdletBinding(PositionalBinding = $false)]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$FilePath,

        [string[]]$ArgumentList = @(),

        [ValidateRange(1, 86400)]
        [int]$TimeoutSeconds = 300,

        [string[]]$SensitiveArgumentPattern = @()
    )

    $dateStart = Get-Date
    $arrDisplayArgument = @(
        foreach ($strArgument in $ArgumentList) {
            $boolSensitive = $false
            foreach ($strPattern in $SensitiveArgumentPattern) {
                if ($strArgument -match $strPattern) {
                    $boolSensitive = $true
                }
            }

            if ($boolSensitive) {
                '***REDACTED***'
            } else {
                $strArgument
            }
        }
    )

    $objStartInfo = [System.Diagnostics.ProcessStartInfo]::new()
    $objStartInfo.FileName = $FilePath
    $objStartInfo.UseShellExecute = $false
    $objStartInfo.RedirectStandardOutput = $true
    $objStartInfo.RedirectStandardError = $true

    foreach ($strArgument in $ArgumentList) {
        [void]$objStartInfo.ArgumentList.Add($strArgument)
    }

    $objProcess = [System.Diagnostics.Process]::new()
    $objProcess.StartInfo = $objStartInfo

    try {
        [void]$objProcess.Start()
        $boolExited = $objProcess.WaitForExit($TimeoutSeconds * 1000)

        if (-not $boolExited) {
            $objProcess.Kill($true)
            $objProcess.WaitForExit()
        }

        $strStdout = $objProcess.StandardOutput.ReadToEnd()
        $strStderr = $objProcess.StandardError.ReadToEnd()

        [pscustomobject]@{
            FilePath = $FilePath
            DisplayCommand = (($FilePath, $arrDisplayArgument) -join ' ')
            ExitCode = if ($boolExited) { $objProcess.ExitCode } else { -1 }
            TimedOut = -not $boolExited
            StartedAt = $dateStart.ToUniversalTime().ToString('o')
            DurationMs = [int]((Get-Date) - $dateStart).TotalMilliseconds
            Stdout = $strStdout
            Stderr = $strStderr
        }
    } finally {
        $objProcess.Dispose()
    }
}
