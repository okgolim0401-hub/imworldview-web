$bytes = [System.IO.File]::ReadAllBytes("stellar_setup.glb")

# Read JSON chunk length
$jsonLength = [System.BitConverter]::ToUInt32($bytes, 12)
Write-Host "JSON Chunk Length - $jsonLength"

# Extract JSON string
$jsonBytes = New-Object byte[] $jsonLength
[System.Array]::Copy($bytes, 20, $jsonBytes, 0, $jsonLength)
$jsonStr = [System.Text.Encoding]::UTF8.GetString($jsonBytes)

# Parse JSON
$data = ConvertFrom-Json $jsonStr

# Print materials
Write-Host "`nMATERIALS in GLB:"
$matIndex = 0
foreach ($mat in $data.materials) {
    $n = $mat.name
    Write-Host "Material $matIndex - Name = $n"
    $matIndex++
}

# Print nodes
Write-Host "`nNODES in GLB:"
$nodeIndex = 0
foreach ($node in $data.nodes) {
    if ($node.name) {
        $n = $node.name
        Write-Host "Node $nodeIndex - Name = '$n'"
    }
    $nodeIndex++
}
