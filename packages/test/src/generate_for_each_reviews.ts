import { resolve } from 'node:path'
import { package_dir, writeCatalog } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

writeCatalog(
	'upstream/reviews/built_ins/array/for_each.jsonl',
	readRows(resolve(package_dir, 'src/data/for_each.jsonl'))
)
