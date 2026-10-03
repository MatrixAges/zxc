export default class JsonNumber {
	readonly raw: string
	readonly identity: string

	constructor(raw: string) {
		this.raw = raw

		const negative = raw.startsWith('-')
		const [mantissa, exponent = '0'] = raw.replace(/^-/, '').toLowerCase().split('e')
		const fraction = mantissa!.split('.')[1]?.length ?? 0
		const digits = mantissa!.replace('.', '').replace(/^0+/, '')

		if (!digits) {
			this.identity = negative ? '-0' : '0'

			return
		}

		const significant = digits.replace(/0+$/, '')
		const power = BigInt(exponent) - BigInt(fraction) + BigInt(digits.length - significant.length)

		this.identity = `${negative ? '-' : ''}${significant}e${power}`
	}
}
