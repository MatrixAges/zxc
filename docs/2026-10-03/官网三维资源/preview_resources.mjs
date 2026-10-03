import { readFile, writeFile } from 'node:fs/promises'
import { create, globals } from '../../../node_modules/.pnpm/webgpu@0.6.1/node_modules/webgpu/index.js'
import { PNG } from '../../../node_modules/.pnpm/pngjs@7.0.0/node_modules/pngjs/lib/png.js'

Object.assign(globalThis, globals)
const gpu = create([])
Object.defineProperty(globalThis, 'navigator', { value: { gpu }, configurable: true })
globalThis.requestAnimationFrame = callback => setTimeout(() => callback(performance.now()), 0)
globalThis.self = { requestAnimationFrame: () => 0, cancelAnimationFrame: () => {} }

const THREE = await import('../../../packages/website/node_modules/three/build/three.webgpu.js')
const { tslExports } = await import('../../../packages/website/node_modules/vgpu/dist/three.js')
const { positionGeometry, positionLocal, normalLocal, transformNormalToView, uniform } =
	await import('../../../packages/website/node_modules/three/build/three.tsl.js')
const source = await readFile(
	new URL('../../../packages/website/features/home/data_flow/surface.wgsl', import.meta.url),
	'utf8'
)
const { flowPosition, flowNormal, flowColor } = tslExports(source.replace(/export fn/g, 'fn'))(
	'flowPosition',
	'flowNormal',
	'flowColor'
)
const { GLTFLoader } = await import('../../../packages/website/node_modules/three/examples/jsm/loaders/GLTFLoader.js')
const { HDRLoader } = await import('../../../packages/website/node_modules/three/examples/jsm/loaders/HDRLoader.js')
const adapter = await gpu.requestAdapter()
const device = await adapter.requestDevice({ requiredFeatures: [...adapter.features] })
const canvas = { width: 640, height: 640, style: {}, addEventListener() {}, removeEventListener() {} }
const renderer = new THREE.WebGPURenderer({ device, canvas, antialias: true })
await renderer.init()
renderer.setSize(640, 640, false)
const target = new THREE.RenderTarget(640, 640)
target.texture.colorSpace = THREE.SRGBColorSpace
target.samples = 4
renderer.setRenderTarget(target)

const hdr = await readFile(new URL('../../../packages/website/public/visuals/studio_small_03_1k.hdr', import.meta.url))
const parsed = new HDRLoader().parse(hdr.buffer.slice(hdr.byteOffset, hdr.byteOffset + hdr.byteLength))
const environment = new THREE.DataTexture(parsed.data, parsed.width, parsed.height, THREE.RGBAFormat, parsed.type)
environment.mapping = THREE.EquirectangularReflectionMapping
environment.needsUpdate = true

for (const name of ['source_sculpture', 'output_sculpture']) {
	const bytes = await readFile(new URL('../../../packages/website/public/visuals/' + name + '.glb', import.meta.url))
	const gltf = await new GLTFLoader().parseAsync(
		bytes.buffer.slice(bytes.byteOffset, bytes.byteOffset + bytes.byteLength),
		''
	)
	const mesh = gltf.scene.getObjectByProperty('isMesh', true)
	const bounds = new THREE.Box3().setFromObject(mesh).getSize(new THREE.Vector3())
	const scale = 3.1 / Math.max(bounds.x, bounds.y, bounds.z)
	mesh.geometry.center()
	mesh.geometry.scale(scale, scale, scale)
	if (name === 'output_sculpture') mesh.geometry.rotateX(Math.PI / 2)
	mesh.material = new THREE.MeshPhysicalNodeMaterial({
		color: '#b5a482',
		metalness: 1,
		roughness: 0.24,
		clearcoat: 0.25
	})
	const progress = uniform(0.65)
	const time = uniform(Number(process.env.PREVIEW_TIME ?? 0))
	const inputs = { position: positionGeometry, progress, time }
	mesh.material.positionNode = flowPosition(inputs)
	mesh.material.normalNode = transformNormalToView(flowNormal({ ...inputs, normal: normalLocal }))
	mesh.material.clearcoatNormalNode = mesh.material.normalNode
	mesh.material.colorNode = flowColor({ position: positionLocal, progress })
	mesh.rotation.set(0.12, -0.2, name === 'output_sculpture' ? -0.24 : 0.1)

	const scene = new THREE.Scene()
	scene.background = new THREE.Color('#151516')
	scene.environment = environment
	scene.add(mesh, new THREE.AmbientLight(0xffffff, 0.12))
	const key = new THREE.DirectionalLight('#fff2d6', 1.4)
	key.position.set(3, 5, 6)
	scene.add(key)
	const camera = new THREE.OrthographicCamera(-2, 2, 2, -2, 0.1, 100)
	camera.position.z = 10

	await renderer.compileAsync(scene, camera)
	renderer.render(scene, camera)
	const pixels = await renderer.readRenderTargetPixelsAsync(target, 0, 0, 640, 640)
	const png = new PNG({ width: 640, height: 640 })
	png.data = Buffer.from(pixels)
	const output = new URL('./' + name + '.png', import.meta.url)
	await writeFile(output, PNG.sync.write(png))
	console.log(output.pathname)
}

renderer.dispose()
device.destroy()
