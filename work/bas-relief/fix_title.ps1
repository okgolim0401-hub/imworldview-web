$path = 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html'
$bytes = [System.IO.File]::ReadAllBytes($path)
$content = [System.Text.Encoding]::UTF8.GetString($bytes)

# 1. BAS RELIEF -> BAS-RELIEF (main title h1 and data-original)
$content = $content.Replace('data-original="BAS RELIEF"', 'data-original="BAS-RELIEF"')
$content = $content.Replace('>BAS RELIEF</h1>', '>BAS-RELIEF</h1>')

$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText($path, $content, $utf8NoBom)
Write-Host "Title changed to BAS-RELIEF!"
