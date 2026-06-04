$path = 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html'
$html = Get-Content $path -Raw -Encoding UTF8

# 1. Update text
$html = $html -replace 'LIVING FRAGMENTS', 'STELLAR, STILL HERE.'

# 2. Add image to next-image-card
$targetCard = 'id="next-image-card" onclick="location.href=''../StellarRestomod/index.html''">'
$replacementCard = $targetCard + '
                <img src="../StellarRestomod/intro.jpg" alt="Stellar, Still Here" class="absolute inset-0 w-full h-full object-cover opacity-60 group-hover/img-card:opacity-100 transition-opacity duration-700 z-0 pointer-events-none" />'

$html = $html.Replace($targetCard, $replacementCard)

# Also update the null image text to be less prominent or remove it, but it's fine to leave it underneath.
# Actually let's remove the SYSTEM_NODE_04 // [NULL_IMAGE] text so it doesn't overlap the image.
$nullText = '<span class="font-label-mono text-[9px] text-primary tracking-[0.4em] uppercase">SYSTEM_NODE_04 // [NULL_IMAGE]</span>'
$html = $html.Replace($nullText, '')

[System.IO.File]::WriteAllText($path, $html, [System.Text.Encoding]::UTF8)
Write-Host "Updated NEXT PROJECT!"
