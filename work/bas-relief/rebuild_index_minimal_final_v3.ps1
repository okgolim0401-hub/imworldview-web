$stellarPath = 'C:\Users\PC\Desktop\IMWV\WEB\StellarRestomod\index.html'
$basPath = 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html'

if (!(Test-Path $stellarPath)) {
    Write-Error "StellarRestomod/index.html not found!"
    exit 1
}

Write-Host "Reading Stellar template..."
$html = [System.IO.File]::ReadAllText($stellarPath, [System.Text.Encoding]::UTF8)

# 1. Standardize all px-margin classes to px-12 immediately for 100% layout grid alignment
$html = $html.Replace('px-margin', 'px-12')

# 2. Update Title and Slogans to TokTokShadow Bas-Relief
$html = $html.Replace('<title>STELLAR RESTOMOD</title>', '<title>TOK TOK SHADOW / BAS-RELIEF</title>')
$html = $html.Replace('data-original="STELLAR RESTOMOD">STELLAR RESTOMOD', 'data-original="TOK TOK SHADOW / BAS-RELIEF">TOK TOK SHADOW / BAS-RELIEF')
$html = $html.Replace('STELLAR RESTOMOD', 'TOK TOK SHADOW / BAS-RELIEF')
$html = $html.Replace('STELLAR', 'TOK TOK SHADOW')

# 3. Replace Hero WebGL Container with bas-1.png Image Cover Layout
$heroWebgl = '<div class="absolute inset-0 z-0 bg-black overflow-hidden pointer-events-none" id="webgl-container"></div>'
$heroBasImg = @'
    <div class="absolute inset-0 z-0 bg-black overflow-hidden">
        <img alt="TOK TOK SHADOW Hero Image" class="absolute w-[160%] max-w-none h-auto left-1/2 -translate-x-1/2 top-[40px] mobile-fade-mask md:w-full md:h-full md:object-cover md:object-[center_80%] md:left-0 md:translate-x-0 md:top-0" src="bas-1.png"/>
        <div class="absolute inset-0 bg-gradient-to-t from-black via-black/40 to-transparent pointer-events-none"></div>
    </div>
'@
$html = $html.Replace($heroWebgl, $heroBasImg)

# 4. Hide 3D Configurator Activation Overlay
$html = $html.Replace('id="viewer-activation-overlay"', 'id="viewer-activation-overlay" class="hidden"')

# 5. Replace Hero Meta Info per exact user request
$html = $html.Replace('data-original="Hyundai TOK TOK SHADOW Restomod Design competition" data-reveal-delay="0">Hyundai TOK TOK SHADOW Restomod Design competition', 'data-original="TOKTOK SHADOW" data-reveal-delay="0">TOKTOK SHADOW')
$html = $html.Replace('data-original="TOK TOK SHADOW, STILL HERE" data-reveal-delay="300">TOK TOK SHADOW, STILL HERE', 'data-original="BAS-RELIEF" data-reveal-delay="300">BAS-RELIEF')
$html = $html.Replace('data-original="2025" data-reveal-delay="2800">2025', 'data-original="2024" data-reveal-delay="2800">2024')
$html = $html.Replace('data-original="MOBILITY" data-reveal-delay="3000">MOBILITY', 'data-original="INSTALLATION" data-reveal-delay="3000">INSTALLATION')
$html = $html.Replace('>HOST</span>', '>EXHIBITION</span>')
$html = $html.Replace('data-original="HYUNDAI MOTOR STUDIO&#10;EREVO" data-reveal-delay="3200">HYUNDAI MOTOR STUDIO<br/>EREVO', 'data-original="GIAF 2024" data-reveal-delay="3200">GIAF 2024')

# 6. OVERVIEW Section: Remove CONNECTING Past Present Future H2 completely!
$overviewH2 = '<h2 class="font-headline-md text-[30px] sm:text-[40px] md:text-[56px] text-primary tracking-tight font-light font-label-mono leading-[1.15] uppercase text-left scramble-text" data-scramble-type="random" data-original="CONNECTING&#10;PAST, PRESENT, AND FUTURE.">CONNECTING<br/>PAST, PRESENT, AND FUTURE.</h2>'
$html = $html.Replace($overviewH2, '')

