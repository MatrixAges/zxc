let calls = 0
const key = {
    toString() {
        calls += 1
        return ''
    }
}
const base = {}

base[key] *= 0

console.log(
    JSON.stringify({
        engine: process.versions.bun ? 'Bun' : 'Node',
        version: process.versions.bun ?? process.version,
        calls
    })
)
