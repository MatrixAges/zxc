import { writeCatalog } from './shared/catalog.ts'

const numeric = ['u8', 'u16', 'u32', 'u64', 'i32', 'i64', 'f32', 'f64']
const types = {
    ...Object.fromEntries(numeric.map(name => [name, name])),
    bool: 'bool',
    string: 'string',
    list: 'u64[]',
    object: '{ value: u64 }'
}
const operators = {
    add: '+',
    subtract: '-',
    multiply: '*',
    divide: '/',
    remainder: '%',
    less: '<',
    less_equal: '<=',
    greater: '>',
    greater_equal: '>=',
    equal: '==',
    not_equal: '!=',
    and: '&&',
    or: '||'
}

for (const [name, operator] of Object.entries(operators)) {
    const arithmetic = ['add', 'subtract', 'multiply', 'divide', 'remainder'].includes(name)
    const comparable = ['equal', 'not_equal'].includes(name) ? [...numeric, 'bool', 'string'] : numeric
    const rows = []

    for (const [left, left_type] of Object.entries(types)) {
        for (const [right, right_type] of Object.entries(types)) {
            let allowed = left === right && comparable.includes(left)

            if (['and', 'or'].includes(name)) allowed = left === 'bool' && right === 'bool'

            const output = arithmetic ? (numeric.includes(left) ? left_type : 'u64') : 'bool'
            const source = `export type Input = { left: ${left_type}
 right: ${right_type} }

export type Output = ${output}

export default function (in: Input): Output {
  return in.left ${operator} in.right
}
`
            rows.push({
                id: `language/types/operators/${name}/${left}/${right}`,
                source,
                phase: 'analyze',
                diagnostic: allowed ? null : 'type_mismatch'
            })
        }
    }

    writeCatalog(`tests/language/types/operators/${name}.jsonl`, rows)
}