# 7. Reconstruct the 16 cards grid HTML with line art PNGs (Thumbnail) and 02.jpgs (Lightbox)
# Placed directly underneath description text with mt-24 md:mt-32 margin!
$gridAndVideo = @'
    
    <!-- Deconstructed Source Lights Section (16 design slots) -->
    <div class="mt-24 md:mt-32 w-full flex flex-col gap-8" id="deconstructed-lights-container">
        <div class="grid grid-cols-2 sm:grid-cols-4 lg:grid-cols-8 gap-3 md:gap-4 w-full" id="deconstructed-grid">
'@

# Safe templates using simple text placeholders instead of curly braces to avoid PowerShell parsing errors!
$template = @'
            <div class="relative aspect-square border border-white/10 bg-black overflow-hidden group/light cursor-pointer" onclick="openLightbox('__LBOX__', '__LIGHTID__')">
                <div class="absolute inset-0 border border-white/0 group-hover/light:border-white/20 transition-all duration-300 z-20"></div>
                <img loading="eager" decoding="async" src="__IMG__" alt="Source Light __INDEXSTR__" class="absolute inset-0 w-full h-full object-contain object-bottom p-0 opacity-60 group-hover/light:opacity-100 group-hover/light:scale-105 transition-all duration-500 z-0" />
                
                <!-- Stroke Diet Lines -->
                <div class="absolute top-0 left-[8px] w-[calc(100%-16px)] h-[2px] bg-white shadow-[0_0_6px_rgba(255,255,255,0.8)] scale-x-0 origin-left transition-all duration-[300ms] cubic-bezier(0.16, 1, 0.3, 1) delay-[50ms] group-hover/light:scale-x-100 group-hover/light:h-[1.5px] group-hover/light:bg-white group-hover/light:shadow-[0_0_4px_rgba(255,255,255,0.6)] z-40 pointer-events-none"></div>
                <div class="absolute top-[8px] right-0 h-[calc(100%-16px)] w-[2px] bg-white shadow-[0_0_6px_rgba(255,255,255,0.8)] scale-y-0 origin-top transition-all duration-[300ms] cubic-bezier(0.16, 1, 0.3, 1) delay-[150ms] group-hover/light:scale-y-100 group-hover/light:w-[1.5px] group-hover/light:bg-white group-hover/light:shadow-[0_0_4px_rgba(255,255,255,0.6)] z-40 pointer-events-none"></div>
                <div class="absolute bottom-0 right-[8px] w-[calc(100%-16px)] h-[2px] bg-white shadow-[0_0_6px_rgba(255,255,255,0.8)] scale-x-0 origin-right transition-all duration-[300ms] cubic-bezier(0.16, 1, 0.3, 1) delay-[250ms] group-hover/light:scale-x-100 group-hover/light:h-[1.5px] group-hover/light:bg-white group-hover/light:shadow-[0_0_4px_rgba(255,255,255,0.6)] z-40 pointer-events-none"></div>
                <div class="absolute bottom-[8px] left-0 h-[calc(100%-16px)] w-[2px] bg-white shadow-[0_0_6px_rgba(255,255,255,0.8)] scale-y-0 origin-bottom transition-all duration-[300ms] cubic-bezier(0.16, 1, 0.3, 1) delay-[350ms] group-hover/light:scale-y-100 group-hover/light:w-[1.5px] group-hover/light:bg-white group-hover/light:shadow-[0_0_4px_rgba(255,255,255,0.6)] z-40 pointer-events-none"></div>

                <!-- Dot Dispersion -->
                <div class="absolute inset-0 pointer-events-none z-40">
                    <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-1 h-1 bg-white opacity-0 rounded-full shadow-[0_0_4px_rgba(255,255,255,0.8)] transition-all duration-500 cubic-bezier(0.16, 1, 0.3, 1) group-hover/light:top-0 group-hover/light:left-0 group-hover/light:opacity-100 group-hover/light:translate-x-[-2px] group-hover/light:translate-y-[-2px] z-20"></div>
                    <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-1 h-1 bg-white opacity-0 rounded-full shadow-[0_0_4px_rgba(255,255,255,0.8)] transition-all duration-500 cubic-bezier(0.16, 1, 0.3, 1) group-hover/light:top-0 group-hover/light:left-full group-hover/light:opacity-100 group-hover/light:translate-x-[2px] group-hover/light:translate-y-[-2px] z-20"></div>
                    <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-1 h-1 bg-white opacity-0 rounded-full shadow-[0_0_4px_rgba(255,255,255,0.8)] transition-all duration-500 cubic-bezier(0.16, 1, 0.3, 1) group-hover/light:top-full group-hover/light:left-full group-hover/light:opacity-100 group-hover/light:translate-x-[2px] group-hover/light:translate-y-[2px] z-20"></div>
                    <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-1 h-1 bg-white opacity-0 rounded-full shadow-[0_0_4px_rgba(255,255,255,0.8)] transition-all duration-500 cubic-bezier(0.16, 1, 0.3, 1) group-hover/light:top-full group-hover/light:left-0 group-hover/light:opacity-100 group-hover/light:translate-x-[-2px] group-hover/light:translate-y-[-2px] z-20"></div>
                </div>

                <!-- Technical Corner Bracket Indicators -->
                <div class="absolute top-2 left-2 w-3 h-3 border-t border-l border-white/0 transition-all duration-500 ease-out group-hover/light:top-0 group-hover/light:left-0 group-hover/light:border-white/40 z-40 pointer-events-none"></div>
                <div class="absolute top-2 right-2 w-3 h-3 border-t border-r border-white/0 transition-all duration-500 ease-out group-hover/light:top-0 group-hover/light:right-0 group-hover/light:border-white/40 z-40 pointer-events-none"></div>
                <div class="absolute bottom-2 left-2 w-3 h-3 border-b border-l border-white/0 transition-all duration-500 ease-out group-hover/light:bottom-0 group-hover/light:left-0 group-hover/light:border-white/40 z-40 pointer-events-none"></div>
                <div class="absolute bottom-2 right-2 w-3 h-3 border-b border-r border-white/0 transition-all duration-500 ease-out group-hover/light:bottom-0 group-hover/light:right-0 group-hover/light:border-white/40 z-40 pointer-events-none"></div>

                <!-- Hover Text Label Overlay -->
                <div class="absolute inset-0 bg-black/65 opacity-0 group-hover/light:opacity-100 flex items-center justify-center transition-all duration-300 z-30 backdrop-blur-[2px]">
                    <span class="font-label-mono text-[13px] md:text-[15px] font-bold tracking-[0.25em] text-white uppercase translate-y-2 group-hover/light:translate-y-0 transition-transform duration-500 ease-[cubic-bezier(0.16,1,0.3,1)]">__LABEL__</span>
                </div>
            </div>
