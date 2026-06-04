// --- DOM Elements ---
const bootLoader = document.getElementById('boot-loader');

// --- Initialization ---
document.addEventListener('DOMContentLoaded', () => {
    // Force scroll to top on page reload
    if ('scrollRestoration' in history) {
        history.scrollRestoration = 'manual';
    }
    window.scrollTo(0, 0);

    // Initialize immediately without boot sequence
    document.body.style.overflow = 'auto';
    document.body.style.overflowX = 'hidden';
    initSectionReveal();
    initGridLines();
    initScrambleEffect();
    initDigitalScramble();
    initPremiumVideoLoop();
});

function initPremiumVideoLoop() {
    const video = document.getElementById('premium-video');
    if (!video) return;

    // Listen to the 'ended' event, wait 1 second (1000ms), then play again
    video.addEventListener('ended', () => {
        setTimeout(() => {
            video.play().catch(err => console.log('Video play interrupted:', err));
        }, 1000);
    });
}

function initSectionReveal() {
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('visible');
            }
        });
    }, { threshold: 0.1 });

    document.querySelectorAll('section').forEach(section => {
        observer.observe(section);
    });
}

function runBootSequence() {
    const containers = document.querySelectorAll('.pixel-container');

    // 1. Draw Pixels sequentially
    containers.forEach((container, index) => {
        setTimeout(() => {
            container.classList.add('drawn');
        }, 500 + (index * 800)); // Adjusted rhythm: 800ms between each square
    });

    // 2. Complete Boot Sequence immediately after drawing
    const totalDrawTime = 500 + (containers.length * 800);
    setTimeout(() => {
        completeBootSequence();
    }, totalDrawTime + 800);

    // 3. SAFETY FALLBACK: Force hide after 8 seconds if something hangs
    setTimeout(() => {
        if (bootLoader && bootLoader.style.display !== 'none') {
            console.log('Safety fallback: Hiding boot loader');
            completeBootSequence();
        }
    }, 8000);
}

function completeBootSequence() {
    // Fade out the boot loader
    bootLoader.style.opacity = '0';

    // Restore scrolling and hide boot loader completely
    setTimeout(() => {
        bootLoader.style.display = 'none';
        document.body.style.overflow = 'auto';
        document.body.style.overflowX = 'hidden';

        initGridLines();
        initScrambleEffect(); // Initialize scramble reveal effects only after the boot screen is gone!
        initDigitalScramble(); // Initialize digital decoding only after the boot screen is gone!
    }, 200);
}

// --- Line Animations ---
function initGridLines() {
    const lines = document.querySelectorAll('.grid-line-h, .grid-line-v');

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                // Delay slightly for organic feel
                setTimeout(() => {
                    entry.target.classList.add('active');
                }, 100);
                observer.unobserve(entry.target); 
            }
        });
    }, { threshold: 0.1 });

    lines.forEach(line => {
        // If it's a fixed line, animate it immediately since the intro is done
        if (line.closest('.fixed')) {
            setTimeout(() => {
                line.classList.add('active');
            }, 300); 
        } else {
            // Otherwise, animate when scrolled into view
            observer.observe(line);
        }
    });
}

