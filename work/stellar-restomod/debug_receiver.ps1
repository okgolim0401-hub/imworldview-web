$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:8089/")
$listener.Start()
Write-Host "Debug Receiver started at http://localhost:8089/"

try {
    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response

        if ($request.HttpMethod -eq "OPTIONS") {
            $response.AddHeader("Access-Control-Allow-Origin", "*")
            $response.AddHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS")
            $response.AddHeader("Access-Control-Allow-Headers", "Content-Type")
            $response.StatusCode = 200
            $response.Close()
            continue
        }

        if ($request.HttpMethod -eq "POST" -and $request.Url.LocalPath -eq "/log") {
            $reader = New-Object System.IO.StreamReader($request.InputStream, [System.Text.Encoding]::UTF8)
            $body = $reader.ReadToEnd()
            $reader.Close()

            $body | Out-File -FilePath "debug_output.txt" -Encoding utf8
            Write-Host "Received debug data and wrote to debug_output.txt"

            $response.AddHeader("Access-Control-Allow-Origin", "*")
            $response.ContentType = "application/json; charset=utf-8"
            $msg = [System.Text.Encoding]::UTF8.GetBytes('{"status":"ok"}')
            $response.ContentLength64 = $msg.Length
            $response.OutputStream.Write($msg, 0, $msg.Length)
        } else {
            $response.StatusCode = 404
        }
        $response.Close()
    }
} finally {
    $listener.Stop()
}
