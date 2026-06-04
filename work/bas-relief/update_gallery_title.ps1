$path = 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\app.js'
$js = Get-Content $path -Raw -Encoding UTF8

$target1 = '    function updateLightboxState() {
        if (currentLightboxIndex !== -1) {
            lightboxImg.src = galleryImages[currentLightboxIndex];
            if (lightboxTitle) {
                lightboxTitle.textContent = galleryTitles[currentLightboxIndex];
            }
            const counter = document.getElementById(''lightbox-counter'');
            if (counter) {
                counter.textContent = `${String(currentLightboxIndex + 1).padStart(2, ''0'')} / ${galleryImages.length}`;
            }
        }
    }'

$replacement1 = '    function updateLightboxState() {
        if (currentLightboxIndex !== -1) {
            lightboxImg.src = galleryImages[currentLightboxIndex];
            if (lightboxTitle) {
                lightboxTitle.textContent = galleryTitles[currentLightboxIndex];
            }
            const counter = document.getElementById(''lightbox-counter'');
            if (counter) {
                counter.textContent = `${String(currentLightboxIndex + 1).padStart(2, ''0'')} / ${galleryImages.length}`;
            }
            const toktokLabel = document.getElementById(''lightbox-toktok-label'');
            const mergeLabel = document.getElementById(''lightbox-merge-label'');
            if (toktokLabel) {
                toktokLabel.style.display = ''block'';
                toktokLabel.innerHTML = galleryTitles[currentLightboxIndex];
            }
            if (mergeLabel) mergeLabel.style.display = ''none'';
        }
    }'

$target2 = '        if (currentLightboxIndex !== -1) {
            updateLightboxState();
            if (toktokLabel) {
                toktokLabel.style.display = ''block'';
                toktokLabel.innerHTML = ''TOKTOK SHADOW'';
            }
            if (mergeLabel) mergeLabel.style.display = ''block'';
        } else {'

$replacement2 = '        if (currentLightboxIndex !== -1) {
            updateLightboxState();
        } else {'

$escaped1 = [regex]::Escape($target1).Replace('\r\n', '\r?\n').Replace('\n', '\r?\n')
$escaped2 = [regex]::Escape($target2).Replace('\r\n', '\r?\n').Replace('\n', '\r?\n')

if ($js -match $escaped1 -and $js -match $escaped2) {
    $js = [regex]::Replace($js, $escaped1, $replacement1)
    $js = [regex]::Replace($js, $escaped2, $replacement2)
    [System.IO.File]::WriteAllText($path, $js, [System.Text.Encoding]::UTF8)
    Write-Host "Updated app.js for 16 gallery images title!"
} else {
    Write-Host "Failed to find one of the targets in app.js!"
}
