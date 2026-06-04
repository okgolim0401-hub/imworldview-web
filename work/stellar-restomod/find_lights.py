import json
import struct

with open('stellar_setup.glb', 'rb') as f:
    header = f.read(20)
    magic, version, length, json_length, json_format = struct.unpack('<IIIII', header)
    json_data = f.read(json_length)

data = json.loads(json_data.decode('utf-8'))

print("--- MATERIALS ---")
if 'materials' in data:
    for idx, mat in enumerate(data['materials']):
        name = mat.get('name', '')
        emissive = mat.get('emissiveFactor', [0,0,0])
        print(f"Material {idx}: Name='{name}' Emissive={emissive}")

print("\n--- NODES WITH MESHES ---")
node_map = {}
if 'nodes' in data:
    for idx, node in enumerate(data['nodes']):
        node_map[idx] = node

def get_absolute_translation(node_idx):
    t = [0.0, 0.0, 0.0]
    curr_idx = node_idx
    visited = set()
    while curr_idx is not None and curr_idx not in visited:
        visited.add(curr_idx)
        node = node_map.get(curr_idx)
        if not node:
            break
        if 'translation' in node:
            t[0] += node['translation'][0]
            t[1] += node['translation'][1]
            t[2] += node['translation'][2]
        
        # Find parent
        parent = None
        for i, n in node_map.items():
            if 'children' in n and curr_idx in n['children']:
                parent = i
                break
        curr_idx = parent
    return t

if 'nodes' in data:
    for node_idx, node in node_map.items():
        if 'mesh' in node:
            mesh_idx = node['mesh']
            mesh = data['meshes'][mesh_idx]
            mesh_name = mesh.get('name', '')
            abs_pos = get_absolute_translation(node_idx)
            
            primitives = mesh.get('primitives', [])
            mat_indices = [p.get('material') for p in primitives if p.get('material') is not None]
            mat_names = []
            for m_idx in mat_indices:
                if 'materials' in data and m_idx < len(data['materials']):
                    mat_names.append(data['materials'][m_idx].get('name', ''))
                else:
                    mat_names.append('default')
            
            print(f"Node {node_idx}: Name='{node.get('name', '')}', Mesh {mesh_idx}: Name='{mesh_name}', Pos=[{', '.join(f'{v:.3f}' for v in abs_pos)}], Materials={mat_names}")
