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

$gMinX = [double]::MaxValue; $gMaxX = [double]::MinValue
$gMinY = [double]::MaxValue; $gMaxY = [double]::MinValue
$gMinZ = [double]::MaxValue; $gMaxZ = [double]::MinValue

$nodeIdx = 0
foreach ($node in $data.nodes) {
    if ($node.mesh -ne $null) {
        $meshIdx = $node.mesh
        $mesh = $data.meshes[$meshIdx]
        
        $posAccessorIdx = $null
        if ($mesh.primitives -ne $null -and $mesh.primitives.Count -gt 0) {
            $prim = $mesh.primitives[0]
            if ($prim.attributes -ne $null -and $prim.attributes.POSITION -ne $null) {
                $posAccessorIdx = $prim.attributes.POSITION
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
                
                $wMinX = $minX + $tx; $wMaxX = $maxX + $tx
                $wMinY = $minY + $ty; $wMaxY = $maxY + $ty
                $wMinZ = $minZ + $tz; $wMaxZ = $maxZ + $tz
                
                if ($wMinX -lt $gMinX) { $gMinX = $wMinX }
                if ($wMaxX -gt $gMaxX) { $gMaxX = $wMaxX }
                if ($wMinY -lt $gMinY) { $gMinY = $wMinY }
                if ($wMaxY -gt $gMaxY) { $gMaxY = $wMaxY }
                if ($wMinZ -lt $gMinZ) { $gMinZ = $wMinZ }
                if ($wMaxZ -gt $gMaxZ) { $gMaxZ = $wMaxZ }
            }
        }
    }
    $nodeIdx++
}

$centerX = ($gMinX + $gMaxX) / 2
$centerY = ($gMinY + $gMaxY) / 2
$centerZ = ($gMinZ + $gMaxZ) / 2

Write-Host "GLB Bounding Box:"
Write-Host "Min: ($gMinX, $gMinY, $gMinZ)"
Write-Host "Max: ($gMaxX, $gMaxY, $gMaxZ)"
Write-Host "Center: ($centerX, $centerY, $centerZ)"
