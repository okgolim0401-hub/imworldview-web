$webPath = "c:\Users\PC\Desktop\IMWV\WEB"
$rootPath = "c:\Users\PC\Desktop\IMWV"

$extensions = @("*.html", "*.css", "*.js")
$sourceFiles = Get-ChildItem -Path $webPath -Recurse -Include $extensions
$sourceContent = ""
foreach ($file in $sourceFiles) {
    $sourceContent += [System.IO.File]::ReadAllText($file.FullName)
}

$mediaExtensions = @("*.jpg", "*.jpeg", "*.png", "*.gif", "*.webp", "*.svg", "*.mp4", "*.glb")
$mediaFiles = Get-ChildItem -Path $rootPath -Recurse -Include $mediaExtensions

$unusedMedia = @()

foreach ($media in $mediaFiles) {
    $name = $media.Name
    $encodedName = [uri]::EscapeDataString($name)
    
    if ($sourceContent -notmatch [regex]::Escape($name) -and $sourceContent -notmatch [regex]::Escape($encodedName)) {
        $unusedMedia += $media
    }
}

$totalSize = ($unusedMedia | Measure-Object -Property Length -Sum).Sum
$totalSizeMB = [math]::Round($totalSize / 1MB, 2)

Write-Host "Found $($unusedMedia.Count) unused media files."
Write-Host "Total Size: $totalSizeMB MB"

$unusedMedia | Select-Object FullName, @{Name="SizeMB";Expression={[math]::Round($_.Length/1MB, 2)}} | Sort-Object SizeMB -Descending | Out-File "$webPath\all_unused_media.txt"