'@

$designs = @(
    @{ img="BUBBLE.png"; lbox="BUBBLE_02.jpg"; label="BUBBLE" },
    @{ img="COOKIE.png"; lbox="COOKIE_02.jpg"; label="COOKIE" },
    @{ img="Crane.png"; lbox="Crane_02.jpg"; label="CRANE" },
    @{ img="FACTORY.png"; lbox="FACTORY_02.jpg"; label="FACTORY" },
    @{ img="GLUTTON.png"; lbox="GLUTTON_02.jpg"; label="GLUTTON" },
    @{ img="HANGER BAR.png"; lbox="hangerbar_02.png"; label="HANGER BAR" },
    @{ img="Light House.png"; lbox="Light House_02.jpg"; label="LIGHT HOUSE" },
    @{ img="NOMAD.png"; lbox="NOMAD_02.jpg"; label="NOMAD" },
    @{ img="PIPE.png"; lbox="pipe_02.jpg"; label="PIPE" },
    @{ img="PUMPKIN.png"; lbox="PUMPKIN)-2.jpg"; label="PUMPKIN" },
    @{ img="ROLYPOLY.png"; lbox="ROLYPOLY_02.jpg"; label="ROLYPOLY" },
    @{ img="Satellite.png"; lbox="Satellite_02.jpg"; label="SATELLITE" },
    @{ img="TRAY.png"; lbox="TRAY_02.jpg"; label="TRAY" },
    @{ img="Tunnel.png"; lbox="Tunnel_02.jpg"; label="TUNNEL" },
    @{ img="Umbrella.png"; lbox="Umbrella_02.jpg"; label="UMBRELLA" },
    @{ img="WITCH.png"; lbox="WITCH_02.jpg"; label="WITCH" }
)

