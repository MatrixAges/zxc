const targets = [
	{ target: 'x86_64-linux-musl', runner: 'ubuntu-24.04' },
	{ target: 'aarch64-linux-musl', runner: 'ubuntu-24.04-arm' },
	{ target: 'x86_64-macos', runner: 'macos-15-intel' },
	{ target: 'aarch64-macos', runner: 'macos-15' },
	{ target: 'x86_64-windows-gnu', runner: 'windows-2025' },
	{ target: 'aarch64-windows-gnu', runner: 'windows-11-arm' }
]

export default targets