// --- Text Scramble Effect ---
function initScrambleEffect() {
    const sections = document.querySelectorAll('section');
    
    // Hide scramble text elements initially and cache their original text to prevent flicker
    document.querySelectorAll('.scramble-text').forEach(el => {
        const text = el.innerText.trim();
        if (text.length > 0 && !el.dataset.original) {
            el.dataset.original = text;
        }
        el.style.opacity = '0';
    });
    
    function getElementDelay(el, sectionIndex) {
        if (sectionIndex === 0) {
            // Hero section
            if (el.tagName === 'H1') return 150; // Title (BAS RELIEF)
            if (el.textContent.includes('TOKTOK') || el.dataset.original?.includes('TOKTOK')) return 0; // Subtitle (TOKTOK SHADOW)
            if (el.dataset.revealDelay === '2800') return 2300; // DATE label & value
            if (el.dataset.revealDelay === '3000') return 2500; // INDUSTRY label & value
            if (el.dataset.revealDelay === '3200') return 2700; // EXHIBITION label & value
            return 1200; // default hero fallback
        }
        
        if (sectionIndex === 1) {
            // Concept Section (Overview / 01)
            if (el.textContent.includes('OVERVIEW') || el.dataset.original?.includes('OVERVIEW')) return 0; // Overview / 01 label
            if (el.tagName === 'H2') return 400; // Main Title (CONNECTING PAST...)
            if (el.id === 'english-text-trigger') return 3200; // English Paragraph
            if (el.tagName === 'P') return 1800; // Korean Paragraph
            return 800;
        }
        
        if (sectionIndex === 2) {
            // Gallery Section (Visualization / 02)
            if (el.textContent.includes('MATERIALITY') || el.dataset.original?.includes('MATERIALITY') || el.textContent.includes('PRODUCTION LOG') || el.dataset.original?.includes('PRODUCTION LOG')) return 0; // Label
            if (el.tagName === 'H2') return 400; // Main Title (THE ART OF STEEL...)
            const paragraphs = Array.from(el.closest('section').querySelectorAll('p.scramble-text'));
            if (el === paragraphs[0]) return 1800; // Korean Paragraph
            if (el === paragraphs[1]) return 3200; // English Paragraph
            return 800;
        }
        
        if (sectionIndex === 3) {
            // 3D Configurator Section (Design Perspectives / 03)
            if (el.textContent.includes('DESIGN PERSPECTIVES') || el.dataset.original?.includes('DESIGN PERSPECTIVES')) return 0; // Label
            return 400;
        }
        
        if (sectionIndex === 4) {
            // Footer Section (Next: LIVING FRAGMENTS)
            if (el.textContent.includes('NEXT') || el.dataset.original?.includes('NEXT')) return 0;
            return 200;
        }
        
        return 0;
    }

    function scramble(el, delay) {
        el.dataset.scrambling = 'true';
        const originalText = el.dataset.original || el.innerText;
        const length = originalText.length;
        
        
        
        // Determine original target opacity to avoid turning gray/dimmed texts white during reveal!
        let targetOpacity = '1';
        if (el.classList.contains('opacity-70')) targetOpacity = '0.7';
        else if (el.classList.contains('opacity-60')) targetOpacity = '0.6';
        else if (el.classList.contains('opacity-40')) targetOpacity = '0.4';
        else if (el.classList.contains('opacity-80')) targetOpacity = '0.8';
        
        el.style.opacity = targetOpacity; // Smoothly show the container with its correct native opacity!
        
        let output = '';
        const charData = [];
        
        const escapeHTML = (str) => {
            return str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
        };

        for (let i = 0; i < length; i++) {
            if (originalText[i] === ' ' || originalText[i] === '\n') {
                output += originalText[i];
                charData.push(null);
                continue;
            }
            
            const safeChar = escapeHTML(originalText[i]);
            let extraStyle = '';
            if (safeChar === ',') extraStyle = 'font-family: Inter, sans-serif;';
            if (originalText[i] === 'L' && i < length - 1 && originalText[i+1] === 'A') {
                extraStyle += ' margin-right: 0.06em;';
            }
            
            const transDuration = '1.2s';
            output += `<span class="reveal-char" style="opacity: 0; filter: blur(3px); display: inline; transition: opacity ${transDuration} cubic-bezier(0.16, 1, 0.3, 1), filter ${transDuration} cubic-bezier(0.16, 1, 0.3, 1); ${extraStyle}">${safeChar}</span>`;
            charData.push(i);
        }
        
        el.innerHTML = output;
        const spans = el.querySelectorAll('.reveal-char');
        
        let seed = 0;
        for (let i = 0; i < length; i++) seed += originalText.charCodeAt(i);
        
        const validIndices = [];
        for (let i = 0; i < length; i++) {
            if (charData[i] !== null) validIndices.push(i);
        }
        
        const shuffledIndices = [...validIndices];
        for (let i = shuffledIndices.length - 1; i > 0; i--) {
            const x = Math.sin(seed++) * 10000;
            const rand = x - Math.floor(x);
            const j = Math.floor(rand * (i + 1));
            [shuffledIndices[i], shuffledIndices[j]] = [shuffledIndices[j], shuffledIndices[i]];
        }
        
        // Stretched the stagger duration slightly for short texts so they don't look rushed
        let staggerDuration = length < 30 ? 1200 : (length < 100 ? 1600 : 2200);
        if (originalText.includes('competition') || originalText.includes('Restomod') || originalText.includes('TOKTOK') || originalText.includes('SHADOW') || originalText.includes('BAS RELIEF')) {
            staggerDuration = 1200;
        }
        const interval = shuffledIndices.length > 0 ? staggerDuration / shuffledIndices.length : 0;
        
        setTimeout(() => {
            let spanIndex = 0;
            for (let i = 0; i < length; i++) {
                if (charData[i] === null) continue;
                
                const currentSpan = spans[spanIndex];
                const rank = shuffledIndices.indexOf(i);
                let calculatedDelay = rank * interval;
                
                setTimeout(() => {
                    currentSpan.style.opacity = '1';
                    currentSpan.style.filter = 'blur(0px)';
                }, calculatedDelay);
                
                spanIndex++;
            }
            
            setTimeout(() => {
                // By keeping the spans instead of replacing with finalHTML, 
                // we prevent the kerning-related layout shift (line break 'pop') 
                // that occurs when the browser suddenly recalculates text width without spans.
                
                // Remove the initial scramble-text class and clear inline opacity so standard stylesheet handles it
                el.classList.remove('scramble-text');
                el.style.opacity = ''; 

                // Fallback trigger (in case early trigger didn't fire)
                if (el.id === 'english-text-trigger') {
                    if (window.startDiagramSequence) {
                        window.startDiagramSequence();
                    }
                }
            }, staggerDuration + 1500); 

            // Early diagram trigger: fire 1000ms before the text fully settles (tight pacing)
            if (el.id === 'english-text-trigger') {
                const finalOffset = (length < 30 || originalText.includes('competition') || originalText.includes('Restomod') || originalText.includes('TOKTOK') || originalText.includes('SHADOW') || originalText.includes('BAS RELIEF')) ? 1000 : 1300;
                setTimeout(() => {
                    if (window.startDiagramSequence) {
                        window.startDiagramSequence();
                    }
                }, staggerDuration + finalOffset - 1000);
            }
            
        }, delay);
    }

    function triggerSectionSequence(section, sectionIndex) {
        const elements = Array.from(section.querySelectorAll('.scramble-text')).filter(el => {
            return !el.classList.contains('digital-scramble') && !el.classList.contains('diagram-text');
        });
        
        if (sectionIndex === 2 || sectionIndex === 3) {
            // Gallery Sections (02 and 03) are very tall, so paragraphs should observe element-level viewport entry!
            const elementObserver = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        const el = entry.target;
                        if (!el.dataset.scrambling) {
                            const text = el.innerText.trim();
                            if (text.length > 0 && !el.dataset.original) {
                                el.dataset.original = text;
                            }
                            scramble(el, 150); // Eased 150ms timing for highly organic scrolling entry reveal
                            elementObserver.unobserve(el);
                        }
                    }
                });
            }, { threshold: 0.15, rootMargin: '0px 0px -5% 0px' });

            elements.forEach(el => {
                const text = el.innerText.trim();
                if (text.length > 0 && !el.dataset.original) {
                    el.dataset.original = text;
                }
                
                // Gallery header label triggers instantly, description paragraphs trigger on view-scroll entry
                if (el.textContent.includes('MATERIALITY') || el.dataset.original?.includes('MATERIALITY') || el.textContent.includes('PRODUCTION LOG') || el.dataset.original?.includes('PRODUCTION LOG')) {
                    scramble(el, 0);
                } else {
                    elementObserver.observe(el);
                }
            });
        } else {
            // Default sequential stagger flow for standard sections
            elements.forEach(el => {
                const text = el.innerText.trim();
                if (text.length > 0 && !el.dataset.original) {
                    el.dataset.original = text;
                }
                const delay = getElementDelay(el, sectionIndex);
                scramble(el, delay);
            });
        }
        
        // Horizontal line expansions
        if (sectionIndex === 0) {
            const line = section.querySelector('.expand-line');
            if (line) {
                setTimeout(() => {
                    line.classList.add('active');
                    line.classList.add('expanded');
                }, 1100); // Trigger horizontal line at 1100ms (as title is almost fully revealed)
            }
        }
    }

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const section = entry.target;
                const sectionIndex = Array.from(sections).indexOf(section);
                
                if (!section.dataset.revealed) {
                    section.dataset.revealed = 'true';
                    observer.unobserve(section);
                    triggerSectionSequence(section, sectionIndex);
                }
            }
        });
    }, { threshold: 0.1, rootMargin: '0px 0px -10% 0px' });

    sections.forEach(section => {
        observer.observe(section);
    });

    // Force immediate trigger for Hero section to ensure banner and title scramble play flawlessly on initial load
    setTimeout(() => {
        const heroSection = sections[0];
        if (heroSection && !heroSection.dataset.revealed) {
            heroSection.dataset.revealed = 'true';
            observer.unobserve(heroSection);
            triggerSectionSequence(heroSection, 0);
        }
    }, 200);
}

// --- Digital Scramble Effect (Original) ---
function initDigitalScramble() {
    // Removed wide characters like W, M, O from scramble pool to prevent wrapping/jumping
    const chars = '!<>-_\\/[]{}??+*^?#_0123456789ILTFJ';
    const elements = document.querySelectorAll('.digital-scramble:not(.diagram-text)');

    elements.forEach(el => {
        // Prepare element
        const originalText = el.dataset.original || el.innerText;
        if (!el.dataset.original) el.dataset.original = originalText;
        
        const length = originalText.length;
        el.style.opacity = '1';
        
        let frame = 0;
        
        // Read hierarchy parameters from dataset
        const delay = parseInt(el.dataset.decodeDelay) || 0;
        const maxFrames = parseInt(el.dataset.decodeDuration) || (30 + Math.random() * 20);
        
        // Initial text clearing so it's not visible before scramble starts
        el.innerHTML = '';
        for (let i=0; i<length; i++) {
            if (originalText[i] === ' ' || originalText[i] === '\n') el.innerHTML += originalText[i];
            else el.innerHTML += chars[Math.floor(Math.random() * chars.length)];
        }
        el.innerHTML = el.innerHTML.replace(/\n/g, '<br/>');

        // Trigger scramble immediately after boot complete + element specific delay
        setTimeout(() => {
            const interval = setInterval(() => {
                let output = '';
                for (let i = 0; i < length; i++) {
                    if (originalText[i] === ' ' || originalText[i] === '\n') {
                        output += originalText[i];
                        continue;
                    }
                    
                    const revealThreshold = Math.max(0, (frame - 10) / (maxFrames - 10));
                    if (Math.random() < revealThreshold) {
                        output += originalText[i];
                    } else {
                        output += chars[Math.floor(Math.random() * chars.length)];
                    }
                }
                
                // Keep line breaks if any
                el.innerHTML = output.replace(/\n/g, '<br/>');
                
                frame++;
                if (frame > maxFrames) {
                    clearInterval(interval);
                    el.innerHTML = originalText.replace(/\n/g, '<br/>');
                }
            }, 50); // 50ms interval = faster, more natural wave
        }, delay); 
    });
}

