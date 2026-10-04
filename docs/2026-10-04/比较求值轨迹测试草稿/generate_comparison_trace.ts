import type { Json } from './shared/json.ts'
import { writeCatalog, writeOutput } from './shared/catalog.ts'

const operations: Array<[string, string, (left: number, right: number) => boolean]> = [
	['less', '<', (left, right) => left < right],
	['greater', '>', (left, right) => left > right],
	['less_equal', '<=', (left, right) => left <= right],
	['greater_equal', '>=', (left, right) => left >= right],
	['equal', '==', (left, right) => left === right],
	['not_equal', '!=', (left, right) => left !== right],
]
const rows: Array<{ id: string; input: Json; expected: { trace: string; value?: boolean; error?: string } }> = []
const left_call = '(readLeft(in.fail_left) + in.left - 2)'
const right_call = '(readRight(in.fail_right) + in.right - 3)'
const branches: Array<string> = []
const reversed_branches: Array<string> = []

for (const [operator, [name, symbol, compare]] of operations.entries()) {
	branches.push(`    case ${operator}: return ${left_call} ${symbol} ${right_call};`)
	reversed_branches.push(`      case ${operator}: return ${right_call} ${symbol} ${left_call};`)

	for (const reverse of [false, true]) {
		for (const left of [-3, 0, 2]) {
			for (const right of [-3, 0, 2]) {
				for (const fail_left of [false, true]) {
					for (const fail_right of [false, true]) {
						const first_fails = reverse ? fail_right : fail_left
						const second_fails = reverse ? fail_left : fail_right
						const first = reverse ? 'R' : 'L'
						const second = reverse ? 'L' : 'R'
						const expected = first_fails
							? { error: reverse ? 'RightFailure' : 'LeftFailure' }
							: second_fails
								? { error: reverse ? 'LeftFailure' : 'RightFailure' }
								: { value: reverse ? compare(right, left) : compare(left, right) }

						rows.push({
							id: `comparison_order/${name}/${reverse ? 'RL' : 'LR'}/${left}/${right}/fail_left_${fail_left}/fail_right_${fail_right}`,
							input: { operator, reverse, left, right, fail_left, fail_right },
							expected: { ...expected, trace: first_fails ? first : first + second },
						})
					}
				}
			}
		}
	}
}

writeCatalog('tests/runtime/evaluation_order/comparison.jsonl', rows)
writeOutput('tests/runtime/evaluation_order/comparison.zx', `import readLeft from "lib:probe-left";
import readRight from "lib:probe-right";

export type Input = { operator: u64; reverse: bool; left: f64; right: f64; fail_left: bool; fail_right: bool; };

export type Output = bool;

export default function (in: Input): Output {
  if (in.reverse) {
    switch (in.operator) {
${reversed_branches.join('\n')}
      default: return false;
    }
  }

  switch (in.operator) {
${branches.join('\n')}
    default: return false;
  }
}
`)
