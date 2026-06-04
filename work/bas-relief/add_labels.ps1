$path = 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html'
$html = Get-Content $path -Raw -Encoding UTF8

$target = '<!-- Hover Text Label Overlay -->'
$replacement = '<!-- Corner Labels -->
                <div class="absolute bottom-1 left-1.5 md:bottom-2 md:left-2 font-label-mono text-[7px] md:text-[8px] text-white/40 tracking-[0.2em] z-30 pointer-events-none transition-opacity duration-300 group-hover/light:opacity-0">
                    TOKTOK SHADOW
                </div>
                <div class="absolute bottom-1 right-1.5 md:bottom-2 md:right-2 font-label-mono text-[7px] md:text-[8px] text-white/20 tracking-[0.2em] z-30 pointer-events-none transition-opacity duration-300 group-hover/light:opacity-0">
                    #MERGE #JOIN
                </div>
                <!-- Hover Text Label Overlay -->'

$count = ([regex]::Matches($html, [regex]::Escape($target))).Count

if ($count -eq 16) {
    $html = $html.Replace($target, $replacement)
    [System.IO.File]::WriteAllText($path, $html, [System.Text.Encoding]::UTF8)
    Write-Host "Success"
} else {
    Write-Host "Failed. Found $count matches."
}
