$bytes = [System.IO.File]::ReadAllBytes("stellar_setup.glb")
$jsonLength = [System.BitConverter]::ToUInt32($bytes, 12)
$jsonBytes = New-Object byte[] $jsonLength
[System.Array]::Copy($bytes, 20, $jsonBytes, 0, $jsonLength)
$jsonStr = [System.Text.Encoding]::UTF8.GetString($jsonBytes)
$data = ConvertFrom-Json $jsonStr

Write-Host "--- GLB OVERVIEW ---"
Write-Host ("Total GLB Size: " + [Math]::Round($bytes.Length / 1MB, 2) + " MB")
Write-Host ("JSON Size: " + [Math]::Round($jsonLength / 1KB, 2) + " KB")
Write-Host ("Meshes Count: " + $data.meshes.Count)
Write-Host ("Nodes Count: " + $data.nodes.Count)
Write-Host ("Images Count: " + $data.images.Count)
Write-Host ("Buffers Count: " + $data.buffers.Count)
Write-Host ("BufferViews Count: " + $data.bufferViews.Count)

if ($data.images) {
    Write-Host "`n--- IMAGES IN GLB ---"
    $idx = 0
    foreach ($img in $data.images) {
        $name = $img.name
        $mime = $img.mimeType
        $bvIdx = $img.bufferView
        $bv = $data.bufferViews[$bvIdx]
        $length = $bv.byteLength
        $sizeKb = [Math]::Round($length / 1KB, 2)
        Write-Host ("Image " + $idx + ": Name='" + $name + "', MimeType='" + $mime + "', Size=" + $sizeKb + " KB")
        $idx++
    }
} else {
    Write-Host "`nNo images embedded inside this GLB"
}
