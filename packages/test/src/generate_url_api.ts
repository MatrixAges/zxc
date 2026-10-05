import writeFiles from './url_api/file_cases.ts'
import writeWpt from './url_api/wpt.ts'
import writeSuite from './url_api/write_suite.ts'

writeWpt()
writeFiles()

const domains = [
	['EXAMPLE.COM', 'example.com', 'example.com'],
	['bücher.example', 'xn--bcher-kva.example', 'bücher.example'],
	['faß.de', 'xn--fa-hia.de', 'faß.de'],
	['你好', 'xn--6qq79v', '你好'],
	['xn--bcher-kva.example', 'xn--bcher-kva.example', 'bücher.example'],
	['ｅｘａｍｐｌｅ．ＣＯＭ', 'example.com', 'example.com'],
	['127.1', '127.0.0.1', '127.0.0.1'],
	['[0:0:0:0:0:0:0:1]', '[::1]', '[::1]'],
	['a b', '', ''],
	['%FF', '', ''],
	['a/b', '', ''],
	['a@b', '', ''],
	['xn--', 'xn--', 'xn--'],
	['', '', '']
]

for (const [operation, column] of [
	['domainToASCII', 1],
	['domainToUnicode', 2]
] as const) {
	writeSuite({
		operation,
		input: 'string',
		output: 'string',
		rows: domains.map((row, index) => ({ name: `domain-${index}`, input: row[0], value: row[column] }))
	})
}
