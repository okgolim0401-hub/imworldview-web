$lines = Get-Content 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\app.js'
$stack = 0
for ($i=0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    $open = ($line.ToCharArray() | Where-Object { $_ -eq '{' }).Count
    $close = ($line.ToCharArray() | Where-Object { $_ -eq '}' }).Count
    $stack += ($open - $close)
    Write-Host "Line $($i+1): Stack $stack - $line"
}
Write-Host "Final stack: $stack"
