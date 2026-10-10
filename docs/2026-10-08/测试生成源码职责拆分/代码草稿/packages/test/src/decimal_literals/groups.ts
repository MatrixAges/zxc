export function groupName(token: string): string {
    if (token.includes('.')) return /[eE]/.test(token) ? 'fraction_exponent' : 'fraction'
    if (token.includes('e')) return 'integer_lower_exponent'
    if (token.includes('E')) return 'integer_upper_exponent'
    if (/^[+-]/.test(token)) return 'integer_signed'

    return token.length === 1 ? 'integer_digit' : 'integer_multi_digit'
}

export function subgroupName(args: { name: string; token: string }): string | null {
    const { name, token } = args

    if (name.endsWith('_exponent')) {
        const exponent = token.split(/[eE]/)[1]

        return exponent.startsWith('-') ? 'negative' : exponent.startsWith('+') ? 'positive' : 'unsigned'
    }

    if (name === 'integer_multi_digit') {
        return token.startsWith('0') ? 'leading_zero_' + token.length : 'unprefixed'
    }

    return null
}
