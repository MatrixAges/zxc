import { resolve } from 'node:path'
import { serve } from '@hono/node-server'
import createApp from './app.ts'
import WorkspaceFiles from './workspace/files.ts'
import TestRunner from './execution/runner.ts'
import SessionRunner from './sessions/runner.ts'
import findCodex from './sessions/find_codex.ts'

const root = resolve(import.meta.dirname, '../../..')
const workspace = new WorkspaceFiles(root)
const tests = new TestRunner(root)
const codex_bin = await findCodex()
const sessions = new SessionRunner(root, codex_bin)

await sessions.init()

const app = createApp({ root, workspace, tests, sessions })
const server = serve({ fetch: app.fetch, hostname: '127.0.0.1', port: 4311 }, () => {
	console.log('zray server: http://127.0.0.1:4311')
	console.log(`Codex CLI: ${codex_bin}`)
})

const shutdown = () => {
	tests.close()
	sessions.close()
	server.close()
}

process.once('SIGINT', shutdown)
process.once('SIGTERM', shutdown)
