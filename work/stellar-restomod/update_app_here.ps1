try {
    $filePath = "app.js"
    # Read file contents as a single string
    $content = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)

    # Normalize content line endings to LF
    $content = $content -replace "`r`n", "`n"

    # 1. isTargetWheel condition
    $oldWheel = @'
            const isTargetWheel = (s) => {
                if (!s) return false;
                const lo = s.toLowerCase();
                return (lo.includes('wheel') || lo.includes('rim') || lo.includes('disc') || lo.includes('\ud72c')) 
                       && !lo.includes('tire');
            };
'@ -replace "`r`n", "`n"

    $newWheel = @'
            const isTargetWheel = (s) => {
                if (!s) return false;
                const lo = s.toLowerCase();
                return (lo.includes('wheel') || lo.includes('rim') || lo.includes('disc') || lo.includes('휠')) 
                       && !lo.includes('tire');
            };
'@ -replace "`r`n", "`n"

    # 2. Headlight Cover & Glass Handlers
    $oldHeadlightAndGlass = @'
                // A. Convert inner headlight glass covers into solid glowing premium horizontal line lights (DRL Bars)
                // This replaces the "shabby-looking" 9 individual dots with a rich, uniform glowing light bar!
                const isHeadlightBar = (rawMesh === 'mesh_540' || rawMesh === 'mesh_542');
                if (isHeadlightBar) {
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
                    child.material.emissiveIntensity = 10.0; // Solid glowing bar!
                    child.material.metalness = 0.0;
                    child.material.roughness = 0.0;
                    child.material.toneMapped = false;
                    child.material.needsUpdate = true;
                    return; // Done
                }

                // 1. Handle Glass / Translucent Lenses
                // CRITICAL: mesh_527 (left) and mesh_519 (right) are the clear protective lenses over the bumper pixel lights.
                // Because they were named "踰⑦듃?쇱씤" in Rhino, they were treated as opaque trim, completely blocking the emission!
                const isBumperLens = (rawMesh === 'mesh_527' || rawMesh === 'mesh_519');
                if (isGlassName(rawMat) || isGlassName(rawMesh) || isBumperLens) {
                    child.material.transparent = true;
                    child.material.opacity = 0.15; // Extremely clear
                    child.material.metalness = 0.1; // CRITICAL: High metalness absorbs light in PBR. Must be low for transmission!
                    child.material.roughness = 0.0; // Perfectly smooth
                    child.material.color.set(0xffffff); // Clear glass
                    child.material.depthWrite = false; // Prevents glass from hiding objects behind it
                    child.material.needsUpdate = true;
                    return; // Prevent fall-through to body paint or black trims!
                }
'@ -replace "`r`n", "`n"

    $newHeadlightAndGlass = @'
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
'@ -replace "`r`n", "`n"

    # 3. Bumper Pixel
    $oldBumper = @'
                if (isBumperPixel) {
                    child.material = child.material.clone();
                    child.material.map = null;
                    child.material.emissiveMap = null;
                    child.material.lightMap = null;
                    child.material.aoMap = null;
                    child.material.vertexColors = false;
                    child.material.color.set(0xaaaaaa); // Brighter diffuse base to show clean white light
                    child.material.emissive.set(0xffffff);
                    child.material.emissiveIntensity = 0.75; // Perfectly balanced intensity so it clearly glows but stays separated!
                    child.material.metalness = 0.0; // CRITICAL: Reset metalness so empty materials can emit light!
                    child.material.roughness = 0.0; // CRITICAL: Smooth emissive surface
                    child.material.toneMapped = true; // CRITICAL: Use tone mapping to keep 4 pixels crisp and separate!
                    child.material.needsUpdate = true;
                    return; // Done
                }
'@ -replace "`r`n", "`n"

    $newBumper = @'
                if (isBumperPixel) {
                    child.material = child.material.clone();
                    child.material.map = null;
                    child.material.emissiveMap = null;
                    child.material.lightMap = null;
                    child.material.aoMap = null;
                    child.material.vertexColors = false;
                    child.material.color.set(0xaaaaaa); // Brighter diffuse base to show clean white light
                    child.material.emissive.set(0xffffff);
                    child.material.emissiveIntensity = 0.5; // Perfectly balanced intensity so it clearly glows but stays separated!
                    child.material.metalness = 0.0; // CRITICAL: Reset metalness so empty materials can emit light!
                    child.material.roughness = 0.0; // CRITICAL: Smooth emissive surface
                    child.material.toneMapped = true; // CRITICAL: Use tone mapping to keep 4 pixels crisp and separate!
                    child.material.needsUpdate = true;
                    return; // Done
                }
'@ -replace "`r`n", "`n"

    # 4. Wheels Material
    $oldWheelMat = @'
                // 4. Targeted Wheels (Metal Gray)
                if (isTargetWheel(rawMat) || isTargetWheel(rawMesh)) {
                    child.material.color.set(0x888888); // Metal Gray
                    child.material.metalness = 0.9;
                    child.material.roughness = 0.4;
                }
'@ -replace "`r`n", "`n"

    $newWheelMat = @'
                // 4. Targeted Wheels (Polished Premium Chrome/Silver Metal)
                if (isTargetWheel(rawMat) || isTargetWheel(rawMesh)) {
                    child.material = child.material.clone();
                    child.material.color.set(0xdddddd); // Polished Silver
                    child.material.metalness = 1.0; // Pure metal reflection
                    child.material.roughness = 0.15; // Smooth specular finish
                    child.material.needsUpdate = true;
                    return; // Done
                }
'@ -replace "`r`n", "`n"

    # 5. Film Grain Post Processing
    $oldFilm = @'
        // Film Grain Pass for cinematic noise texture
        const filmPass = new THREE.FilmPass(0.25, 0.0, 0, false); // Subtle noise, no scanlines, color noise

        const composer = new THREE.EffectComposer(renderer);
        composer.addPass(renderScene);
        composer.addPass(bloomPass);
        composer.addPass(filmPass);
'@ -replace "`r`n", "`n"

    $newFilm = @'
        const composer = new THREE.EffectComposer(renderer);
        composer.addPass(renderScene);
        composer.addPass(bloomPass);
'@ -replace "`r`n", "`n"

    # Check replacements
    $contentBefore = $content
    $content = $content.Replace($oldWheel, $newWheel)
    if ($contentBefore -eq $content) { Write-Warning "Replacement 1 (Wheel Helper) failed to match!" }

    $contentBefore = $content
    $content = $content.Replace($oldHeadlightAndGlass, $newHeadlightAndGlass)
    if ($contentBefore -eq $content) { Write-Warning "Replacement 2 (Headlight & Glass) failed to match!" }

    $contentBefore = $content
    $content = $content.Replace($oldBumper, $newBumper)
    if ($contentBefore -eq $content) { Write-Warning "Replacement 3 (Bumper Pixels) failed to match!" }

    $contentBefore = $content
    $content = $content.Replace($oldWheelMat, $newWheelMat)
    if ($contentBefore -eq $content) { Write-Warning "Replacement 4 (Wheel Material) failed to match!" }

    $contentBefore = $content
    $content = $content.Replace($oldFilm, $newFilm)
    if ($contentBefore -eq $content) { Write-Warning "Replacement 5 (Film Pass) failed to match!" }

    # Restore CRLF line endings before saving
    $content = $content -replace "`n", "`r`n"

    # Write file back in UTF8
    [System.IO.File]::WriteAllText($filePath, $content, [System.Text.Encoding]::UTF8)
    Write-Output "APP_UPDATE_SUCCESS"
} catch {
    Write-Error $_.Exception.Message
}
