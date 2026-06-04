$path = 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html'
$html = Get-Content $path -Raw -Encoding UTF8

$target = '            <!-- Corner Labels on Lightbox -->
            <div class="absolute bottom-4 left-4 font-label-mono text-[10px] text-white/50 tracking-widest z-30 pointer-events-none drop-shadow-md">
                TOKTOK SHADOW
            </div>
            <div class="absolute bottom-4 right-4 font-label-mono text-[10px] text-white/30 tracking-widest z-30 pointer-events-none drop-shadow-md">
                #MERGE #JOIN
            </div>'

$replacement = '            <!-- Corner Labels on Lightbox -->
            <div id="lightbox-toktok-label" class="absolute bottom-4 left-4 font-label-mono text-[10px] text-white/50 tracking-widest z-30 pointer-events-none drop-shadow-md">
                TOKTOK SHADOW
            </div>
            <div id="lightbox-merge-label" class="absolute bottom-4 right-4 font-label-mono text-[10px] text-white/30 tracking-widest z-30 pointer-events-none drop-shadow-md">
                #MERGE #JOIN
            </div>'

$escaped = [regex]::Escape($target).Replace('\r\n', '\r?\n').Replace('\n', '\r?\n')

if ($html -match $escaped) {
    $html = [regex]::Replace($html, $escaped, $replacement)
    [System.IO.File]::WriteAllText($path, $html, [System.Text.Encoding]::UTF8)
    Write-Host "Added IDs to lightbox labels!"
} else {
    Write-Host "Failed to find lightbox labels block."
}
