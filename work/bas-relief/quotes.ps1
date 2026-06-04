$text = Get-Content app_v2.js -Raw
$s = 0; $d = 0; $b = 0
foreach ($char in $text.ToCharArray()) {
    if ($char -eq "'") { $s++ }
    elseif ($char -eq '"') { $d++ }
    elseif ($char -eq '`') { $b++ }
}
Write-Host "Single: $s, Double: $d, Backtick: $b"
