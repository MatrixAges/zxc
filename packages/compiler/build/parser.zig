const std = @import("std");

pub const Sources = struct {
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
    const core_dependency = b.dependency("core", .{ .target = target, .optimize = optimize });
    const core = core_dependency.module("core");
    const lint_dependency = b.dependency("lint", .{ .target = target, .optimize = optimize, .seed = true });
    const lint = lint_dependency.module("lint");

    const lexer = b.createModule(.{
        .root_source_file = b.path("bootstrap/lexer/lex.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "zx", .module = core }},
    });

    const seed = @import("compiler.zig").create(b, target, optimize, lexer, null, lint);
    const flow = @import("seed_rx.zig").create(b, target, optimize, seed.frontend, lint);

    const executable = b.addExecutable(.{ .name = "generate-parser", .root_module = b.createModule(.{
        .root_source_file = b.path("build/generate_parser.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{ .{ .name = "compiler", .module = seed.compiler }, .{ .name = "rx", .module = flow.syntax }, .{ .name = "rx_analysis", .module = flow.analysis } },
    }) });

    executable.root_module.addAnonymousImport("semantic_floats", .{ .root_source_file = b.path("src/zx/analysis/semantic/native/floats.d.zx") });
    executable.root_module.addAnonymousImport("semantic_integers", .{ .root_source_file = b.path("src/zx/analysis/semantic/native/integers.d.zx") });

    const run = b.addRunArtifact(executable);
    const root = b.path("src");

    run.addDirectoryArg2(root, .{});
    trackSources(b, run, root, b.root.joinString(b.allocator, "src") catch @panic("out of memory")) catch @panic("unable to track RX and ZX parser sources");

    const program = run.addOutputFileArg("parser.zig");
    const expression = run.addOutputFileArg("expression.zig");
    const xml = run.addOutputFileArg("xml.zig");
    const paths = run.addOutputFileArg("paths.zig");
    const graph = run.addOutputFileArg("graph.zig");
    const attribute_role = run.addOutputFileArg("attribute_role.zig");
    const attribute_content = run.addOutputFileArg("attribute_content.zig");
    const call_rule = run.addOutputFileArg("call_rule.zig");
    const path_kind = run.addOutputFileArg("path_kind.zig");
    const file_kind = run.addOutputFileArg("file_kind.zig");
    const specifier = run.addOutputFileArg("specifier.zig");
    const integer = run.addOutputFileArg("integer.zig");
    const type_lookup = run.addOutputFileArg("type_lookup.zig");
    const semantic_abi = run.addOutputFileArg("semantic_abi.zig");
    const nominal_lookup = run.addOutputFileArg("nominal_lookup.zig");
    const nominal_abi = run.addOutputFileArg("nominal_abi.zig");
    const origin_validation = run.addOutputFileArg("origin_validation.zig");
    const origins_abi = run.addOutputFileArg("origins_abi.zig");
    const origin_production = run.addOutputFileArg("origin_production.zig");
    const production_abi = run.addOutputFileArg("production_abi.zig");
    const merge_preflight = run.addOutputFileArg("merge_preflight.zig");
    const preflight_abi = run.addOutputFileArg("preflight_abi.zig");
    const type_merge = run.addOutputFileArg("type_merge.zig");
    const merge_abi = run.addOutputFileArg("merge_abi.zig");
    const type_validation = run.addOutputFileArg("type_validation.zig");
    const validation_abi = run.addOutputFileArg("validation_abi.zig");
    const type_resolution = run.addOutputFileArg("type_resolution.zig");
    const resolution_abi = run.addOutputFileArg("resolution_abi.zig");
    const type_construction = run.addOutputFileArg("type_construction.zig");
    const construction_abi = run.addOutputFileArg("construction_abi.zig");
    const type_query = run.addOutputFileArg("type_query.zig");
    const query_abi = run.addOutputFileArg("query_abi.zig");
    const ownership = run.addOutputFileArg("ownership.zig");
    const ownership_abi = run.addOutputFileArg("ownership_abi.zig");
    const ir_body = run.addOutputFileArg("ir_body.zig");
    const ir_body_abi = run.addOutputFileArg("ir_body_abi.zig");
    const ir_stores = run.addOutputFileArg("ir_stores.zig");
    const ir_stores_abi = run.addOutputFileArg("ir_stores_abi.zig");
    const ir_store_call = run.addOutputFileArg("ir_store_call.zig");
    const ir_store_call_abi = run.addOutputFileArg("ir_store_call_abi.zig");
    const ir_tasks = run.addOutputFileArg("ir_tasks.zig");
    const ir_tasks_abi = run.addOutputFileArg("ir_tasks_abi.zig");
    const ir_functions = run.addOutputFileArg("ir_functions.zig");
    const ir_functions_abi = run.addOutputFileArg("ir_functions_abi.zig");
    const ir_task_call = run.addOutputFileArg("ir_task_call.zig");
    const ir_task_call_abi = run.addOutputFileArg("ir_task_call_abi.zig");
    const ir_program_pure = run.addOutputFileArg("ir_program_pure.zig");
    const ir_program_pure_abi = run.addOutputFileArg("ir_program_pure_abi.zig");
    const ir_expressions = run.addOutputFileArg("ir_expressions.zig");
    const ir_expressions_abi = run.addOutputFileArg("ir_expressions_abi.zig");
    const ir_contracts = run.addOutputFileArg("ir_contracts.zig");
    const ir_contracts_abi = run.addOutputFileArg("ir_contracts_abi.zig");
    const ir_contract_tables = run.addOutputFileArg("ir_contract_tables.zig");
    const ir_contract_tables_abi = run.addOutputFileArg("ir_contract_tables_abi.zig");
    const ir_scopes = run.addOutputFileArg("ir_scopes.zig");
    const ir_scopes_abi = run.addOutputFileArg("ir_scopes_abi.zig");
    const refinement_assume = run.addOutputFileArg("refinement_assume.zig");
    const refinement_assume_abi = run.addOutputFileArg("refinement_assume_abi.zig");
    const refinement_bind = run.addOutputFileArg("refinement_bind.zig");
    const refinement_bind_abi = run.addOutputFileArg("refinement_bind_abi.zig");
    const refinement_type = run.addOutputFileArg("refinement_type.zig");
    const refinement_type_abi = run.addOutputFileArg("refinement_type_abi.zig");
    const native_modules = run.addOutputFileArg("native_modules.zig");
    const native_modules_abi = run.addOutputFileArg("native_modules_abi.zig");
    const native_export = run.addOutputFileArg("native_export.zig");
    const native_export_abi = run.addOutputFileArg("native_export_abi.zig");
    const native_type = run.addOutputFileArg("native_type.zig");
    const native_type_abi = run.addOutputFileArg("native_type_abi.zig");
    const native_names = run.addOutputFileArg("native_names.zig");
    const native_names_abi = run.addOutputFileArg("native_names_abi.zig");
    const native_interface = run.addOutputFileArg("native_interface.zig");
    const native_interface_abi = run.addOutputFileArg("native_interface_abi.zig");
    const artifact_roots = run.addOutputFileArg("artifact_roots.zig");
    const artifact_roots_abi = run.addOutputFileArg("artifact_roots_abi.zig");
    const artifact_prepare = run.addOutputFileArg("artifact_prepare.zig");
    const artifact_prepare_abi = run.addOutputFileArg("artifact_prepare_abi.zig");
    const artifact_remap = run.addOutputFileArg("artifact_remap.zig");
    const artifact_remap_abi = run.addOutputFileArg("artifact_remap_abi.zig");
    const refinement_mark = run.addOutputFileArg("refinement_mark.zig");
    const refinement_restore = run.addOutputFileArg("refinement_restore.zig");
    const refinement_add = run.addOutputFileArg("refinement_add.zig");
    const analyzer = run.addOutputFileArg("analyzer.zig");
    const analyzer_abi = run.addOutputFileArg("analyzer_abi.zig");
    const source_signature = run.addOutputFileArg("source_signature.zig");
    const source_signature_abi = run.addOutputFileArg("source_signature_abi.zig");
    const expression_analysis = run.addOutputFileArg("expression_analysis.zig");
    const expression_analysis_abi = run.addOutputFileArg("expression_analysis_abi.zig");
    const ir_validation = run.addOutputFileArg("ir_validation.zig");
    const ir_validation_abi = run.addOutputFileArg("ir_validation_abi.zig");
    const compiled_library = run.addOutputFileArg("compiled_library.zig");
    const compiled_library_abi = run.addOutputFileArg("compiled_library_abi.zig");
    const native_restore = run.addOutputFileArg("native_restore.zig");
    const native_restore_abi = run.addOutputFileArg("native_restore_abi.zig");
    const naming = run.addOutputFileArg("naming.zig");
    const naming_root = lint_dependency.path("src/naming");

    run.addDirectoryArg2(naming_root, .{});
    trackSources(b, run, naming_root, lint_dependency.builder.root.joinString(b.allocator, "src/naming") catch @panic("out of memory")) catch @panic("unable to track lint naming sources");

    const core_root = core_dependency.path("src");

    run.addDirectoryArg2(core_root, .{});
    trackSources(b, run, core_root, core_dependency.builder.root.joinString(b.allocator, "src") catch @panic("out of memory")) catch @panic("unable to track core model sources");

    return .{ .native_restore = native_restore, .native_restore_abi = native_restore_abi, .compiled_library = compiled_library, .compiled_library_abi = compiled_library_abi, .ir_validation = ir_validation, .ir_validation_abi = ir_validation_abi, .expression_analysis = expression_analysis, .expression_analysis_abi = expression_analysis_abi, .source_signature = source_signature, .source_signature_abi = source_signature_abi, .analyzer = analyzer, .analyzer_abi = analyzer_abi, .refinement_mark = refinement_mark, .refinement_restore = refinement_restore, .refinement_add = refinement_add, .artifact_remap = artifact_remap, .artifact_remap_abi = artifact_remap_abi, .artifact_prepare = artifact_prepare, .artifact_prepare_abi = artifact_prepare_abi, .artifact_roots = artifact_roots, .artifact_roots_abi = artifact_roots_abi, .native_interface = native_interface, .native_interface_abi = native_interface_abi, .native_names = native_names, .native_names_abi = native_names_abi, .native_type = native_type, .native_type_abi = native_type_abi, .native_modules = native_modules, .native_modules_abi = native_modules_abi, .native_export = native_export, .native_export_abi = native_export_abi, .ir_scopes = ir_scopes, .ir_scopes_abi = ir_scopes_abi, .refinement_assume = refinement_assume, .refinement_assume_abi = refinement_assume_abi, .refinement_bind = refinement_bind, .refinement_bind_abi = refinement_bind_abi, .refinement_type = refinement_type, .refinement_type_abi = refinement_type_abi, .ir_contracts = ir_contracts, .ir_contracts_abi = ir_contracts_abi, .ir_contract_tables = ir_contract_tables, .ir_contract_tables_abi = ir_contract_tables_abi, .ir_expressions = ir_expressions, .ir_expressions_abi = ir_expressions_abi, .ownership = ownership, .ownership_abi = ownership_abi, .ir_functions = ir_functions, .ir_functions_abi = ir_functions_abi, .ir_task_call = ir_task_call, .ir_task_call_abi = ir_task_call_abi, .ir_program_pure = ir_program_pure, .ir_program_pure_abi = ir_program_pure_abi, .ir_tasks = ir_tasks, .ir_tasks_abi = ir_tasks_abi, .ir_body = ir_body, .ir_body_abi = ir_body_abi, .ir_stores = ir_stores, .ir_stores_abi = ir_stores_abi, .ir_store_call = ir_store_call, .ir_store_call_abi = ir_store_call_abi, .naming = naming, .program = program, .expression = expression, .xml = xml, .paths = paths, .graph = graph, .attribute_role = attribute_role, .attribute_content = attribute_content, .call_rule = call_rule, .path_kind = path_kind, .file_kind = file_kind, .specifier = specifier, .integer = integer, .type_lookup = type_lookup, .semantic_abi = semantic_abi, .nominal_lookup = nominal_lookup, .nominal_abi = nominal_abi, .origin_validation = origin_validation, .origins_abi = origins_abi, .origin_production = origin_production, .production_abi = production_abi, .merge_preflight = merge_preflight, .preflight_abi = preflight_abi, .type_merge = type_merge, .merge_abi = merge_abi, .type_validation = type_validation, .validation_abi = validation_abi, .type_resolution = type_resolution, .resolution_abi = resolution_abi, .type_construction = type_construction, .construction_abi = construction_abi, .type_query = type_query, .query_abi = query_abi };
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

pub fn modules(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, source: Sources) @import("compiler.zig").ParserModules {
    const integers = b.createModule(.{ .root_source_file = b.path("src/zx/analysis/semantic/native/integers.zig"), .target = target, .optimize = optimize });
    const floats = b.createModule(.{ .root_source_file = b.path("src/zx/analysis/semantic/native/floats.zig"), .target = target, .optimize = optimize });
    const lookup = b.createModule(.{ .root_source_file = source.type_lookup, .target = target, .optimize = optimize });

    lookup.addImport("integers", integers);
    lookup.addImport("zxc_abi", b.createModule(.{ .root_source_file = source.semantic_abi, .target = target, .optimize = optimize }));

    const nominal = b.createModule(.{ .root_source_file = source.nominal_lookup, .target = target, .optimize = optimize });

    nominal.addImport("integers", integers);
    nominal.addImport("zxc_abi", b.createModule(.{ .root_source_file = source.nominal_abi, .target = target, .optimize = optimize }));

    const origins = b.createModule(.{ .root_source_file = source.origin_validation, .target = target, .optimize = optimize });

    origins.addImport("integers", integers);
    origins.addImport("zxc_abi", b.createModule(.{ .root_source_file = source.origins_abi, .target = target, .optimize = optimize }));

    const nominal_data = @import("compiler.zig").nominalData(b, target, optimize);
    const production_abi = b.createModule(.{ .root_source_file = source.production_abi, .target = target, .optimize = optimize });
    const production = b.createModule(.{ .root_source_file = source.origin_production, .target = target, .optimize = optimize });

    production.addImport("integers", integers);
    production.addImport("zxc_abi", production_abi);

    const preflight_abi = b.createModule(.{ .root_source_file = source.preflight_abi, .target = target, .optimize = optimize });
    const preflight = b.createModule(.{ .root_source_file = source.merge_preflight, .target = target, .optimize = optimize });

    preflight.addImport("integers", integers);
    preflight.addImport("zxc_abi", preflight_abi);

    const artifact_roots_abi = b.createModule(.{ .root_source_file = source.artifact_roots_abi, .target = target, .optimize = optimize });
    const artifact_roots = b.createModule(.{ .root_source_file = source.artifact_roots, .target = target, .optimize = optimize });

    artifact_roots.addImport("integers", integers);
    artifact_roots.addImport("zxc_abi", artifact_roots_abi);

    const artifact_prepare_abi = b.createModule(.{ .root_source_file = source.artifact_prepare_abi, .target = target, .optimize = optimize });
    const artifact_prepare = b.createModule(.{ .root_source_file = source.artifact_prepare, .target = target, .optimize = optimize });

    artifact_prepare.addImport("integers", integers);
    artifact_prepare.addImport("zxc_abi", artifact_prepare_abi);

    const artifact_remap_abi = b.createModule(.{ .root_source_file = source.artifact_remap_abi, .target = target, .optimize = optimize });
    const artifact_remap = b.createModule(.{ .root_source_file = source.artifact_remap, .target = target, .optimize = optimize });

    artifact_remap.addImport("integers", integers);
    artifact_remap.addImport("zxc_abi", artifact_remap_abi);

    const merge_abi = b.createModule(.{ .root_source_file = source.merge_abi, .target = target, .optimize = optimize });
    const merge = b.createModule(.{ .root_source_file = source.type_merge, .target = target, .optimize = optimize });

    merge.addImport("integers", integers);
    merge.addImport("zxc_abi", merge_abi);

    const validation_abi = b.createModule(.{ .root_source_file = source.validation_abi, .target = target, .optimize = optimize });
    const type_validation = b.createModule(.{ .root_source_file = source.type_validation, .target = target, .optimize = optimize });

    type_validation.addImport("integers", integers);
    type_validation.addImport("zxc_abi", validation_abi);

    const program = b.createModule(.{ .root_source_file = source.program, .target = target, .optimize = optimize });
    const expression = b.createModule(.{ .root_source_file = source.expression, .target = target, .optimize = optimize });
    const type_views = @import("compiler.zig").typeViews(b, target, optimize);
    const resolution_abi = b.createModule(.{ .root_source_file = source.resolution_abi, .target = target, .optimize = optimize });

    const resolution_standard = b.createModule(.{
        .root_source_file = b.path("standard/src/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "zxc_abi", .module = resolution_abi }},
    });

    const type_resolution = b.createModule(.{
        .root_source_file = source.type_resolution,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_standard", .module = resolution_standard },
            .{ .name = "zxc_abi", .module = resolution_abi },
            .{ .name = "integers", .module = integers },
        },
    });

    const construction_abi = b.createModule(.{ .root_source_file = source.construction_abi, .target = target, .optimize = optimize });

    const type_construction = b.createModule(.{
        .root_source_file = source.type_construction,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_abi", .module = construction_abi },
            .{ .name = "integers", .module = integers },
        },
    });

    const type_query = b.createModule(.{
        .root_source_file = source.type_query,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = source.query_abi, .target = target, .optimize = optimize }) },
            .{ .name = "integers", .module = integers },
        },
    });

    const analyzer_abi = b.createModule(.{ .root_source_file = source.analyzer_abi, .target = target, .optimize = optimize });

    const analyzer = b.createModule(.{
        .root_source_file = source.analyzer,
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
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = source.source_signature_abi, .target = target, .optimize = optimize }) },
            .{ .name = "zxc_standard", .module = resolution_standard },
            .{ .name = "integers", .module = integers },
        },
    });

    const expression_analysis = b.createModule(.{
        .root_source_file = source.expression_analysis,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = source.expression_analysis_abi, .target = target, .optimize = optimize }) },
            .{ .name = "zxc_standard", .module = resolution_standard },
            .{ .name = "integers", .module = integers },
            .{ .name = "floats", .module = floats },
        },
    });

    const ir_validation = b.createModule(.{
        .root_source_file = source.ir_validation,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = source.ir_validation_abi, .target = target, .optimize = optimize }) },
            .{ .name = "integers", .module = integers },
            .{ .name = "floats", .module = floats },
        },
    });

    const compiled_library = b.createModule(.{
        .root_source_file = source.compiled_library,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = source.compiled_library_abi, .target = target, .optimize = optimize }) },
            .{ .name = "zxc_standard", .module = resolution_standard },
            .{ .name = "integers", .module = integers },
            .{ .name = "floats", .module = floats },
        },
    });

    const native_restore = b.createModule(.{
        .root_source_file = source.native_restore,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = source.native_restore_abi, .target = target, .optimize = optimize }) },
            .{ .name = "zxc_standard", .module = resolution_standard },
            .{ .name = "integers", .module = integers },
            .{ .name = "floats", .module = floats },
        },
    });

    const ownership = b.createModule(.{
        .root_source_file = source.ownership,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = source.ownership_abi, .target = target, .optimize = optimize }) },
            .{ .name = "integers", .module = integers },
        },
    });

    const native_interface = b.createModule(.{
        .root_source_file = source.native_interface,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "integers", .module = integers },
            .{ .name = "zxc_standard", .module = resolution_standard },
            .{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = source.native_interface_abi, .target = target, .optimize = optimize }) },
        },
    });

    const native_names_abi = b.createModule(.{ .root_source_file = source.native_names_abi, .target = target, .optimize = optimize });

    const native_names = b.createModule(.{
        .root_source_file = source.native_names,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_standard", .module = resolution_standard },
            .{ .name = "zxc_abi", .module = native_names_abi },
        },
    });

    const native_type = b.createModule(.{
        .root_source_file = source.native_type,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "integers", .module = integers },
            .{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = source.native_type_abi, .target = target, .optimize = optimize }) },
        },
    });

    const native_modules = b.createModule(.{
        .root_source_file = source.native_modules,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = source.native_modules_abi, .target = target, .optimize = optimize }) },
            .{ .name = "integers", .module = integers },
        },
    });

    const native_export = b.createModule(.{
        .root_source_file = source.native_export,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = source.native_export_abi, .target = target, .optimize = optimize }) },
            .{ .name = "integers", .module = integers },
        },
    });

    const ir_scopes = b.createModule(.{
        .root_source_file = source.ir_scopes,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = source.ir_scopes_abi, .target = target, .optimize = optimize }) },
            .{ .name = "integers", .module = integers },
        },
    });

    const refinement_mark = b.createModule(.{
        .root_source_file = source.refinement_mark,
        .target = target,
        .optimize = optimize,
    });

    const refinement_restore = b.createModule(.{
        .root_source_file = source.refinement_restore,
        .target = target,
        .optimize = optimize,
    });

    const refinement_add = b.createModule(.{
        .root_source_file = source.refinement_add,
        .target = target,
        .optimize = optimize,
    });

    const refinement_assume = b.createModule(.{
        .root_source_file = source.refinement_assume,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = source.refinement_assume_abi, .target = target, .optimize = optimize }) },
            .{ .name = "integers", .module = integers },
        },
    });

    const refinement_bind = b.createModule(.{
        .root_source_file = source.refinement_bind,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = source.refinement_bind_abi, .target = target, .optimize = optimize }) },
            .{ .name = "integers", .module = integers },
        },
    });

    const refinement_type = b.createModule(.{
        .root_source_file = source.refinement_type,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = source.refinement_type_abi, .target = target, .optimize = optimize }) },
            .{ .name = "integers", .module = integers },
        },
    });

    const ir_contracts = b.createModule(.{
        .root_source_file = source.ir_contracts,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = source.ir_contracts_abi, .target = target, .optimize = optimize }) },
            .{ .name = "integers", .module = integers },
            .{ .name = "floats", .module = floats },
        },
    });

    const ir_contract_tables = b.createModule(.{
        .root_source_file = source.ir_contract_tables,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = source.ir_contract_tables_abi, .target = target, .optimize = optimize }) },
            .{ .name = "integers", .module = integers },
        },
    });

    const ir_expressions = b.createModule(.{
        .root_source_file = source.ir_expressions,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = source.ir_expressions_abi, .target = target, .optimize = optimize }) },
            .{ .name = "integers", .module = integers },
            .{ .name = "floats", .module = floats },
        },
    });

    const ir_functions = b.createModule(.{
        .root_source_file = source.ir_functions,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = source.ir_functions_abi, .target = target, .optimize = optimize }) },
            .{ .name = "integers", .module = integers },
        },
    });

    const ir_task_call = b.createModule(.{
        .root_source_file = source.ir_task_call,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = source.ir_task_call_abi, .target = target, .optimize = optimize }) },
            .{ .name = "integers", .module = integers },
        },
    });

    const ir_program_pure = b.createModule(.{
        .root_source_file = source.ir_program_pure,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = source.ir_program_pure_abi, .target = target, .optimize = optimize }) },
            .{ .name = "integers", .module = integers },
        },
    });

    const ir_tasks = b.createModule(.{
        .root_source_file = source.ir_tasks,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = source.ir_tasks_abi, .target = target, .optimize = optimize }) },
            .{ .name = "integers", .module = integers },
        },
    });

    const ir_body = b.createModule(.{
        .root_source_file = source.ir_body,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = source.ir_body_abi, .target = target, .optimize = optimize }) },
            .{ .name = "integers", .module = integers },
        },
    });

    const ir_stores = b.createModule(.{
        .root_source_file = source.ir_stores,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = source.ir_stores_abi, .target = target, .optimize = optimize }) },
            .{ .name = "integers", .module = integers },
        },
    });

    const ir_store_call = b.createModule(.{
        .root_source_file = source.ir_store_call,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_abi", .module = b.createModule(.{ .root_source_file = source.ir_store_call_abi, .target = target, .optimize = optimize }) },
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
        .native_names = native_names,
        .native_type = native_type,
        .native_modules = native_modules,
        .native_export = native_export,
        .ir_scopes = ir_scopes,
        .refinement_mark = refinement_mark,
        .refinement_restore = refinement_restore,
        .refinement_add = refinement_add,
        .refinement_assume = refinement_assume,
        .refinement_bind = refinement_bind,
        .refinement_type = refinement_type,
        .ownership = ownership,
        .ir_body = ir_body,
        .ir_tasks = ir_tasks,
        .ir_contracts = ir_contracts,
        .ir_contract_tables = ir_contract_tables,
        .ir_expressions = ir_expressions,
        .ir_functions = ir_functions,
        .ir_task_call = ir_task_call,
        .ir_program_pure = ir_program_pure,
        .ir_stores = ir_stores,
        .ir_store_call = ir_store_call,
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
        .nominal_lookup = nominal,
        .origin_validation = origins,
        .origin_production = production,
        .nominal_data = nominal_data,
        .type_lookup = lookup,
        .program = program,
        .expression = expression,
        .xml = b.createModule(.{ .root_source_file = source.xml, .target = target, .optimize = optimize }),
        .specifier = b.createModule(.{ .root_source_file = source.specifier, .target = target, .optimize = optimize }),
        .integer = b.createModule(.{ .root_source_file = source.integer, .target = target, .optimize = optimize }),
    };
}
