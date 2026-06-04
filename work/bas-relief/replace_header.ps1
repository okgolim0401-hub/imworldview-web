$stellar = Get-Content 'C:\Users\PC\Desktop\IMWV\WEB\StellarRestomod\index.html' -Raw
$navMatch = [regex]::Match($stellar, '(?s)<!-- TopNavBar -->\s*<nav.*?</nav>')

if ($navMatch.Success) {
    $toktok = Get-Content 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html' -Raw
    $newTokTok = [regex]::Replace($toktok, '(?s)<header.*?id="main-header">.*?</header>', $navMatch.Value)
    Set-Content 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html' $newTokTok
    Write-Host "Header replaced successfully."
} else {
    Write-Host "TopNavBar not found in StellarRestomod."
}
