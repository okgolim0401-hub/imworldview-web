$path = 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html'
$html = Get-Content $path -Raw -Encoding UTF8

$badBlock = '<!-- Corner Labels -->
                <div class="absolute bottom-1 left-1.5 md:bottom-2 md:left-2 font-label-mono text-[7px] md:text-[8px] text-white/40 tracking-[0.2em] z-30 pointer-events-none transition-opacity duration-300 group-hover/light:opacity-0">
                    TOKTOK SHADOW
                </div>
                <div class="absolute bottom-1 right-1.5 md:bottom-2 md:right-2 font-label-mono text-[7px] md:text-[8px] text-white/20 tracking-[0.2em] z-30 pointer-events-none transition-opacity duration-300 group-hover/light:opacity-0">
                    #MERGE #JOIN
                </div>
                <!-- Hover Text Label Overlay -->'

$replacement = '<!-- Hover Text Label Overlay -->'

$count = ([regex]::Matches($html, [regex]::Escape($badBlock))).Count
Write-Host "Found $count bad blocks."

if ($count -gt 0) {
    $html = $html.Replace($badBlock, $replacement)
    [System.IO.File]::WriteAllText($path, $html, [System.Text.Encoding]::UTF8)
    Write-Host "Removed bad labels from thumbnails!"
}
