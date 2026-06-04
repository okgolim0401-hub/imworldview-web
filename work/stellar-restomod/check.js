const fs = require('fs');
const buffer = fs.readFileSync('stellar_setup.glb');
const jsonLength = buffer.readUInt32LE(12);
const jsonBuffer = buffer.slice(20, 20 + jsonLength);
const jsonStr = jsonBuffer.toString('utf-8');
const data = JSON.parse(jsonStr);

const meshes = new Set();
const materials = new Set();

if (data.meshes) data.meshes.forEach(m => meshes.add(m.name || ''));
if (data.materials) data.materials.forEach(m => materials.add(m.name || ''));

console.log('MESHES:');
meshes.forEach(m => console.log(m));
console.log('MATERIALS:');
materials.forEach(m => console.log(m));
