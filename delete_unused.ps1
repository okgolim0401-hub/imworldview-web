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

$deletedCount = 0
$deletedSize = 0

foreach ($media in $mediaFiles) {
    $name = $media.Name
    $encodedName = [uri]::EscapeDataString($name)
    
    if ($sourceContent -notmatch [regex]::Escape($name) -and $sourceContent -notmatch [regex]::Escape($encodedName)) {
        $deletedSize += $media.Length
        Remove-Item -Path $media.FullName -Force
        $deletedCount++
    }
}

$deletedSizeMB = [math]::Round($deletedSize / 1MB, 2)
Write-Host "Successfully deleted $deletedCount unused media files."
Write-Host "Reclaimed Space: $deletedSizeMB MB"
