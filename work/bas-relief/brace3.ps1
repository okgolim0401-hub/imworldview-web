 = Get-Content app.js -Raw;  = (.ToCharArray() | Where-Object {  -eq '{' }).Count;  = (.ToCharArray() | Where-Object {  -eq '}' }).Count; Write-Host Open: , Close: 
