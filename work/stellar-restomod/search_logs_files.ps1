[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$logPath = "C:\Users\PC\.gemini\antigravity\brain\6d720c7c-7cc0-4db1-b2e4-063f87e59e70\.system_generated\logs\overview.txt"
if (-not (Test-Path $logPath)) {
    Write-Host "Log path does not exist"
    Exit
}

$lines = [System.IO.File]::ReadAllLines($logPath, [System.Text.Encoding]::UTF8)
$count = 0
foreach ($line in $lines) {
    $count++
    if ($line.Contains("app.js") -or $line.Contains("index.html") -or $line.Contains("style.css")) {
        $status = "CLEARED"
        if ($line.Contains("CodeContent") -or $line.Contains("ReplacementContent") -or $line.Contains("ReplacementChunks")) {
            $status = "HAS_CONTENT"
        }
        $created = ""
        if ($line -match '"created_at":"([^"]+)"') {
            $created = $Matches[1]
        }
        Write-Host "Line: $count | Time: $created | Status: $status | Length: $($line.Length)"
    }
}
