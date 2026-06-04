$path = 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html'
$html = Get-Content $path -Raw -Encoding UTF8

$target = '<div class="flex justify-between items-center mb-[50px]" style="margin-bottom: 50px;">'
$replacement = '<div class="flex justify-between items-center mb-[25px]" style="margin-bottom: 25px;">'

$html = $html.Replace($target, $replacement)

[System.IO.File]::WriteAllText($path, $html, [System.Text.Encoding]::UTF8)
Write-Host "Updated margins to 25px!"
