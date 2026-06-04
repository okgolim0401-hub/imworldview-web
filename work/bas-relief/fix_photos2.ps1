$path = 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html'
$content = Get-Content $path -Raw -Encoding UTF8

# Fix the photos (remove the bottom right labels for Bas_test 04-09)
$content = [regex]::Replace($content, '(?s)\s*<div class="absolute bottom-2 md:bottom-6 right-2 md:right-6 bg-black/80 backdrop-blur-sm[^>]*onclick="openLightbox\(''Bas_test_0[4-9]\.png''.*?</div>', '')

# Fix the BAS_ENVIORMENT label
$content = [regex]::Replace($content, 'BAS_ENVIORMENT', 'BAS_ENV_04')
$content = [regex]::Replace($content, '(?<=onclick="openLightbox\(''Bas_Env\.jpg'', '')[^'']*(?=''\)")', 'BAS_ENV_04')

Set-Content $path $content -Encoding UTF8
Write-Host "Photos fixed successfully."
