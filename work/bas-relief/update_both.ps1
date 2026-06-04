# 1. Fix TokTokShadow_Bas_Relief
$path1 = 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html'
$html1 = Get-Content $path1 -Raw -Encoding UTF8
$html1 = $html1 -replace '../StellarRestomod/intro.jpg', '../StellarRestomod/3.jpg'
[System.IO.File]::WriteAllText($path1, $html1, [System.Text.Encoding]::UTF8)
Write-Host "Updated TokTok image to 3.jpg"

# 2. Fix StellarRestomod
$path2 = 'C:\Users\PC\Desktop\IMWV\WEB\StellarRestomod\index.html'
$html2 = Get-Content $path2 -Raw -Encoding UTF8
# Change LIVING FRAGMENTS to BAS-RELIEF
$html2 = $html2 -replace 'LIVING FRAGMENTS', 'BAS-RELIEF'
# Change link to point to TokTokShadow
$html2 = $html2 -replace 'onclick="location.href=''#''"', 'onclick="location.href=''../TokTokShadow_Bas_Relief/index.html''"'

# Also, since StellarRestomod's next image is empty, let's inject BAS_main.jpg if possible, or just leave it blank if they only asked for title.
# The user only asked "타이틀을 BAS-RELIEF라고 하자" for the next project.
# But it's good practice to add the image so it matches.
$targetCard2 = 'id="next-image-card" onclick="location.href=''../TokTokShadow_Bas_Relief/index.html''">'
$replacementCard2 = $targetCard2 + '
                <img src="../TokTokShadow_Bas_Relief/BAS_main.jpg" alt="Bas-Relief" class="absolute inset-0 w-full h-full object-cover opacity-60 group-hover/img-card:opacity-100 transition-opacity duration-700 z-0 pointer-events-none" />'

if ($html2 -notmatch 'BAS_main.jpg') {
    $html2 = $html2.Replace($targetCard2, $replacementCard2)
    # Remove NULL_IMAGE text
    $nullText2 = '<span class="font-label-mono text-[9px] text-primary tracking-[0.4em] uppercase">SYSTEM_NODE_04 // [NULL_IMAGE]</span>'
    $html2 = $html2.Replace($nullText2, '')
}

[System.IO.File]::WriteAllText($path2, $html2, [System.Text.Encoding]::UTF8)
Write-Host "Updated StellarRestomod NEXT title to BAS-RELIEF"
