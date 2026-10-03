import type { Node } from 'three/webgpu'
import { MeshPhysicalMaterial, MeshPhysicalNodeMaterial } from 'three/webgpu'
import { normalLocal, positionGeometry, positionLocal, transformNormalToView, uniform } from 'three/tsl'
import { tslExports } from 'vgpu/three'
import surface from './surface.wgsl'

type SurfaceInputs = { position: Node; progress: Node | number }
type MotionInputs = SurfaceInputs & { time: Node | number }

const { flowColor, flowPosition, flowNormal } = tslExports<{
	flowColor: SurfaceInputs
	flowPosition: MotionInputs
	flowNormal: MotionInputs & { normal: Node }
}>(surface)('flowColor', 'flowPosition', 'flowNormal')

export default function createSourceMaterial(webgpu: boolean) {
	const progress = uniform(0)
	const time = uniform(0)
	const options = { color: '#b5a482', metalness: 1, roughness: 0.24, clearcoat: 0.25 }
	const material = webgpu ? new MeshPhysicalNodeMaterial(options) : new MeshPhysicalMaterial(options)

	if (material instanceof MeshPhysicalNodeMaterial) {
		const inputs = { position: positionGeometry, progress, time }

		material.positionNode = flowPosition(inputs)
		material.normalNode = transformNormalToView(flowNormal({ ...inputs, normal: normalLocal }))
		material.clearcoatNormalNode = material.normalNode
		material.colorNode = flowColor({ position: positionLocal, progress })
	}

	return { material, progress, time }
}
