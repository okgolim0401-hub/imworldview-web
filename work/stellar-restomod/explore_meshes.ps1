try {
    $content = Get-Content -Path "glb_header.json" -Raw -Encoding utf8
    $data = ConvertFrom-Json -InputObject $content
    
    $out = @()
    $i = 0
    foreach ($m in $data.meshes) {
        $matNames = @()
        foreach ($p in $m.primitives) {
            if ($p.material -ne $null) {
                $matIndex = $p.material
                $matName = $data.materials[$matIndex].name
                $matNames += "$matIndex ($matName)"
            }
        }
        $mName = if ($m.name) { $m.name } else { "(unnamed)" }
        $line = 'Mesh ' + $i + ': Name=' + $mName + ' Materials=[' + ($matNames -join ', ') + ']'
        $out += $line
        $i++
    }
    
    $out | Out-File -FilePath "explored_meshes.txt" -Encoding utf8
    Write-Output "EXPLORE_SUCCESS"
} catch {
    Write-Error $_.Exception.Message
}
