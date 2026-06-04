import json

with open('stellar_setup.glb', 'rb') as f:
    magic = f.read(4)
    version = int.from_bytes(f.read(4), 'little')
    length = int.from_bytes(f.read(4), 'little')
    json_chunk_length = int.from_bytes(f.read(4), 'little')
    json_chunk_type = f.read(4)
    json_data = f.read(json_chunk_length).decode('utf-8')
    data = json.loads(json_data)
    
    meshes = set()
    materials = set()
    for m in data.get('meshes', []):
        meshes.add(m.get('name', ''))
    for m in data.get('materials', []):
        materials.add(m.get('name', ''))
        
    print('MESHES:')
    for m in meshes: print(m)
    print('MATERIALS:')
    for m in materials: print(m)
