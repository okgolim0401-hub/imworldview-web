$htmlPath = 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html'
$htmlContent = [System.IO.File]::ReadAllText($htmlPath, [System.Text.Encoding]::UTF8)

# Replace the first border-t
$target1 = '<div id="footer-glow-wrapper" class="relative bg-black border-t border-white/5 overflow-hidden">'
$replacement1 = '<div id="footer-glow-wrapper" class="relative bg-black overflow-hidden">`n    <!-- Animated Top Line -->`n    <div class="draw-line absolute top-0 left-0 w-full h-[1px] bg-white/15 origin-left scale-x-0 transition-transform duration-[1.5s] ease-in-out z-20"></div>'
$htmlContent = $htmlContent.Replace($target1, $replacement1)

# Replace the second border-t
$target2 = '<div class="flex flex-col md:flex-row justify-between items-center w-full gap-12 md:gap-8 pt-12 border-t border-white/5">'
$replacement2 = '<div class="flex flex-col md:flex-row justify-between items-center w-full gap-12 md:gap-8 pt-12 relative">`n            <!-- Animated Top Line -->`n            <div class="draw-line absolute top-0 left-0 w-full h-[1px] bg-white/15 origin-left scale-x-0 transition-transform duration-[1.5s] ease-in-out"></div>'
$htmlContent = $htmlContent.Replace($target2, $replacement2)

[System.IO.File]::WriteAllText($htmlPath, $htmlContent, (New-Object System.Text.UTF8Encoding $false))

# Now modify app_v2.js to add the observer
$jsPath = 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\app_v2.js'
$jsContent = [System.IO.File]::ReadAllText($jsPath, [System.Text.Encoding]::UTF8)

$jsAdd = @"
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

if (-not $jsContent.Contains('drawObserver')) {
    $jsContent = $jsContent + "`n" + $jsAdd
    [System.IO.File]::WriteAllText($jsPath, $jsContent, (New-Object System.Text.UTF8Encoding $false))
}
Write-Host "Line animation applied!"
