$path = 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\app.js'
$js = Get-Content $path -Raw -Encoding UTF8

$target = '    const lightboxCloseBtn = document.getElementById(''lightbox-close'');'
$replacement = '    const lightboxCloseBtn = document.getElementById(''lightbox-close'');
    const resolutionText = document.getElementById(''lightbox-resolution'');
    
    if (lightboxImg && resolutionText) {
        lightboxImg.addEventListener(''load'', () => {
            const width = lightboxImg.naturalWidth;
            const height = lightboxImg.naturalHeight;
            if (width && height) {
                resolutionText.textContent = `RESOLUTION: ${width} x ${height}`;
            }
        });
    }'

$escaped = [regex]::Escape($target).Replace('\r\n', '\r?\n').Replace('\n', '\r?\n')

if ($js -match $escaped) {
    $js = [regex]::Replace($js, $escaped, $replacement)
    [System.IO.File]::WriteAllText($path, $js, [System.Text.Encoding]::UTF8)
    Write-Host "Injected resolution logic!"
} else {
    Write-Host "Failed to find target in app.js."
}
