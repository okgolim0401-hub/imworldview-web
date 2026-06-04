$htmlPath = 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html'
$htmlContent = [System.IO.File]::ReadAllText($htmlPath, [System.Text.Encoding]::UTF8)

# Replace the first draw-line
$target1 = '<div class="draw-line absolute top-0 left-0 w-full h-[1px] bg-white/15 origin-left scale-x-0 transition-transform duration-[1.5s] ease-in-out z-20"></div>'
$replacement1 = '<div class="special-line-container absolute top-0 left-0 w-full h-[20px] flex items-end overflow-hidden z-20"></div>'
$htmlContent = $htmlContent.Replace($target1, $replacement1)

# Replace the second draw-line
$target2 = '<div class="draw-line absolute top-0 left-0 w-full h-[1px] bg-white/15 origin-left scale-x-0 transition-transform duration-[1.5s] ease-in-out"></div>'
$replacement2 = '<div class="special-line-container absolute top-[0px] left-0 w-full h-[20px] flex items-end overflow-hidden"></div>'
$htmlContent = $htmlContent.Replace($target2, $replacement2)

[System.IO.File]::WriteAllText($htmlPath, $htmlContent, (New-Object System.Text.UTF8Encoding $false))

# Now modify app_v2.js
$jsPath = 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\app_v2.js'
$jsContent = [System.IO.File]::ReadAllText($jsPath, [System.Text.Encoding]::UTF8)

# Remove the old drawObserver block
$oldJs = @"
document.addEventListener('DOMContentLoaded', () => {
    const drawObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.replace('scale-x-0', 'scale-x-100');
                drawObserver.unobserve(entry.target);
            }
        });
    }, { threshold: 0.1 });
    document.querySelectorAll('.draw-line').forEach(el => drawObserver.observe(el));
});
"@

$newJs = @"
document.addEventListener('DOMContentLoaded', () => {
    const specialContainers = document.querySelectorAll('.special-line-container');
    
    specialContainers.forEach(container => {
        // Generate pattern: line -> 5 dots -> line ...
        // We will just generate enough to cover any wide screen (e.g. 4000px)
        const totalWidth = 4000;
        let currentWidth = 0;
        let html = '';
        
        while(currentWidth < totalWidth) {
            // Horizontal line
            html += `<div class="h-line w-[100px] md:w-[150px] shrink-0 h-[1px] bg-white/20 origin-left scale-x-0 transition-transform duration-1000 ease-in-out"></div>`;
            currentWidth += 150;
            
            // Dots
            for(let i=0; i<5; i++) {
                html += `
                <div class="relative flex flex-col items-center justify-end h-[15px] w-[20px] md:w-[30px] shrink-0">
                    <div class="v-dot w-[2px] h-[2px] bg-white/80 rounded-full absolute top-0 opacity-0 transition-opacity duration-500"></div>
                    <div class="v-line w-[1px] h-0 bg-white/30 absolute bottom-0 origin-bottom transition-all duration-300 ease-out"></div>
                </div>`;
                currentWidth += 30;
            }
        }
        container.innerHTML = html;
        
        const lineObserver = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const hLines = container.querySelectorAll('.h-line');
                    const vLines = container.querySelectorAll('.v-line');
                    const dots = container.querySelectorAll('.v-dot');
                    
                    // 1. Draw H lines progressively
                    hLines.forEach((line, i) => {
                        setTimeout(() => {
                            line.classList.replace('scale-x-0', 'scale-x-100');
                        }, i * 200); // 200ms stagger for each long segment
                    });
                    
                    // 2. Animate V lines and Dots progressively
                    vLines.forEach((line, i) => {
                        // The delay corresponds to its horizontal position roughly
                        // 5 dots per segment.
                        const segmentIndex = Math.floor(i / 5);
                        const dotIndex = i % 5;
                        const delay = segmentIndex * 200 + 400 + (dotIndex * 80);
                        
                        setTimeout(() => {
                            line.style.height = '15px'; // Shoot up
                            setTimeout(() => {
                                line.style.opacity = '0'; // Fade out line
                                dots[i].classList.replace('opacity-0', 'opacity-100'); // Leave dot
                            }, 300);
                        }, delay);
                    });
                    
                    lineObserver.unobserve(container);
                }
            });
        }, { threshold: 0.1 });
        
        lineObserver.observe(container);
    });
});
"@

$jsContent = $jsContent.Replace($oldJs, $newJs)

[System.IO.File]::WriteAllText($jsPath, $jsContent, (New-Object System.Text.UTF8Encoding $false))

Write-Host "New special line animation applied!"
