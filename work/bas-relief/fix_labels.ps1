$path = 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html'
$bytes = [System.IO.File]::ReadAllBytes($path)
$content = [System.Text.Encoding]::UTF8.GetString($bytes)

# 1. Rename PERSPECTIVE_01 -> BAS_MAIN_01 (in onclick and span text)
$content = $content.Replace("openLightbox('BAS_main.jpg', 'PERSPECTIVE_01')", "openLightbox('BAS_main.jpg', 'BAS_MAIN_01')")
$content = $content.Replace(">PERSPECTIVE_01</span>", ">BAS_MAIN_01</span>")

# 2. Rename PRODUCTION_01 -> BAS_ENVIORMENT_04 (span text only, onclick already says BAS_ENV_04)
$content = $content.Replace(">PRODUCTION_01</span>", ">BAS_ENVIORMENT_04</span>")

# 3. Reduce gap for MATERIALITY/02 and PRODUCTION LOG/03: mb-[50px] -> mb-[25px], style margin-bottom 50px -> 25px
# Only target the two section headers (MATERIALITY / 02 and PRODUCTION LOG / 03)
$content = $content.Replace('mb-[50px]" style="margin-bottom: 50px;"', 'mb-[25px]" style="margin-bottom: 25px;"')

$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText($path, $content, $utf8NoBom)
Write-Host "All label and spacing fixes applied!"

# 4. Fix app_v2.js: When BAS_main.jpg is clicked, hide toktokLabel (no name above resolution)
$jsPath = 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\app_v2.js'
$jsBytes = [System.IO.File]::ReadAllBytes($jsPath)
$jsContent = [System.Text.Encoding]::UTF8.GetString($jsBytes)

# Replace the BAS_main.jpg block to hide toktokLabel instead of showing it
$old = "if (actualSrc.includes('BAS_main.jpg')) {`n                if (toktokLabel) {`n                    toktokLabel.style.display = 'block';`n                    toktokLabel.innerHTML = title || 'PERSPECTIVE_01';`n                }"
$new = "if (actualSrc.includes('BAS_main.jpg')) {`n                if (toktokLabel) {`n                    toktokLabel.style.display = 'none';`n                }"

$jsContent = $jsContent.Replace($old, $new)

[System.IO.File]::WriteAllText($jsPath, $jsContent, $utf8NoBom)
Write-Host "JS lightbox label fix applied!"
