$path = 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\app_v2.js'
$bytes = [System.IO.File]::ReadAllBytes($path)
$content = [System.Text.Encoding]::UTF8.GetString($bytes)

# Add specLabel hide in closeLightbox
$target = "currentLightboxIndex = -1;`r`n`r`n        setTimeout"
$replacement = "currentLightboxIndex = -1;`r`n        const specLabel = document.getElementById('lightbox-spec-label');`r`n        if (specLabel) specLabel.style.display = 'none';`r`n`r`n        setTimeout"
$content = $content.Replace($target, $replacement)

$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText($path, $content, $utf8NoBom)
Write-Host "closeLightbox specLabel hide added!"
