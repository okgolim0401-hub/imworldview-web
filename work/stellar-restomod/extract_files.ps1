[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$logPath = "C:\Users\PC\.gemini\antigravity\brain\5592fa48-9ab7-48a5-bab8-b7658585e462\.system_generated\logs\overview.txt"
$logContent = [System.IO.File]::ReadAllText($logPath, [System.Text.Encoding]::UTF8)

$lines = $logContent -split "`n"
$i = 0
foreach ($line in $lines) {
    $i++
    if ([string]::IsNullOrWhiteSpace($line)) { continue }
    try {
        $json = ConvertFrom-Json -InputObject $line.Trim() -ErrorAction SilentlyContinue
        if ($json -ne $null -and $json.tool_calls -ne $null) {
            foreach ($tc in $json.tool_calls) {
                if ($tc.name -eq "write_to_file" -or $tc.name -eq "replace_file_content" -or $tc.name -eq "multi_replace_file_content") {
                    $target = $tc.args.TargetFile
                    $content = $tc.args.CodeContent
                    if ($content -eq $null) {
                        $content = $tc.args.ReplacementContent
                    }
                    if ($content -ne $null -and ($target -like "*index.html*" -or $target -like "*style.css*")) {
                        $basename = [System.IO.Path]::GetFileName($target).Replace('"', '')
                        $outPath = "restored_${basename}_line_${i}.txt"
                        [System.IO.File]::WriteAllText($outPath, $content, [System.Text.Encoding]::UTF8)
                        Write-Host "SUCCESS: Saved $basename content (Length: $($content.Length)) from Line $i to $outPath"
                    }
                }
            }
        }
    } catch {
        # Silent ignore
    }
}
