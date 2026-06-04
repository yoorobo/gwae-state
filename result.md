# RESULT - GWAE cube performance analysis for Reddit reply

Recorded: 2026-06-04 13:37:32 KST
Scope: read-only code analysis. No code or STATE mutation.

## 1. 렌더링 스택 한 줄 요약

Three.js/Vite app: package.json sets three ^0.165.0 and vite ^5.2.0 (bets/gwae/apps/gwae-cube-v0-leo/3DCube_YJH/package.json:12,15). The active path imports DivinationCube and Starfield from main.js, not the older RubiksCube module (src/main.js:4-5). Renderer is WebGLRenderer(canvas, antialias true, alpha false), pixelRatio capped at min(devicePixelRatio, 2), fixed clear color; powerPreference is not set in the renderer options shown in code (src/main.js:67-70). The render loop is continuous requestAnimationFrame, not on-demand invalidation (src/main.js:328-342).

Cube scene construction is dynamic: DivinationCube builds a 3x3 shell by looping x/y/z -1..1 and skipping only center, so 26 piece groups are created (src/DivinationCube.js:91-100). Each piece gets one cubie mesh and one edge LineSegments (src/DivinationCube.js:102-104), and stickers are added only on exterior faces via STICKER_FACES (src/DivinationCube.js:14-20,106-114), giving 54 sticker meshes by code structure. Geometry/materials are shared per build for cubies, edges, stickers (src/DivinationCube.js:69-87). InstancedMesh is not present in the searched src path; code에서 확인 불가 as an optimization.

## 2. per-frame 비용 (매 프레임 vs 이벤트 1회 구분)

매 프레임: main animate calls starfield.update(delta), divCube.update(delta) only while cube visible, renderer.render, and FPS tracking (src/main.js:330-340). Starfield per-frame work rotates/moves one Points object and changes material opacity (src/effects/starfield.js:53-68); particle buffers are created on init, not per frame (src/effects/starfield.js:13-38). DivinationCube per-frame work applies group rotation, accumulates x/y/z totals, updates possible layer turn, damps velocities, bobbing, and edge opacity breathing (src/DivinationCube.js:225-250). Active layer turn updates only the sliceGroup angle per frame and completes at target angle (src/DivinationCube.js:370-384).

이벤트/상태 전환 1회성: cube build creates BoxGeometry/EdgesGeometry/PlaneGeometry and materials during _build/resetVisual, not every frame (src/DivinationCube.js:60-87,387-400). Layer turn start filters 9 pieces and attaches them to a sliceGroup when a turn starts, not every frame (src/DivinationCube.js:292-317). The actual rich casting calculation happens in finishDivination after timeout/decision, where computeAdr017Cast then computeDivinationFromNumbers are called once for the result (src/main.js:970-997). Debug helpers can compute a preview when debug mode asks for it, but that is debug UI code, not the normal render loop (src/main.js:594-616,696-708).

## 3. 작괘<->렌더 분리 구조

The code explicitly states that whole-cube rotation/inertia remains casting input and layer rotation is visual-only (src/DivinationCube.js:1-2). applyTorque converts drag/gesture deltas into angular velocities and accumulates inputAxisTotals, without computing hexagrams or mutating sticker colors (src/DivinationCube.js:129-144). Per-frame update separately accumulates rotation totals from velocity (src/DivinationCube.js:229-235). getAxisAccumulation returns rotation/input totals and ranked axes as data for casting (src/DivinationCube.js:424-432).

The adapter boundary is finishDivination: it reads getRotation/getAxisAccumulation/stillMs, calls computeAdr017Cast({ environment, rotationTotals, stillMs }), then passes that into computeDivinationFromNumbers (src/main.js:981-997). computeAdr017Cast maps environment plus ranked rotation axes into upper/lower/movingLine and diagnostics (src/divination/adr017Adapter.js:102-134). computeDivinationFromNumbers maps upper/lower/movingLine into trigram/hexagram/changingHexagram data (src/divination/hexagramEngine.js:41-51). Visual face/layer turns are started for opening/hand/queued animation paths (src/DivinationCube.js:259-289) and their code path does not call the divination adapter.

## 4. 모바일 최적화 현황

Present: renderer pixelRatio cap at 2 (src/main.js:67-69). Runtime low-FPS fallback samples FPS, and if average FPS drops below 40 once, it sets renderer pixelRatio to 1 and reduces Starfield particles to 1200 (src/main.js:308-324). Camera input requests 640x480 front camera first, with video:true fallback (src/HandTracker.js:86-96). Secure-context checks and iOS camera recovery are implemented (src/HandTracker.js:78-80,54-76).

Not present / 확인 불가: no mobile-specific shadow/postprocessing branch was found in the active renderer path; main renderer/lights are shared (src/main.js:65-88). 60fps guarantee is code에서 확인 불가; code only displays sampled FPS and applies fallback below 40fps (src/main.js:310-324). MediaPipe Hands runs from the main browser thread via requestAnimationFrame and awaits hands.send(video) each frame; no worker offload is visible in code (src/HandTracker.js:32-42). Hand result handling also clears/draws the 2D overlay and landmarks per result on the canvas (src/HandTracker.js:122-151,155-181).

## 5. 에셋 방식 (생성 vs 로드)

The cube is generated in code: BoxGeometry, EdgesGeometry, PlaneGeometry, MeshStandardMaterial, LineBasicMaterial are constructed in _build (src/DivinationCube.js:69-87). The starfield is generated in code with Float32Array positions/sizes, BufferGeometry, BufferAttributes, PointsMaterial, and THREE.Points (src/effects/starfield.js:13-38). Opening halo texture is generated from a canvas and wrapped in THREE.CanvasTexture (src/main.js:90-103,111-117).

External 3D model loading such as glTF/GLTFLoader or TextureLoader was not found in the searched src path; code에서 확인 불가 as an asset pipeline. The actual loaded external runtime asset is MediaPipe Hands from jsDelivr locateFile, not the cube model (src/HandTracker.js:16-18).

## 검증

- Read-only analysis only: code and STATE were not edited.
- Files cited with line numbers under all 5 required headings.
- Existing private repo untracked files were not touched.
- Vault copy: _vault/decisions/GWAE_큐브성능분석_레딧답글용_20260604.md
