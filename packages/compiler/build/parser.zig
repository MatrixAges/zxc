const std = @import("std");
const entries = @import("entries.zig");

pub const Sources = struct {
    standard_abi: std.Build.LazyPath,
    native_restore: std.Build.LazyPath,
    native_restore_abi: std.Build.LazyPath,
    compiled_library: std.Build.LazyPath,
    compiled_library_abi: std.Build.LazyPath,
    ir_validation: std.Build.LazyPath,
    ir_validation_abi: std.Build.LazyPath,
    expression_analysis: std.Build.LazyPath,
    expression_analysis_abi: std.Build.LazyPath,
    source_signature: std.Build.LazyPath,
    source_signature_abi: std.Build.LazyPath,
    analyzer: std.Build.LazyPath,
    analyzer_abi: std.Build.LazyPath,
    refinement_mark: std.Build.LazyPath,
    refinement_restore: std.Build.LazyPath,
    refinement_add: std.Build.LazyPath,
    artifact_remap: std.Build.LazyPath,
    artifact_remap_abi: std.Build.LazyPath,
    artifact_prepare: std.Build.LazyPath,
    artifact_prepare_abi: std.Build.LazyPath,
    artifact_roots: std.Build.LazyPath,
    artifact_roots_abi: std.Build.LazyPath,
    native_interface: std.Build.LazyPath,
    native_interface_abi: std.Build.LazyPath,
    native_names: std.Build.LazyPath,
    native_names_abi: std.Build.LazyPath,
    native_type: std.Build.LazyPath,
    native_type_abi: std.Build.LazyPath,
    native_modules: std.Build.LazyPath,
    native_modules_abi: std.Build.LazyPath,
    native_export: std.Build.LazyPath,
    native_export_abi: std.Build.LazyPath,
    ir_scopes: std.Build.LazyPath,
    ir_scopes_abi: std.Build.LazyPath,
    refinement_assume: std.Build.LazyPath,
    refinement_assume_abi: std.Build.LazyPath,
    refinement_bind: std.Build.LazyPath,
    refinement_bind_abi: std.Build.LazyPath,
    refinement_type: std.Build.LazyPath,
    refinement_type_abi: std.Build.LazyPath,
    ownership: std.Build.LazyPath,
    ownership_abi: std.Build.LazyPath,
    ir_contracts: std.Build.LazyPath,
    ir_contracts_abi: std.Build.LazyPath,
    ir_contract_tables: std.Build.LazyPath,
    ir_contract_tables_abi: std.Build.LazyPath,
    ir_expressions: std.Build.LazyPath,
    ir_expressions_abi: std.Build.LazyPath,
    ir_functions: std.Build.LazyPath,
    ir_functions_abi: std.Build.LazyPath,
    ir_task_call: std.Build.LazyPath,
    ir_task_call_abi: std.Build.LazyPath,
    ir_program_pure: std.Build.LazyPath,
    ir_program_pure_abi: std.Build.LazyPath,
    ir_tasks: std.Build.LazyPath,
    ir_tasks_abi: std.Build.LazyPath,
    ir_body: std.Build.LazyPath,
    ir_body_abi: std.Build.LazyPath,
    ir_stores: std.Build.LazyPath,
    ir_stores_abi: std.Build.LazyPath,
    ir_store_call: std.Build.LazyPath,
    ir_store_call_abi: std.Build.LazyPath,
    naming: std.Build.LazyPath,
    program: std.Build.LazyPath,
    expression: std.Build.LazyPath,
    xml: std.Build.LazyPath,
    paths: std.Build.LazyPath,
    graph: std.Build.LazyPath,
    attribute_role: std.Build.LazyPath,
    attribute_content: std.Build.LazyPath,
    call_rule: std.Build.LazyPath,
    path_kind: std.Build.LazyPath,
    file_kind: std.Build.LazyPath,
    specifier: std.Build.LazyPath,
    integer: std.Build.LazyPath,
    type_lookup: std.Build.LazyPath,
    semantic_abi: std.Build.LazyPath,
    nominal_lookup: std.Build.LazyPath,
    nominal_abi: std.Build.LazyPath,
    origin_validation: std.Build.LazyPath,
    origins_abi: std.Build.LazyPath,
    origin_production: std.Build.LazyPath,
    production_abi: std.Build.LazyPath,
    merge_preflight: std.Build.LazyPath,
    preflight_abi: std.Build.LazyPath,
    type_merge: std.Build.LazyPath,
    merge_abi: std.Build.LazyPath,
    type_validation: std.Build.LazyPath,
    type_resolution: std.Build.LazyPath,
    resolution_abi: std.Build.LazyPath,
    type_construction: std.Build.LazyPath,
    construction_abi: std.Build.LazyPath,
    type_query: std.Build.LazyPath,
    query_abi: std.Build.LazyPath,
    validation_abi: std.Build.LazyPath,
};

