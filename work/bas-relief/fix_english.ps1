$path = 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html'
$bytes = [System.IO.File]::ReadAllBytes($path)
$content = [System.Text.Encoding]::UTF8.GetString($bytes)

# Update OVERVIEW English text
$oldOverviewEn = "have been stripped of their innate utility"
$newOverviewEn = "have had their innate utility eliminated"
$content = $content.Replace($oldOverviewEn, $newOverviewEn)

# Update PRODUCTION LOG English text
# We'll just replace the whole paragraph content by regex or specific matching
# Because the exact character for em-dash might be tricky, we can match the start and end of the paragraph.
$oldProdEnStart = "This outlines the main production processes"
$oldProdEnEnd = "Gyeongnam International Art Fair)."

# To safely replace the paragraph, we will use a regex replace for the content of that specific p tag
$regex = "(?s)This outlines the main production processes.*?Gyeongnam International Art Fair\)\."
$newProdEn = "These are the key production processes leading up to the final installation, including structural deconstruction, CNC machining, painting, and wiring.<br/>It captures the complete timeline of design data being converted into physical mass, and &lt;TOKTOK SHADOW : BAS-RELIEF&gt; was exhibited at GIAF 2024 (Gyeongnam International Art Fair)."
$content = $content -replace $regex, $newProdEn

$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText($path, $content, $utf8NoBom)
Write-Host "English texts updated successfully!"
