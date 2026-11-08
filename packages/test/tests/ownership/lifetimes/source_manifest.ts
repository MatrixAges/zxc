import { readFileSync, writeFileSync } from 'node:fs'

const [base_path, source_path, output_path] = process.argv.slice(2)
const manifest = JSON.parse(readFileSync(base_path, 'utf8')) as {
    roots: Array<{ path: string; prefix?: string }>
    entries: Array<{ path: string; name: string }>
    packages: Array<{ specifier: string; entry: string }>
}

manifest.roots.push({ path: source_path, prefix: 'probe/' })
manifest.entries = [{ path: 'probe/build.rx', name: 'loan_report' }]
manifest.packages.push(
    { specifier: 'genz/scope_reads', entry: 'genz/analysis/scope/reads/collect.rx' },
    { specifier: 'genz/scope_reads/model', entry: 'genz/analysis/scope/reads/model.zx' }
)

writeFileSync(output_path, JSON.stringify(manifest))
