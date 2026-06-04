$content = [System.IO.File]::ReadAllText("app.js", [System.Text.Encoding]::UTF8)
$chars = $content.ToCharArray()
for ($idx = 0; $idx -lt $chars.Length; $idx++) {
    $code = [int]$chars[$idx]
    if ($code -gt 127) {
        $c = $chars[$idx]
        Write-Host "Char at index $idx - Code = $code - '$c'"
    }
}
