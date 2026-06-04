const fs = require('fs');

const buffer = fs.readFileSync('stellar_setup.glb');
const jsonLength = buffer.readUInt32LE(12);
const jsonBuffer = buffer.slice(20, 20 + jsonLength);
const jsonStr = jsonBuffer.toString('utf-8');
const data = JSON.parse(jsonStr);

console.log('--- MATERIALS ---');
if (data.materials) {
    data.materials.forEach((mat, idx) => {
        console.log(`Material ${idx}: Name='${mat.name || ""}' Emissive=${JSON.stringify(mat.emissiveFactor || [0,0,0])}`);
    });
}

console.log('\n--- NODES WITH MESHES ---');
const nodeMap = new Map();
if (data.nodes) {
    data.nodes.forEach((node, idx) => {
        nodeMap.set(idx, node);
    });
}

function getAbsoluteTranslation(nodeIdx) {
    let t = [0, 0, 0];
    let currIdx = nodeIdx;
    let visited = new Set();
    while (currIdx !== undefined && currIdx !== null && !visited.has(currIdx)) {
        visited.add(currIdx);
        const node = nodeMap.get(currIdx);
        if (!node) break;
        if (node.translation) {
            t[0] += node.translation[0];
            t[1] += node.translation[1];
            t[2] += node.translation[2];
        }
        // Find parent
        let parent = null;
        if (data.nodes) {
            for (let i = 0; i < data.nodes.length; i++) {
                if (data.nodes[i].children && data.nodes[i].children.includes(currIdx)) {
                    parent = i;
                    break;
                }
            }
        }
        currIdx = parent;
    }
    return t;
}

if (data.nodes) {
    data.nodes.forEach((node, nodeIdx) => {
        if (node.mesh !== undefined) {
            const mesh = data.meshes[node.mesh];
            const meshName = mesh.name || "";
            const absPos = getAbsoluteTranslation(nodeIdx);
            
            // Check materials used in primitives
            const primitives = mesh.primitives || [];
            const matIndices = primitives.map(p => p.material).filter(m => m !== undefined);
            const matNames = matIndices.map(idx => data.materials[idx] ? data.materials[idx].name || "" : "default");

            console.log(`Node ${nodeIdx}: Name='${node.name || ""}', Mesh ${node.mesh}: Name='${meshName}', Pos=[${absPos.map(v => v.toFixed(3)).join(', ')}], Materials=[${matNames.join(', ')}]`);
        }
    });
}
