$content = Get-Content 'C:\Users\PC\Desktop\IMWV\WEB\StellarRestomod\index.html' -Raw
$divs = ([regex]::Matches($content, '<div')).Count
$enddivs = ([regex]::Matches($content, '</div')).Count
Write-Host "divs: $divs, end divs: $enddivs"
