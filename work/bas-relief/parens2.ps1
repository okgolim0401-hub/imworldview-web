$text = Get-Content app.js -Raw
$stack = New-Object System.Collections.Generic.Stack[int]
for ($i = 0; $i -lt $text.Length; $i++) {
    if ($text[$i] -eq '(') {
        $stack.Push($i)
    } elseif ($text[$i] -eq ')') {
        if ($stack.Count -gt 0) {
            [void]$stack.Pop()
        } else {
            Write-Host "Unmatched ) at index $i"
            $line = 1
            for ($j = 0; $j -lt $i; $j++) {
                if ($text[$j] -eq "`n") { $line++ }
            }
            Write-Host "Line: $line"
        }
    }
}
Write-Host "Unmatched ( at indices:"
foreach ($index in $stack) {
    $line = 1
    for ($j = 0; $j -lt $index; $j++) {
        if ($text[$j] -eq "`n") { $line++ }
    }
    Write-Host "Line: $line"
}
