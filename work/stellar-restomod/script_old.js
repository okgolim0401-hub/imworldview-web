let scene, camera, renderer, controls, model;
let envMap, currentEnvMap;
let activeMaterial = null;

// Honda 스타일 상태 관리
const state = {
    color: { name: 'Ivory White', hex: '#f5f5f0' },
    scene: 'navy' // 기본 배경을 네이비로 설정
};

init();
animate();

function init() {
    // 1. Scene & Renderer
    scene = new THREE.Scene();
    scene.background = new THREE.Color(0x1a2030); // 기본 네이비 배경
    
    const container = document.getElementById('webgl-container');
    camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 0.1, 1000);
    camera.position.set(-8, 3, 10);

    renderer = new THREE.WebGLRenderer({ antialias: true, powerPreference: "high-performance" });
    renderer.setSize(window.innerWidth, window.innerHeight);
    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
    renderer.shadowMap.enabled = true;
    renderer.shadowMap.type = THREE.PCFSoftShadowMap;
    renderer.outputEncoding = THREE.sRGBEncoding;
    renderer.toneMapping = THREE.ACESFilmicToneMapping;
    renderer.toneMappingExposure = 1.2;
    container.appendChild(renderer.domElement);

    // 2. Controls
    controls = new THREE.OrbitControls(camera, renderer.domElement);
    controls.enableDamping = true;
    controls.dampingFactor = 0.05;
    controls.maxPolarAngle = Math.PI / 2.1;
    controls.minDistance = 5;
    controls.maxDistance = 20;

    // 3. Lighting & Environment
    setupLighting('navy');

    // 4. Ground
    setupGround('navy');

    // 5. Model Loading
    const loader = new THREE.GLTFLoader();
    loader.load('stella.glb', (gltf) => {
        model = gltf.scene;
        
        // 중앙 정렬
        const box = new THREE.Box3().setFromObject(model);
        const center = box.getCenter(new THREE.Vector3());
        model.position.sub(center);
        
        model.traverse((child) => {
            if (child.isMesh) {
                const mat = child.material;
                const matName = mat.name || '';
                
                mat.envMap = currentEnvMap;
                mat.envMapIntensity = 1.5;
                child.castShadow = true;
                child.receiveShadow = true;

                // 초기 재질 품질 최적화
                mat.metalness = Math.max(mat.metalness, 0.85);
                mat.roughness = Math.min(mat.roughness, 0.2);

                // --- 초기 재질 컬러 자동 세팅 ---
                // 바디 페인트 (한국어/영어 모두 포함)
                if (matName === '페인트' || matName === 'Paint' || matName === 'Metal (2)') {
                    mat.color.set(state.color.hex);
                    mat.metalness = 0.9;
                    mat.roughness = 0.15;
                }
                // 블랙 트림
                else if (matName === 'Paint (3)') {
                    mat.color.set(0x111111);
                    mat.metalness = 0.95;
                    mat.roughness = 0.1;
                }
                // 유리
                else if (matName.includes('Plastic')) {
                    mat.transparent = true;
                    mat.opacity = 0.25;
                    mat.color.set(0x9dc4d6);
                    mat.roughness = 0.01;
                }
            }
        });
        
        scene.add(model);
        startIntro();
        
    }, (xhr) => {
        if (xhr.total > 0) {
            const percent = Math.round((xhr.loaded / xhr.total) * 100);
            document.querySelector('.drop-title').innerText = 'Loading... ' + percent + '%';
        }
    });

    // 6. UI Interaction Setup
    setupUI();

    window.addEventListener('resize', onWindowResize);
    renderer.domElement.addEventListener('click', onModelClick);
}

function setupLighting(type) {
    // 기존 조명 제거
    scene.children.filter(c => c.isLight).forEach(l => scene.remove(l));

    if (type === 'navy') {
        scene.background = new THREE.Color(0x1a2030);
        const ambient = new THREE.AmbientLight(0xffffff, 0.4);
        const main = new THREE.DirectionalLight(0xffffff, 1.5);
        main.position.set(5, 10, 7.5);
        main.castShadow = true;
        scene.add(ambient, main);

        // 네이비 블루 포인트 라이트 (시네마틱)
        const p1 = new THREE.PointLight(0x4466ff, 1.5, 20);
        p1.position.set(-10, 5, -5);
        scene.add(p1);
    } else {
        scene.background = new THREE.Color(0xd0d0d0);
        const ambient = new THREE.AmbientLight(0xffffff, 0.7);
        const main = new THREE.DirectionalLight(0xffffff, 1.2);
        main.position.set(5, 10, 5);
        main.castShadow = true;
        scene.add(ambient, main);
    }

    // EnvMap 갱신
    const pmremGenerator = new THREE.PMREMGenerator(renderer);
    currentEnvMap = pmremGenerator.fromScene(new THREE.Scene()).texture;
    if (model) {
        model.traverse(c => { if(c.isMesh) c.material.envMap = currentEnvMap; });
    }
}

