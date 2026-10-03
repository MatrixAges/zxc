import { bindings, defineConfig } from 'cf/config'

export default defineConfig({
	worker: {
		name: 'zxc-website',
		entrypoint: 'vinext/server/fetch-handler',
		compatibilityDate: '2026-10-03',
		compatibilityFlags: ['nodejs_compat'],
		assets: { notFoundHandling: 'none' },
		env: { ASSETS: bindings.assets() }
	}
})
