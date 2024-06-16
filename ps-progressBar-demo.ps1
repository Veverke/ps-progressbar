param (
    [int] $timeoutInSecs
)

$job = Start-Job -ScriptBlock { 
    for ($i = 0; $i -lt 5; $i++)
    {
        Start-Sleep -s 1
    }

    return "myResult"
}

function GetTimeStamp {
    return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
}

function writeProgress
{
    param(
        $job,
        [string]    $activityName,
        [string]    $progressText,
        [bool]      $clearHost,
        [int]       $timeoutInSecs
    )

    $timeoutJob = Start-Job -ScriptBlock { Start-Sleep -Seconds $using:timeoutInSecs }
    
    Write-Host "$(GetTimeStamp) Job timeout in secs: [$timeoutInSecs]"
    while(($job.State -eq "Running") -and ($timeoutJob.State -ne "Completed"))
    {
        if ($clearHost)
        {
            Clear-Host
        }

        Write-Host -NoNewline "$progressText "
        Start-Sleep -s 0.5
        Write-Host  -NoNewline "."
        Start-Sleep -s 0.5
        Write-Host  -NoNewline "."
        Start-Sleep -s 0.5
        Write-Host  -NoNewline "."
        Start-Sleep -s 0.5
        if (!$clearHost)
        {
            Write-Host  -NoNewline "`r"
        }
    }
    
    Write-Host
    if ($job.State -ne "Running")
    {
        Write-Host "$(GetTimeStamp) ----------------------------[$activityName completed]----------------------------"
    }
    else {
        Write-Warning "$(GetTimeStamp) ----------------------------[$activityName aborted due allowed [${timeoutInSecs}] timeout in secs expiring]----------------------------"
    }
}

writeProgress $job "my job" "doing job" 0 $timeoutInSecs

$result = $job | Receive-Job
Write-Host "Result: [$result]"
