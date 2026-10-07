export type Operation = 'add' | 'subtract' | 'multiply' | 'divide' | 'remainder'

export default function evaluate(args: {
    operation: Operation
    left: bigint
    right: bigint
    minimum: bigint
    maximum: bigint
}): bigint | string {
    const { operation, left, right, minimum, maximum } = args

    if ((operation === 'divide' || operation === 'remainder') && right === 0n) return 'division by zero'

    const value =
        operation === 'add'
            ? left + right
            : operation === 'subtract'
              ? left - right
              : operation === 'multiply'
                ? left * right
                : operation === 'divide'
                  ? left / right
                  : left % right

    return value < minimum || value > maximum ? 'integer overflow' : value
}
