$path = 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html'
$content = Get-Content $path -Raw -Encoding UTF8

# 1. Add INSTALLATION under INDUSTRY
$industry_target = '<span class="font-label-mono text-\[10px\] sm:text-\[13px\] text-outline uppercase tracking-\[0\.2em\] scramble-text" data-reveal-delay="3000">INDUSTRY</span>'
$installation_span = "`n                <span class=`"font-label-mono text-[14px] sm:text-[18px] md:text-[20px] text-primary uppercase font-bold tracking-tight scramble-text`" data-original=`"INSTALLATION`" data-reveal-delay=`"3000`">INSTALLATION</span>"
$content = [regex]::Replace($content, $industry_target, "$industry_target$installation_span")

# 2. Swap Lightbox Label and Resolution Order
# Currently: 
# <div id="lightbox-toktok-label" class="absolute bottom-4 left-4 ...">
# <div id="lightbox-merge-label" class="absolute bottom-4 right-4 ...">
# <div class="absolute bottom-8 left-4 font-label-mono text-[10px] text-white/30">RESOLUTION: <span id="lightbox-resolution"></span></div>
$content = [regex]::Replace($content, 'id="lightbox-toktok-label" class="absolute bottom-4', 'id="lightbox-toktok-label" class="absolute bottom-8')
$content = [regex]::Replace($content, '<div class="absolute bottom-8 left-4([^>]*>RESOLUTION: <span id="lightbox-resolution">)', '<div class="absolute bottom-4 left-4$1')

Set-Content $path $content -Encoding UTF8
Write-Host "Final tweaks applied!"
