$job = Start-Job -ScriptBlock { 
    for ($i = 0; $i -lt 3; $i++)
    {
        Start-Sleep -s 1
    }
}

writeProgress $job "my job" "doing job" 0

function writeProgress
{
    param(
        $job,
        [string] $activityName,
        [string] $progressText,
        [bool] $clearHost
    )

    while($job.State -ne "Completed")
    {

        if ($clearHost)
        {
            Clear-Host
        }

        Write-Host -NoNewline "$progressText ."    

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
