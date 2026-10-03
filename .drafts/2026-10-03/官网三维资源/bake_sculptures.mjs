import { createRequire } from 'node:module'
import { writeFile } from 'node:fs/promises'
import {
	BufferGeometry,
	Float32BufferAttribute,
	Mesh,
	MeshStandardMaterial
} from '../../../packages/website/node_modules/three/build/three.module.js'
import { GLTFExporter } from '../../../packages/website/node_modules/three/examples/jsm/exporters/GLTFExporter.js'

const require = createRequire(import.meta.url)
const { surfaceNets } = require('/tmp/zxc-flow-bake/node_modules/isosurface')

// Shape definitions adapted from Vercel vgpu Glass Sculpture (MIT).
// https://vgpu.sh/examples/glass-sculpture
function smoothUnion(a, b, radius) {
	const blend = Math.max(0, Math.min(1, 0.5 + (0.5 * (b - a)) / radius))
	return b * (1 - blend) + a * blend - radius * blend * (1 - blend)
}

function blob(x, y, z) {
	let distance = 100000
	const time = 0.7

	for (let index = 0; index < 6; index++) {
		const cx = Math.sin(time * 0.7 + index * 2.1) * 0.55
		const cy = Math.cos(time * 0.5 + index * 1.3) * 0.6 * 0.55
		const cz = Math.sin(time * 0.6 + index * 0.7 + 1) * 0.55
		const radius = 0.42 + Math.sin(index * 3 + time) * 0.1

		distance = smoothUnion(distance, Math.hypot(x - cx, y - cy, z - cz) - radius, 0.35)
	}

	return distance
}

function ribbon(x, y, z) {
	const angle = Math.atan2(z, x) * 1.5
	const radial = Math.hypot(x, z) - 0.75
	const a = Math.cos(angle) * radial + Math.sin(angle) * y
	const b = -Math.sin(angle) * radial + Math.cos(angle) * y
	const dx = Math.abs(a) - 0.34
	const dy = Math.abs(b) - 0.12
	const distance = Math.hypot(Math.max(dx, 0), Math.max(dy, 0)) + Math.min(Math.max(dx, dy, 0), 0) - 0.08
	const ring = Math.hypot(Math.hypot(x, z) - 1.05, y) - 0.06

	return smoothUnion(distance, ring, 0.15)
}

function gradient(field, point) {
	const [x, y, z] = point
	const epsilon = 0.0001

	return [
		(field(x + epsilon, y, z) - field(x - epsilon, y, z)) / (2 * epsilon),
		(field(x, y + epsilon, z) - field(x, y - epsilon, z)) / (2 * epsilon),
		(field(x, y, z + epsilon) - field(x, y, z - epsilon)) / (2 * epsilon)
	]
}

class BlobReader {
	async readAsArrayBuffer(blob) {
		this.result = await blob.arrayBuffer()
		this.onloadend?.()
	}
}

globalThis.FileReader = BlobReader

for (const [name, field] of [
	['source_sculpture', blob],
	['output_sculpture', ribbon]
]) {
	const data = surfaceNets([160, 160, 160], field, [
		[-1.5, -1.5, -1.5],
		[1.5, 1.5, 1.5]
	])
	const indices = data.cells.flatMap(face =>
		face.length === 4 ? [face[0], face[1], face[2], face[0], face[2], face[3]] : face
	)
	const geometry = new BufferGeometry()

	const normals = []

	for (const point of data.positions) {
		for (let iteration = 0; iteration < 3; iteration++) {
			const normal = gradient(field, point)
			const length_squared = normal.reduce((sum, value) => sum + value * value, 0)
			const distance = field(...point)

			if (length_squared < 1e-10) throw new Error('Undefined surface normal')

			for (let axis = 0; axis < 3; axis++) point[axis] -= (distance * normal[axis]) / length_squared
		}

		const normal = gradient(field, point)
		const length = Math.hypot(...normal)
		normals.push(...normal.map(value => value / length))
	}

	geometry.setAttribute('position', new Float32BufferAttribute(data.positions.flat(), 3))
	geometry.setAttribute('normal', new Float32BufferAttribute(normals, 3))
	geometry.setIndex(indices)
	geometry.center()

	const mesh = new Mesh(geometry, new MeshStandardMaterial({ color: '#b5a482', metalness: 1, roughness: 0.19 }))
	mesh.name = name

	const output = await new GLTFExporter().parseAsync(mesh, { binary: true })
	await writeFile(
		new URL('../../../packages/website/public/visuals/' + name + '.glb', import.meta.url),
		Buffer.from(output)
	)
	console.log(name, data.positions.length, 'vertices', output.byteLength, 'bytes')
}
