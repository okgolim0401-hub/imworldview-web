$text = Get-Content app_v2.js -Raw
$text = $text -replace '(?s)/\*.*?\*/', ''
$text = $text -replace '//.*', ''
$text = $text -replace "'(?:\\'|[^'])*'", "''"
$text = $text -replace '"(?:\\"|[^"])*"', '""'
$text = $text -replace '`(?:\`|[^`])*`', '``'

$braces = 0
$parens = 0
$brackets = 0

for ($i = 0; $i -lt $text.Length; $i++) {
    $c = $text[$i]
    if ($c -eq '{') { $braces++ }
    elseif ($c -eq '}') { $braces-- }
    elseif ($c -eq '(') { $parens++ }
    elseif ($c -eq ')') { $parens-- }
    elseif ($c -eq '[') { $brackets++ }
    elseif ($c -eq ']') { $brackets-- }
}

Write-Host "Braces: $braces, Parens: $parens, Brackets: $brackets"
