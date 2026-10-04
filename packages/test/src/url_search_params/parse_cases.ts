type Case = { name: string; query: string }

export default function parseCases(): Array<Case> {
	const queries = [
		'',
		'?',
		'??a=1',
		'?a=1',
		'&&',
		'=',
		'&=&=',
		'a',
		'a=',
		'=b',
		'a=b=c',
		'a=1&b=2&a=3',
		'&a=1&&b=2&',
		'a+b=c+d',
		'a%2Bb=%2B+',
		'a%26b=c%3Dd',
		'%G1=%1&%=%%',
		'%00=a%00b',
		'a=1#tail',
		'http://example.test/?a=1',
		'%EF%BB%BF=x',
		'x=%EF%BB%BF',
		'%E4%B8%AD=%F0%9F%8C%B1',
		'a%3Db=c%26d'
	]
	const rows = queries.map((query, index) => ({ name: `syntax_${index}`, query }))

	for (let byte = 0; byte < 256; byte++) {
		const encoded = `%${byte.toString(16).padStart(2, '0')}`

		rows.push({ name: `byte_key_${byte}`, query: `${encoded}=x` })
		rows.push({ name: `byte_value_${byte}`, query: `x=${encoded}` })
	}

	const sequences = [
		'C0AF',
		'E080AF',
		'EDA080',
		'F0808080',
		'F4908080',
		'F5808080',
		'E282',
		'F09F8C',
		'E228A1',
		'F0288CBC',
		'C2A2',
		'E282AC',
		'F09F8CB1',
		'EFBBBF',
		'EFBFBD'
	]

	for (const sequence of sequences) {
		const encoded = sequence.replace(/../g, byte => `%${byte}`)

		rows.push({ name: `utf8_${sequence}`, query: `${encoded}=${encoded}` })
	}

	rows.push({ name: 'no_default_limit', query: Array.from({ length: 1001 }, (_, index) => `key=${index}`).join('&') })

	return rows
}
