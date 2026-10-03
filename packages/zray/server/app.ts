import type { Context } from './rpc/trpc.ts'
import { resolve } from 'node:path'
import { Hono } from 'hono'
import { bodyLimit } from 'hono/body-limit'
import { serveStatic } from '@hono/node-server/serve-static'
import { trpcServer } from '@hono/trpc-server'
import router from './rpc/index.ts'

export default function createApp(context: Context) {
	const app = new Hono()

	app.use('/trpc/*', async (c, next) => {
		const host = c.req.header('host') ?? ''
		if (!/^(127\.0\.0\.1|localhost):(4310|4311)$/.test(host) || c.req.header('x-zray-request') !== '1') {
			return c.json({ error: '仅允许本机 zray 请求' }, 403)
		}
		if (c.req.header('origin') && c.req.header('origin') !== `http://${host}`) {
			return c.json({ error: '来源不匹配' }, 403)
		}

		c.header('Cache-Control', 'no-store')
		await next()
	})
	app.use('/trpc/*', bodyLimit({ maxSize: 64_000 }))
	app.use('/trpc/*', trpcServer({ router, createContext: () => context }))
	app.get('/health', c => c.json({ status: 'ready' }))
	app.use('/*', serveStatic({ root: resolve(import.meta.dirname, '../app/dist') }))

	return app
}
