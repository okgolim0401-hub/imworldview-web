$extensions = @("*.html", "*.css", "*.js")
$sourceFiles = Get-ChildItem -Path . -Recurse -Include $extensions
$sourceContent = ""
foreach ($file in $sourceFiles) {
    $sourceContent += [System.IO.File]::ReadAllText($file.FullName)
}

$imageExtensions = @("*.jpg", "*.jpeg", "*.png", "*.gif", "*.webp", "*.svg")
$imageFiles = Get-ChildItem -Path . -Recurse -Include $imageExtensions

$unusedImages = @()

foreach ($img in $imageFiles) {
    $name = $img.Name
    $encodedName = [uri]::EscapeDataString($name)
    
    # Check if the name or encoded name exists in the source content
    if ($sourceContent -notmatch [regex]::Escape($name) -and $sourceContent -notmatch [regex]::Escape($encodedName)) {
        # Check without extension just in case? No, usually they have extensions.
        $unusedImages += $img.FullName
    }
}

$unusedImages | Out-File "unused_images.txt"
Write-Host "Found $($unusedImages.Count) unused images. Saved to unused_images.txt"
