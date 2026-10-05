import { readFile } from 'node:fs/promises'
import { WASI } from 'node:wasi'

const wasi = new WASI({ version: 'preview1', args: ['application', ...process.argv.slice(3)] })
const module = await WebAssembly.compile(await readFile(process.argv[2]))
const instance = await WebAssembly.instantiate(module, wasi.getImportObject())

wasi.start(instance)
