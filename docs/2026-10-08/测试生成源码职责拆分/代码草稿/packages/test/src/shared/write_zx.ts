import { writeOutput } from './catalog.ts'

export default function writeZx(path: string, source: string): void {
    const lines = source.split(/\r\n|\r|\n/).length - (source.endsWith('\n') || source.endsWith('\r') ? 1 : 0)

    if (lines > 120) throw new Error('ZX source exceeds 120 lines: ' + path)

    writeOutput(path, source)
}
