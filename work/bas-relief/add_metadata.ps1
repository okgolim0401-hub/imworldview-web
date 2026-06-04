$path = 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\app.js'
$js = Get-Content $path -Raw -Encoding UTF8

$target = '        const toktokLabel = document.getElementById(''lightbox-toktok-label'');
        const mergeLabel = document.getElementById(''lightbox-merge-label'');
        if (currentLightboxIndex !== -1) {
            updateLightboxState();
            if (toktokLabel) toktokLabel.style.display = ''block'';
            if (mergeLabel) mergeLabel.style.display = ''block'';
        } else {
            lightboxImg.src = actualSrc;
            if (lightboxTitle) lightboxTitle.textContent = title;
            const counter = document.getElementById(''lightbox-counter'');
            if (counter) counter.textContent = "";
            if (toktokLabel) toktokLabel.style.display = ''none'';
            if (mergeLabel) mergeLabel.style.display = ''none'';
        }'

$replacement = '        const toktokLabel = document.getElementById(''lightbox-toktok-label'');
        const mergeLabel = document.getElementById(''lightbox-merge-label'');
        if (currentLightboxIndex !== -1) {
            updateLightboxState();
            if (toktokLabel) {
                toktokLabel.style.display = ''block'';
                toktokLabel.innerHTML = ''TOKTOK SHADOW'';
            }
            if (mergeLabel) mergeLabel.style.display = ''block'';
        } else {
            lightboxImg.src = actualSrc;
            if (lightboxTitle) lightboxTitle.textContent = title;
            const counter = document.getElementById(''lightbox-counter'');
            if (counter) counter.textContent = "";
            if (actualSrc.includes(''BAS_main.jpg'')) {
                if (toktokLabel) {
                    toktokLabel.style.display = ''block'';
                    toktokLabel.innerHTML = ''SLS 3D PRINTED NYLON POWDER, XPS FORM<br/>890 x 1520x50 mm'';
                }
                if (mergeLabel) mergeLabel.style.display = ''none'';
            } else {
                if (toktokLabel) toktokLabel.style.display = ''none'';
                if (mergeLabel) mergeLabel.style.display = ''none'';
            }
        }'

$escaped = [regex]::Escape($target).Replace('\r\n', '\r?\n').Replace('\n', '\r?\n')

if ($js -match $escaped) {
    $js = [regex]::Replace($js, $escaped, $replacement)
    [System.IO.File]::WriteAllText($path, $js, [System.Text.Encoding]::UTF8)
    Write-Host "Updated app.js for BAS_main.jpg text!"
} else {
    Write-Host "Failed to find target in app.js!"
}
