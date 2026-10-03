import type { StagePlacement } from './stages'
import { CubicBezierCurve3, Vector3 } from 'three'
import { graph_nodes } from './objects'

export default function createConnections(placements: Array<StagePlacement>, zoom: number) {
	const centers = placements.map(stage => -stage.center / zoom)
	const edges = [
		{ from: 0, to: 1, x: 0, start: centers[0] - 1.5, end: centers[1] + 1.3 },
		...graph_nodes.map(([x, y]) => ({ from: 1, to: 2, x, start: centers[1] - 1.3, end: centers[2] + y + 0.26 })),
		{ from: 2, to: 3, x: 0, start: centers[2] - 1.2, end: centers[3] + 2.4 },
		{ from: 3, to: 4, x: 0, start: centers[3] - 2.4, end: centers[4] + 1.65 }
	]

	return edges.map(edge => ({
		...edge,
		curve: new CubicBezierCurve3(
			new Vector3(edge.x, edge.start, -0.6),
			new Vector3(edge.x, (edge.start + edge.end) / 2, -0.6),
			new Vector3(edge.x, (edge.start + edge.end) / 2, -0.6),
			new Vector3(edge.x, edge.end, -0.6)
		)
	}))
}
