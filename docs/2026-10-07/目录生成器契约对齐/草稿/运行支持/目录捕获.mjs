export const outputs = []

export function writeOutput(path, content) {
    outputs.push({ path, content })
}

export function writeCatalog(path, rows) {
    outputs.push({ path, rows })
}
