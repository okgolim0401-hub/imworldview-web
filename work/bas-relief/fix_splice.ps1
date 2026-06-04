$path = 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html'
$html = Get-Content $path -Raw -Encoding UTF8

$bad_chunk = '                        <span class="font-label-mono text-[8px] md:text-[10px] text-primary tracking-widest uppercase transition-colors duration-300 leading-none md:leading-normal">SIDE_02</span>
    
            </div>
            <p class="font-body-base text-[16px] md:text-[18px] text-on-surface leading-[2.2] font-light text-left scramble-text mobile-ko-text">'

$good_chunk = '                        <span class="font-label-mono text-[8px] md:text-[10px] text-primary tracking-widest uppercase transition-colors duration-300 leading-none md:leading-normal">SIDE_02</span>
                    </div>
                </div>
                <div class="relative overflow-hidden bg-black">
                    <img alt="MATERIALITY Detail 2" loading="lazy" decoding="async" class="w-full h-auto block" src="BAS_detail_2.jpg"/>
                    <div class="absolute bottom-2 md:bottom-6 right-2 md:right-6 bg-black/80 backdrop-blur-sm px-2 md:px-4 py-1 md:py-2 border border-white/10 md:border-white/15 cursor-pointer hover:bg-white/20 hover:border-white/40 transition-all duration-300 z-20 group/btn flex items-center justify-center h-6 md:h-auto" onclick="openLightbox(''BAS_detail_2.jpg'', ''REAR_QUATER_03'')">
                        <span class="font-label-mono text-[8px] md:text-[10px] text-primary tracking-widest uppercase transition-colors duration-300 leading-none md:leading-normal">REAR_QUATER_03</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Text Block -->
        <div class="flex flex-col gap-6 md:gap-10 mt-16 w-full md:max-w-[50%] text-left items-start">
            <!-- Mobile Language Switcher -->
            <div class="flex md:hidden items-center gap-3 font-label-mono text-[9px] tracking-widest text-outline">
                <button class="lang-btn active text-primary border border-white/20 px-2 py-0.5" onclick="toggleLanguage(this, ''ko'')">KR</button>
                <div class="w-[1px] h-3 bg-white/10"></div>
                <button class="lang-btn text-outline" onclick="toggleLanguage(this, ''en'')">EN</button>
            </div>
            <p class="font-body-base text-[16px] md:text-[18px] text-on-surface leading-[2.2] font-light text-left scramble-text mobile-ko-text">'

$bad_regex = [regex]::Escape($bad_chunk).Replace('\r\n', '\r?\n').Replace('\n', '\r?\n')

if ($html -match $bad_regex) {
    $html = [regex]::Replace($html, $bad_regex, $good_chunk)
    [System.IO.File]::WriteAllText($path, $html, [System.Text.Encoding]::UTF8)
    Write-Host "Fixed MATERIALITY splice!"
} else {
    Write-Host "Bad chunk not found!"
}
