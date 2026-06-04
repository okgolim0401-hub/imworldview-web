$path = 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html'
$content = Get-Content $path -Raw -Encoding UTF8

$ko_01 = Get-Content 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\ko_01.txt' -Raw -Encoding UTF8
$ko_02 = Get-Content 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\ko_02.txt' -Raw -Encoding UTF8
$ko_03 = Get-Content 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\ko_03.txt' -Raw -Encoding UTF8

# The mobile-ko-text blocks are somewhat mangled, so we use a loose regex to capture everything inside the <p class="...">...</p>
$content = [regex]::Replace($content, '(?s)(<span[^>]*data-original="OVERVIEW / 01"[^>]*>.*?<p class="[^"]*mobile-ko-text[^"]*">)(.*?)(</p>)', "`${1}`n      $ko_01`n    `${3}")
$content = [regex]::Replace($content, '(?s)(<span[^>]*data-original="MATERIALITY / 02"[^>]*>.*?<p class="[^"]*mobile-ko-text[^"]*">)(.*?)(</p>)', "`${1}`n      $ko_02`n    `${3}")
$content = [regex]::Replace($content, '(?s)(<span[^>]*data-original="PRODUCTION LOG / 03"[^>]*>.*?<p class="[^"]*mobile-ko-text[^"]*">)(.*?)(</p>)', "`${1}`n      $ko_03`n    `${3}")

Set-Content $path $content -Encoding UTF8
Write-Host "Texts injected successfully!"
