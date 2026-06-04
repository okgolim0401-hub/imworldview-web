[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$content = Get-Content -Path "glb_header.json" -Raw -Encoding utf8
$data = ConvertFrom-Json -InputObject $content

$parents = @{}
$idx = 0
foreach ($node in $data.nodes) {
    if ($node.children -ne $null) {
        foreach ($c in $node.children) {
            $parents[$c] = $idx
        }
    }
    $idx++
}

Write-Host "--- FRONT LIGHTS & LOGOS ---"
$nodeIdx = 0
foreach ($node in $data.nodes) {
    if ($node.mesh -ne $null) {
        $meshIdx = $node.mesh
        $mesh = $data.meshes[$meshIdx]
        
        $mIdx = $null
        if ($mesh.primitives -ne $null -and $mesh.primitives.Count -gt 0) {
            $prim = $mesh.primitives[0]
            if ($prim.material -ne $null) {
                $mIdx = $prim.material
            }
        }
        
        if ($mIdx -eq 10 -or $mIdx -eq 5) {
            # Find translation
            $tx = 0.0; $ty = 0.0; $tz = 0.0
            if ($node.translation -ne $null) {
                $tx = $node.translation[0]
                $ty = $node.translation[1]
                $tz = $node.translation[2]
            }
            
            # Parent translation
            $pIdx = $parents[$nodeIdx]
            if ($pIdx -ne $null) {
                $pNode = $data.nodes[$pIdx]
                if ($pNode.translation -ne $null) {
                    $tx += $pNode.translation[0]
                    $ty += $pNode.translation[1]
                    $tz += $pNode.translation[2]
                }
            }
            
            $matName = $data.materials[$mIdx].name
            Write-Host "Node: $nodeIdx | Mesh: $meshIdx | Mat: $mIdx ($matName) | Pos: ($tx, $ty, $tz)"
        }
    }
    $nodeIdx++
}
