$logPath = "C:\Users\PC\.gemini\antigravity\brain\b9d00a28-3c74-4dcb-897d-7f8c2a796992\.system_generated\logs\transcript.jsonl"
$lines = Get-Content -Path $logPath -ErrorAction SilentlyContinue
foreach ($line in $lines) {
    try {
        $obj = ConvertFrom-Json $line
        if ($obj.step_index -ge 536 -and $obj.step_index -le 642) {
            if ($obj.source -eq "MODEL" -and $obj.type -eq "PLANNER_RESPONSE") {
                Write-Output "Step $($obj.step_index): $($obj.content)"
                Write-Output "-------------------------"
            }
        }
    } catch {}
}
