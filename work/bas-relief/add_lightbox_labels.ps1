$path = 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html'
$html = Get-Content $path -Raw -Encoding UTF8

$target = '            <img id="lightbox-image" src="" alt="" class="max-w-full max-h-[70vh] object-contain block"/>
        </div>'

$replacement = '            <img id="lightbox-image" src="" alt="" class="max-w-full max-h-[70vh] object-contain block"/>
            
            <!-- Corner Labels on Lightbox -->
            <div class="absolute bottom-4 left-4 font-label-mono text-[10px] text-white/50 tracking-widest z-30 pointer-events-none drop-shadow-md">
                TOKTOK SHADOW
            </div>
            <div class="absolute bottom-4 right-4 font-label-mono text-[10px] text-white/30 tracking-widest z-30 pointer-events-none drop-shadow-md">
                #MERGE #JOIN
            </div>
        </div>'

$escaped = [regex]::Escape($target).Replace('\r\n', '\r?\n').Replace('\n', '\r?\n')

if ($html -match $escaped) {
    $html = [regex]::Replace($html, $escaped, $replacement)
    [System.IO.File]::WriteAllText($path, $html, [System.Text.Encoding]::UTF8)
    Write-Host "Injected labels to lightbox!"
} else {
    Write-Host "Failed to find lightbox target."
}