function setupGround(type) {
    const existingGround = scene.getObjectByName('ground');
    if (existingGround) scene.remove(existingGround);

    const groundGeo = new THREE.CircleGeometry(50, 64);
    const groundMat = new THREE.MeshStandardMaterial({ 
        color: type === 'navy' ? 0x2a3040 : 0xbbbbbb,
        roughness: 0.2,
        metalness: 0.1
    });
    const ground = new THREE.Mesh(groundGeo, groundMat);
    ground.name = 'ground';
    ground.rotation.x = -Math.PI / 2;
    ground.position.y = -2.05;
    ground.receiveShadow = true;
    scene.add(ground);
}

function setupUI() {
    // 사이드바 아이콘 클릭
    document.querySelectorAll('.sidebar-icon').forEach(btn => {
        btn.addEventListener('click', () => {
            const panelId = 'panel-' + btn.dataset.panel;
            const targetPanel = document.getElementById(panelId);
            const isOpen = targetPanel.classList.contains('open');

            // 모든 패널 닫기
            document.querySelectorAll('.slide-panel').forEach(p => p.classList.remove('open'));
            document.querySelectorAll('.sidebar-icon').forEach(i => i.classList.remove('active'));

            if (!isOpen) {
                targetPanel.classList.add('open');
                btn.classList.add('active');
            }
        });
    });

    // 패널 닫기 버튼
    document.querySelectorAll('.panel-close').forEach(btn => {
        btn.addEventListener('click', () => {
            document.querySelectorAll('.slide-panel').forEach(p => p.classList.remove('open'));
            document.querySelectorAll('.sidebar-icon').forEach(i => i.classList.remove('active'));
        });
    });

    // 컬러 스와치 클릭
    document.querySelectorAll('.swatch').forEach(swatch => {
        swatch.addEventListener('click', () => {
            const color = swatch.dataset.color;
            const name = swatch.dataset.name;
            
            // UI 업데이트
            document.querySelectorAll('.swatch').forEach(s => s.classList.remove('active'));
            swatch.classList.add('active');
            document.getElementById('color-info').innerText = name;
            document.getElementById('status-color-name').innerText = '차체색 : ' + name;

            // 모델 컬러 변경 (페인트 & Paint 동시 타겟)
            if (model) {
                model.traverse(child => {
                    if (child.isMesh) {
                        const mn = child.material.name || '';
                        if (mn === '페인트' || mn === 'Paint' || mn === 'Metal (2)') {
                            child.material.color.set(color);
                            child.material.needsUpdate = true;
                        }
                    }
                });
            }
        });
    });

    // 배경 전환
    document.querySelectorAll('.scene-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            const type = btn.dataset.scene;
            document.querySelectorAll('.scene-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            
            setupLighting(type);
            setupGround(type);
        });
    });

    // 재질 슬라이더
    document.getElementById('mat-metal').addEventListener('input', (e) => {
        if (activeMaterial) activeMaterial.metalness = parseFloat(e.target.value);
    });
    document.getElementById('mat-rough').addEventListener('input', (e) => {
        if (activeMaterial) activeMaterial.roughness = parseFloat(e.target.value);
    });
}

function onModelClick(event) {
    const mouse = new THREE.Vector2(
        (event.clientX / window.innerWidth) * 2 - 1,
        -(event.clientY / window.innerHeight) * 2 + 1
    );

    const raycaster = new THREE.Raycaster();
    raycaster.setFromCamera(mouse, camera);
    const intersects = raycaster.intersectObjects(scene.children, true);

    if (intersects.length > 0) {
        const object = intersects[0].object;
        if (object.isMesh && object.material) {
            activeMaterial = object.material;
            
            // 재질 패널 자동 열기
            document.querySelectorAll('.slide-panel').forEach(p => p.classList.remove('open'));
            document.querySelectorAll('.sidebar-icon').forEach(i => i.classList.remove('active'));
            
            const matPanel = document.getElementById('panel-material');
            matPanel.classList.add('open');
            document.querySelector('[data-panel="material"]').classList.add('active');
            
            document.getElementById('selected-part').innerText = activeMaterial.name || 'Unknown Part';
            document.getElementById('mat-metal').value = activeMaterial.metalness;
            document.getElementById('mat-rough').value = activeMaterial.roughness;
        }
    }
}

function startIntro() {
    const overlay = document.getElementById('intro-overlay');
    const yearText = document.getElementById('year-counter');
    const dropZone = document.getElementById('drop-zone');
    
    if(dropZone) dropZone.style.display = 'none';

    let year = 1980;
    yearText.style.opacity = '1';
    
    const counter = setInterval(() => {
        year += 1;
        yearText.innerText = year;
        if (year >= 2024) {
            clearInterval(counter);
            setTimeout(() => {
                overlay.style.opacity = '0';
                setTimeout(() => {
                    overlay.style.display = 'none';
                    // Honda UI 요소들 나타내기
                    document.getElementById('sidebar').classList.remove('hidden');
                    document.getElementById('top-nav').classList.remove('hidden');
                    document.getElementById('status-bar').classList.remove('hidden');
                }, 1500);
            }, 1000);
        }
    }, 30);
}

function onWindowResize() {
    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();
    renderer.setSize(window.innerWidth, window.innerHeight);
}

function animate() {
    requestAnimationFrame(animate);
    if (controls) controls.update();
    renderer.render(scene, camera);
}
