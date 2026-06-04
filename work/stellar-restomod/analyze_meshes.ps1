$bytes = [System.IO.File]::ReadAllBytes("stellar_setup.glb")
$jsonLength = [System.BitConverter]::ToUInt32($bytes, 12)
$jsonBytes = New-Object byte[] $jsonLength
[System.Array]::Copy($bytes, 20, $jsonBytes, 0, $jsonLength)
$jsonStr = [System.Text.Encoding]::UTF8.GetString($jsonBytes)
$data = ConvertFrom-Json $jsonStr

Write-Host "--- ANALYSIS OF MESH BUFFERVIEWS ---"
$bufferViews = $data.bufferViews
$meshes = $data.meshes

# Analyze meshes and their accessor bufferView sizes
$meshSizes = @()
foreach ($mesh in $meshes) {
    $totalSize = 0
    $meshName = $mesh.name
    if (-not $meshName) { $meshName = "unnamed" }
    
    foreach ($pr in $mesh.primitives) {
        # Check attributes (POSITION, NORMAL, TEXCOORD, etc.)
        foreach ($attr in $pr.attributes.psobject.properties) {
            $accIdx = $attr.Value
            $acc = $data.accessors[$accIdx]
            $bvIdx = $acc.bufferView
            $bv = $bufferViews[$bvIdx]
            $totalSize += $bv.byteLength
        }
        # Check indices
        if ($pr.indices -ne $null) {
            $accIdx = $pr.indices
            $acc = $data.accessors[$accIdx]
            $bvIdx = $acc.bufferView
            $bv = $bufferViews[$bvIdx]
            $totalSize += $bv.byteLength
        }
    }
    
    $meshSizes += [PSCustomObject]@{
        Name = $meshName
        SizeMb = [Math]::Round($totalSize / 1MB, 2)
    }
}

# Sort by size descending and print top 20 heaviest meshes
$meshSizes = $meshSizes | Sort-Object SizeMb -Descending
Write-Host "`nTop 20 heaviest meshes in GLB:"
$i = 1
foreach ($ms in $meshSizes[0..19]) {
    Write-Host ("#$i : MeshName='" + $ms.Name + "', EstSize=" + $ms.SizeMb + " MB")
    $i++
}
