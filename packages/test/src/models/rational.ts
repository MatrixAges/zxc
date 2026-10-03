export default class Rational {
	numerator: bigint
	denominator: bigint

	constructor(numerator: bigint, denominator = 1n) {
		if (denominator === 0n) throw new Error('zero denominator')

		this.numerator = denominator < 0n ? -numerator : numerator
		this.denominator = denominator < 0n ? -denominator : denominator
	}

	static decimal(text: string): Rational {
		const [integer, fraction = ''] = text.split('.')

		return new Rational(BigInt(integer + fraction), 10n ** BigInt(fraction.length))
	}

	divide(other: Rational): Rational {
		return new Rational(this.numerator * other.denominator, this.denominator * other.numerator)
	}

	compare(other: Rational): number {
		const difference = this.numerator * other.denominator - other.numerator * this.denominator

		return difference < 0n ? -1 : difference > 0n ? 1 : 0
	}

	negate(): Rational {
		return new Rational(-this.numerator, this.denominator)
	}
}
