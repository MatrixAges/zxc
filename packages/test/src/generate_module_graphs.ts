import { range, writeCatalog } from './shared/catalog.ts'

function cases(size: number, shape: string) {
	const pairs = range(size).flatMap(owner =>
		range(size)
			.filter(target => size === 3 || owner !== target)
			.map(target => [owner, target])
	)
	const rows = []

	for (let mask = 0; mask < 1 << pairs.length; mask++) {
		const edges = pairs.filter((_, index) => mask & (1 << index))
		const reachable = range(size).map(owner =>
			range(size).map(target => edges.some(pair => pair[0] === owner && pair[1] === target))
		)

		for (const middle of range(size)) {
			for (const owner of range(size)) {
				for (const target of range(size))
					reachable[owner][target] ||= reachable[owner][middle] && reachable[middle][target]
			}
		}

		const cyclic_edges = edges
			.filter(([owner, target]) => reachable[target][owner])
			.map(([owner, target]) => owner * size + target)
		rows.push({
			id: `rx/modules/graphs/${size}/${shape}/${mask.toString(16).padStart(4, '0')}`,
			size,
			shape,
			edges: edges.map(([owner, target]) => owner * size + target),
			cyclic_edges
		})
	}

	return rows
}

function resourceCases(sizes: Array<number>, mode: string) {
	const rows = []

	for (const size of sizes) {
		for (const shape of ['call', 'import', 'case', 'parallel_task']) {
			for (const topology of ['chain', 'ring', 'fan_out']) {
				if (mode === 'stack' && topology === 'fan_out') continue

				let edges = range(size - 1).map(owner => owner * size + owner + 1)

				if (topology === 'ring') edges.push((size - 1) * size)
				else if (topology === 'fan_out') edges = range(size - 1).map(index => index + 1)

				rows.push({
					id: `rx/modules/resources/${mode}/${size}/${shape}/${topology}`,
					size,
					shape,
					edges,
					cyclic_edges: topology === 'ring' ? edges : [],
					[mode === 'allocation' ? 'allocation_failures' : 'bounded_stack']: true
				})
			}
		}
	}

	return rows
}

const root = 'tests/rx/modules/'

for (const size of [3, 4]) {
	for (const shape of size === 3 ? ['call', 'import', 'case', 'parallel_task'] : ['call', 'import'])
		writeCatalog(`${root}graphs/${size}/${shape}.jsonl`, cases(size, shape))
}

writeCatalog(root + 'resources/allocation.jsonl', resourceCases([4, 16, 64], 'allocation'))
writeCatalog(root + 'resources/stack.jsonl', resourceCases([256, 1024], 'stack'))
