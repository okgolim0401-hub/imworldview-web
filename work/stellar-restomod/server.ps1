$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:8085/")
$listener.Start()
Write-Host "Server started at http://localhost:8085/"
Write-Host "Press Ctrl+C to stop."

$root = $PSScriptRoot
if (-not $root) { $root = Get-Location }

$mimeTypes = @{
    ".html" = "text/html"
    ".css"  = "text/css"
    ".js"   = "application/javascript"
    ".glb"  = "model/gltf-binary"
    ".jpg"  = "image/jpeg"
    ".png"  = "image/png"
    ".json" = "application/json"
}

while ($listener.IsListening) {
    $context = $listener.GetContext()
    $request = $context.Request
    $response = $context.Response

    $localPath = $request.Url.LocalPath
    if ($localPath -eq "/") { $localPath = "/index.html" }

    $filePath = Join-Path $root $localPath.TrimStart("/")

    if (Test-Path $filePath) {
        $ext = [System.IO.Path]::GetExtension($filePath)
        $contentType = $mimeTypes[$ext]
        if (-not $contentType) { $contentType = "application/octet-stream" }

        $response.ContentType = $contentType
        if ($contentType.StartsWith("text/") -or $contentType -eq "application/javascript" -or $contentType -eq "application/json") {
            $response.ContentType += "; charset=utf-8"
        }
        $buffer = [System.IO.File]::ReadAllBytes($filePath)
        $response.ContentLength64 = $buffer.Length
        $response.OutputStream.Write($buffer, 0, $buffer.Length)
    } else {
        $response.StatusCode = 404
        $msg = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found")
        $response.OutputStream.Write($msg, 0, $msg.Length)
    }
    $response.Close()
    Write-Host "$($request.HttpMethod) $($request.Url.LocalPath) -> $($response.StatusCode)"
}
