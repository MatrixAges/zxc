import { cloudflare } from '@cloudflare/vite-plugin'
import vinext from 'vinext'
import { defineConfig } from 'vite'
import { wgslVitePlugin } from 'vgpu/client'

export default defineConfig({
	server: { host: '127.0.0.1', port: 4320, strictPort: true },
	plugins: [
		wgslVitePlugin({ minify: true }),
		vinext(),
		cloudflare({
			viteEnvironment: {
				name: 'rsc',
				childEnvironments: ['ssr']
			}
		})
	]
})
