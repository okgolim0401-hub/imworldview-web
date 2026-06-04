$ErrorActionPreference = "Stop"
$root = $PSScriptRoot
if (-not $root) { $root = Get-Location }

# 1. Create a temporary folder for Node.js
$tempDir = Join-Path $root "nodejs_tmp"
if (Test-Path $tempDir) { Remove-Item -Recurse -Force $tempDir }
New-Item -ItemType Directory -Path $tempDir | Out-Null

$zipPath = Join-Path $tempDir "node.zip"
$nodeUrl = "https://nodejs.org/dist/v18.16.0/node-v18.16.0-win-x64.zip"

Write-Host "1. Downloading portable Node.js v18.16.0 (~30MB) using curl.exe..."
& curl.exe -L -o "$zipPath" "$nodeUrl"
Write-Host "Download complete!"

Write-Host "`n2. Extracting Node.js zip..."
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory($zipPath, $tempDir)
Write-Host "Extraction complete!"

# Find node.exe and npm paths
$nodeDir = Get-ChildItem -Path $tempDir -Directory | Select-Object -First 1
$nodeExe = Join-Path $nodeDir.FullName "node.exe"
$npmCli = Join-Path $nodeDir.FullName "node_modules\npm\bin\npm-cli.js"

# CRITICAL FIX: Add temporary node.exe path to active environment PATH so npm can call 'node'
$nodeDirFull = $nodeDir.FullName
$env:PATH = "$nodeDirFull;$env:PATH"
Write-Host ("Added to PATH: " + $nodeDirFull)

Write-Host ("Node.exe path: " + $nodeExe)
Write-Host ("Npm path: " + $npmCli)

Write-Host "`n3. Installing gltf-pipeline locally inside the temp folder..."
# CRITICAL FIX: Added --ignore-scripts to completely bypass postinstall script compilation and prevent node error
$installArgs = @($npmCli, "install", "gltf-pipeline", "--no-audit", "--no-fund", "--ignore-scripts", "--prefix", $tempDir)
& $nodeExe $installArgs
Write-Host "gltf-pipeline installation complete!"

Write-Host "`n4. Running Google Draco Compression (HIGH QUALITY) on stellar_setup.glb -> stellar_setup_compressed.glb..."
# Locate gltf-pipeline entry script
$pipelineScript = Join-Path $tempDir "node_modules\gltf-pipeline\bin\gltf-pipeline.js"
# HIGH QUALITY DRACO: Position 20-bit (default 14), Normal 14-bit (default 10), TexCoord 14-bit (default 12)
# This preserves mesh surface fidelity while still achieving significant compression.
$compressArgs = @($pipelineScript, "-i", "stellar_setup.glb", "-o", "stellar_setup_compressed.glb", "-d", "--draco.quantizePositionBits", "20", "--draco.quantizeNormalBits", "14", "--draco.quantizeTexcoordBits", "14", "--draco.quantizeColorBits", "10", "--draco.compressionLevel", "7")
& $nodeExe $compressArgs
Write-Host "Draco Compression finished successfully!"

# Validate compressed file size
if (Test-Path "stellar_setup_compressed.glb") {
    $compSize = (Get-Item "stellar_setup_compressed.glb").Length
    Write-Host ("`nSUCCESS! Compressed GLB created: stellar_setup_compressed.glb")
    Write-Host ("Compressed Size: " + [Math]::Round($compSize / 1MB, 2) + " MB (Original was 287.67 MB!)")
} else {
    Write-Error "Failed to generate compressed GLB file"
}

Write-Host "`n5. Cleaning up temporary Node.js and installation files..."
# Clear environment PATH first
$env:PATH = $env:PATH.Replace("$nodeDirFull;", "")
# Safe cleanup loop to dodge EPERM locks
for ($retry=1; $retry -le 5; $retry++) {
    try {
        [System.GC]::Collect()
        [System.GC]::WaitForPendingFinalizers()
        Remove-Item -Recurse -Force $tempDir
        break
    } catch {
        Write-Host "Locked files detected, retrying cleanup in 1s ($retry/5)..."
        Start-Sleep -Seconds 1
    }
}
Write-Host "Cleanup complete! Workspace is clean."
