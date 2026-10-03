import { cloudflare } from '@cloudflare/vite-plugin'
import vinext from 'vinext'
import { defineConfig } from 'vite'

export default defineConfig({
	server: { host: '127.0.0.1', port: 4320, strictPort: true },
	plugins: [
		vinext(),
		cloudflare({
			viteEnvironment: {
				name: 'rsc',
				childEnvironments: ['ssr']
			}
		})
	]
})
