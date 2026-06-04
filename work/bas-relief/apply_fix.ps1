$lines = Get-Content 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html' -Encoding UTF8
$replacement = Get-Content 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\replacement.html' -Encoding UTF8

$prefix = $lines[0..1058]
$suffix = $lines[1072..($lines.Count-1)]

$newLines = @()
$newLines += $prefix
$newLines += $replacement
$newLines += $suffix

[System.IO.File]::WriteAllLines('C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html', $newLines, [System.Text.Encoding]::UTF8)
Write-Host "Successfully rebuilt index.html"
