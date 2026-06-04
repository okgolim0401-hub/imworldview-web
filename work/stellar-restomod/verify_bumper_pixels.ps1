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

$centerZ = -3.12428

Write-Host "--- BUMPER PIXEL DETAILS (VERTICES AND INDICES COUNT) ---"

$nodeIdx = 0
foreach ($node in $data.nodes) {
    if ($node.mesh -ne $null) {
        $meshIdx = $node.mesh
        $mesh = $data.meshes[$meshIdx]
        
        $mIdx = $null
        $posAccessorIdx = $null
        $indexAccessorIdx = $null
        if ($mesh.primitives -ne $null -and $mesh.primitives.Count -gt 0) {
            $prim = $mesh.primitives[0]
            if ($prim.material -ne $null) {
                $mIdx = $prim.material
            }
            if ($prim.attributes -ne $null -and $prim.attributes.POSITION -ne $null) {
                $posAccessorIdx = $prim.attributes.POSITION
            }
            if ($prim.indices -ne $null) {
                $indexAccessorIdx = $prim.indices
            }
        }
        
        if ($posAccessorIdx -ne $null) {
            $acc = $data.accessors[$posAccessorIdx]
            if ($acc.min -ne $null -and $acc.max -ne $null) {
                $minX = $acc.min[0]; $maxX = $acc.max[0]
                $minY = $acc.min[1]; $maxY = $acc.max[1]
                $minZ = $acc.min[2]; $maxZ = $acc.max[2]
                
                $pos = Get-AbsoluteTranslation $nodeIdx
                $tx = $pos[0]; $ty = $pos[1]; $tz = $pos[2]
                
                $width = $maxX - $minX
                $height = $maxY - $minY
                $depth = $maxZ - $minZ
                
                $xCenter = (($minX + $maxX) / 2) + $tx
                $yCenter = (($minY + $maxY) / 2) + $ty - 0.049
                $zCenter = (($minZ + $maxZ) / 2) + $tz - $centerZ
                
                $isSmallPixel = ($width -lt 0.08) -and ($height -lt 0.08) -and ($depth -lt 0.08)
                $isBumperPixel = $isSmallPixel -and `
                                 ([Math]::Abs($xCenter) -gt 0.4) -and `
                                 ([Math]::Abs($xCenter) -lt 0.7) -and `
                                 ($yCenter -gt 0.55) -and `
                                 ($yCenter -lt 0.78) -and `
                                 ($zCenter -gt 2.2) -and `
                                 ($zCenter -lt 2.7)
                                 
                if ($isBumperPixel) {
                    $vertexCount = $data.accessors[$posAccessorIdx].count
                    $indexCount = "none"
                    if ($indexAccessorIdx -ne $null) {
                        $indexCount = $data.accessors[$indexAccessorIdx].count
                    }
                    $matName = "default"
                    if ($mIdx -ne $null) {
                        $matName = $data.materials[$mIdx].name
                    }
                    Write-Host "Node: $nodeIdx | Mesh: $meshIdx | Mat: $mIdx ($matName) | Center: ($($xCenter.ToString('F3')), $($yCenter.ToString('F3')), $($zCenter.ToString('F3'))) | Verts: $vertexCount | Indices: $indexCount"
                }
            }
        }
    }
    $nodeIdx++
}
