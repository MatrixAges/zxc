/// <reference lib="dom" />

import { readFileSync } from 'node:fs'
import { WASI } from 'node:wasi'

const [path, ...args] = process.argv.slice(2)
const wasi = new WASI({ version: 'preview1', args: ['application', ...args], returnOnExit: true })
const module = new WebAssembly.Module(readFileSync(path))
const instance = new WebAssembly.Instance(module, wasi.getImportObject() as WebAssembly.Imports)

process.exitCode = wasi.start(instance)
