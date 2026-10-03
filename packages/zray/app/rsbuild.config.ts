import { defineConfig } from '@rsbuild/core'
import { pluginReact } from '@rsbuild/plugin-react'
import tailwindcss from '@tailwindcss/postcss'

export default defineConfig({
	root: import.meta.dirname,
	plugins: [pluginReact()],
	source: { entry: { index: './main.tsx' } },
	resolve: { alias: { '@': import.meta.dirname } },
	html: { template: './index.html' },
	output: { cleanDistPath: true },
	server: {
		host: '127.0.0.1',
		port: 4310,
		strictPort: true,
		open: false,
		proxy: { '/trpc': { target: 'http://127.0.0.1:4311', changeOrigin: false } }
	},
	tools: {
		cssLoader: { url: { filter: (url: string) => !url.startsWith('/') } },
		postcss: { postcssOptions: { plugins: [tailwindcss()] } }
	}
})
