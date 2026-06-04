$content = Get-Content -Path "glb_header.json" -Raw -Encoding utf8
$data = ConvertFrom-Json -InputObject $content

$targetMeshes = @(412, 413, 414, 424, 425, 426, 540, 542)

Write-Host "NODES USING TARGET MESHES:"
$nodeIdx = 0
foreach ($n in $data.nodes) {
    if ($n.mesh -ne $null) {
        $mIdx = $n.mesh
        if ($targetMeshes -contains $mIdx) {
            $name = if ($n.name) { $n.name } else { "(null)" }
            Write-Host "Node $nodeIdx - Mesh = $mIdx - Name = '$name'"
        }
    }
    $nodeIdx++
}