// --- 3D Viewer (Stella Configurator) ---
(function initStellaViewer() {
    const container = document.getElementById('webgl-container');
    let startViewer;
    if (!container || typeof THREE === 'undefined') {
        console.log("3D Viewer container or THREE not found. Skipping 3D setup.");
    } else {
        let scene, camera, renderer, controls, model;
        const GROUND_Y = 0;
        const PAINT_COLOR_IVORY = '#fdfdfb'; // Default: Elegant Pearl Ivory
        const INTERIOR_ORANGE = '#d37a3c';   // Rich Cognac/Orange Interior

        startViewer = () => {
        const rect = container.getBoundingClientRect();
        if (rect.width === 0) { requestAnimationFrame(startViewer); return; }

        // Scene
        scene = new THREE.Scene();
        scene.background = new THREE.Color(0x080808);

        // Camera
        camera = new THREE.PerspectiveCamera(30, rect.width / rect.height, 0.1, 100);
        camera.position.set(3.8, 3.3, 5.8); // High-angle top-down front-left quarter view matching user's rendering
 
        // Renderer setup
        renderer = new THREE.WebGLRenderer({ antialias: true, powerPreference: 'high-performance' });
        renderer.setSize(rect.width, rect.height);
        renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
        renderer.shadowMap.enabled = true;
        renderer.shadowMap.type = THREE.PCFSoftShadowMap;
        renderer.outputEncoding = THREE.sRGBEncoding;
        renderer.toneMapping = THREE.LinearToneMapping; // Reverted back to linear tone mapping
        renderer.toneMappingExposure = 1.0;
        container.appendChild(renderer.domElement);
 
        // Environment Setup (Reference Image 2 - Dark Navy Wall, Bright Floor)
        const bgColor = 0x07090b; // Dark navy/black wall
        scene.background = new THREE.Color(bgColor);
        scene.fog = new THREE.Fog(bgColor, 5, 30); // Fade the bright floor into the dark wall
 
        // Controls
        controls = new THREE.OrbitControls(camera, renderer.domElement);
        controls.enableDamping = true;
        controls.dampingFactor = 0.05;
        controls.maxPolarAngle = Math.PI / 2.05;
        controls.minDistance = 4; // Allow zooming in closer
        controls.maxDistance = 20;
        controls.target.set(0, 0.40, 0); // Balanced target centering on the car body

        // Studio Lighting - Avoid Specular Glare by moving light directly overhead
        const ambient = new THREE.AmbientLight(0xffffff, 0.15); // Soft ambient
        const spotLight = new THREE.SpotLight(0xffffff, 1.0); // Balanced intensity
        spotLight.position.set(-10, 12, 2); // Moved to the top-left to cast a beautiful shadow to the right
        spotLight.angle = Math.PI / 3;
        spotLight.penumbra = 1.0; // Extremely soft edge for the floor pool
        spotLight.castShadow = true;
        spotLight.shadow.mapSize.set(2048, 2048);
        spotLight.shadow.bias = -0.001; // Balance between shadow acne and Peter Panning (floating)
        spotLight.shadow.normalBias = 0.05; // Smooths shadow edges on curved surfaces
        const fillLight = new THREE.DirectionalLight(0xffffff, 0.25); // Soft fill to prevent crushed blacks
        fillLight.position.set(10, 5, -10);
        scene.add(ambient, spotLight, fillLight);

        // Premium Matte Studio Floor - Bright gray, completely matte.
        // It catches the overhead spotlight beautifully, then fades into the dark navy fog.
        const groundMat = new THREE.MeshStandardMaterial({ color: 0x666b75, roughness: 1.0, metalness: 0.0 });
        const ground = new THREE.Mesh(new THREE.PlaneGeometry(100, 100), groundMat);
        ground.rotation.x = -Math.PI / 2;
        ground.position.y = GROUND_Y;
        ground.receiveShadow = true;
        scene.add(ground);

        // Load GLB (Draco Compressed)
        const loader = new THREE.GLTFLoader();
        const dracoLoader = new THREE.DRACOLoader();
        dracoLoader.setDecoderPath('https://www.gstatic.com/draco/versioned/decoders/1.4.3/');
        loader.setDRACOLoader(dracoLoader);

        loader.load('stellar_setup_compressed.glb', (gltf) => {
            model = gltf.scene;
            window.stellarModel = model;

            // Center & ground the model
            const box = new THREE.Box3().setFromObject(model);
            const center = box.getCenter(new THREE.Vector3());
            model.position.x -= center.x;
            model.position.z -= center.z;

            // Find lowest wheel point to ensure perfect grounding without hovering over invisible planes
            let lowestWheelY = Infinity;
            let hasWheel = false;
            model.traverse((child) => {
                if (child.isMesh) {
                    const name = (child.name || '').toLowerCase();
                    const matName = (child.material && child.material.name ? child.material.name : '').toLowerCase();
                    if (name.includes('wheel') || name.includes('tire') || name.includes('바퀴') || name.includes('타이어') ||
                        matName.includes('wheel') || matName.includes('tire') || matName.includes('바퀴') || matName.includes('타이어')) {
                        const wheelBox = new THREE.Box3().setFromObject(child);
                        if (wheelBox.min.y < lowestWheelY) {
                            lowestWheelY = wheelBox.min.y;
                            hasWheel = true;
                        }
                    }
                }
            });
            const trueMinY = hasWheel ? lowestWheelY : box.min.y;
            model.position.y -= trueMinY - GROUND_Y;
            model.position.y -= 0.02; // Sink tires 2cm into the floor for realistic grounded weight
            model.updateMatrixWorld(true);

            // Helper: is a name a paint keyword?
            const isPaintName = (s) => {
                if (!s) return false;
                const lo = s.toLowerCase();
                return lo.includes('차체'); 
            };

            const isGlassName = (s) => {
                if (!s) return false;
                const lo = s.toLowerCase();
                return lo.includes('glass') || lo.includes('window') || 
                       lo.includes('유리') || lo.includes('투명') || lo.includes('plastic');
            };

            const isLightName = (s) => {
                if (!s) return false;
                const lo = s.toLowerCase();
                return lo.includes('light') || lo.includes('emissive') || lo.includes('emission') ||
                       lo.includes('발광') || lo.includes('램프') || lo.includes('pixel') || lo.includes('불빛') ||
                       lo.includes('led') || lo.includes('조명') || lo.includes('라이트') || lo.includes('라이트') ||
                       lo.includes('headlight') || lo.includes('lamp') || lo.includes('glow') || lo.includes('drl') || 
                       lo.includes('turn') || lo.includes('signal') || lo.includes('전조등') || lo.includes('방향지시등') || 
                       lo.includes('깜빡이') || lo.includes('안개등') || lo.includes('미등') || lo.includes('후미등');
            };

            const isTargetInterior = (s) => {
                if (!s) return false;
                const lo = s.toLowerCase();
                return lo.includes('seat') || lo.includes('시트') || 
                       lo.includes('천장') || lo.includes('ceiling') || lo.includes('roof') ||
                       lo.includes('paint') || lo.includes('페인트');
            };

            const isTargetWheel = (s) => {
                if (!s) return false;
                const lo = s.toLowerCase();
                return (lo.includes('wheel') || lo.includes('휠') || lo.includes('rim') || lo.includes('disc')) 
                       && !lo.includes('tire');
            };

            const isTargetBlack = (s) => {
                if (!s) return false;
                const lo = s.toLowerCase();
                return lo.includes('trim') || lo.includes('frame') || lo.includes('bumper') || 
                       lo.includes('base') || lo.includes('skirt') || lo.includes('black') || 
                       lo.includes('pill') || lo.includes('mold') || lo.includes('grill') || 
                       lo.includes('inner') || lo.includes('well') || lo.includes('artifact') ||
                       lo.includes('belt') || lo.includes('벨트') || lo.includes('handle') || lo.includes('손잡이') ||
                       lo.includes('vent') || lo.includes('hole') || lo.includes('실내') || lo.includes('interior') ||
                       lo.includes('dash') || lo.includes('대시보드');
            };


            const meshLog = [];
            model.traverse((child) => {
                if (!child.isMesh) return;
                child.castShadow = true;
                child.receiveShadow = true;

                const rawMat = child.material ? child.material.name || '' : '';
                const rawMesh = child.name || '';
                meshLog.push({ mesh: rawMesh, mat: rawMat });

                // Calculate geometry dimensions (local)
                child.geometry.computeBoundingBox();
                const bbox = child.geometry.boundingBox;
                const width = bbox.max.x - bbox.min.x;
                const height = bbox.max.y - bbox.min.y;
                const depth = bbox.max.z - bbox.min.z;

                // Calculate true world center coordinates (fool-proof spatial override)
                const localCenter = new THREE.Vector3();
                bbox.getCenter(localCenter);
                const worldCenter = localCenter.clone().applyMatrix4(child.matrixWorld);
                const xCenter = worldCenter.x;
                const yCenter = worldCenter.y;
                const zCenter = worldCenter.z;

                if (!child.material) return;
                child.material = child.material.clone();
                child.material.side = THREE.DoubleSide;
                child.material.needsUpdate = true;

                // SPATIAL OVERRIDE: Front bumper pixel lights (Symmetrical Left/Right, subtle white bloom)
                // Filter specifically for the tiny pixel meshes (width < 0.08) and exclude the larger background panel grid meshes (width 0.111)
                const isSmallPixel = width < 0.08 && height < 0.08 && depth < 0.08;
                const isBumperPixel = isSmallPixel && 
                                       Math.abs(xCenter) > 0.4 && 
                                       Math.abs(xCenter) < 0.7 && 
                                       yCenter > 0.55 &&
                                       yCenter < 0.78 && 
                                       zCenter > 2.2 &&
                                       zCenter < 2.7;

                if (isBumperPixel) {
                    // Filter emitting pixel faces (verts < 30) from surrounding housing/reflector shells (verts >= 100)
                    const vertexCount = (child.geometry.attributes.position) ? child.geometry.attributes.position.count : 0;
                    const isRealPixel = vertexCount < 30;

                    if (isRealPixel) {
                        // Recreate a clean standard material to completely wipe out GLTF transmission extensions (e.g. from Material 10)
                        child.material = new THREE.MeshStandardMaterial({
                            color: 0xffffff,
                            emissive: 0xffffff,
                            emissiveIntensity: 0.70, // Lowered from 1.2 to keep the 4 pixels beautifully distinct
                            roughness: 0.1,
                            metalness: 0.1,
                            side: THREE.DoubleSide,
                            toneMapped: false
                        });
                    } else {
                        // Background housing & overlap shells -> Completely turn off emissive to prevent blending blobbing!
                        child.material = new THREE.MeshStandardMaterial({
                            color: 0x151820, // Refined premium dark housing trim
                            emissive: 0x000000,
                            emissiveIntensity: 0.0,
                            roughness: 0.20,
                            metalness: 0.90,
                            side: THREE.DoubleSide
                        });
                    }
                    child.material.needsUpdate = true;
                    return; // Done
                }

                // SPATIAL OVERRIDE: Rear license plate 'STELLAR' Lettering (Force Silver/Grey Metallic)
                // Center coordinates: Z is around -2.42, Y is around 0.64, |X| < 0.22
                // Size: width < 0.08, height < 0.08, depth < 0.02
                // These were set to '??댁뼱' material or unassigned. By strictly filtering for rawMat === '??댁뼱',
                // we only metalize the actual letters, keeping the inner letter holes (A and R) hollow and empty!
                const isSmallLetter = width < 0.08 && height < 0.08 && depth < 0.02;
                const isRearLettering = isSmallLetter &&
                                        zCenter < -2.35 && 
                                        zCenter > -2.48 && 
                                        yCenter > 0.60 && 
                                        yCenter < 0.70 && 
                                        Math.abs(xCenter) < 0.22 &&
                                        rawMat.includes('??댁뼱');

                if (isRearLettering) {
                    child.material = new THREE.MeshStandardMaterial({
                        color: 0xcccccc, // Beautiful light metallic silver gray
                        metalness: 0.90,
                        roughness: 0.15,
                        side: THREE.DoubleSide
                    });
                    child.material.needsUpdate = true;
                    return; // Done
                }

                // SPATIAL OVERRIDE: Rear Tail Light Outer Cover Glass (Material 7, empty name)
                // These cover meshes sit directly in front of the rear vertical and horizontal tail lights.
                // By making them crystal-clear transparent glass, we allow the inner glowing tail lights 
                // to shine through beautifully and trigger the magnificent, thick red HDR bloom!
                const isRearLightCover = rawMat === '' && 
                                         zCenter < -2.20 && 
                                         yCenter > 0.50 && 
                                         yCenter < 1.10;

                if (isRearLightCover) {
                    child.material = new THREE.MeshStandardMaterial({
                        color: 0xffffff,
                        transparent: true,
                        opacity: 0.15, // Let 85% of inner light pass through
                        roughness: 0.05,
                        metalness: 0.95,
                        side: THREE.DoubleSide,
                        depthWrite: false
                    });
                    child.material.needsUpdate = true;
                    return; // Done
                }


                // 1. Handle Glass (Reflective Tinted Mirror Glass for Windows, Super Clear for Headlights)
                if (isGlassName(rawMat) || isGlassName(rawMesh)) {
                    child.material.transparent = true;
                    if (yCenter < 1.0) {
                        // Headlight or bumper lighting cover glass -> Must be crystal clear to let light pass!
                        child.material.opacity = 0.15;
                        child.material.metalness = 0.10;
                        child.material.roughness = 0.05;
                        child.material.color.set(0xffffff);
                        child.material.depthWrite = true;
                    } else {
                        // Main cabin window glass -> Premium highly-reflective dark tint to hide interior cognacs
                        child.material.opacity = 0.70; 
                        child.material.metalness = 0.95; 
                        child.material.roughness = 0.02; 
                        child.material.color.set(0x151820); 
                        child.material.depthWrite = false; 
                    }
                }
                
                // Silver Metallic Paint Default
                if (isPaintName(rawMat) || isPaintName(rawMesh)) {
                    child.material.metalness = 0.8;
                    child.material.roughness = 0.35;
                    child.material.color.set(0xcac8c4);
                }

                // Auto-detect rear tail light meshes based on position and their original red diffuse color!
                // This bypasses any GLTF name optimization bugs and avoids engulfing non-light parts like license plates.
                let isRearTailLight = false;
                if (zCenter < -0.5 && child.material && child.material.color) {
                    const c = child.material.color;
                    // Check if the original material is distinctly red (Red is dominant, green & blue are very low)
                    if (c.r > 0.5 && c.g < 0.25 && c.b < 0.25) {
                        isRearTailLight = true;
                    }
                }

                if (isLightName(rawMat) || isLightName(rawMesh) || isRearTailLight) {
                    // Upgrade material to MeshStandardMaterial if it doesn't support emissive properties (e.g., MeshBasicMaterial)
                    if (!child.material.emissive) {
                        const oldMat = child.material;
                        child.material = new THREE.MeshStandardMaterial({
                            color: oldMat.color ? oldMat.color.clone() : new THREE.Color(0xff0000),
                            map: oldMat.map || null,
                            roughness: 0.15,
                            metalness: 0.1,
                            side: THREE.DoubleSide
                        });
                    }

                    // Clone the material so each light part can be controlled independently!
                    child.material = child.material.clone();
                    
                    // STRIP ALL MAPS & VERTEX COLORS to clean up Rhino junk! 
                    child.material.map = null;
                    child.material.emissiveMap = null;
                    child.material.lightMap = null;
                    child.material.aoMap = null;
                    child.material.vertexColors = false;
                    child.material.toneMapped = false; // Bypass tone mapping for pure glowing energy
                    child.material.needsUpdate = true;
                    
                    // Strict identification: Use names first, fallback to coordinates only if names are ambiguous
                    const rawNameCombined = (rawMat + ' ' + rawMesh).toLowerCase();
                    const isRearName = rawNameCombined.includes('rear') || rawNameCombined.includes('tail') || rawNameCombined.includes('뒤') || rawNameCombined.includes('후면');
                    const isFrontName = rawNameCombined.includes('front') || rawNameCombined.includes('head') || rawNameCombined.includes('drl') || rawNameCombined.includes('앞') || rawNameCombined.includes('전면');

                    let isRear = false;
                    if (isRearName || isRearTailLight) {
                        isRear = true;
                    } else if (isFrontName) {
                        isRear = false;
                    } else {
                        isRear = zCenter < -0.1; 
                    }

                    if (isRear) {
                        if (yCenter > 0.80) { 
                            // Upper lights: Force double-sided rendering to guard against inverted normal bugs!
                            child.material.side = THREE.DoubleSide;
                            
                            // Pure saturated red for both base and emissive color to ensure beautiful HDR red bloom
                            // without desaturating to white/yellow.
                            child.material.color.set(0xff0000); // Pure deep red base
                            child.material.emissive.set(0xff0000); // Pure red emissive to keep the glow rich and red!
                            child.material.emissiveIntensity = 120.0; // High intensity for a stunning pure red HDR bloom
                        } else {
                            // Lower vertical bumper lights: premium glossy orange-red (二쇳솉???덈뱶) plastic reflector
                            child.material.emissive.set(0x000000);
                            child.material.emissiveIntensity = 0.0;
                            child.material.color.set(0xff3300); // Premium glossy orange-red plastic base color
                            child.material.roughness = 0.02;    // Very glossy / shiny reflection
                            child.material.metalness = 0.10;    // Plastic reflective index
                        }
                    } else {
                        // FRONT headlights
                        const isVertical = height > width * 1.5;

                        if (isVertical) {
                            // Side vertical pixel lights -> Premium Amber / Orange turn indicator as in Original Design!
                            child.material.emissive.set(0xffaa00); 
                            child.material.color.set(0xffaa00);
                            child.material.emissiveIntensity = 12.0; // Saturated, clear glow
                        } else {
                            // Main horizontal headlights / DRL -> High-intensity Pure White DRL pixels
                            child.material.emissive.set(0xffffff); 
                            child.material.color.set(0xffffff);
                            child.material.emissiveIntensity = 12.0; // Balanced bright glow
                        }
                    }
                    
                    // Specific pixel lights
                    if (rawMesh.toLowerCase().includes('pixel') || rawMat.toLowerCase().includes('pixel')) {
                        child.material.emissiveIntensity *= 1.5; // Boost pixel lights
                    }
                    
                    return; // Prevent subsequent material overrides for lighting parts
                }

                // 2.8. Targeted Logos & Emblems (Metallic Gray for Front 4-Pixel Logo & Rear 'STELLAR' Lettering)
                const isLogoMat = rawMat.includes('logo') || rawMesh.includes('logo');
                if (isLogoMat) {
                    child.material = child.material.clone();
                    child.material.map = null;
                    child.material.emissiveMap = null;
                    child.material.vertexColors = false;
                    child.material.color.set(0xa0a0a0); // One tone darker refined metallic steel gray
                    child.material.metalness = 0.52;    // Balanced metalness for beautiful metallic sheen
                    child.material.roughness = 0.35;    // Mild roughness to reflect highlights softly
                    child.material.emissive.set(0x222222); // Elegant subtle self-illumination to preserve presence
                    child.material.emissiveIntensity = 1.0;
                    child.material.needsUpdate = true;
                    return; // Skip other modifiers
                }

                // 3. Targeted Interior (Orange)
                if (isTargetInterior(rawMat) || isTargetInterior(rawMesh)) {
                    child.material.color.set(INTERIOR_ORANGE);
                    child.material.roughness = 0.6;
                    child.material.metalness = 0.1;
                }

                // 4. Targeted Wheels (Metal Gray)
                if (isTargetWheel(rawMat) || isTargetWheel(rawMesh)) {
                    child.material.color.set(0x888888); // Metal Gray
                    child.material.metalness = 0.9;
                    child.material.roughness = 0.4;
                }

                // 5. Targeted Black Trims & Bumpers
                if (isTargetBlack(rawMat) || isTargetBlack(rawMesh)) {
                    child.material.color.set(0x050505); // Much darker black
                    child.material.roughness = 0.95;
                    child.material.metalness = 0.05;
                    return; // Skip paint tagging
                }

                // 6. Tag paint for color-swatch selector
                if (isPaintName(rawMat) || isPaintName(rawMesh)) {
                    child.material.name = 'body_paint_custom';
                    child.material.color.set(PAINT_COLOR_IVORY);
                    child.material.metalness = 0.7; // Metallic bronze feel
                    child.material.roughness = 0.25;
                }
            });

            scene.add(model);
        }, undefined, (err) => console.error('[Stellar] GLB load error:', err));

        // Color swatches
        document.querySelectorAll('.swatch').forEach(swatch => {
            swatch.addEventListener('click', () => {
                const color = swatch.dataset.color;
                document.querySelectorAll('.swatch').forEach(s => s.classList.remove('active'));
                swatch.classList.add('active');
                if (!model) return;
                model.traverse(child => {
                    if (child.isMesh && child.material && child.material.name === 'body_paint_custom') {
                        child.material.color.set(color);
                    }
                });
            });
        });

        // Setup Post-processing (Bloom)
        const renderScene = new THREE.RenderPass(scene, camera);
        const bloomPass = new THREE.UnrealBloomPass(
            new THREE.Vector2(container.clientWidth, container.clientHeight),
            1.5, // strength
            0.4, // radius
            0.85 // threshold
        );
        // Reverted to Linear parameters for pure saturated gradient blooms
        bloomPass.threshold = 0.80; // Slightly lowered to capture more subtle HDR highlights for bloom
        bloomPass.strength = 1.8; // Increased from 1.5 to boost overall glow strength
        bloomPass.radius = 0.75; // Increased from 0.6 for a wider, softer gradient bloom

        // Film Grain Pass for cinematic noise texture (Subtle 0.12 intensity to keep eyes comfortable)
        const filmPass = new THREE.FilmPass(0.12, 0.0, 0, false); // Subtle noise, no scanlines, color noise

        const composer = new THREE.EffectComposer(renderer);
        composer.addPass(renderScene);
        composer.addPass(bloomPass);
        composer.addPass(filmPass); // Restored with gentle film noise

        // Resize handler
        new ResizeObserver(() => {
            const r = container.getBoundingClientRect();
            if (r.width === 0) return;
            camera.aspect = r.width / r.height;
            camera.updateProjectionMatrix();
            renderer.setSize(r.width, r.height);
            composer.setSize(r.width, r.height);
        }).observe(container);

        function animate() {
            requestAnimationFrame(animate);
            controls.update();
            composer.render(); // Use composer for bloom effect
        }
        animate();
    };
    }
})();
    
    function initDiagramSequence() {
        const container = document.getElementById('diagram-container');
        const transitionContainer = document.getElementById('transition-container');
        if (!container) return;
        const boxes = Array.from(container.querySelectorAll('.diagram-seq-box'));
        boxes.forEach(box => {
            box.querySelectorAll('.diagram-text').forEach(t => { t.style.opacity = '0'; });
        });
        
        let started = false;
        window.startDiagramSequence = () => {
            if (started) return;
            started = true;
            runBox(0); // No extra delay - diagram fires immediately when triggered
        };
        
        function runBox(i) {
            if (i >= boxes.length) {
                setTimeout(triggerTransition, 400);
                return;
            }
            const box = boxes[i];
            // Keep texts fully hidden until borders are done
            box.querySelectorAll('.diagram-text').forEach(t => { t.style.opacity = '0'; });
            
            // Phase 1: Dots scale up in the center of the box
            box.classList.add('dots-active');
            
            // Phase 2: Glide dots to their respective corners after 300ms
            setTimeout(() => {
                box.classList.add('dots-dispersed');
                
                // Phase 3: Start sequential border connection drawing after dispersion finishes (800ms)
                setTimeout(() => {
                    box.classList.add('is-drawn');
                    
                    // Phase 4: Reveal scramble texts inside this box after borders are complete (1200ms)
                    setTimeout(() => {
                        revealTexts(box.querySelectorAll('.diagram-text'), () => {
                            // After scramble texts reveal finishes, wait 300ms and move to the next box
                            setTimeout(() => {
                                runBox(i + 1);
                            }, 300);
                        });
                    }, 1200);
                    
                }, 800);
                
            }, 300);
        }
        
        function revealTexts(els, onDone) {
            const arr = Array.from(els);
            if (!arr.length) { if (onDone) onDone(); return; }
            const esc = (s) => s.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
            let finished = 0;
            arr.forEach((el, idx) => {
                const txt = el.dataset.original || '';
                let html = '';
                for (let c of txt) {
                    if (c === ' ') { html += ' '; continue; }
                    html += `<span class="rc" style="opacity:0;filter:blur(4px);transform:translateY(4px);display:inline-block;transition:opacity 1.2s ease,filter 1.2s ease,transform 1.2s ease;">${esc(c)}</span>`;
                }
                el.innerHTML = html;
                setTimeout(() => {
                    if (el.classList.contains('glass-label')) {
                        el.classList.add('revealed');
                    } else {
                        el.style.opacity = '1';
                    }
                    const spans = el.querySelectorAll('.rc');
                    if (!spans.length) { finished++; if (finished === arr.length && onDone) onDone(); return; }
                    let done = 0;
                    spans.forEach(s => {
                        setTimeout(() => {
                            s.style.opacity = '1'; s.style.filter = 'blur(0)'; s.style.transform = 'translateY(0)';
                            done++;
                            if (done === spans.length) {
                                setTimeout(() => {
                                    el.innerHTML = esc(txt);
                                    if (el.classList.contains('glass-label')) {
                                        el.style.opacity = '';
                                    }
                                }, 1200);
                                finished++;
                                if (finished === arr.length && onDone) setTimeout(onDone, 200);
                            }
                        }, Math.random() * 700);
                    });
                }, idx * 200);
            });
        }
        
        function triggerTransition() {
            if (!transitionContainer) return;
            const dots = transitionContainer.querySelectorAll('.transition-dot');
            const lines = transitionContainer.querySelectorAll('.transition-line');
            
            // 1. Stagger dot reveal (pop/fade) left-to-right (all within 0.5s)
            dots.forEach((dot, idx) => {
                setTimeout(() => {
                    dot.classList.add('active');
                }, idx * 100);
            });

            // 2. Wait exactly 0.3s (300ms) after all dots are fully printed,
            // then drop ALL lines down together simultaneously ("?쒕쾲??已?)
            const allDotsPrintedTime = (dots.length - 1) * 100;
            setTimeout(() => {
                lines.forEach((line) => {
                    line.classList.add('active');
                });
            }, allDotsPrintedTime + 300);
        }
    }

    initDiagramSequence();

    // --- Lightbox Control Functions ---
    const lightboxModal = document.getElementById('lightbox-modal');
    const lightboxImg = document.getElementById('lightbox-image');
    const lightboxTitle = document.getElementById('lightbox-title');
    const lightboxContent = document.getElementById('lightbox-content');
    const lightboxCloseBtn = document.getElementById('lightbox-close');
    const resolutionText = document.getElementById('lightbox-resolution');
    
    if (lightboxImg && resolutionText) {
        lightboxImg.addEventListener('load', () => {
            const width = lightboxImg.naturalWidth;
            const height = lightboxImg.naturalHeight;
            if (width && height) {
                resolutionText.textContent = `${width} x ${height}`;
            }
        });
    }

    // 16 high-resolution gallery images list for arrow navigation
    const galleryImages = [
        '/work/bas-relief/BUBBLE_02.jpg',
        '/work/bas-relief/COOKIE_02.jpg',
        '/work/bas-relief/Crane_02.jpg',
        '/work/bas-relief/FACTORY_02.jpg',
        '/work/bas-relief/GLUTTON_02.jpg',
        '/work/bas-relief/hangerbar_02.png',
        '/work/bas-relief/Light House_02.jpg',
        '/work/bas-relief/NOMAD_02.jpg',
        '/work/bas-relief/pipe_02.jpg',
        '/work/bas-relief/PUMPKIN)-2.jpg',
        '/work/bas-relief/ROLYPOLY_02.jpg',
        '/work/bas-relief/Satellite_02.jpg',
        '/work/bas-relief/TRAY_02.jpg',
        '/work/bas-relief/Tunnel_02.jpg',
        '/work/bas-relief/Umbrella_02.jpg',
        '/work/bas-relief/WITCH_02.jpg'
    ];
    let currentLightboxIndex = -1;

    // Background preloading of high-resolution details for instant lightbox transitions
    if (typeof window !== 'undefined') {
        window.addEventListener('load', () => {
            setTimeout(() => {
                galleryImages.forEach(src => {
                    const img = new Image();
                    img.src = src;
                });
            }, 1000); // Wait 1 second after page load to keep boot absolutely light
        });
    }

    function updateLightboxState() {
        if (currentLightboxIndex !== -1) {
            lightboxImg.src = galleryImages[currentLightboxIndex];
            if (lightboxTitle) {
                lightboxTitle.textContent = galleryTitles[currentLightboxIndex];
            }
            const counter = document.getElementById('lightbox-counter');
            if (counter) {
                counter.textContent = `${String(currentLightboxIndex + 1).padStart(2, '0')} / ${galleryImages.length}`;
            }
            const toktokLabel = document.getElementById('lightbox-toktok-label');
            const mergeLabel = document.getElementById('lightbox-merge-label');
            if (toktokLabel) {
                toktokLabel.style.display = 'block';
                toktokLabel.innerHTML = galleryTitles[currentLightboxIndex];
            }
            if (mergeLabel) mergeLabel.style.display = 'none';
        }
    }

    function openLightbox(src, title) {
        if (!lightboxModal || !lightboxImg || !lightboxContent) return;

        document.body.style.overflow = 'hidden';
        document.body.classList.add('lightbox-active');

        // Check if we passed a short thumbnail name like 'BUBBLE.png' and map it to the _02 file
        let actualSrc = src;
        if (src.includes('.png') && !src.includes('hangerbar')) {
            const baseName = src.replace('.png', '');
            const index = galleryTitles.findIndex(t => t.toUpperCase() === baseName.toUpperCase());
            if (index !== -1) {
                actualSrc = galleryImages[index];
            }
        }

        currentLightboxIndex = galleryImages.indexOf(actualSrc);

        const toktokLabel = document.getElementById('lightbox-toktok-label');
        const mergeLabel = document.getElementById('lightbox-merge-label');
        const specLabel = document.getElementById('lightbox-spec-label');
        if (currentLightboxIndex !== -1) {
            updateLightboxState();
            if (specLabel) specLabel.style.display = 'none';
        } else {
            lightboxImg.src = actualSrc.startsWith('/') ? actualSrc : `/work/bas-relief/${actualSrc}`;
            if (lightboxTitle) lightboxTitle.textContent = title;
            const counter = document.getElementById('lightbox-counter');
            if (counter) counter.textContent = "";
            if (actualSrc.includes('BAS_main.jpg')) {
                if (toktokLabel) {
                    toktokLabel.style.display = 'none';
                }
                if (specLabel) {
                    specLabel.style.display = 'block';
                    specLabel.innerHTML = '890 x 1520x60 mm<br/>SLS 3D PRINTED NYLON POWDER, XPS FORM';
                }
                if (mergeLabel) mergeLabel.style.display = 'none';
            } else {
                if (toktokLabel) toktokLabel.style.display = 'none';
                if (mergeLabel) mergeLabel.style.display = 'none';
            }
        }

        lightboxModal.classList.remove('pointer-events-none', 'opacity-0');
        lightboxModal.classList.add('opacity-100');

        setTimeout(() => {
            lightboxContent.classList.remove('scale-95', 'opacity-0');
            lightboxContent.classList.add('scale-100', 'opacity-100');
        }, 50);
    }

    function closeLightbox() {
        if (!lightboxModal || !lightboxContent) return;

        document.body.style.overflow = 'auto';
        document.body.style.overflowX = 'hidden';
        document.body.classList.remove('lightbox-active');

        lightboxContent.classList.remove('scale-100', 'opacity-100');
        lightboxContent.classList.add('scale-95', 'opacity-0');
        currentLightboxIndex = -1;
        const specLabel = document.getElementById('lightbox-spec-label');
        if (specLabel) specLabel.style.display = 'none';

        setTimeout(() => {
            lightboxModal.classList.remove('opacity-100');
            lightboxModal.classList.add('pointer-events-none', 'opacity-0');
        }, 300);
    }

    if (lightboxCloseBtn) {
        lightboxCloseBtn.addEventListener('click', (e) => {
            e.preventDefault();
            e.stopPropagation();
            closeLightbox();
        });
    }
    if (lightboxModal) {
        lightboxModal.addEventListener('click', (e) => {
            if (e.target === lightboxModal || e.target.id === 'lightbox-modal') {
                e.preventDefault();
                e.stopPropagation();
                closeLightbox();
            }
        });
    }

    // Mapped titles for each of the 16 gallery items to update lightboxTitle on arrow key navigation
    const galleryTitles = [
        'BUBBLE',
        'COOKIE',
        'CRANE',
        'FACTORY',
        'GLUTTON',
        'HANGER BAR',
        'LIGHT HOUSE',
        'NOMAD',
        'PIPE',
        'PUMPKIN',
        'ROLYPOLY',
        'SATELLITE',
        'TRAY',
        'TUNNEL',
        'UMBRELLA',
        'WITCH'
    ];

    function nextImage() {
        if (currentLightboxIndex !== -1) {
            currentLightboxIndex = (currentLightboxIndex + 1) % galleryImages.length;
            updateLightboxState();
        }
    }

    function prevImage() {
        if (currentLightboxIndex !== -1) {
            currentLightboxIndex = (currentLightboxIndex - 1 + galleryImages.length) % galleryImages.length;
            updateLightboxState();
        }
    }

    const nextBtn = document.getElementById('lightbox-next');
    const prevBtn = document.getElementById('lightbox-prev');
    if (nextBtn) nextBtn.addEventListener('click', (e) => { e.stopPropagation(); nextImage(); });
    if (prevBtn) prevBtn.addEventListener('click', (e) => { e.stopPropagation(); prevImage(); });

    window.addEventListener('keydown', (e) => {
        if (lightboxModal && !lightboxModal.classList.contains('pointer-events-none')) {
            if (e.key === 'Escape') {
                closeLightbox();
            } else if (e.key === 'ArrowRight' || e.key === 'Right') {
                nextImage();
            } else if (e.key === 'ArrowLeft' || e.key === 'Left') {
                prevImage();
            }
        }
    });

    window.openLightbox = openLightbox;
    window.closeLightbox = closeLightbox;

    const activationOverlay = document.getElementById('viewer-activation-overlay');
    const colorSelector = document.getElementById('viewer-color-selector');

    // Always start 3D Configurator immediately without waiting for click
    if (typeof startViewer === 'function') {
        if (document.readyState === 'complete' || document.readyState === 'interactive') {
            startViewer();
        } else {
            window.addEventListener('DOMContentLoaded', startViewer);
        }
    }

    if (colorSelector) {
        colorSelector.classList.remove('opacity-0', 'pointer-events-none');
        colorSelector.classList.add('opacity-100', 'pointer-events-auto');
    }

    // --- Dynamic Footer Scroll-Triggered Ambient Gradient ---
    const footerGradient = document.getElementById('dynamic-footer-gradient');
    const glowWrapper = document.getElementById('footer-glow-wrapper');
    if (footerGradient && glowWrapper) {
        window.addEventListener('scroll', () => {
            const rect = glowWrapper.getBoundingClientRect();
            const viewportHeight = window.innerHeight;
            
            // Calculate how many pixels the user is scrolled away from the absolute bottom of the document
            const distanceToBottom = rect.bottom - viewportHeight;
            
            // Trigger when the user is within 200px of the absolute bottom
            if (distanceToBottom <= 200) {
                footerGradient.classList.add('active');
            } else {
                footerGradient.classList.remove('active');
            }
        }, { passive: true });
    }

    // --- Next Section Image Hover Arrow Expand Listener ---
    const nextImgCard = document.getElementById('next-image-card');
    const nextArrowLine = document.getElementById('next-arrow-line');
    const nextArrowHead = document.getElementById('next-arrow-head');
    if (nextImgCard && nextArrowLine) {
        nextImgCard.addEventListener('mouseenter', () => {
            nextArrowLine.style.width = '380px'; // Extremely dramatic expansion
            nextArrowLine.style.backgroundColor = 'rgba(255, 255, 255, 1.0)';
            if (nextArrowHead) nextArrowHead.style.color = 'rgba(255, 255, 255, 1.0)';
        });
        nextImgCard.addEventListener('mouseleave', () => {
            nextArrowLine.style.width = '96px'; // Restore to default w-24
            nextArrowLine.style.backgroundColor = 'rgba(255, 255, 255, 0.2)';
            if (nextArrowHead) nextArrowHead.style.color = 'rgba(255, 255, 255, 0.2)';
        });
    }

    // --- Dynamic Header Scanline Scroll transition ---
    let isHeaderScrolled = false;
    let isDesktopMenuOpen = false;
    const scanLine = document.getElementById('header-scan-line');
    const menuLinks = document.getElementById('desktop-menu-links');
    const triggerBtn = document.getElementById('mobile-menu-trigger');

    window.toggleDesktopInlineMenu = function() {
        if (!scanLine || !menuLinks || !triggerBtn) return;
        
        const menuLine = document.getElementById('menu-line');
        if (!isDesktopMenuOpen) {
            // Reveal links inline on desktop
            isDesktopMenuOpen = true;
            scanLine.style.transformOrigin = 'right';
            scanLine.style.transform = 'scaleX(1)';
            
            if (menuLine) {
                menuLine.style.transform = 'scaleX(0.6)';
                menuLine.style.backgroundColor = '#ffffff'; 
            }
            
            setTimeout(() => {
                menuLinks.style.opacity = '1';
                menuLinks.style.pointerEvents = 'auto';
                scanLine.style.transformOrigin = 'left';
                scanLine.style.transform = 'scaleX(0)';
            }, 300);
        } else {
            // Hide links inline on desktop
            isDesktopMenuOpen = false;
            scanLine.style.transformOrigin = 'left';
            scanLine.style.transform = 'scaleX(1)';
            
            if (menuLine) {
                menuLine.style.transform = 'none';
                menuLine.style.backgroundColor = '#ffffff';
            }
            
            setTimeout(() => {
                menuLinks.style.opacity = '0';
                menuLinks.style.pointerEvents = 'none';
                scanLine.style.transformOrigin = 'right';
                scanLine.style.transform = 'scaleX(0)';
            }, 300);
        }
    };

    if (scanLine && menuLinks && triggerBtn) {
        window.addEventListener('scroll', () => {
            if (window.innerWidth < 768) return; // Only apply on desktop viewports
            
            const menuLine = document.getElementById('menu-line');
            if (window.scrollY > 80) {
                if (!isHeaderScrolled) {
                    isHeaderScrolled = true;
                    // 1. Scan line draws across from left to right
                    scanLine.style.transformOrigin = 'left';
                    scanLine.style.transform = 'scaleX(1)';
                    
                    setTimeout(() => {
                        // 2. Links fade out, scanline collapses to right
                        if (!isDesktopMenuOpen) {
                            menuLinks.style.opacity = '0';
                            menuLinks.style.pointerEvents = 'none';
                        }
                        scanLine.style.transformOrigin = 'right';
                        scanLine.style.transform = 'scaleX(0)';
                        
                        // 3. Trigger button slides/fades in
                        triggerBtn.classList.remove('md:opacity-0', 'md:translate-x-8', 'md:pointer-events-none');
                        triggerBtn.classList.add('md:opacity-100', 'md:translate-x-0', 'md:pointer-events-auto');
                    }, 300);
                }
            } else {
                if (isHeaderScrolled) {
                    isHeaderScrolled = false;
                    isDesktopMenuOpen = false;
                    
                    if (menuLine) {
                        menuLine.style.transform = 'none';
                        menuLine.style.backgroundColor = '#ffffff';
                    }
                    
                    // Reverse sequence to restore desktop links
                    scanLine.style.transformOrigin = 'right';
                    scanLine.style.transform = 'scaleX(1)';
                    
                    setTimeout(() => {
                        menuLinks.style.opacity = '1';
                        menuLinks.style.pointerEvents = 'auto';
                        scanLine.style.transformOrigin = 'left';
                        scanLine.style.transform = 'scaleX(0)';
                        
                        triggerBtn.classList.add('md:opacity-0', 'md:translate-x-8', 'md:pointer-events-none');
                        triggerBtn.classList.remove('md:opacity-100', 'md:translate-x-0', 'md:pointer-events-auto');
                    }, 300);
                }
            }
        }, { passive: true });
    }

