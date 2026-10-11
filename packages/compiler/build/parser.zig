const std = @import("std");
const entries = @import("entries.zig");

pub const Sources = struct { standard_abi: std.Build.LazyPath, main: std.Build.LazyPath, checks: std.Build.LazyPath };

pub fn generate(b: *std.Build, optimize: std.builtin.OptimizeMode, stage0: []const u8) Sources {
    const target = b.graph.host;
    const generator_optimize: std.builtin.OptimizeMode = if (optimize == .debug) .safe else optimize;
    const core_dependency = b.dependency("core", .{ .target = target, .optimize = generator_optimize });
    const core = core_dependency.module("core");
    const lint_dependency = b.dependency("lint", .{ .target = target, .optimize = generator_optimize, .seed = true });
    const lint = lint_dependency.module("lint");

    const lexer = b.createModule(.{
        .root_source_file = b.path("bootstrap/lexer/lex.zig"),
        .target = target,
        .optimize = generator_optimize,
        .imports = &.{.{ .name = "zx", .module = core }},
    });

    const seed = @import("compiler.zig").create(b, target, generator_optimize, lexer, null, lint);
    const flow = @import("seed_rx.zig").create(b, target, generator_optimize, seed.frontend, lint);
    // The root module selects LLVM's pipeline for the whole tool; small compiles it much faster, while every
    // imported module keeps safe so the compiler code still runs with its runtime safety checks.
    const generator_root: std.builtin.OptimizeMode = if (optimize == .debug or optimize == .safe) .small else optimize;

    const executable = b.addExecutable(.{ .name = "generate-parser", .root_module = b.createModule(.{
        .root_source_file = b.path("build/generate_parser.zig"),
        .target = target,
        .optimize = generator_root,
        .imports = &.{ .{ .name = "compiler", .module = seed.compiler }, .{ .name = "rx", .module = flow.syntax }, .{ .name = "rx_analysis", .module = flow.analysis } },
    }) });

    @import("compiler_rt.zig").configure(b, executable);

    const standard = generatorRun(b, executable, stage0);

    standard.addArg("--standard-abi");

    const standard_abi = standard.addOutputFileArg("standard_abi.zig");
    const genz_dependency = b.dependency("genz", .{ .target = target, .optimize = generator_optimize });
    const roots = [_]std.Build.LazyPath{ b.path("src"), lint_dependency.path("src/naming"), core_dependency.path("src"), genz_dependency.path("src") };

    const directories = [_][]const u8{
        b.root.joinString(b.allocator, "src") catch @panic("out of memory"),
        lint_dependency.builder.root.joinString(b.allocator, "src/naming") catch @panic("out of memory"),
        core_dependency.builder.root.joinString(b.allocator, "src") catch @panic("out of memory"),
        genz_dependency.builder.root.joinString(b.allocator, "src") catch @panic("out of memory"),
    };

    var sources: Sources = undefined;
    sources.standard_abi = standard_abi;

    const manifests = b.addWriteFiles();
    const manifest = @import("generation_manifest.zig");

    const manifest_roots = [_]manifest.Root{
        .{ .path = directories[0] },
        .{ .path = directories[1], .prefix = "lint/naming/" },
        .{ .path = directories[2], .prefix = "core/" },
        .{ .path = directories[3], .prefix = "genz/" },
    };

    // Each entry set runs as its own step, so builds that never import the checks do not generate them.
    inline for (.{ entries.Set.main, entries.Set.checks }) |set| {
        const run = generatorRun(b, executable, stage0);

        const project = manifest.Project{
            .roots = &manifest_roots,
            .entries = entries.of(set),
            .packages = @import("source_packages.zig").entries,
            .interfaces = &.{.{
                .specifier = "zig:string",
                .path = b.root.joinString(b.allocator, "standard/interfaces/string.d.zx") catch @panic("out of memory"),
                .module = "zxc_string",
            }},
        };

        const content = std.json.Stringify.valueAlloc(b.allocator, project, .{}) catch @panic("out of memory");

        run.addArg("--manifest");
        run.addFileArg(manifests.add(@tagName(set) ++ ".json", content));
        run.addFileInput(b.path("standard/interfaces/string.d.zx"));

        for (roots, directories) |root, directory| {
            trackSources(b, run, root, directory) catch @panic("unable to track RX and ZX bootstrap sources");
        }

        const directory = run.addOutputDirectoryArg(@tagName(set));

        run.addDirectoryArg2(std.Build.LazyPath.cache_root.path(b, "bootstrap-functions"), .{ .make_absolute = true });
        @field(sources, @tagName(set)) = directory;
    }

    return sources;
}

