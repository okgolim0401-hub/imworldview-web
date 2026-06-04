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

function Get-AbsoluteTranslation($nIdx) {
    $tx = 0.0; $ty = 0.0; $tz = 0.0
    $curr = $nIdx
    $visited = @()
    while ($curr -ne $null -and -not ($visited -contains $curr)) {
        $visited += $curr
        $n = $data.nodes[$curr]
        if ($n -ne $null) {
            if ($n.translation -ne $null) {
                $tx += $n.translation[0]
                $ty += $n.translation[1]
                $tz += $n.translation[2]
            }
        }
        $curr = $parents[$curr]
    }
    return @($tx, $ty, $tz)
}

Write-Host "--- FRONT BUMPER REGION MESHES ---"
$nodeIdx = 0
foreach ($node in $data.nodes) {
    if ($node.mesh -ne $null) {
        $meshIdx = $node.mesh
        $mesh = $data.meshes[$meshIdx]
        
        $mIdx = $null
        $posAccessorIdx = $null
        if ($mesh.primitives -ne $null -and $mesh.primitives.Count -gt 0) {
            $prim = $mesh.primitives[0]
            if ($prim.material -ne $null) {
                $mIdx = $prim.material
            }
            if ($prim.attributes -ne $null -and $prim.attributes.POSITION -ne $null) {
                $posAccessorIdx = $prim.attributes.POSITION
            }
        }
        
        # Get accessor bounds
        $minX = 0.0; $maxX = 0.0; $minY = 0.0; $maxY = 0.0; $minZ = 0.0; $maxZ = 0.0
        if ($posAccessorIdx -ne $null) {
            $acc = $data.accessors[$posAccessorIdx]
            if ($acc.min -ne $null -and $acc.max -ne $null) {
                $minX = $acc.min[0]; $maxX = $acc.max[0]
                $minY = $acc.min[1]; $maxY = $acc.max[1]
                $minZ = $acc.min[2]; $maxZ = $acc.max[2]
            }
        }
        
        # Absolute translation of the node
        $pos = Get-AbsoluteTranslation $nodeIdx
        $tx = $pos[0]; $ty = $pos[1]; $tz = $pos[2]
        
        # Compute world bounds
        $wMinX = $minX + $tx; $wMaxX = $maxX + $tx
        $wMinY = $minY + $ty; $wMaxY = $maxY + $ty
        $wMinZ = $minZ + $tz; $wMaxZ = $maxZ + $tz
        
        $wCenterX = ($wMinX + $wMaxX) / 2
        $wCenterY = ($wMinY + $wMaxY) / 2
        $wCenterZ = ($wMinZ + $wMaxZ) / 2
        
        $width = $wMaxX - $wMinX
        $height = $wMaxY - $wMinY
        $depth = $wMaxZ - $wMinZ
        
        # Symmetrical bumper light search space
        if ($wCenterY -gt 0.5 -and $wCenterY -lt 0.8) {
            $matName = "default"
            if ($mIdx -ne $null) {
                $matName = $data.materials[$mIdx].name
            }
            Write-Host "Node: $nodeIdx | Mesh: $meshIdx | Mat: $mIdx ($matName) | PosCenter: ($($wCenterX.ToString('F3')), $($wCenterY.ToString('F3')), $($wCenterZ.ToString('F3'))) | Size: ($($width.ToString('F3')), $($height.ToString('F3')), $($depth.ToString('F3')))"
        }
    }
    $nodeIdx++
}
