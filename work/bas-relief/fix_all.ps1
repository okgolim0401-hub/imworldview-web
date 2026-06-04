$path = 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html'

# Read as raw bytes, decode as UTF-8
$bytes = [System.IO.File]::ReadAllBytes($path)
# Skip BOM if present
$startIndex = 0
if ($bytes.Length -ge 3 -and $bytes[0] -eq 239 -and $bytes[1] -eq 187 -and $bytes[2] -eq 191) {
    $startIndex = 3
}
$content = [System.Text.Encoding]::UTF8.GetString($bytes, $startIndex, $bytes.Length - $startIndex)

# 1. Fix Korean text - read from .txt files (these were saved correctly)
$ko_01 = [System.IO.File]::ReadAllText('C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\ko_01.txt', [System.Text.Encoding]::UTF8).Trim()
$ko_02 = [System.IO.File]::ReadAllText('C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\ko_02.txt', [System.Text.Encoding]::UTF8).Trim()
$ko_03 = [System.IO.File]::ReadAllText('C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\ko_03.txt', [System.Text.Encoding]::UTF8).Trim()

# Replace Korean text blocks using regex - match mobile-ko-text <p> blocks
# Pattern: find <p ...mobile-ko-text...> followed by content until </p>
$sections = @('OVERVIEW / 01', 'MATERIALITY / 02', 'PRODUCTION LOG / 03')
$koTexts = @($ko_01, $ko_02, $ko_03)

for ($i = 0; $i -lt 3; $i++) {
    $section = [regex]::Escape($sections[$i])
    $pattern = "(?s)(data-original=`"$section`".*?<p class=`"[^`"]*mobile-ko-text[^`"]*`">)\s*(.*?)\s*(</p>)"
    $replacement = "`${1}`n      $($koTexts[$i])`n    `${3}"
    $content = [regex]::Replace($content, $pattern, $replacement, [System.Text.RegularExpressions.RegexOptions]::None)
}

# 2. Fix Stellar text boxes - rename SIDE_02 to BAS_DETAIL_01, REAR_QUATER_03 to BAS_DETAIL_02
$content = $content -replace "openLightbox\('BAS_detail_1\.jpg', 'SIDE_02'\)", "openLightbox('BAS_detail_1.jpg', 'BAS_DETAIL_01')"
$content = $content -replace '>SIDE_02</span>', '>BAS_DETAIL_01</span>'
$content = $content -replace "openLightbox\('BAS_detail_2\.jpg', 'REAR_QUATER_03'\)", "openLightbox('BAS_detail_2.jpg', 'BAS_DETAIL_02')"
$content = $content -replace '>REAR_QUATER_03</span>', '>BAS_DETAIL_02</span>'

# 3. Write back as UTF-8 WITHOUT BOM
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText($path, $content, $utf8NoBom)

Write-Host "Done! Korean text restored, labels fixed, UTF-8 no BOM."
