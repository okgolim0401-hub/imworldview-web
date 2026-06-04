[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$content = Get-Content -Path "glb_header.json" -Raw -Encoding utf8
$data = ConvertFrom-Json -InputObject $content

Write-Host "Searching for possible lettering nodes/materials..."

$idx = 0
foreach ($node in $data.nodes) {
    $name = $node.name
    $meshIdx = $node.mesh
    
    $matName = ""
    $meshName = ""
    if ($meshIdx -ne $null) {
        $mesh = $data.meshes[$meshIdx]
        $meshName = $mesh.name
        if ($mesh.primitives -ne $null -and $mesh.primitives.Count -gt 0) {
            $prim = $mesh.primitives[0]
            if ($prim.material -ne $null -and $data.materials -ne $null -and $prim.material -lt $data.materials.Count) {
                $matName = $data.materials[$prim.material].name
            }
        }
    }
    
    $combined = ""
    if ($name -ne $null) { $combined += " " + $name }
    if ($meshName -ne $null) { $combined += " " + $meshName }
    if ($matName -ne $null) { $combined += " " + $matName }
    $combined = $combined.ToLower()
    
    if ($combined.Contains("stellar") -or $combined.Contains("letter") -or $combined.Contains("text") -or $combined.Contains("plate") -or $combined.Contains("logo")) {
        Write-Host "Node: $idx | NodeName: $name | MeshName: $meshName | MatName: $matName"
    }
    $idx++
}
