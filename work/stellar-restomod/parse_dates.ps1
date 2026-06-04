[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$logPath = "C:\Users\PC\.gemini\antigravity\brain\6d720c7c-7cc0-4db1-b2e4-063f87e59e70\.system_generated\logs\overview.txt"
if (-not (Test-Path $logPath)) {
    Write-Host "Log path does not exist"
    Exit
}

$lines = [System.IO.File]::ReadAllLines($logPath, [System.Text.Encoding]::UTF8)
$groups = @{}
$i = 0
foreach ($line in $lines) {
    $i++
    if ($line -match '"created_at":"([^"]+)"') {
        $date = $Matches[1].Substring(0, 10)
        if (-not $groups.ContainsKey($date)) {
            $groups[$date] = [System.Collections.Generic.List[int]]::new()
        }
        $groups[$date].Add($i)
    }
}

foreach ($key in $groups.Keys) {
    $list = $groups[$key]
    Write-Host "Date: $key | Count: $($list.Count) | Line Range: $($list[0]) to $($list[-1])"
}
