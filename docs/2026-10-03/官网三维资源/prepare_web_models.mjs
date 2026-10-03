import { readFile, writeFile } from 'node:fs/promises'
import {
	Group,
	Mesh,
	MeshStandardMaterial,
	Vector3
} from '../../../packages/website/node_modules/three/build/three.module.js'
import { GLTFLoader } from '../../../packages/website/node_modules/three/examples/jsm/loaders/GLTFLoader.js'
import { STLLoader } from '../../../packages/website/node_modules/three/examples/jsm/loaders/STLLoader.js'
import { GLTFExporter } from '../../../packages/website/node_modules/three/examples/jsm/exporters/GLTFExporter.js'
import {
	mergeGeometries,
	mergeVertices
} from '../../../packages/website/node_modules/three/examples/jsm/utils/BufferGeometryUtils.js'
import { MeshoptSimplifier } from '../../../node_modules/.pnpm/meshoptimizer@1.1.1/node_modules/meshoptimizer/index.js'

globalThis.FileReader = class {
	readAsArrayBuffer(blob) {
		blob.arrayBuffer().then(result => {
			this.result = result
			this.onloadend?.()
		})
	}
}

await MeshoptSimplifier.ready

for (const name of ['parametric_sphere', 'hopf_link']) {
	const bytes = await readFile(name === 'hopf_link' ? '/tmp/zxc-hopf-link.stl' : '/tmp/zxc-parametric-sphere.glb')
	const buffer = bytes.buffer.slice(bytes.byteOffset, bytes.byteOffset + bytes.byteLength)
	let geometries

	if (name === 'hopf_link') {
		geometries = [new STLLoader().parse(buffer)]
	} else {
		const model = await new GLTFLoader().parseAsync(buffer, '')
		model.scene.updateMatrixWorld(true)
		geometries = []
		model.scene.traverse(node => {
			if (node.isMesh) geometries.push(node.geometry.clone().applyMatrix4(node.matrixWorld).toNonIndexed())
		})
	}

	for (const geometry of geometries) {
		for (const attribute of Object.keys(geometry.attributes)) {
			if (attribute !== 'position' && (name === 'hopf_link' || attribute !== 'normal'))
				geometry.deleteAttribute(attribute)
		}
	}

	let geometry = mergeVertices(mergeGeometries(geometries), 0.00001)
	geometry.center()
	geometry.computeBoundingBox()
	const size = geometry.boundingBox.getSize(new Vector3())
	const scale = 3.1 / Math.max(size.x, size.y, size.z)
	geometry.scale(scale, scale, scale)

	if (name === 'hopf_link') geometry.computeVertexNormals()

	const [indices, error] = MeshoptSimplifier.simplifyWithAttributes(
		new Uint32Array(geometry.index.array),
		geometry.attributes.position.array,
		3,
		geometry.attributes.normal.array,
		3,
		[0.5, 0.5, 0.5],
		null,
		240000,
		0.0003
	)
	geometry.setIndex(Array.from(indices))
	geometry = mergeVertices(geometry.toNonIndexed(), 0.00001)

	const mesh = new Mesh(geometry, new MeshStandardMaterial({ color: '#a89878', metalness: 0.75, roughness: 0.38 }))
	mesh.name = name
	let object = mesh

	if (name === 'parametric_sphere') {
		object = new Group()
		object.add(mesh)
		const inner_material = new MeshStandardMaterial({ color: '#8f7952', metalness: 0.75, roughness: 0.36 })

		for (const placement of [
			{ position: [-0.38, 0.18, 0], scale: [0.36, 0.4, 0.3], rotation: [0.2, 0.8, 0.2] },
			{ position: [0.46, -0.24, -0.12], scale: [0.28, 0.32, 0.36], rotation: [-0.4, -0.6, 0.4] }
		]) {
			const inner = new Mesh(geometry, inner_material)
			inner.position.set(...placement.position)
			inner.scale.set(...placement.scale)
			inner.rotation.set(...placement.rotation)
			object.add(inner)
		}
	}

	const output = await new GLTFExporter().parseAsync(object, { binary: true })
	await writeFile(
		new URL('../../../packages/website/public/visuals/' + name + '.glb', import.meta.url),
		Buffer.from(output)
	)
	console.log(name, indices.length / 3, 'triangles', error, 'simplification error', output.byteLength, 'bytes')
}
