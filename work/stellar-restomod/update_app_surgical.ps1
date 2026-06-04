$newBlock = @'
// A. Convert inner rectangular glass blocks behind headlights to premium glowing light bars
                // Left Headlight: mesh_412, mesh_413, mesh_414 | Right Headlight: mesh_424, mesh_425, mesh_426
                const isHeadlightGlowingRect = (
                    rawMesh === 'mesh_412' || rawMesh === 'mesh_413' || rawMesh === 'mesh_414' ||
                    rawMesh === 'mesh_424' || rawMesh === 'mesh_425' || rawMesh === 'mesh_426'
                );
                if (isHeadlightGlowingRect) {
                    child.material = child.material.clone();
                    child.material.map = null;
                    child.material.emissiveMap = null;
                    child.material.lightMap = null;
                    child.material.aoMap = null;
                    child.material.vertexColors = false;
                    child.material.transparent = false;
                    child.material.opacity = 1.0;
                    child.material.color.set(0xffeedd); // Warm white premium LED
                    child.material.emissive.set(0xffeedd);
                    child.material.emissiveIntensity = 8.0; // Clean glowing light!
                    child.material.metalness = 0.0;
                    child.material.roughness = 0.0;
                    child.material.toneMapped = false;
                    child.material.needsUpdate = true;
                    return; // Done
                }

                // 1. Handle Glass / Translucent Lenses
                const isBumperLens = (rawMesh === 'mesh_527' || rawMesh === 'mesh_519');
                if (isGlassName(rawMat) || isGlassName(rawMesh) || isBumperLens) {
                    child.material = child.material.clone();
                    child.material.transparent = true;
                    
                    // Separate cabin windows from protective light covers based on dimension
                    const maxDim = Math.max(wWidth, wHeight, wDepth);
                    const isCabinWindow = maxDim > 0.35;
                    
                    if (isCabinWindow) {
                        // Premium Tinted Cabin Windows
                        child.material.opacity = 0.45; // Sleek dark tint opacity
                        child.material.color.set(0x1a212b); // Deep premium dark tint
                        child.material.metalness = 0.1;
                        child.material.roughness = 0.05;
                    } else {
                        // Clear Protective Light Covers
                        child.material.opacity = 0.15; // Transparent enough to see glowing internals
                        child.material.color.set(0xffffff); // Clear
                        child.material.metalness = 0.0;
                        child.material.roughness = 0.0;
                    }
                    
                    child.material.depthWrite = false; // Prevents glass from hiding objects behind it
                    child.material.needsUpdate = true;
                    return; // Prevent fall-through to body paint or black trims!
                }
                
                
'@

$newWheelBlock = @'
// 4. Targeted Wheels (Polished Premium Chrome/Silver Metal)
                if (isTargetWheel(rawMat) || isTargetWheel(rawMesh)) {
                    child.material = child.material.clone();
                    child.material.color.set(0xdddddd); // Polished Silver
                    child.material.metalness = 1.0; // Pure metal reflection
                    child.material.roughness = 0.15; // Smooth specular finish
                    child.material.needsUpdate = true;
                    return; // Done
                }

                
'@

$newFilmBlock = @'
const composer = new THREE.EffectComposer(renderer);
        composer.addPass(renderScene);
        composer.addPass(bloomPass);
'@

try {
    $filePath = "app.js"
    $content = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)

    # 1. replace \ud72c with 휠 (using unicode char escape to prevent encoding bugs)
    $wheelChar = [char]0xd720
    $content = $content.Replace('\ud72c', $wheelChar)
    Write-Host "Step 1: Wheel helper unicode replaced."

    # 2. Surgical Headlight Glow & Glass Handlers
    $startAnchor = "// A. Convert inner headlight glass covers"
    $endAnchor = "// Silver Metallic Paint Default"
    $startIndex = $content.IndexOf($startAnchor)
    $endIndex = $content.IndexOf($endAnchor)

    if ($startIndex -ge 0 -and $endIndex -gt $startIndex) {
        $oldBlock = $content.Substring($startIndex, $endIndex - $startIndex)
        $content = $content.Replace($oldBlock, $newBlock)
        Write-Host "Step 2: Headlight & Glass block updated successfully."
    } else {
        Write-Error "Step 2 anchors not found: startIndex=$startIndex, endIndex=$endIndex"
    }

    # 3. Bumper Pixel intensity
    $bumperAnchor = "if (isBumperPixel)"
    $bumperIndex = $content.IndexOf($bumperAnchor)
    if ($bumperIndex -ge 0) {
        $intensityAnchor = "emissiveIntensity = 0.75;"
        $intensityIndex = $content.IndexOf($intensityAnchor, $bumperIndex)
        if ($intensityIndex -gt $bumperIndex) {
            # Replace only that single instance of 0.75
            $content = $content.Substring(0, $intensityIndex) + "emissiveIntensity = 0.5;" + $content.Substring($intensityIndex + $intensityAnchor.Length)
            Write-Host "Step 3: Bumper pixel intensity updated to 0.5."
        } else {
            Write-Error "Step 3 intensity anchor not found."
        }
    } else {
        Write-Error "Step 3 bumper anchor not found."
    }

    # 4. Wheels Material
    $wheelStart = "// 4. Targeted Wheels"
    $wheelEnd = "// 5. Targeted Black Trims"
    $wStartIndex = $content.IndexOf($wheelStart)
    $wEndIndex = $content.IndexOf($wheelEnd)
    if ($wStartIndex -ge 0 -and $wEndIndex -gt $wStartIndex) {
        $oldWheelBlock = $content.Substring($wStartIndex, $wEndIndex - $wStartIndex)
        $content = $content.Replace($oldWheelBlock, $newWheelBlock)
        Write-Host "Step 4: Wheels material updated successfully."
    } else {
        Write-Error "Step 4 anchors not found."
    }

    # 5. Film Grain Post-processing removal
    $filmStart = "// Film Grain Pass for cinematic noise texture"
    $filmEnd = "composer.addPass(filmPass);"
    $fStartIndex = $content.IndexOf($filmStart)
    $fEndIndex = $content.IndexOf($filmEnd)
    if ($fStartIndex -ge 0 -and $fEndIndex -gt $fStartIndex) {
        $oldFilmBlock = $content.Substring($fStartIndex, ($fEndIndex - $fStartIndex) + $filmEnd.Length)
        $content = $content.Replace($oldFilmBlock, $newFilmBlock)
        Write-Host "Step 5: Film grain noise pass removed successfully."
    } else {
        Write-Error "Step 5 anchors not found."
    }

    # Write back the modified content with UTF8-BOM to match original
    [System.IO.File]::WriteAllText($filePath, $content, [System.Text.Encoding]::UTF8)
    Write-Host "SURGICAL_PATCH_COMPLETED"
} catch {
    Write-Error $_.Exception.Message
}
