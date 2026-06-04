$text = Get-Content app.js -Raw
$o = 0
$c = 0
foreach ($char in $text.ToCharArray()) {
    if ($char -eq '{') { $o++ }
    elseif ($char -eq '}') { $c++ }
}
Write-Host "Open: $o, Close: $c"
