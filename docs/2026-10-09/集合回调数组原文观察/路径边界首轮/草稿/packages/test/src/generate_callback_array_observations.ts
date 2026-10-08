import { resolve } from 'node:path'
import { package_dir, writeCatalog } from './shared/catalog.ts'
import { readRows } from './shared/json.ts'

writeCatalog(
    'upstream/reviews/built_ins/array/callback_array_observations.jsonl',
    readRows(resolve(package_dir, 'src/data/callback_array_observations.jsonl'))
)
