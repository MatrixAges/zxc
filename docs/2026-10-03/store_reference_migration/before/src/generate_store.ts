import type { StoreCase } from './models/store.ts'
import evaluate from './models/store.ts'
import { range, writeCatalog, writeOutput } from './shared/catalog.ts'

const base = 'tests/stores/transactions/staging'
const source = `export type Input = { action: u8; increment: u64; index: u64; };

export type State = { count: u64; items: u64[]; };

export type Output = { before: u64; after: u64; other: u64; value: u64; };

export default function (in: Input): Output {
  const before = $store_a.value.count;

  $store_a.value = { ...$store_a.value, count: before + in.increment };

  if (in.action == 1) {
    $store_a.value = { ...$store_a.value, count: $store_a.value.count + in.increment };
  }

  if (in.action == 2) {
    const owned = $store_a.value.items.clone();
    const [items, _] = owned.push(in.increment);

    $store_a.value = { ...$store_a.value, items };
  }

  $store_b.value = { ...$store_b.value, count: $store_b.value.count + $store_a.value.count };

  return { before, after: $store_a.value.count, other: $store_b.value.count, value: $store_a.value.items[in.index] };
}
`
const rows: Array<StoreCase> = []

for (const [array_name, items] of Object.entries({ empty: [], one: [5n], many: [1n, 8n, 13n] })) {
	for (const count of [0n, 2n ** 64n - 11n]) {
		for (const increment of [0n, 2n]) {
			for (const action of [0, 1, 2]) {
				const initial_a = { count, items }
				const initial_b = { count: 3n, items: [21n, 34n] }
				const length = items.length + Number(action === 2)
				const indices = new Set([0, Math.max(0, length - 1), length, length + 1])

				for (const index of indices) {
					for (const conflict of [false, true]) {
						const input = { action, increment, index }
						rows.push({
							id: `stores/transactions/staging/${array_name}/${count}/${increment}/${action}/${index}/${conflict}`,
							initial_a,
							initial_b,
							input,
							conflict,
							expected: evaluate({ initial_a, initial_b, input, conflict })
						})
					}
				}
			}
		}
	}
}

const allocation_rows = [3, 1024].flatMap(length =>
	[false, true].map(conflict => {
		const initial_a = { count: 0n, items: range(length).map(value => BigInt(value)) }
		const initial_b = { count: 3n, items: [21n, 34n] }
		const input = { action: 2, increment: 2n, index: 0 }

		return {
			id: `stores/transactions/allocation/${length}/${conflict}`,
			initial_a,
			initial_b,
			input,
			conflict,
			expected: evaluate({ initial_a, initial_b, input, conflict }),
			allocation_failures: true
		}
	})
)

writeCatalog(base + '.jsonl', [...rows, ...allocation_rows])
writeOutput(base + '.zx', source)
