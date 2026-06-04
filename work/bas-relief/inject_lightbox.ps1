$path = 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html'
$content = Get-Content $path -Raw -Encoding UTF8

$lightboxHtml = @"
<div id="lightbox-modal" class="fixed inset-0 z-[100] pointer-events-none opacity-0 transition-opacity duration-500">
    <div class="absolute inset-0 bg-black/90 backdrop-blur-sm"></div>
    <div class="absolute inset-0 pointer-events-none border border-white/5 m-8">
        <div id="lightbox-toktok-label" class="absolute bottom-8 left-4 font-label-mono text-[10px] text-white/50 tracking-widest z-30 pointer-events-none drop-shadow-md">TOKTOK SHADOW</div>
        <div id="lightbox-merge-label" class="absolute bottom-4 right-4 font-label-mono text-[10px] text-white/30 tracking-widest z-30 pointer-events-none drop-shadow-md">#MERGE #JOIN</div>
        <div class="absolute bottom-4 left-4 font-label-mono text-[10px] text-white/30">RESOLUTION: <span id="lightbox-resolution"></span></div>
        <div class="absolute bottom-8 right-4 font-label-mono text-[10px] text-white/30">ARCHIVE SYSTEM v1.0.8</div>
    </div>
    
    <button id="lightbox-close" class="absolute top-12 right-12 z-50 font-label-mono text-[12px] text-white/60 hover:text-white border border-white/20 hover:border-white px-4 py-2 bg-black/50 transition-all duration-300">
        CLOSE [ESC]
    </button>
    
    <div class="relative w-full h-full flex flex-col justify-center items-center gap-6 transform scale-95 opacity-0 transition-all duration-500 ease-out p-12 md:p-24" id="lightbox-content">
        <div class="relative p-2 border border-white/10 bg-black/40">
            <div class="absolute -top-[1px] -left-[1px] w-2 h-2 border-t border-l border-white"></div>
            <div class="absolute -top-[1px] -right-[1px] w-2 h-2 border-t border-r border-white"></div>
            <div class="absolute -bottom-[1px] -left-[1px] w-2 h-2 border-b border-l border-white"></div>
            <div class="absolute -bottom-[1px] -right-[1px] w-2 h-2 border-b border-r border-white"></div>
            <img id="lightbox-image" src="" alt="" class="max-w-[90vw] max-h-[85vh] object-contain block"/>
        </div>
    </div>
</div>
"@

$content = $content -replace '(?s)<script src="app_v2.js"></script>', "$lightboxHtml`n<script src=`"app_v2.js`"></script>"

Set-Content $path $content -Encoding UTF8
Write-Host "Lightbox injected!"
