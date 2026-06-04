$lines = Get-Content 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html'
$divs = ($lines | Select-String -Pattern '<div' -AllMatches).Matches.Count
$enddivs = ($lines | Select-String -Pattern '</div' -AllMatches).Matches.Count
Write-Host "divs: $divs, end divs: $enddivs"
