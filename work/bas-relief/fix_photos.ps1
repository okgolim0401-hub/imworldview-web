$content = Get-Content 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html' -Raw

# Replace the 6 black and white photos (Bas_test_04 to 09) to remove the hover text box and the lightbox click event
$content = [regex]::Replace($content, '(?s)<div class="relative overflow-hidden bg-black">\s*<img alt="PRODUCTION LOG \d+" class="w-full h-auto block" src="Bas_test_0[4-9]\.png"/>\s*<div class="absolute bottom-2[^>]*>.*?</div>\s*</div>', {
    param($m)
    # Return just the wrapper and the image, removing the inner div (the text box)
    # Also we want to ensure the lightbox doesn't trigger on the wrapper, but the wrapper doesn't have the onclick, the inner div did!
    # By removing the inner div, we remove both the text box and the click event.
    $m.Value -replace '(?s)<div class="absolute bottom-2.*</div>', ''
})

# Rename BAS_ENVIORMENT to BAS_ENV_04
$content = $content -replace 'BAS_ENVIORMENT', 'BAS_ENV_04'

Set-Content 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html' $content
