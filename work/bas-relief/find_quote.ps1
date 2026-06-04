$text = Get-Content app_v2.js -Raw
$inSingle = $false
$inDouble = $false
$escape = $false
$lastSinglePos = -1

for ($i = 0; $i -lt $text.Length; $i++) {
    $c = $text[$i]
    if ($escape) { $escape = $false; continue }
    if ($c -eq '\') { $escape = $true; continue }
    
    if ($c -eq "'" -and -not $inDouble) {
        $inSingle = -not $inSingle
        if ($inSingle) { $lastSinglePos = $i }
    } elseif ($c -eq '"' -and -not $inSingle) {
        $inDouble = -not $inDouble
    }
}

if ($inSingle) {
    $line = 1
    for ($j = 0; $j -lt $lastSinglePos; $j++) {
        if ($text[$j] -eq "`n") { $line++ }
    }
    Write-Host "Unclosed Single Quote starting at Line: $line"
} else {
    Write-Host "No unclosed single quote."
}
