$job = Start-Job -ScriptBlock { 
    for ($i = 0; $i -lt 5; $i++)
    {
        Start-Sleep -s 1
    }

    return "myResult"
}

writeProgress $job "my job" "doing job" 0

$result = $job | Receive-Job
Write-Host "Result: [$result]"

function writeProgress
{
    param(
        $job,
        [string] $activityName,
        [string] $progressText,
        [bool] $clearHost
    )

    while($job.State -eq "Running")
    {

        if ($clearHost)
        {
            Clear-Host
        }

        Write-Host -NoNewline "$progressText "
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
    Write-Host "----------------------------[$activityName completed]----------------------------"
}
