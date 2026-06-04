[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$logPath = "C:\Users\PC\.gemini\antigravity\brain\6d720c7c-7cc0-4db1-b2e4-063f87e59e70\.system_generated\logs\overview.txt"
if (-not (Test-Path $logPath)) {
    Write-Host "Log path does not exist"
    Exit
}

$lines = [System.IO.File]::ReadAllLines($logPath, [System.Text.Encoding]::UTF8)

for ($i = 295; $i -lt 405; $i++) {
    $ln = $i + 1
    $line = $lines[$i]
    if ([string]::IsNullOrWhiteSpace($line)) { continue }
    
    try {
        $json = ConvertFrom-Json -InputObject $line.Trim() -ErrorAction SilentlyContinue
        if ($json -ne $null) {
            $createdAt = $json.created_at
            if ($json.tool_calls -ne $null) {
                foreach ($tc in $json.tool_calls) {
                    if ($tc.name -eq "write_to_file" -or $tc.name -eq "replace_file_content" -or $tc.name -eq "multi_replace_file_content") {
                        $target = $tc.args.TargetFile
                        $len = 0
                        if ($tc.args.CodeContent -ne $null) {
                            $len = $tc.args.CodeContent.Length
                        } elseif ($tc.args.ReplacementContent -ne $null) {
                            $len = $tc.args.ReplacementContent.Length
                        } elseif ($tc.args.ReplacementChunks -ne $null) {
                            $len = $tc.args.ReplacementChunks.Count
                        }
                        Write-Host "Line: $ln | Time: $createdAt | Tool: $($tc.name) | Target: $target | Size/Count: $len"
                    }
                }
            }
        }
    } catch {
        # Ignore
    }
}
