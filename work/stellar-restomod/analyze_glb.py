import struct
import json

def analyze_glb(filepath):
    print(f"Analyzing {filepath}...")
    with open(filepath, 'rb') as f:
        # GLB Header
        magic = f.read(4)
        if magic != b'glTF':
            print("Not a valid glTF file")
            return
        
        version, = struct.unpack('<I', f.read(4))
        length, = struct.unpack('<I', f.read(4))
        print(f"GLB Version: {version}, Total Length: {length / (1024*1024):.2f} MB")
        
        # Chunk 0: JSON
        chunk_length, = struct.unpack('<I', f.read(4))
        chunk_type = f.read(4)
        if chunk_type != b'JSON':
            print("First chunk is not JSON")
            return
            
        json_data = f.read(chunk_length).decode('utf-8')
        gltf = json.loads(json_data)
        
        # Print main glTF structures count
        print(f"Meshes count: {len(gltf.get('meshes', []))}")
        print(f"Nodes count: {len(gltf.get('nodes', []))}")
        print(f"Accessors count: {len(gltf.get('accessors', []))}")
        print(f"BufferViews count: {len(gltf.get('bufferViews', []))}")
        print(f"Images count: {len(gltf.get('images', []))}")
        
        # Check images
        images = gltf.get('images', [])
        for idx, img in enumerate(images):
            name = img.get('name', 'unnamed')
            mimeType = img.get('mimeType', 'unknown')
            bufferView = img.get('bufferView', 'none')
            print(f"Image {idx}: name='{name}', mimeType='{mimeType}', bufferView={bufferView}")

if __name__ == "__main__":
    analyze_glb("stellar_setup.glb")
