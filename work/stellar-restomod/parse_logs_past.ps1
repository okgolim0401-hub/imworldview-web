$filePath = "app.js"
if (-not (Test-Path $filePath)) {
    Write-Host "app.js DOES NOT EXIST!"
    Exit
}

Write-Host "=== SWEEPING app.js FOR ENCODING CORRUPTIONS ==="
$content = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)
$lines = $content -split "`n"

$corruptCount = 0
$ln = 0
foreach ($line in $lines) {
    $ln++
    # Sweep for classic broken Korean characters and typical encoding artifacts
    if ($line.Contains("諛") -or $line.Contains("踰") -or $line.Contains("€") -or $line.Contains("") -or $line.Contains("ï¿½")) {
        $corruptCount++
        Write-Host "LINE $ln: $($line.Trim())"
    }
}
Write-Host "=== SWEEP COMPLETE. Found: $corruptCount corruptions ==="
