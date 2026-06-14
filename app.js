document.addEventListener('DOMContentLoaded', () => {
    // --- Refik Anadol Style Intro Animation ---
    (function initIntroAnimation() {
        const layer1 = document.getElementById('intro-layer-1');
        const layer2 = document.getElementById('intro-layer-2');
        const logoWrapper = document.getElementById('intro-logo-wrapper');
        const navLogo = document.querySelector('nav img');
        
        if (!layer1 || !layer2 || !logoWrapper) return;

        // Check if intro has already been played in this browser session
        if (sessionStorage.getItem('introPlayed') === 'true') {
            layer1.remove();
            layer2.remove();
            return;
        }

        // Mark intro as played for future navigation
        sessionStorage.setItem('introPlayed', 'true');

        const numBlinds = 40;
        const columns = new Array(numBlinds).fill(0); 
        
        function updateClipPath() {
            let polygons = [];
            polygons.push(`0% 0%`); // Start at top-left of screen
            
            for (let i = 0; i < numBlinds; i++) {
                let startX = (i / numBlinds) * 100;
                let width = columns[i] * (100 / numBlinds);
                let overlapEndX = startX + (width * 1.05);
                
                if (i > 0) {
                    polygons.push(`${startX}% 100%`);
                    polygons.push(`${startX}% 0%`);
                }
                polygons.push(`${overlapEndX}% 0%`);
                polygons.push(`${overlapEndX}% 100%`);
            }
            // Return to bottom-left to close the polygon correctly without diagonal lines
            polygons.push(`0% 100%`);
            
            layer2.style.clipPath = `polygon(${polygons.join(', ')})`;
        }
        updateClipPath();

        const fadeDelay = 1500;
        const durationMs = 1200; 
        const staggerMs = 25; 
        let startTime = null;

        setTimeout(() => {
            startTime = performance.now();
            requestAnimationFrame(animateBlinds);
        }, fadeDelay);

        function animateBlinds(time) {
            let elapsed = time - startTime;
            let allDone = true;

            for (let i = 0; i < numBlinds; i++) {
                let blindStart = i * staggerMs;
                let blindElapsed = elapsed - blindStart;
                
                if (blindElapsed < 0) {
                    columns[i] = 0;
                    allDone = false;
                } else if (blindElapsed < durationMs) {
                    let t = blindElapsed / durationMs;
                    // cubic ease-out
                    let ease = 1 - Math.pow(1 - t, 4); 
                    columns[i] = ease;
                    allDone = false;
                } else {
                    columns[i] = 1;
                }
            }

            updateClipPath();

            if (!allDone) {
                requestAnimationFrame(animateBlinds);
            } else {
                finishAnimation();
            }
        }

        function finishAnimation() {
            layer2.style.clipPath = 'none';
            layer1.remove(); 

            const pauseBeforeFlip = 800;
            setTimeout(() => {
                if (navLogo) {
                    const targetRect = navLogo.getBoundingClientRect();
                    const initialRect = logoWrapper.getBoundingClientRect();
                    
                    // Calculate center positions to perform a pure transform-based FLIP
                    const initialCX = initialRect.left + initialRect.width / 2;
                    const initialCY = initialRect.top + initialRect.height / 2;
                    
                    const targetCX = targetRect.left + targetRect.width / 2;
                    const targetCY = targetRect.top + targetRect.height / 2;
                    
                    const translateX = targetCX - initialCX;
                    const translateY = targetCY - initialCY;
                    
                    const scaleX = targetRect.width / initialRect.width;
                    const scaleY = targetRect.height / initialRect.height;
                    
                    // Apply linear straight-line translation using transform
                    logoWrapper.style.transform = `translate(-50%, -50%) translate(${translateX}px, ${translateY}px) scale(${scaleX}, ${scaleY})`;
                    
                    navLogo.style.opacity = '0';
                    layer2.classList.add('opacity-0');
                }
            }, pauseBeforeFlip);

            setTimeout(() => {
                if (navLogo) navLogo.style.opacity = '1';
                logoWrapper.style.opacity = '0';
                setTimeout(() => {
                    layer2.remove();
                }, 500);
            }, pauseBeforeFlip + 1000);
        }
    })();

    // --- Dynamic Header Scanline Scroll transition (Stellar Exact Match) ---
    let isHeaderScrolled = false;
    let isDesktopMenuOpen = false;
    const scanLine = document.getElementById('header-scan-line');
    const menuLinks = document.getElementById('desktop-menu-links');
    const triggerBtn = document.getElementById('mobile-menu-trigger');

    window.toggleDesktopInlineMenu = function() {
        if (!scanLine || !menuLinks || !triggerBtn) return;
        
        const menuLine = document.getElementById('menu-line');
        if (!isDesktopMenuOpen) {
            isDesktopMenuOpen = true;
            scanLine.style.transformOrigin = 'right';
            scanLine.style.transform = 'scaleX(1)';
            
            if (menuLine) {
                menuLine.style.transform = 'scaleX(0.6)';
                menuLine.style.backgroundColor = '#ffffff'; 
            }
            
            setTimeout(() => {
                menuLinks.style.opacity = '1';
                menuLinks.style.pointerEvents = 'auto';
                scanLine.style.transformOrigin = 'left';
                scanLine.style.transform = 'scaleX(0)';
            }, 300);
        } else {
            isDesktopMenuOpen = false;
            scanLine.style.transformOrigin = 'left';
            scanLine.style.transform = 'scaleX(1)';
            
            if (menuLine) {
                menuLine.style.transform = 'none';
                menuLine.style.backgroundColor = '#ffffff';
            }
            
            setTimeout(() => {
                menuLinks.style.opacity = '0';
                menuLinks.style.pointerEvents = 'none';
                scanLine.style.transformOrigin = 'right';
                scanLine.style.transform = 'scaleX(0)';
            }, 300);
        }
    };

    if (scanLine && menuLinks && triggerBtn) {
        window.addEventListener('scroll', () => {
            if (window.innerWidth < 768) return; 
            
            if (window.scrollY > 80) {
                if (!isHeaderScrolled) {
                    isHeaderScrolled = true;
                    scanLine.style.transformOrigin = 'left';
                    scanLine.style.transform = 'scaleX(1)';
                    setTimeout(() => {
                        if (!isDesktopMenuOpen) {
                            menuLinks.style.opacity = '0';
                            menuLinks.style.pointerEvents = 'none';
                        }
                        scanLine.style.transformOrigin = 'right';
                        scanLine.style.transform = 'scaleX(0)';
                        triggerBtn.classList.remove('md:opacity-0', 'md:translate-x-8', 'md:pointer-events-none');
                        triggerBtn.classList.add('md:opacity-100', 'md:translate-x-0', 'md:pointer-events-auto');
                    }, 300);
                }
            } else {
                if (isHeaderScrolled) {
                    isHeaderScrolled = false;
                    isDesktopMenuOpen = false;
                    
                    const menuLine = document.getElementById('menu-line');
                    if (menuLine) {
                        menuLine.style.transform = 'none';
                        menuLine.style.backgroundColor = '#ffffff';
                    }
                    
                    scanLine.style.transformOrigin = 'right';
                    scanLine.style.transform = 'scaleX(1)';
                    setTimeout(() => {
                        menuLinks.style.opacity = '1';
                        menuLinks.style.pointerEvents = 'auto';
                        scanLine.style.transformOrigin = 'left';
                        scanLine.style.transform = 'scaleX(0)';
                        triggerBtn.classList.add('md:opacity-0', 'md:translate-x-8', 'md:pointer-events-none');
                        triggerBtn.classList.remove('md:opacity-100', 'md:translate-x-0', 'md:pointer-events-auto');
                    }, 300);
                }
            }
        });

        triggerBtn.addEventListener('click', (e) => {
            if (window.innerWidth >= 768) {
                e.preventDefault();
                e.stopPropagation();
                window.toggleDesktopInlineMenu();
            }
        });
    }

    // --- Scroll-Triggered Dot/Line Animations for Footer ---
    (function initFooterSpecialLines() {
        const topContainers = document.querySelectorAll('.special-line-top');
        topContainers.forEach(container => {
            let html = `
            <div class="w-full h-full flex justify-end items-start gap-8 md:gap-12 pr-8 md:pr-16 pt-0">
                <div class="relative flex flex-col items-end justify-end h-[120px] w-[140px] shrink-0">
                    <div class="absolute bottom-[0.5px] right-0 w-[140px] h-[1px] overflow-hidden">
                        <div class="h-line w-[140px] h-[1px] bg-white/30 absolute top-0 left-[-140px] transition-transform duration-[1500ms] ease-in-out z-10"></div>
                    </div>
                    <div class="v-dot w-[2px] h-[2px] bg-white rounded-full absolute bottom-0 right-0 opacity-0 transition-opacity duration-[500ms]  z-20"></div>
                </div>
                <div class="relative flex flex-col items-center justify-start h-[120px] w-[20px] shrink-0 overflow-hidden">
                    <div class="v-line w-[1px] h-[120px] bg-white/30 absolute top-[-120px] transition-transform duration-[1500ms] ease-in-out"></div>
                    <div class="v-dot w-[2px] h-[2px] bg-white rounded-full absolute bottom-0 opacity-0 transition-opacity duration-[500ms] "></div>
                </div>
            </div>`;
            container.innerHTML = html;
            
            const lineObserver = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        const hLine = container.querySelector('.h-line');
                        const vLine = container.querySelector('.v-line');
                        const dots = container.querySelectorAll('.v-dot');
                        
                        hLine.style.transform = 'translateX(280px)';
                        setTimeout(() => { dots[0].classList.replace('opacity-0', 'opacity-100'); }, 750); 
                        
                        vLine.style.transform = 'translateY(240px)';
                        setTimeout(() => { dots[1].classList.replace('opacity-0', 'opacity-100'); }, 750); 
                        
                        lineObserver.unobserve(container);
                    }
                });
            }, { threshold: 0.1 });
            
            lineObserver.observe(container);
        });

        const bottomContainers = document.querySelectorAll('.special-line-bottom');
        bottomContainers.forEach(container => {
            let html = `
            <div class="relative w-full h-[80px] flex justify-between items-start">
                <div class="flex items-center h-[2px] w-[10%] shrink-0">
                    <div class="h-line w-full h-[1px] bg-white/30 scale-x-0 origin-left transition-transform duration-[1200ms] ease-out"></div>
                </div>
                <div class="flex items-center h-[2px] w-[25%] shrink-0">
                    <div class="h-line w-full h-[1px] bg-white/30 scale-x-0 origin-left transition-transform duration-[1200ms] ease-out"></div>
                </div>
                <div class="flex items-center h-[2px] shrink-0 justify-center">
                    <div class="relative shrink-0">
                        <div class="v-dot w-[2px] h-[2px] bg-white rounded-full opacity-0 transition-opacity duration-[300ms] shadow-[0_0_6px_rgba(255,255,255,1)] z-20"></div>
                        <div class="v-line-container absolute top-[2px] left-1/2 -translate-x-1/2 w-[1px] h-[60px] overflow-hidden">
                            <div class="v-line w-full h-[40px] bg-gradient-to-t from-transparent via-white/40 to-white/80 absolute top-[60px] transition-transform duration-[1200ms] ease-in-out"></div>
                        </div>
                    </div>
                </div>
                <div class="flex items-center h-[2px] shrink-0 justify-center">
                    <div class="relative shrink-0">
                        <div class="v-dot w-[2px] h-[2px] bg-white rounded-full opacity-0 transition-opacity duration-[300ms] shadow-[0_0_6px_rgba(255,255,255,1)] z-20"></div>
                        <div class="v-line-container absolute top-[2px] left-1/2 -translate-x-1/2 w-[1px] h-[60px] overflow-hidden">
                            <div class="v-line w-full h-[40px] bg-gradient-to-t from-transparent via-white/40 to-white/80 absolute top-[60px] transition-transform duration-[1200ms] ease-in-out"></div>
                        </div>
                    </div>
                </div>
                <div class="flex items-center h-[2px] w-[25%] shrink-0">
                    <div class="h-line w-full h-[1px] bg-white/30 scale-x-0 origin-left transition-transform duration-[1200ms] ease-out"></div>
                </div>
                <div class="flex items-center h-[2px] w-[10%] shrink-0 justify-end">
                    <div class="h-line w-full h-[1px] bg-white/30 scale-x-0 origin-left transition-transform duration-[1200ms] ease-out"></div>
                </div>
            </div>`;
            container.innerHTML = html;
            
            const lineObserver = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        const hLines = container.querySelectorAll('.h-line');
                        const vLines = container.querySelectorAll('.v-line');
                        const dots = container.querySelectorAll('.v-dot');
                        
                        hLines.forEach(hline => { hline.classList.replace('scale-x-0', 'scale-x-100'); });
                        
                        vLines.forEach((vline, i) => {
                            vline.style.transform = 'translateY(-100px)'; 
                            setTimeout(() => { dots[i].classList.replace('opacity-0', 'opacity-100'); }, 700);
                        });
                        
                        lineObserver.unobserve(container);
                    }
                });
            }, { threshold: 0.1 });
            lineObserver.observe(container);
        });
    })();
});
