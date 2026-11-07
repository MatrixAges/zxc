const std = @import("std");
const entries = @import("entries.zig");

pub const Sources = struct { standard_abi: std.Build.LazyPath, main: std.Build.LazyPath, checks: std.Build.LazyPath, ordered: std.Build.LazyPath, collections: std.Build.LazyPath, growth: std.Build.LazyPath };

pub fn generate(b: *std.Build, optimize: std.builtin.OptimizeMode, stage0: []const u8, partitions: u32) Sources {
    const target = b.graph.host;
    // Debug iteration reruns the generator on every source edit, so it runs unchecked there: ReleaseFast cuts a
    // cached run by about a third and compiles as quickly as ReleaseSafe. Other modes keep the requested checks.
    const generator_optimize: std.builtin.OptimizeMode = if (optimize == .debug) .fast else optimize;
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
        .strip = false,
        .imports = &.{ .{ .name = "compiler", .module = seed.compiler }, .{ .name = "rx", .module = flow.syntax }, .{ .name = "rx_analysis", .module = flow.analysis } },
    }) });

    @import("compiler_rt.zig").configure(b, executable);

    const standard = generatorRun(b, executable, stage0);

    standard.addArg("--standard-abi");

    const standard_abi = standard.addOutputFileArg("standard_abi.zig");
    const genz_dependency = b.dependency("genz", .{ .target = target, .optimize = generator_optimize });
    const roots = [_]std.Build.LazyPath{ b.path("src"), lint_dependency.path("src"), core_dependency.path("src"), genz_dependency.path("src") };

    const directories = [_][]const u8{
        b.root.joinString(b.allocator, "src") catch @panic("out of memory"),
        lint_dependency.builder.root.joinString(b.allocator, "src") catch @panic("out of memory"),
        core_dependency.builder.root.joinString(b.allocator, "src") catch @panic("out of memory"),
        genz_dependency.builder.root.joinString(b.allocator, "src") catch @panic("out of memory"),
    };

    var sources: Sources = undefined;
    sources.standard_abi = standard_abi;

    const manifests = b.addWriteFiles();
    const manifest = @import("generation_manifest.zig");

    const manifest_roots = [_]manifest.Root{
        .{ .path = directories[0] },
        .{ .path = directories[1], .prefix = "lint/" },
        .{ .path = directories[2], .prefix = "core/" },
        .{ .path = directories[3], .prefix = "genz/" },
    };

    // Each entry set runs as its own step, so builds that never import the checks do not generate them.
    inline for (.{ entries.Set.main, entries.Set.checks, entries.Set.constant_seed, entries.Set.snapshot_seed, entries.Set.partition_seed, entries.Set.ordered, entries.Set.collections, entries.Set.growth }) |set| {
        const run = generatorRun(b, executable, stage0);

        const project = manifest.Project{
            .roots = switch (set) {
                .ordered => &.{.{
                    .path = b.fmt("{s}/analysis/uniqueness/replay/ordered", .{directories[3]}),
                    .prefix = "genz/analysis/uniqueness/replay/ordered/",
                }},
                .collections => &.{ manifest_roots[2], .{
                    .path = b.fmt("{s}/analysis/state/locals", .{directories[3]}),
                    .prefix = "genz/analysis/state/locals/",
                }, .{
                    .path = b.fmt("{s}/analysis/state/queries", .{directories[3]}),
                    .prefix = "genz/analysis/state/queries/",
                }, .{
                    .path = b.fmt("{s}/analysis/members", .{directories[3]}),
                    .prefix = "genz/analysis/members/",
                }, .{
                    .path = b.fmt("{s}/analysis/iteration/transfer/history", .{directories[3]}),
                    .prefix = "genz/analysis/iteration/transfer/history/",
                } },
                else => &manifest_roots,
            },
            .entries = entries.of(set),
            .packages = @import("source_packages.zig").entries,
            .interfaces = &.{.{
                .specifier = "zig:string",
                .path = b.dependency("zxc_std", .{}).builder.root.joinString(b.allocator, "interfaces/string.d.zx") catch @panic("out of memory"),
                .module = "zxc_string",
            }},
        };

        const content = std.json.Stringify.valueAlloc(b.allocator, project, .{}) catch @panic("out of memory");

        run.addArg("--manifest");
        run.addFileArg(manifests.add(@tagName(set) ++ ".json", content));
        run.addFileInput(b.dependency("zxc_std", .{}).path("interfaces/string.d.zx"));

        if (set == .ordered or set == .collections) {
            const relative = if (set == .ordered) "src/analysis/uniqueness/replay/ordered" else "src/analysis/members";
            const directory = genz_dependency.builder.root.joinString(b.allocator, relative) catch @panic("out of memory");

            trackSources(b, run, genz_dependency.path(relative), directory) catch @panic("unable to track comparison sources");

            if (set == .collections) {
                trackSources(b, run, roots[2], directories[2]) catch @panic("unable to track index sources");

                inline for (.{ "src/analysis/state/locals", "src/analysis/state/queries" }) |relative_state| {
                    const state_directory = genz_dependency.builder.root.joinString(b.allocator, relative_state) catch @panic("out of memory");

                    trackSources(b, run, genz_dependency.path(relative_state), state_directory) catch @panic("unable to track local state sources");
                }

                const history = "src/analysis/iteration/transfer/history";
                const history_directory = genz_dependency.builder.root.joinString(b.allocator, history) catch @panic("out of memory");

                trackSources(b, run, genz_dependency.path(history), history_directory) catch @panic("unable to track transfer history");
            }
        } else for (roots, directories) |root, directory| {
            trackSources(b, run, root, directory) catch @panic("unable to track RX and ZX bootstrap sources");
        }

        const directory = run.addOutputDirectoryArg(@tagName(set));

        run.addDirectoryArg2(std.Build.LazyPath.cache_root.path(b, "bootstrap-functions"), .{ .make_absolute = true });

        // Partitioned output lives in one directory reused by every run, so unchanged partitions keep their
        // paths and contents and Zig reuses their objects; the generator itself skips work when inputs match.
        if (set == .main and partitions != 0) {
            run.addArgs(&.{ "--partitions", b.fmt("{d}", .{partitions}) });
            run.has_side_effects = true;
        }

        if (set == .constant_seed) {
            const install = b.addInstallDirectory(.{ .source_dir = directory, .install_dir = .prefix, .install_subdir = "bootstrap/constants" });

            b.step("bootstrap-constant-seed", "Generate the initial constant evaluator snapshot from RX and ZX").dependOn(&install.step);
        } else if (set == .snapshot_seed) {
            const install = b.addInstallDirectory(.{ .source_dir = directory, .install_dir = .prefix, .install_subdir = "bootstrap/input_snapshot" });

            b.step("bootstrap-input-snapshot", "Generate the initial input snapshot predicate from RX and ZX").dependOn(&install.step);
        } else if (set == .partition_seed) {
            const install = b.addInstallDirectory(.{ .source_dir = directory, .install_dir = .prefix, .install_subdir = "bootstrap/partition" });

            b.step("bootstrap-partition-seed", "Generate the initial partition planner from RX and ZX").dependOn(&install.step);
        } else @field(sources, @tagName(set)) = directory;
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
        } else if (entry.kind == .file and (std.mem.endsWith(u8, entry.path, ".zx") or std.mem.endsWith(u8, entry.path, ".rx") or std.mem.endsWith(u8, entry.path, ".tpl"))) {
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
/// `objects` links the partition objects into an artifact that imports it; null when generated code is one unit.
/// `self_hosted_objects` are the same partitions compiled by Zig's own backend, which compiles an edited partition in
/// about 0.4 s instead of 1.5 s on x86_64 Debug. Code calling into them has to come from that backend too, since the
/// layout of Zig's own types only agrees within one backend, and only Apple's linker turns them into a runnable
/// executable on macOS; artifacts that cannot meet both keep `objects`. Each set compiles only when an artifact uses it.
/// They come as one directory holding `zxc_partition_<n>.o` for each partition.
pub const Shared = struct { generated: *std.Build.Module, checks: *std.Build.Module, ordered: *std.Build.Module, collections: *std.Build.Module, growth: *std.Build.Module, objects: ?*std.Build.Module, self_hosted_objects: ?std.Build.LazyPath };

pub fn shared(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, source: Sources, strip: ?bool, partitions: u32) Shared {
    const abi = b.createModule(.{ .root_source_file = source.main.path(b, "types.zig"), .target = target, .optimize = optimize, .strip = strip });

    const standard = b.createModule(.{
        .root_source_file = b.dependency("zxc_std", .{}).path("src/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "zxc_abi", .module = abi }},
    });

    const string = b.createModule(.{ .root_source_file = b.dependency("zxc_std", .{}).path("src/string.zig"), .target = target, .optimize = optimize, .strip = strip });

    const generated = b.createModule(.{
        .root_source_file = source.main.path(b, "root.zig"),
        .target = target,
        .optimize = optimize,
        .strip = strip,
        .imports = &.{
            .{ .name = "zxc_abi", .module = abi },
            .{ .name = "zxc_standard", .module = standard },
            .{ .name = "zxc_string", .module = string },
        },
    });

    var objects: ?*std.Build.Module = null;
    var self_hosted_objects: ?std.Build.LazyPath = null;

    if (partitions != 0) {
        const bridge = b.createModule(.{ .root_source_file = b.path("build/partition/bridge.zig"), .target = target, .optimize = optimize, .strip = strip });

        const signatures = b.createModule(.{
            .root_source_file = source.main.path(b, "signatures.zig"),
            .target = target,
            .optimize = optimize,
            .strip = strip,
            .imports = &.{.{ .name = "zxc_abi", .module = abi }},
        });

        const imports: []const std.Build.Module.Import = &.{
            .{ .name = "zxc_abi", .module = abi },
            .{ .name = "zxc_standard", .module = standard },
            .{ .name = "zxc_string", .module = string },
            .{ .name = "zxc_bridge", .module = bridge },
            .{ .name = "zxc_signatures", .module = signatures },
        };

        generated.addImport("zxc_bridge", bridge);
        generated.addImport("zxc_signatures", signatures);

        generated.addImport("zxc_comptime", b.createModule(.{
            .root_source_file = source.main.path(b, "original/root.zig"),
            .target = target,
            .optimize = optimize,
            .strip = strip,
            .imports = &.{
                .{ .name = "zxc_abi", .module = abi },
                .{ .name = "zxc_standard", .module = standard },
                .{ .name = "zxc_string", .module = string },
            },
        }));

        objects = if (target.query.isNative()) cachedPartitionObjects(b, target, optimize, source, partitions, strip) else partitionObjects(b, target, optimize, source, partitions, imports, strip);

        if (optimize == .debug and target.result.cpu.arch == .x86_64 and target.query.isNative()) self_hosted_objects = cachedObjects(b, optimize, source, partitions, strip, false);
    }

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

    const ordered_abi = b.createModule(.{ .root_source_file = source.ordered.path(b, "types.zig"), .target = target, .optimize = optimize, .strip = strip });

    const ordered = b.createModule(.{
        .root_source_file = source.ordered.path(b, "root.zig"),
        .target = target,
        .optimize = optimize,
        .strip = strip,
        .imports = &.{ .{ .name = "zxc_abi", .module = ordered_abi }, .{ .name = "zxc_string", .module = string } },
    });

    const collections_abi = b.createModule(.{ .root_source_file = source.collections.path(b, "types.zig"), .target = target, .optimize = optimize, .strip = strip });

    const collections = b.createModule(.{
        .root_source_file = source.collections.path(b, "root.zig"),
        .target = target,
        .optimize = optimize,
        .strip = strip,
        .imports = &.{
            .{ .name = "zxc_abi", .module = collections_abi },
            .{ .name = "zxc_standard", .module = standard },
            .{ .name = "zxc_string", .module = string },
        },
    });

    const growth_abi = b.createModule(.{ .root_source_file = source.growth.path(b, "types.zig"), .target = target, .optimize = optimize, .strip = strip });

    const growth = b.createModule(.{
        .root_source_file = source.growth.path(b, "root.zig"),
        .target = target,
        .optimize = optimize,
        .strip = strip,
        .imports = &.{
            .{ .name = "zxc_abi", .module = growth_abi },
            .{ .name = "zxc_standard", .module = standard },
            .{ .name = "zxc_string", .module = string },
        },
    });

    return .{ .generated = generated, .checks = check_modules, .ordered = ordered, .collections = collections, .growth = growth, .objects = objects, .self_hosted_objects = self_hosted_objects };
}

/// Each partition is its own compilation unit; final artifacts link them by importing the returned module.
/// Generated bodies and their entry module use the same debug policy.
fn partitionObjects(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, source: Sources, partitions: u32, imports: []const std.Build.Module.Import, strip: ?bool) *std.Build.Module {
    const objects = b.createModule(.{ .root_source_file = b.path("build/partition/objects.zig"), .target = target, .optimize = optimize });

    for (0..partitions) |index| {
        const functions = b.createModule(.{
            .root_source_file = source.main.path(b, b.fmt("part_{d}/functions.zig", .{index})),
            .target = target,
            .optimize = optimize,
            .strip = strip,
            .imports = imports,
        });

        const module = b.createModule(.{
            .root_source_file = source.main.path(b, b.fmt("part_{d}/root.zig", .{index})),
            .target = target,
            .optimize = optimize,
            .strip = strip,
            .imports = imports,
        });

        module.addImport("zxc_functions", functions);
        objects.addObject(b.addObject(.{ .name = b.fmt("zxc_partition_{d}", .{index}), .root_module = module }));
    }

    return objects;
}

fn cachedPartitionObjects(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, source: Sources, partitions: u32, strip: ?bool) *std.Build.Module {
    const files = cachedObjects(b, optimize, source, partitions, strip, true);
    const objects = b.createModule(.{ .root_source_file = b.path("build/partition/objects.zig"), .target = target, .optimize = optimize });

    for (0..partitions) |index| objects.addObjectFile(files.path(b, b.fmt("zxc_partition_{d}.o", .{index})));

    return objects;
}

/// One manifest check replaces a Zig cache process per unchanged partition, on either native backend.
fn cachedObjects(b: *std.Build, optimize: std.builtin.OptimizeMode, source: Sources, partitions: u32, strip: ?bool, llvm: bool) std.Build.LazyPath {
    const tool = b.addExecutable(.{ .name = "partition-objects", .root_module = b.createModule(.{
        .root_source_file = b.path("build/partition/compile.zig"),
        .target = b.graph.host,
        .optimize = .ReleaseFast,
    }) });

    const run = b.addRunArtifact(tool);
    const level = b.fmt("-O{s}", .{@tagName(optimize)});
    const stripped: []const []const u8 = if (strip) |value| &.{if (value) "-fstrip" else "-fno-strip"} else &.{};

    run.addArg(b.graph.zig_exe);
    run.addDirectoryArg(source.main);

    const objects = run.addOutputDirectoryArg("objects");

    run.addArg(b.fmt("{d}", .{partitions}));
    run.addDirectoryArg(b.dependency("zxc_std", .{}).path("src"));
    run.addFileArg(b.path("build/partition/bridge.zig"));
    run.addArgs(&.{ "--", "build-obj", if (llvm) "-fllvm" else "-fno-llvm", if (strip orelse false) "-fstrip" else "-fno-strip", level, "--dep", "zxc_bridge", "--dep", "zxc_functions", "-Mroot=%generated%/part_%index%/root.zig" });
    run.addArgs(stripped);
    run.addArgs(&.{ level, "-Mzxc_abi=%generated%/types.zig", level, "--dep", "zxc_abi", b.fmt("-Mzxc_standard={s}", .{b.dependency("zxc_std", .{}).builder.root.joinString(b.allocator, "src/root.zig") catch @panic("out of memory")}) });
    run.addArgs(stripped);
    run.addArgs(&.{ level, b.fmt("-Mzxc_string={s}", .{b.dependency("zxc_std", .{}).builder.root.joinString(b.allocator, "src/string.zig") catch @panic("out of memory")}) });
    run.addArgs(stripped);
    run.addArgs(&.{ level, "--dep", "zxc_abi", "-Mzxc_signatures=%generated%/signatures.zig", level });
    run.addPrefixedFileArg("-Mzxc_bridge=", b.path("build/partition/bridge.zig"));
    run.addArgs(stripped);
    run.addArgs(&.{ level, "--dep", "zxc_abi", "--dep", "zxc_standard", "--dep", "zxc_string", "--dep", "zxc_bridge", "--dep", "zxc_signatures", "-Mzxc_functions=%generated%/part_%index%/functions.zig" });
    run.addArgs(&.{ "--name", if (llvm) "zxc_partition_%index%" else "zxc_partition_%index%_self_hosted", "-femit-bin=%objects%/zxc_partition_%index%.o" });

    // The object directory persists across runs, so unchanged partitions keep their objects.
    run.has_side_effects = true;

    return objects;
}

pub fn modules(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, source: Sources, natives: Shared, strip: ?bool) @import("compiler.zig").ParserModules {
    var result: @import("compiler.zig").ParserModules = undefined;
    result.type_views = @import("compiler.zig").typeViews(b, target, optimize);
    result.nominal_data = @import("compiler.zig").nominalData(b, target, optimize);

    inline for (.{ entries.Set.main, entries.Set.ordered, entries.Set.collections, entries.Set.growth }) |set| {
        inline for (comptime entries.of(set)) |entry| {
            if (entry.owner == .frontend or entry.owner == .compiler or entry.owner == .genz) {
                const directory = @field(source, @tagName(set));

                const module = b.createModule(.{
                    .root_source_file = directory.path(b, entry.name ++ ".zig"),
                    .target = target,
                    .optimize = optimize,
                    .strip = strip,
                });

                module.addImport("generated", if (set == .main) natives.generated else @field(natives, @tagName(set)));
                @field(result, entry.name) = module;
            }
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
