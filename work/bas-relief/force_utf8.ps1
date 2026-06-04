$path = 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html'
$bytes = [System.IO.File]::ReadAllBytes($path)
# Decode with Default encoding (which is what Set-Content without Encoding probably did)
$text = [System.Text.Encoding]::Default.GetString($bytes)
# Now encode to UTF8
$utf8bytes = [System.Text.Encoding]::UTF8.GetBytes($text)
[System.IO.File]::WriteAllBytes($path, $utf8bytes)
Write-Host 'Forced UTF8 conversion.'
