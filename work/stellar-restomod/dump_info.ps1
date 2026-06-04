try {
    $content = Get-Content -Path "glb_header.json" -Raw -Encoding utf8
    $data = ConvertFrom-Json -InputObject $content
    
    $out = @()
    $out += "=== NODES ==="
    if ($data.nodes) {
        foreach ($n in $data.nodes) {
            if ($n.name) { $out += $n.name }
        }
    } else {
        $out += "(No nodes found)"
    }
    
    $out | Out-File -FilePath "list_nodes.txt" -Encoding utf8
    Write-Output "NODE_DUMP_SUCCESS"
} catch {
    Write-Error $_.Exception.Message
}