for ($i = 1; $i -le 16; $i++) {
    $design = $designs[$i - 1]
    $img = $design.img
    $lbox = $design.lbox
    $label = $design.label
    $indexStr = $i.ToString("D2")
    $lightId = "SOURCE_LIGHT_$indexStr"

    # Precise string replacements for variables in standard single quotes
    $slotHtml = $template.Replace('__IMG__', $img)
    $slotHtml = $slotHtml.Replace('__LBOX__', $lbox)
    $slotHtml = $slotHtml.Replace('__LIGHTID__', $lightId)
    $slotHtml = $slotHtml.Replace('__INDEXSTR__', $indexStr)
    $slotHtml = $slotHtml.Replace('__LABEL__', $label)

    $gridAndVideo += $slotHtml
    if ($i -lt 16) {
        $gridAndVideo += "`r`n"
    }
}
$gridAndVideo += "`r`n        </div>"

# Vimeo Cinematic Player HTML
$gridAndVideo += @'

        <!-- Vimeo Cinematic Player -->
        <div class="w-full relative mt-12 border border-white/10 p-2 md:p-4 bg-black/40" id="video-container">
            <!-- Technical Corners -->
            <div class="absolute -top-[1px] -left-[1px] w-3 h-3 border-t border-l border-white"></div>
            <div class="absolute -top-[1px] -right-[1px] w-3 h-3 border-t border-r border-white"></div>
            <div class="absolute -bottom-[1px] -left-[1px] w-3 h-3 border-b border-l border-white"></div>
            <div class="absolute -bottom-[1px] -right-[1px] w-3 h-3 border-b border-r border-white"></div>
            
            <div class="relative w-full aspect-video bg-surface-container-lowest border border-white/5 overflow-hidden pointer-events-none" id="video-wrapper">
                <video id="premium-video" src="BAS_ANI.mp4" class="absolute inset-0 w-full h-full object-cover pointer-events-none" autoplay loop muted playsinline style="pointer-events: none; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none;"></video>
            </div>
        </div>
    </div>
'@

# 8. OVERVIEW Section: Remove the entire 3 boxes diagram block from the Stellar template!
$diagramStart = $html.IndexOf('<!-- Diagram -->')
$dotsTarget = '<!-- Staggered Waterfall Transition (5 Dots + 5 Lines) -->'
$dotsIdx = $html.IndexOf($dotsTarget)

if ($diagramStart -ge 0 -and $dotsIdx -gt $diagramStart) {
    # Place Grid and Video directly underneath description text inside Overview container divs
    $beforeDiagram = $html.Substring(0, $diagramStart)
    $html = $beforeDiagram + $gridAndVideo + "`r`n`r`n" + $html.Substring($dotsIdx)
    Write-Host "Successfully merged Grid and Video directly underneath Overview text!" -ForegroundColor Green
} else {
    Write-Warning "Could not find Diagram or Dots target!"
}

# 9. Hide transition container to get clean visual flow
$html = $html.Replace('<div class="w-full mt-16 md:mt-24 relative z-20 grid grid-cols-5 justify-items-center" id="transition-container">', '<div class="hidden">')

# 10. Redirect Gallery Image Sources to StellarRestomod
$html = $html.Replace('src="1.jpg"', 'src="../StellarRestomod/1.jpg"')
$html = $html.Replace('src="2.jpg"', 'src="../StellarRestomod/2.jpg"')
$html = $html.Replace('src="3.jpg"', 'src="../StellarRestomod/3.jpg"')
$html = $html.Replace('src="4.jpg"', 'src="../StellarRestomod/4.jpg"')
$html = $html.Replace('src="Front.png"', 'src="../StellarRestomod/Front.png"')
$html = $html.Replace('src="Rear.png"', 'src="../StellarRestomod/Rear.png"')
$html = $html.Replace('src="Perspective.png"', 'src="../StellarRestomod/Perspective.png"')
$html = $html.Replace('src="Pespective_2.png"', 'src="../StellarRestomod/Pespective_2.png"')

