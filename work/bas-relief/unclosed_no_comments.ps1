$text = Get-Content app_v2.js -Raw
$text = $text -replace '(?s)/\*.*?\*/', ''
$text = $text -replace '//.*', ''
$inSingle = $false
$inDouble = $false
$escape = $false
for ($i = 0; $i -lt $text.Length; $i++) {
    $c = $text[$i]
    if ($escape) { $escape = $false; continue }
    if ($c -eq '\') { $escape = $true; continue }
    
    if ($c -eq "'" -and -not $inDouble) {
        $inSingle = -not $inSingle
    } elseif ($c -eq '"' -and -not $inSingle) {
        $inDouble = -not $inDouble
    }
}
Write-Host "Unclosed Single: $inSingle, Double: $inDouble"
