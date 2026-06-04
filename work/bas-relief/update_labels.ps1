$path = 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html'
$html = Get-Content $path -Raw -Encoding UTF8

$html = $html.Replace('PERSPECTIVE_01', 'BAS_MAIN_01')
$html = $html.Replace('SIDE_02', 'BAS_DETAIL_02')
$html = $html.Replace('REAR_QUATER_03', 'BAS_DETAIL_03')
$html = $html.Replace('PRODUCTION_01', 'BAS_ENVIORMENT')

[System.IO.File]::WriteAllText($path, $html, [System.Text.Encoding]::UTF8)
Write-Host "Replaced all text labels!"
