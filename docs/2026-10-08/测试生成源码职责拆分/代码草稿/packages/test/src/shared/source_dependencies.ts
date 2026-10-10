import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'
import { format, resolveConfig } from 'prettier'
import { package_dir, writeOutput } from './catalog.ts'
import { parseJson } from './json.ts'

type Suites = { runtime: Array<{ path: string; sources?: Array<string> }> }

export default async function sourceDependencies(args: { path: string; sources: Array<string> }): Promise<void> {
    const { path, sources } = args
    const suites = parseJson<Suites>(readFileSync(resolve(package_dir, 'suites.json'), 'utf8'))
    const suite = suites.runtime.find(suite => suite.path === path)

    if (!suite) throw new Error('missing runtime suite: ' + path)

    suite.sources = [...new Set(sources.map(source => source.replace(/^tests\//, '')))].sort()

    const manifest = resolve(package_dir, 'suites.json')
    const content = await format(JSON.stringify(suites, null, 4), {
        ...(await resolveConfig(manifest)),
        filepath: manifest
    })

    writeOutput('suites.json', content)
}
