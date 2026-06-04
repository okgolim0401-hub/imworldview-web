$logPath = "C:\Users\PC\.gemini\antigravity\brain\6d720c7c-7cc0-4db1-b2e4-063f87e59e70\.system_generated\logs\overview.txt"
$lines = Get-Content -Path $logPath -Encoding utf8
$count = 0
foreach ($line in $lines) {
    $count++
    if ($count -gt 505) { break }
    if ($line -like "*replace_file_content*" -or $line -like "*write_to_file*" -or $line -like "*multi_replace_file_content*") {
        Write-Host "============================="
        Write-Host "LINE: $count"
        Write-Host $line.Substring(0, [Math]::Min(1500, $line.Length))
    }
}
