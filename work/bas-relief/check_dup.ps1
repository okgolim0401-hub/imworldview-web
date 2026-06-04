$content = Get-Content app_v2.js -Raw
$matches = [regex]::Matches($content, '(?m)^\s*(const|let)\s+(\w+)\s*=')
$dict = @{}
foreach ($m in $matches) {
    $name = $m.Groups[2].Value
    if ($dict.ContainsKey($name)) {
        Write-Host "Duplicate found: $name"
    } else {
        $dict[$name] = $true
    }
}
Write-Host "Done checking duplicates."
