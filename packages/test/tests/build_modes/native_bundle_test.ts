import assert from 'node:assert/strict'
import { createHash } from 'node:crypto'
import { mkdirSync, readFileSync, renameSync, rmSync, symlinkSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'
import { stringify } from 'yaml'

type Run = (args: { command: string; argv: Array<string>; cwd: string; failure?: string }) => string
const source =
	'import native from "zig:sample"\n\nexport type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  return native.apply(in)\n}\n'

function config(bundle_files: Array<string>) {
	return {
		externals: [
			{
				specifier: 'zig:sample',
				export_name: 'apply',
				signature: 'export type Input = u64\n export type Output = u64\n',
				implementation: { module: 'sample_native', member: 'apply' }
			}
		],
		native_modules: [{ name: 'sample_native', path: 'native/root.zig', bundle_files }]
	}
}

export default function checkNativeBundle(args: { directory: string; executable: string; run: Run }): void {
	const { directory, executable, run } = args
	const project = join(directory, 'native_original')
	const library = join(directory, 'native_export')
	const moved = join(directory, 'native relocated library')
	const files = {
		'root.zig':
			'const step = @import("nested/step.zig");\n\npub fn apply(input: u64) u64 {\n    return step.apply(input);\n}\n',
		'nested/step.zig':
			'const data = @embedFile("../delta.txt");\n\npub fn apply(input: u64) u64 {\n    return input + data.len;\n}\n',
		'delta.txt': 'four'
	}

	mkdirSync(join(project, 'native/nested'), { recursive: true })

	for (const [name, content] of Object.entries(files)) writeFileSync(join(project, 'native', name), content)

	writeFileSync(join(project, 'main.zx'), source)
	writeFileSync(
		join(project, 'pkg.yaml'),
		stringify({ name: 'library', version: '0.0.0', ...config(['nested/step.zig', 'delta.txt']) })
	)
	run({ command: executable, argv: ['build', 'main.zx', '--mode', 'lib', '--out', library], cwd: project })
	renameSync(library, moved)
	rmSync(project, { recursive: true })

	const manifest = JSON.parse(readFileSync(join(moved, 'library.json'), 'utf8')) as {
		native_sources_bundled: boolean
		bundled_files: Array<{ path: string; kind: string; sha256: string }>
	}

	assert.equal(manifest.native_sources_bundled, true)
	assert.equal(manifest.bundled_files.length, 3)
	assert.equal(new Set(manifest.bundled_files.map(file => file.path)).size, 3)

	for (const [name, content] of Object.entries(files)) {
		const path = 'native/sample_native/source/' + name
		const record = manifest.bundled_files.find(file => file.path === path)

		assert.ok(record, path)
		assert.equal(record.kind, name.endsWith('.zig') ? 'zig' : 'asset')
		assert.equal(record.sha256, createHash('sha256').update(content).digest('hex'))
		assert.equal(readFileSync(join(moved, path), 'utf8'), content)
	}

	writeFileSync(
		join(moved, 'consumer.zx'),
		'import library from "library"\n\nexport type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  return library(in)\n}\n'
	)
	const application = join(directory, process.platform === 'win32' ? 'native_consumer.exe' : 'native_consumer')

	run({ command: executable, argv: ['build', 'consumer.zx', '--out', application], cwd: moved })
	assert.equal(run({ command: application, argv: ['9'], cwd: directory }).trim(), '13')
	writeFileSync(
		join(moved, 'consumer_test.zig'),
		'const std = @import("std");\nconst library = @import("library");\n\ntest "relocated native dependency executes" {\n    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);\n    defer arena.deinit();\n\n    try std.testing.expectEqual(@as(u64, 13), try library.execute(&arena, 9));\n}\n'
	)
	run({
		command: 'zig',
		argv: [
			'test',
			'--dep',
			'library',
			'-Mroot=consumer_test.zig',
			'--dep',
			'sample_native',
			'--dep',
			'zxc_abi',
			'-Mlibrary=root.zig',
			'--dep',
			'zxc_abi',
			'-Msample_native=native/sample_native/source/root.zig',
			'-Mzxc_abi=abi.zig'
		],
		cwd: moved
	})

	const consumer_project = join(directory, 'native_zig_project')

	mkdirSync(consumer_project)
	writeFileSync(join(consumer_project, 'consumer_test.zig'), readFileSync(join(moved, 'consumer_test.zig')))
	writeFileSync(
		join(consumer_project, 'build.zig.zon'),
		'.{ .name = .zxc_native_consumer, .fingerprint = 0x8fc4a892c4e45db6, .version = "0.0.0", .dependencies = .{ .bundle = .{ .path = "../native relocated library" } }, .paths = .{ "build.zig", "build.zig.zon", "consumer_test.zig" }, }\n'
	)
	writeFileSync(
		join(consumer_project, 'build.zig'),
		`const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const dependency = b.dependency("bundle", .{ .target = target, .optimize = optimize });
    const tests = b.addTest(.{ .root_module = b.createModule(.{
        .root_source_file = b.path("consumer_test.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "library", .module = dependency.module("library") }},
    }) });

    b.default_step.dependOn(&b.addRunArtifact(tests).step);
}
`
	)

	for (const optimize of ['Debug', 'ReleaseSafe'])
		run({ command: 'zig', argv: ['build', '-Doptimize=' + optimize], cwd: consumer_project })

	for (const kind of ['parent', 'absolute', 'symlink', 'dynamic']) {
		const negative = join(directory, 'native_negative_' + kind)

		mkdirSync(join(negative, 'native'), { recursive: true })
		writeFileSync(join(negative, 'outside.txt'), 'outside')
		writeFileSync(join(negative, 'native/delta.txt'), 'four')

		if (kind === 'symlink') symlinkSync(join(negative, 'outside.txt'), join(negative, 'native/escape.txt'))

		const resource =
			kind === 'dynamic'
				? '"delta" ++ ".txt"'
				: JSON.stringify(
						kind === 'parent'
							? '../outside.txt'
							: kind === 'absolute'
								? join(negative, 'outside.txt')
								: 'escape.txt'
					)
		writeFileSync(
			join(negative, 'native/root.zig'),
			`const data = @embedFile(${resource});\n\npub fn apply(input: u64) u64 {\n    return input + data.len;\n}\n`
		)
		writeFileSync(join(negative, 'main.zx'), source)
		writeFileSync(join(negative, 'pkg.yaml'), stringify({ name: 'library', version: '0.0.0', ...config([]) }))
		const failure =
			kind === 'absolute'
				? 'InvalidNativeResourcePath'
				: kind === 'dynamic'
					? 'NativeBundleRequiresFiles'
					: 'NativeResourceOutsideModule'

		run({
			command: executable,
			argv: ['build', 'main.zx', '--mode', 'lib', '--out', join(negative, 'output')],
			cwd: negative,
			failure
		})

		if (kind === 'dynamic') {
			writeFileSync(
				join(negative, 'pkg.yaml'),
				stringify({ name: 'library', version: '0.0.0', ...config(['delta.txt']) })
			)
			const exported = join(negative, 'declared_output')
			const dynamic_moved = join(directory, 'native_dynamic_relocated')

			run({ command: executable, argv: ['build', 'main.zx', '--mode', 'lib', '--out', exported], cwd: negative })
			renameSync(exported, dynamic_moved)
			rmSync(negative, { recursive: true })
			writeFileSync(join(dynamic_moved, 'consumer.zx'), readFileSync(join(moved, 'consumer.zx')))
			const dynamic_application = application + '_dynamic'

			run({
				command: executable,
				argv: ['build', 'consumer.zx', '--out', dynamic_application],
				cwd: dynamic_moved
			})
			assert.equal(run({ command: dynamic_application, argv: ['3'], cwd: directory }).trim(), '7')
		}
	}

	console.log(
		'Native bundle: relocated ZX/Zig execution, file hashes, dependency options, dynamic assets and four path rejection scenarios passed'
	)
}
