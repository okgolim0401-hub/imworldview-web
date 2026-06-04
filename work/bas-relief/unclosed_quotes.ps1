$text = Get-Content app_v2.js -Raw
$inSingle = $false
$inDouble = $false
$inBacktick = $false
$escape = $false
for ($i = 0; $i -lt $text.Length; $i++) {
    $c = $text[$i]
    if ($escape) { $escape = $false; continue }
    if ($c -eq "\") { $escape = $true; continue }
    
    if ($c -eq "'" -and -not $inDouble -and -not $inBacktick) {
        $inSingle = -not $inSingle
    } elseif ($c -eq '"' -and -not $inSingle -and -not $inBacktick) {
        $inDouble = -not $inDouble
    } elseif ($c -eq "`" -and -not $inSingle -and -not $inDouble) {
        $inBacktick = -not $inBacktick
    }
}
Write-Host "Unclosed Single: $inSingle, Double: $inDouble, Backtick: $inBacktick"
