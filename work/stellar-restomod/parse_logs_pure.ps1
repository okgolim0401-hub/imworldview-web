$logPath = "C:\Users\PC\.gemini\antigravity\brain\b9d00a28-3c74-4dcb-897d-7f8c2a796992\.system_generated\logs\transcript.jsonl"
$lines = Get-Content -Path $logPath -ErrorAction SilentlyContinue
foreach ($line in $lines) {
    if ($line.Contains('"type":"USER_INPUT"')) {
        try {
            $obj = ConvertFrom-Json $line
            Write-Output "$($obj.step_index): $($obj.content)"
            Write-Output "-------------------------"
        } catch {
            # Ignore malformed JSON
        }
    }
}
