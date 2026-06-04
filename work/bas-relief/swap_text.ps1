$path = 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\app.js'
$js = Get-Content $path -Raw -Encoding UTF8

$target = 'toktokLabel.innerHTML = ''SLS 3D PRINTED NYLON POWDER, XPS FORM<br/>890 x 1520x50 mm'';'
$replacement = 'toktokLabel.innerHTML = ''890 x 1520x50 mm<br/>SLS 3D PRINTED NYLON POWDER, XPS FORM'';'

$js = $js.Replace($target, $replacement)

[System.IO.File]::WriteAllText($path, $js, [System.Text.Encoding]::UTF8)
Write-Host "Swapped lines in app.js!"