# Update openLightbox links
$html = $html.Replace("openLightbox('1.jpg'", "openLightbox('../StellarRestomod/1.jpg'")
$html = $html.Replace("openLightbox('2.jpg'", "openLightbox('../StellarRestomod/2.jpg'")
$html = $html.Replace("openLightbox('3.jpg'", "openLightbox('../StellarRestomod/3.jpg'")
$html = $html.Replace("openLightbox('4.jpg'", "openLightbox('../StellarRestomod/4.jpg'")
$html = $html.Replace("openLightbox('Front.png'", "openLightbox('../StellarRestomod/Front.png'")
$html = $html.Replace("openLightbox('Rear.png'", "openLightbox('../StellarRestomod/Rear.png'")
$html = $html.Replace("openLightbox('Perspective.png'", "openLightbox('../StellarRestomod/Perspective.png'")
$html = $html.Replace("openLightbox('Pespective_2.png'", "openLightbox('../StellarRestomod/Pespective_2.png'")

# 11. Reconstruct the "NEXT" Project Section
$nextStart = $html.IndexOf('<!-- Next Work Label -->')
$nextEnd = $html.IndexOf('<!-- Refik Anadol Museum-Grade Tech-Style Footer -->')

if ($nextStart -ge 0 -and $nextEnd -gt $nextStart) {
    $beforeNext = $html.Substring(0, $nextStart)
    $afterNext = $html.Substring($nextEnd)
    
    $newNext = @'
<!-- Next Work Label -->
                <span class="font-label-mono text-[12px] text-primary uppercase tracking-[0.3em] opacity-60 scramble-text" data-original="NEXT">NEXT</span>
                
                <!-- Project Title -->
                <h2 class="font-headline-md text-[44px] md:text-[72px] text-primary leading-none uppercase font-light tracking-tight">
                    STELLAR RESTOMOD
                </h2>
                
                <!-- Long Technical Arrow Indicator -->
                <div class="flex items-center mt-4">
                    <div class="relative flex items-center">
                        <div class="w-24 h-[1px] bg-white/20 transition-all duration-500 ease-out" id="next-arrow-line"></div>
                        <svg class="w-[8px] h-[12px] ml-[-1px] overflow-visible text-white/20 transition-colors duration-500" id="next-arrow-head" viewBox="0 0 8 12" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M1 1L7 6L1 11" stroke="currentColor" stroke-width="1.2" stroke-linecap="round" stroke-linejoin="round" />
                        </svg>
                    </div>
                </div>
            </div>
            
            <!-- Right Virtual Cinema Box -->
            <div class="relative w-full md:w-[45%] lg:w-[40%] aspect-[16/7] md:aspect-[21/9] bg-[#0d0d0f]/80 border border-white/5 overflow-hidden rounded-sm cursor-pointer group/img-card" id="next-image-card" onclick="location.href='../StellarRestomod/index.html'">
                <img src="../StellarRestomod/1.jpg" alt="STELLAR Restomod Preview" class="absolute inset-0 w-full h-full object-cover opacity-30 group-hover/img-card:opacity-85 group-hover/img-card:scale-[1.02] transition-[transform,opacity] duration-700 cubic-bezier(0.16, 1, 0.3, 1) z-0 pointer-events-none" style="will-change: transform, opacity;" />
                <div class="absolute inset-0 bg-black/30 group-hover/img-card:bg-black/0 transition-all duration-700 pointer-events-none z-[1]"></div>

                <!-- Stroke Diet Lines -->
                <div class="absolute top-0 left-[16px] w-[calc(100%-32px)] h-[3px] bg-white shadow-[0_0_8px_rgba(255,255,255,0.8)] scale-x-0 origin-left transition-all duration-[400ms] cubic-bezier(0.16, 1, 0.3, 1) delay-[100ms] group-hover/img-card:scale-x-100 group-hover/img-card:h-[0.8px] group-hover/img-card:bg-white/30 group-hover/img-card:shadow-none z-10 pointer-events-none"></div>
                <div class="absolute top-[16px] right-0 h-[calc(100%-16px)] w-[3px] bg-white shadow-[0_0_8px_rgba(255,255,255,0.8)] scale-y-0 origin-top transition-all duration-[400ms] cubic-bezier(0.16, 1, 0.3, 1) delay-[300ms] group-hover/img-card:scale-y-100 group-hover/img-card:w-[0.8px] group-hover/img-card:bg-white/30 group-hover/img-card:shadow-none z-10 pointer-events-none"></div>
                <div class="absolute bottom-0 right-[16px] w-[calc(100%-32px)] h-[3px] bg-white shadow-[0_0_8px_rgba(255,255,255,0.8)] scale-x-0 origin-right transition-all duration-[400ms] cubic-bezier(0.16, 1, 0.3, 1) delay-[500ms] group-hover/img-card:scale-x-100 group-hover/img-card:h-[0.8px] group-hover/img-card:bg-white/30 group-hover/img-card:shadow-none z-10 pointer-events-none"></div>
                <div class="absolute bottom-[16px] left-0 h-[calc(100%-16px)] w-[3px] bg-white shadow-[0_0_8px_rgba(255,255,255,0.8)] scale-y-0 origin-bottom transition-all duration-[400ms] cubic-bezier(0.16, 1, 0.3, 1) delay-[700ms] group-hover/img-card:scale-y-100 group-hover/img-card:w-[0.8px] group-hover/img-card:bg-white/30 group-hover/img-card:shadow-none z-10 pointer-events-none"></div>

                <!-- Dot Dispersion -->
                <div class="absolute inset-0 pointer-events-none z-20">
                    <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-1.5 h-1.5 bg-white opacity-0 rounded-full shadow-[0_0_6px_rgba(255,255,255,0.8)] transition-all duration-700 cubic-bezier(0.16, 1, 0.3, 1) group-hover/img-card:top-0 group-hover/img-card:left-0 group-hover/img-card:opacity-100 group-hover/img-card:translate-x-[-3px] group-hover/img-card:translate-y-[-3px] z-20"></div>
                    <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-1.5 h-1.5 bg-white opacity-0 rounded-full shadow-[0_0_6px_rgba(255,255,255,0.8)] transition-all duration-700 cubic-bezier(0.16, 1, 0.3, 1) group-hover/img-card:top-0 group-hover/img-card:left-full group-hover/img-card:opacity-100 group-hover/img-card:translate-x-[3px] group-hover/img-card:translate-y-[-3px] z-20"></div>
                    <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-1.5 h-1.5 bg-white opacity-0 rounded-full shadow-[0_0_6px_rgba(255,255,255,0.8)] transition-all duration-700 cubic-bezier(0.16, 1, 0.3, 1) group-hover/img-card:top-full group-hover/img-card:left-full group-hover/img-card:opacity-100 group-hover/img-card:translate-x-[3px] group-hover/img-card:translate-y-[3px] z-20"></div>
                    <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-1.5 h-1.5 bg-white opacity-0 rounded-full shadow-[0_0_6px_rgba(255,255,255,0.8)] transition-all duration-700 cubic-bezier(0.16, 1, 0.3, 1) group-hover/img-card:top-full group-hover/img-card:left-0 group-hover/img-card:opacity-100 group-hover/img-card:translate-x-[-3px] group-hover/img-card:translate-y-[3px] z-20"></div>
                </div>
            </div>
        </div>
    </section>
'@
    $html = $beforeNext + $newNext + $afterNext
}

# 12. Remove the entire 3D Viewer Section
$threeDStart = $html.IndexOf('<!-- 3D Viewer Section -->')
$threeDEnd = $html.IndexOf('<div id="footer-glow-wrapper"')

if ($threeDStart -ge 0 -and $threeDEnd -gt $threeDStart) {
    $html = $html.Substring(0, $threeDStart) + $html.Substring($threeDEnd)
    Write-Host "Successfully deleted 3D Viewer Section!" -ForegroundColor Green
}

# 13. Fix the copyright symbol with &copy;
$html = $html.Replace('© 2026 @IMWV.', '&copy; 2026 @IMWV.')

# Update app.js cache bust
$html = $html.Replace('app.js?v=1.6.6', 'app.js?v=1.7.0')
$html = $html.Replace('app.js?v=1.2.5', 'app.js?v=1.7.0')
$html = $html.Replace('app.js?v=1.0.3', 'app.js?v=1.7.0')

Write-Host "Writing rebuilt index.html..."
[System.IO.File]::WriteAllText($basPath, $html, [System.Text.Encoding]::UTF8)

Write-Host "SUCCESS! Clean Rebuilt index.html assembled safely." -ForegroundColor Green
