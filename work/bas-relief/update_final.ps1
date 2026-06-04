$path = 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html'
$html = Get-Content $path -Raw -Encoding UTF8

# Replace the NEXT PROJECT image
$html = $html -replace '\.\./StellarRestomod/3\.jpg', '../StellarRestomod/2.jpg'

# Replace BAS RELIEF with BAS-RELIEF in the h1 tag
$target = 'data-original="BAS RELIEF" data-reveal-delay="300">BAS RELIEF</h1>'
$replacement = 'data-original="BAS-RELIEF" data-reveal-delay="300">BAS-RELIEF</h1>'
$html = $html.Replace($target, $replacement)

[System.IO.File]::WriteAllText($path, $html, [System.Text.Encoding]::UTF8)
Write-Host "Updated next image and title!"
