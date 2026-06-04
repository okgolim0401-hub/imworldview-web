$path = 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html'
$html = Get-Content $path -Raw -Encoding UTF8

$html = $html.Replace('BAS_ENVIORMENT', 'BAS_ENVIORMENT_04')

[System.IO.File]::WriteAllText($path, $html, [System.Text.Encoding]::UTF8)
Write-Host "Appended _04 to BAS_ENVIORMENT!"