pub fn generate(b: *std.Build, optimize: std.builtin.OptimizeMode) Sources {
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
    const generator_root: std.builtin.OptimizeMode = if (optimize == .debug) .small else optimize;

    const executable = b.addExecutable(.{ .name = "generate-parser", .root_module = b.createModule(.{
        .root_source_file = b.path("build/generate_parser.zig"),
        .target = target,
        .optimize = generator_root,
        .imports = &.{ .{ .name = "compiler", .module = seed.compiler }, .{ .name = "rx", .module = flow.syntax }, .{ .name = "rx_analysis", .module = flow.analysis } },
    }) });

    executable.root_module.addAnonymousImport("semantic_floats", .{ .root_source_file = b.path("src/zx/analysis/semantic/native/floats.d.zx") });
    executable.root_module.addAnonymousImport("semantic_integers", .{ .root_source_file = b.path("src/zx/analysis/semantic/native/integers.d.zx") });

    const standard = b.addRunArtifact(executable);

    standard.addArg("--standard-abi");

    const standard_abi = standard.addOutputFileArg("standard_abi.zig");
    const roots = [_]std.Build.LazyPath{ b.path("src"), lint_dependency.path("src/naming"), core_dependency.path("src") };

    const directories = [_][]const u8{
        b.root.joinString(b.allocator, "src") catch @panic("out of memory"),
        lint_dependency.builder.root.joinString(b.allocator, "src/naming") catch @panic("out of memory"),
        core_dependency.builder.root.joinString(b.allocator, "src") catch @panic("out of memory"),
    };

    var sources: Sources = undefined;

    sources.standard_abi = standard_abi;

    // Each entry set runs as its own step, so builds that never import the checks do not generate them.
    inline for (.{ entries.Set.main, entries.Set.checks }) |set| {
        const run = b.addRunArtifact(executable);

        run.addArg(@tagName(set));

        for (roots, directories) |root, directory| {
            run.addDirectoryArg2(root, .{});
            trackSources(b, run, root, directory) catch @panic("unable to track RX and ZX bootstrap sources");
        }

        inline for (comptime entries.of(set)) |entry| {
            @field(sources, entry.name) = run.addOutputFileArg(entry.name ++ ".zig");

            if (entry.abi) |abi| @field(sources, abi) = run.addOutputFileArg(abi ++ ".zig");
        }
    }

    return sources;
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
pub const Shared = struct { integers: *std.Build.Module, floats: *std.Build.Module, standard: *std.Build.Module };

pub fn shared(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, source: Sources, strip: ?bool) Shared {
    return .{
        .integers = b.createModule(.{ .root_source_file = b.path("src/zx/analysis/semantic/native/integers.zig"), .target = target, .optimize = optimize }),
        .floats = b.createModule(.{ .root_source_file = b.path("src/zx/analysis/semantic/native/floats.zig"), .target = target, .optimize = optimize }),
        .standard = b.createModule(.{
            .root_source_file = b.path("standard/src/root.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = source.resolution_abi, .target = target, .optimize = optimize, .strip = strip }) }},
        }),
    };
}

pub fn modules(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, source: Sources, natives: Shared, strip: ?bool) @import("compiler.zig").ParserModules {
    const integers = natives.integers;
    const floats = natives.floats;
    const origins = b.createModule(.{ .root_source_file = source.origin_validation, .target = target, .optimize = optimize, .strip = strip });

    origins.addImport("integers", integers);
    origins.addImport("zxc_abi", b.createModule(.{ .root_source_file = source.origins_abi, .target = target, .optimize = optimize, .strip = strip }));

    const nominal_data = @import("compiler.zig").nominalData(b, target, optimize);
    const production_abi = b.createModule(.{ .root_source_file = source.production_abi, .target = target, .optimize = optimize, .strip = strip });
    const production = b.createModule(.{ .root_source_file = source.origin_production, .target = target, .optimize = optimize, .strip = strip });

    production.addImport("integers", integers);
    production.addImport("zxc_abi", production_abi);

    const preflight_abi = b.createModule(.{ .root_source_file = source.preflight_abi, .target = target, .optimize = optimize, .strip = strip });
    const preflight = b.createModule(.{ .root_source_file = source.merge_preflight, .target = target, .optimize = optimize, .strip = strip });

    preflight.addImport("integers", integers);
    preflight.addImport("zxc_abi", preflight_abi);

    const artifact_roots_abi = b.createModule(.{ .root_source_file = source.artifact_roots_abi, .target = target, .optimize = optimize, .strip = strip });
    const artifact_roots = b.createModule(.{ .root_source_file = source.artifact_roots, .target = target, .optimize = optimize, .strip = strip });

    artifact_roots.addImport("integers", integers);
    artifact_roots.addImport("zxc_abi", artifact_roots_abi);

    const artifact_prepare_abi = b.createModule(.{ .root_source_file = source.artifact_prepare_abi, .target = target, .optimize = optimize, .strip = strip });
    const artifact_prepare = b.createModule(.{ .root_source_file = source.artifact_prepare, .target = target, .optimize = optimize, .strip = strip });

    artifact_prepare.addImport("integers", integers);
    artifact_prepare.addImport("zxc_abi", artifact_prepare_abi);

    const artifact_remap_abi = b.createModule(.{ .root_source_file = source.artifact_remap_abi, .target = target, .optimize = optimize, .strip = strip });
    const artifact_remap = b.createModule(.{ .root_source_file = source.artifact_remap, .target = target, .optimize = optimize, .strip = strip });

    artifact_remap.addImport("integers", integers);
    artifact_remap.addImport("zxc_abi", artifact_remap_abi);

    const merge_abi = b.createModule(.{ .root_source_file = source.merge_abi, .target = target, .optimize = optimize, .strip = strip });
    const merge = b.createModule(.{ .root_source_file = source.type_merge, .target = target, .optimize = optimize, .strip = strip });

    merge.addImport("integers", integers);
    merge.addImport("zxc_abi", merge_abi);

    const validation_abi = b.createModule(.{ .root_source_file = source.validation_abi, .target = target, .optimize = optimize, .strip = strip });
    const type_validation = b.createModule(.{ .root_source_file = source.type_validation, .target = target, .optimize = optimize, .strip = strip });

    type_validation.addImport("integers", integers);
    type_validation.addImport("zxc_abi", validation_abi);

    const program = b.createModule(.{ .root_source_file = source.program, .target = target, .optimize = optimize, .strip = strip });
    const expression = b.createModule(.{ .root_source_file = source.expression, .target = target, .optimize = optimize, .strip = strip });
    const type_views = @import("compiler.zig").typeViews(b, target, optimize);
    const resolution_standard = natives.standard;
    const resolution_abi = resolution_standard.import_table.get("zxc_abi").?;

    const type_resolution = b.createModule(.{
        .root_source_file = source.type_resolution,
        .strip = strip,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_standard", .module = resolution_standard },
            .{ .name = "zxc_abi", .module = resolution_abi },
            .{ .name = "integers", .module = integers },
        },
    });

    const construction_abi = b.createModule(.{ .root_source_file = source.construction_abi, .target = target, .optimize = optimize, .strip = strip });

    const type_construction = b.createModule(.{
        .root_source_file = source.type_construction,
        .strip = strip,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_abi", .module = construction_abi },
            .{ .name = "integers", .module = integers },
        },
    });

    const type_query = b.createModule(.{
        .root_source_file = source.type_query,
        .strip = strip,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = source.query_abi, .target = target, .optimize = optimize, .strip = strip }) },
            .{ .name = "integers", .module = integers },
        },
    });

    const analyzer_abi = b.createModule(.{ .root_source_file = source.analyzer_abi, .target = target, .optimize = optimize, .strip = strip });

    const analyzer = b.createModule(.{
        .root_source_file = source.analyzer,
        .strip = strip,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_abi", .module = analyzer_abi },
            .{ .name = "zxc_standard", .module = resolution_standard },
            .{ .name = "integers", .module = integers },
            .{ .name = "floats", .module = floats },
        },
    });

    const source_signature = b.createModule(.{
        .root_source_file = source.source_signature,
        .strip = strip,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = source.source_signature_abi, .target = target, .optimize = optimize, .strip = strip }) },
            .{ .name = "zxc_standard", .module = resolution_standard },
            .{ .name = "integers", .module = integers },
        },
    });

    const expression_analysis = b.createModule(.{
        .root_source_file = source.expression_analysis,
        .strip = strip,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = source.expression_analysis_abi, .target = target, .optimize = optimize, .strip = strip }) },
            .{ .name = "zxc_standard", .module = resolution_standard },
            .{ .name = "integers", .module = integers },
            .{ .name = "floats", .module = floats },
        },
    });

    const ir_validation = b.createModule(.{
        .root_source_file = source.ir_validation,
        .strip = strip,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = source.ir_validation_abi, .target = target, .optimize = optimize, .strip = strip }) },
            .{ .name = "integers", .module = integers },
            .{ .name = "floats", .module = floats },
        },
    });

    const compiled_library = b.createModule(.{
        .root_source_file = source.compiled_library,
        .strip = strip,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = source.compiled_library_abi, .target = target, .optimize = optimize, .strip = strip }) },
            .{ .name = "zxc_standard", .module = resolution_standard },
            .{ .name = "integers", .module = integers },
            .{ .name = "floats", .module = floats },
        },
    });

    const native_restore = b.createModule(.{
        .root_source_file = source.native_restore,
        .strip = strip,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = source.native_restore_abi, .target = target, .optimize = optimize, .strip = strip }) },
            .{ .name = "zxc_standard", .module = resolution_standard },
            .{ .name = "integers", .module = integers },
            .{ .name = "floats", .module = floats },
        },
    });

    const ownership = b.createModule(.{
        .root_source_file = source.ownership,
        .strip = strip,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = source.ownership_abi, .target = target, .optimize = optimize, .strip = strip }) },
            .{ .name = "integers", .module = integers },
        },
    });

    const native_interface = b.createModule(.{
        .root_source_file = source.native_interface,
        .strip = strip,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "integers", .module = integers },
            .{ .name = "zxc_standard", .module = resolution_standard },
            .{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = source.native_interface_abi, .target = target, .optimize = optimize, .strip = strip }) },
        },
    });

    const native_modules = b.createModule(.{
        .root_source_file = source.native_modules,
        .strip = strip,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = source.native_modules_abi, .target = target, .optimize = optimize, .strip = strip }) },
            .{ .name = "integers", .module = integers },
        },
    });

    const refinement_mark = b.createModule(.{
        .root_source_file = source.refinement_mark,
        .strip = strip,
        .target = target,
        .optimize = optimize,
    });

    const refinement_restore = b.createModule(.{
        .root_source_file = source.refinement_restore,
        .strip = strip,
        .target = target,
        .optimize = optimize,
    });

    const refinement_add = b.createModule(.{
        .root_source_file = source.refinement_add,
        .strip = strip,
        .target = target,
        .optimize = optimize,
    });

    const refinement_assume = b.createModule(.{
        .root_source_file = source.refinement_assume,
        .strip = strip,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = source.refinement_assume_abi, .target = target, .optimize = optimize, .strip = strip }) },
            .{ .name = "integers", .module = integers },
        },
    });

    const refinement_bind = b.createModule(.{
        .root_source_file = source.refinement_bind,
        .strip = strip,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = source.refinement_bind_abi, .target = target, .optimize = optimize, .strip = strip }) },
            .{ .name = "integers", .module = integers },
        },
    });

    const refinement_type = b.createModule(.{
        .root_source_file = source.refinement_type,
        .strip = strip,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = source.refinement_type_abi, .target = target, .optimize = optimize, .strip = strip }) },
            .{ .name = "integers", .module = integers },
        },
    });

    const ir_task_call = b.createModule(.{
        .root_source_file = source.ir_task_call,
        .strip = strip,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = source.ir_task_call_abi, .target = target, .optimize = optimize, .strip = strip }) },
            .{ .name = "integers", .module = integers },
        },
    });

    const ir_program_pure = b.createModule(.{
        .root_source_file = source.ir_program_pure,
        .strip = strip,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = source.ir_program_pure_abi, .target = target, .optimize = optimize, .strip = strip }) },
            .{ .name = "integers", .module = integers },
        },
    });

    return .{
        .native_restore = native_restore,
        .compiled_library = compiled_library,
        .ir_validation = ir_validation,
        .expression_analysis = expression_analysis,
        .source_signature = source_signature,
        .analyzer = analyzer,
        .native_interface = native_interface,
        .native_modules = native_modules,
        .refinement_mark = refinement_mark,
        .refinement_restore = refinement_restore,
        .refinement_add = refinement_add,
        .refinement_assume = refinement_assume,
        .refinement_bind = refinement_bind,
        .refinement_type = refinement_type,
        .ownership = ownership,
        .ir_task_call = ir_task_call,
        .ir_program_pure = ir_program_pure,
        .type_construction = type_construction,
        .type_query = type_query,
        .type_resolution = type_resolution,
        .type_views = type_views,
        .type_validation = type_validation,
        .type_merge = merge,
        .artifact_remap = artifact_remap,
        .artifact_prepare = artifact_prepare,
        .artifact_roots = artifact_roots,
        .merge_preflight = preflight,
        .origin_validation = origins,
        .origin_production = production,
        .nominal_data = nominal_data,
        .program = program,
        .expression = expression,
        .xml = b.createModule(.{ .root_source_file = source.xml, .target = target, .optimize = optimize, .strip = strip }),
        .specifier = b.createModule(.{ .root_source_file = source.specifier, .target = target, .optimize = optimize, .strip = strip }),
        .integer = b.createModule(.{ .root_source_file = source.integer, .target = target, .optimize = optimize, .strip = strip }),
    };
}

/// Individual checkers only test builds import; they hang off one module's import table so tests can merge them.
pub fn checks(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, source: Sources, natives: Shared, strip: ?bool) *std.Build.Module {
    const module = b.createModule(.{ .root_source_file = b.addWriteFiles().add("checks.zig", ""), .target = target, .optimize = optimize });

    inline for (entries.checks) |entry| {
        module.addImport("generated_" ++ entry.name, b.createModule(.{
            .root_source_file = @field(source, entry.name),
            .strip = strip,
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = @field(source, entry.abi.?), .target = target, .optimize = optimize, .strip = strip }) },
                .{ .name = "zxc_standard", .module = natives.standard },
                .{ .name = "integers", .module = natives.integers },
                .{ .name = "floats", .module = natives.floats },
            },
        }));
    }

    return module;
}
