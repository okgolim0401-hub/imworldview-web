$path = 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html'
$html = Get-Content $path -Raw -Encoding UTF8

$target = '<div class="absolute bottom-4 left-4 font-label-mono text-[10px] text-white/30">RESOLUTION: 3840 x 2160</div>'
$replacement = '<div id="lightbox-resolution" class="absolute bottom-4 left-4 font-label-mono text-[10px] text-white/30">RESOLUTION: 3840 x 2160</div>'

$escaped = [regex]::Escape($target).Replace('\r\n', '\r?\n').Replace('\n', '\r?\n')

if ($html -match $escaped) {
    $html = [regex]::Replace($html, $escaped, $replacement)
    [System.IO.File]::WriteAllText($path, $html, [System.Text.Encoding]::UTF8)
    Write-Host "Added ID to resolution text!"
} else {
    Write-Host "Failed to find resolution text."
}
