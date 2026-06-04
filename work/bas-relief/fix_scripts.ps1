$html = Get-Content 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html' -Raw -Encoding UTF8

# Remove three.js scripts
$html = $html -replace '(?s)<script src="https://cdn\.jsdelivr\.net/npm/three@0\.128\.0/.*?</script>\r?\n', ''

# Replace app.js and add closing div for footer-glow-wrapper
$html = $html -replace '<script src="app\.js\?v=1\.2\.5"></script>', "</div>`n<script src=`"app.js?v=1.7.2`"></script>"

[System.IO.File]::WriteAllText('C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html', $html, [System.Text.Encoding]::UTF8)
Write-Host "Fixed scripts and tags!"
