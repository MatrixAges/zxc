import type { CubicBezierCurve3 } from 'three'
import { useEffect, useMemo } from 'react'
import { BufferGeometry, Line, LineDashedMaterial } from 'three'

export default function FlowConnection({ curve }: { curve: CubicBezierCurve3 }) {
	const line = useMemo(() => {
		const geometry = new BufferGeometry().setFromPoints(curve.getPoints(48))
		const material = new LineDashedMaterial({ color: '#8b7c60', dashSize: 0.025, gapSize: 0.035 })
		const object = new Line(geometry, material)

		object.computeLineDistances()
		return object
	}, [curve])

	useEffect(
		() => () => {
			line.geometry.dispose()
			line.material.dispose()
		},
		[line]
	)

	return <primitive object={line} />
}