document.addEventListener('DOMContentLoaded', () => {
    // 1. Top Line: Two dots dropping down vertically at the far left and far right grids (Synchronized)
    const topContainers = document.querySelectorAll('.special-line-top');
    topContainers.forEach(container => {
        let html = `
        <div class="w-full h-full flex justify-end items-start gap-8 md:gap-12 pr-8 md:pr-16 pt-0">
            
            <!-- Left Dot (Horizontal sweep from left to right - trace) -->
            <div class="relative flex flex-col items-end justify-end h-[120px] w-[140px] shrink-0">
                <div class="absolute bottom-[0.5px] right-0 w-[140px] h-[1px] overflow-hidden">
                    <div class="h-line w-[140px] h-[1px] bg-white/30 absolute top-0 left-[-140px] transition-transform duration-[1500ms] ease-in-out z-10"></div>
                </div>
                <div class="v-dot w-[2px] h-[2px] bg-white rounded-full absolute bottom-0 right-0 opacity-0 transition-opacity duration-[500ms]  z-20"></div>
            </div>

            <!-- Right Dot (Vertical sweep from top to bottom - trace) -->
            <div class="relative flex flex-col items-center justify-start h-[120px] w-[20px] shrink-0 overflow-hidden">
                <div class="v-line w-[1px] h-[120px] bg-white/30 absolute top-[-120px] transition-transform duration-[1500ms] ease-in-out"></div>
                <div class="v-dot w-[2px] h-[2px] bg-white rounded-full absolute bottom-0 opacity-0 transition-opacity duration-[500ms] "></div>
            </div>

        </div>`;
        container.innerHTML = html;
        
        const lineObserver = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const hLine = container.querySelector('.h-line');
                    const vLine = container.querySelector('.v-line');
                    const dots = container.querySelectorAll('.v-dot');
                    
                    // Horizontal trace moves completely through and disappears
                    hLine.style.transform = 'translateX(280px)';
                    setTimeout(() => {
                        dots[0].classList.replace('opacity-0', 'opacity-100');
                    }, 750); // Dot appears when line passes over it
                    
                    // Vertical trace moves completely through and disappears
                    vLine.style.transform = 'translateY(240px)';
                    setTimeout(() => {
                        dots[1].classList.replace('opacity-0', 'opacity-100');
                    }, 750); // Dot appears when line passes over it
                    
                    lineObserver.unobserve(container);
                }
            });
        }, { threshold: 0.1 });
        
        lineObserver.observe(container);
    });

    // 2. Bottom Line: 6-element symmetrical array (short line, long line, dot, dot, long line, short line)
    const bottomContainers = document.querySelectorAll('.special-line-bottom');
    bottomContainers.forEach(container => {
        let html = `
        <div class="relative w-full h-[80px] flex justify-between items-start">
            
            <!-- 1. Left Short Line -->
            <div class="flex items-center h-[2px] w-[10%] shrink-0">
                <div class="h-line w-full h-[1px] bg-white/30 scale-x-0 origin-left transition-transform duration-[1200ms] ease-out"></div>
            </div>

            <!-- 2. Mid-Left Long Line -->
            <div class="flex items-center h-[2px] w-[25%] shrink-0">
                <div class="h-line w-full h-[1px] bg-white/30 scale-x-0 origin-left transition-transform duration-[1200ms] ease-out"></div>
            </div>

            <!-- 3. Center-Left Dot -->
            <div class="flex items-center h-[2px] shrink-0 justify-center">
                <div class="relative shrink-0">
                    <div class="v-dot w-[2px] h-[2px] bg-white rounded-full opacity-0 transition-opacity duration-[300ms] shadow-[0_0_6px_rgba(255,255,255,1)] z-20"></div>
                    <div class="v-line-container absolute top-[2px] left-1/2 -translate-x-1/2 w-[1px] h-[60px] overflow-hidden">
                        <div class="v-line w-full h-[40px] bg-gradient-to-t from-transparent via-white/40 to-white/80 absolute top-[60px] transition-transform duration-[1200ms] ease-in-out"></div>
                    </div>
                </div>
            </div>

            <!-- 4. Center-Right Dot -->
            <div class="flex items-center h-[2px] shrink-0 justify-center">
                <div class="relative shrink-0">
                    <div class="v-dot w-[2px] h-[2px] bg-white rounded-full opacity-0 transition-opacity duration-[300ms] shadow-[0_0_6px_rgba(255,255,255,1)] z-20"></div>
                    <div class="v-line-container absolute top-[2px] left-1/2 -translate-x-1/2 w-[1px] h-[60px] overflow-hidden">
                        <div class="v-line w-full h-[40px] bg-gradient-to-t from-transparent via-white/40 to-white/80 absolute top-[60px] transition-transform duration-[1200ms] ease-in-out"></div>
                    </div>
                </div>
            </div>

            <!-- 5. Mid-Right Long Line -->
            <div class="flex items-center h-[2px] w-[25%] shrink-0">
                <div class="h-line w-full h-[1px] bg-white/30 scale-x-0 origin-left transition-transform duration-[1200ms] ease-out"></div>
            </div>

            <!-- 6. Right Short Line -->
            <div class="flex items-center h-[2px] w-[10%] shrink-0 justify-end">
                <div class="h-line w-full h-[1px] bg-white/30 scale-x-0 origin-left transition-transform duration-[1200ms] ease-out"></div>
            </div>
            
        </div>`;
        container.innerHTML = html;
        
        const lineObserver = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const hLines = container.querySelectorAll('.h-line');
                    const vLines = container.querySelectorAll('.v-line');
                    const dots = container.querySelectorAll('.v-dot');
                    
                    // Synchronized flow (援곕Т) - all start at exactly t=0
                    hLines.forEach(hline => {
                        hline.classList.replace('scale-x-0', 'scale-x-100');
                    });
                    
                    vLines.forEach((vline, i) => {
                        vline.style.transform = 'translateY(-100px)'; 
                        setTimeout(() => { 
                            dots[i].classList.replace('opacity-0', 'opacity-100'); 
                        }, 700);
                    });
                    
                    lineObserver.unobserve(container);
                }
            });
        }, { threshold: 0.1 });
        lineObserver.observe(container);
    });
});
