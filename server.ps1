# Master Web Server for IMWV Project
$port = 8080
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")
$listener.Start()
Write-Host "==================================================" -ForegroundColor Yellow
Write-Host " Master Web Server started at http://localhost:$port/" -ForegroundColor Green
Write-Host " Default Route: http://localhost:$port/ -> IMWV_Main" -ForegroundColor Cyan
Write-Host " Press Ctrl+C to stop the server." -ForegroundColor Yellow
Write-Host "==================================================" -ForegroundColor Yellow

$root = $PSScriptRoot
if (-not $root) { $root = Get-Location }

$mimeTypes = @{
    ".html" = "text/html; charset=utf-8"
    ".css"  = "text/css; charset=utf-8"
    ".js"   = "application/javascript; charset=utf-8"
    ".glb"  = "model/gltf-binary"
    ".jpg"  = "image/jpeg"
    ".png"  = "image/png"
    ".mp4"  = "video/mp4"
    ".json" = "application/json; charset=utf-8"
}

try {
    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response

        # CORS support
        $response.Headers.Add("Access-Control-Allow-Origin", "*")

        $localPath = $request.Url.LocalPath
        if ($localPath -eq "/") { $localPath = "/IMWV_Main/index.html" }

        $filePath = Join-Path $root ($localPath -replace '/', '\').TrimStart('\')

        if (Test-Path $filePath -PathType Leaf) {
            $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
            $contentType = $mimeTypes[$ext]
            if (-not $contentType) { $contentType = "application/octet-stream" }

            $response.ContentType = $contentType
            $buffer = [System.IO.File]::ReadAllBytes($filePath)
            $response.ContentLength64 = $buffer.Length
            
            if ($request.HttpMethod -ne "HEAD") {
                $response.OutputStream.Write($buffer, 0, $buffer.Length)
            }
            
            Write-Host "200  $($request.HttpMethod)  $localPath" -ForegroundColor Green
        } else {
            $response.StatusCode = 404
            $msg = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found: $localPath")
            $response.ContentLength64 = $msg.Length
            if ($request.HttpMethod -ne "HEAD") {
                $response.OutputStream.Write($msg, 0, $msg.Length)
            }
            Write-Host "404  $($request.HttpMethod)  $localPath" -ForegroundColor Red
        }
        $response.Close()
    }
} finally {
    $listener.Stop()
    Write-Host "Server stopped." -ForegroundColor Red
}