fn generatorRun(b: *std.Build, seed: *std.Build.Step.Compile, stage0: []const u8) *std.Build.Step.Run {
    if (stage0.len == 0) return b.addRunArtifact(seed);

    const run = b.addSystemCommand(&.{stage0});

    run.addFileInput(.{ .cwd_relative = stage0 });

    return run;
}

fn trackSources(b: *std.Build, run: *std.Build.Step.Run, root: std.Build.LazyPath, absolute: []const u8) !void {
    var directory = try std.Io.Dir.cwd().openDir(b.graph.io, absolute, .{ .iterate = true });

    defer directory.close(b.graph.io);

    var walker = try directory.walk(b.allocator);

    defer walker.deinit();
    b.dependOnDirectoryContents(root);

    var paths: std.ArrayList([]const u8) = .empty;

    while (try walker.next(b.graph.io)) |entry| {
        if (entry.kind == .directory) {
            b.dependOnDirectoryContents(root.path(b, entry.path));
        } else if (entry.kind == .file and (std.mem.endsWith(u8, entry.path, ".zx") or std.mem.endsWith(u8, entry.path, ".rx"))) {
            try paths.append(b.allocator, try b.allocator.dupe(u8, entry.path));
        }
    }

    std.mem.sort([]const u8, paths.items, {}, lessThan);

    for (paths.items) |path| run.addFileInput(root.path(b, path));
}

fn lessThan(_: void, left: []const u8, right: []const u8) bool {
    return std.mem.lessThan(u8, left, right);
}

/// Generated bootstrap modules omit debug information when strip is set; hand-written host modules keep theirs.
/// Native and standard modules every generated module shares; create them once per build so no file lands in two modules.
pub const Shared = struct { generated: *std.Build.Module, checks: *std.Build.Module };

pub fn shared(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, source: Sources, strip: ?bool) Shared {
    const abi = b.createModule(.{ .root_source_file = source.main.path(b, "types.zig"), .target = target, .optimize = optimize, .strip = strip });

    const standard = b.createModule(.{
        .root_source_file = b.path("standard/src/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "zxc_abi", .module = abi }},
    });

    const generated = b.createModule(.{
        .root_source_file = source.main.path(b, "root.zig"),
        .target = target,
        .optimize = optimize,
        .strip = strip,
        .imports = &.{
            .{ .name = "zxc_abi", .module = abi },
            .{ .name = "zxc_standard", .module = standard },
            .{ .name = "zxc_string", .module = b.createModule(.{ .root_source_file = b.path("standard/src/string.zig"), .target = target, .optimize = optimize, .strip = strip }) },
        },
    });

    const check_modules = b.createModule(.{
        .root_source_file = source.checks.path(b, "root.zig"),
        .target = target,
        .optimize = optimize,
        .strip = strip,
        .imports = &.{
            .{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = source.checks.path(b, "types.zig"), .target = target, .optimize = optimize, .strip = strip }) },
            .{ .name = "zxc_standard", .module = standard },
        },
    });

    return .{ .generated = generated, .checks = check_modules };
}

pub fn modules(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, source: Sources, natives: Shared, strip: ?bool) @import("compiler.zig").ParserModules {
    var result: @import("compiler.zig").ParserModules = undefined;
    result.type_views = @import("compiler.zig").typeViews(b, target, optimize);
    result.nominal_data = @import("compiler.zig").nominalData(b, target, optimize);

    inline for (entries.main) |entry| {
        if (entry.owner == .frontend or entry.owner == .compiler or entry.owner == .genz) {
            const module = b.createModule(.{
                .root_source_file = source.main.path(b, entry.name ++ ".zig"),
                .target = target,
                .optimize = optimize,
                .strip = strip,
            });

            module.addImport("generated", natives.generated);
            @field(result, entry.name) = module;
        }
    }

    return result;
}

/// Individual checkers only test builds import; they hang off one module's import table so tests can merge them.
pub fn checks(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, source: Sources, natives: Shared, strip: ?bool) *std.Build.Module {
    const module = b.createModule(.{ .root_source_file = b.addWriteFiles().add("checks.zig", ""), .target = target, .optimize = optimize });

    inline for (entries.checks) |entry| {
        module.addImport("generated_" ++ entry.name, b.createModule(.{
            .root_source_file = source.checks.path(b, entry.name ++ ".zig"),
            .strip = strip,
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "generated", .module = natives.checks }},
        }));
    }

    return module;
}
