$stellarHtml = Get-Content 'C:\Users\PC\Desktop\IMWV\WEB\StellarRestomod\index.html' -Raw -Encoding UTF8
$startIdx = $stellarHtml.IndexOf('<div id="footer-glow-wrapper"')
$footerBlock = $stellarHtml.Substring($startIdx)
$footerBlock = $footerBlock.Replace("onclick=`"location.href='#'`"", "onclick=`"location.href='../StellarRestomod/index.html'`"")

$toktokLines = Get-Content 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html' -Encoding UTF8
$prefix = $toktokLines[0..1048]

$replacement = Get-Content 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\replacement.html' -Raw -Encoding UTF8

$newHtml = ($prefix -join "`r`n") + "`r`n" + $replacement + "`r`n" + $footerBlock

[System.IO.File]::WriteAllText('C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html', $newHtml, [System.Text.Encoding]::UTF8)
Write-Host "SUPER FIX APPLIED!"
