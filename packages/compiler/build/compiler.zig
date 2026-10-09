const std = @import("std");
pub const ParserModules = struct { source_signature: *std.Build.Module, analyzer: *std.Build.Module, refinement_mark: *std.Build.Module, refinement_restore: *std.Build.Module, refinement_add: *std.Build.Module, artifact_remap: *std.Build.Module, artifact_prepare: *std.Build.Module, artifact_roots: *std.Build.Module, native_interface: *std.Build.Module, native_names: *std.Build.Module, native_type: *std.Build.Module, native_modules: *std.Build.Module, native_export: *std.Build.Module, ir_scopes: *std.Build.Module, refinement_assume: *std.Build.Module, refinement_bind: *std.Build.Module, refinement_type: *std.Build.Module, ownership: *std.Build.Module, ir_body: *std.Build.Module, ir_tasks: *std.Build.Module, ir_functions: *std.Build.Module, ir_expressions: *std.Build.Module, ir_contracts: *std.Build.Module, ir_contract_tables: *std.Build.Module, ir_task_call: *std.Build.Module, ir_program_pure: *std.Build.Module, ir_stores: *std.Build.Module, ir_store_call: *std.Build.Module, type_construction: *std.Build.Module, type_query: *std.Build.Module, type_resolution: *std.Build.Module, type_views: *std.Build.Module, type_validation: *std.Build.Module, type_merge: *std.Build.Module, program: *std.Build.Module, expression: *std.Build.Module, xml: *std.Build.Module, specifier: *std.Build.Module, integer: *std.Build.Module, type_lookup: *std.Build.Module, nominal_lookup: *std.Build.Module, origin_validation: *std.Build.Module, origin_production: *std.Build.Module, nominal_data: *std.Build.Module, merge_preflight: *std.Build.Module };
pub const Modules = struct { frontend: *std.Build.Module, compiler: *std.Build.Module };

pub fn create(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, lexer: *std.Build.Module, parser: ?ParserModules, lint: *std.Build.Module) Modules {
    const options = b.addOptions();

    options.addOption(bool, "generated_parser", parser != null);

    const frontend = b.createModule(.{
        .root_source_file = b.path("src/zx/frontend.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "lexer", .module = lexer },
            .{ .name = "zx", .module = b.dependency("core", .{ .target = target, .optimize = optimize }).module("core") },
            .{ .name = "dsl", .module = b.dependency("dsl", .{ .target = target, .optimize = optimize }).module("dsl") },
            .{ .name = "lint", .module = lint },
            .{ .name = "standard_interfaces", .module = @import("standard.zig").create(b) },
        },
    });

    frontend.addOptions("parser_options", options);
    frontend.addImport("type_views", if (parser) |generated| generated.type_views else typeViews(b, target, optimize));
    frontend.addImport("nominal_data", if (parser) |generated| generated.nominal_data else nominalData(b, target, optimize));

    frontend.addImport("xml_adapter", b.createModule(.{
        .root_source_file = b.path("src/rx/syntax_adapter/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "dsl", .module = b.dependency("dsl", .{ .target = target, .optimize = optimize }).module("dsl") }},
    }));

    if (parser) |generated| {
        frontend.addImport("generated_analyzer", generated.analyzer);
        frontend.addImport("generated_source_signature", generated.source_signature);
        frontend.addImport("generated_native_interface", generated.native_interface);
        frontend.addImport("generated_native_names", generated.native_names);
        frontend.addImport("generated_native_type", generated.native_type);
        frontend.addImport("generated_native_modules", generated.native_modules);
        frontend.addImport("generated_native_export", generated.native_export);
        frontend.addImport("generated_ir_scopes", generated.ir_scopes);
        frontend.addImport("generated_refinement_mark", generated.refinement_mark);
        frontend.addImport("generated_refinement_restore", generated.refinement_restore);
        frontend.addImport("generated_refinement_add", generated.refinement_add);
        frontend.addImport("generated_refinement_assume", generated.refinement_assume);
        frontend.addImport("generated_refinement_bind", generated.refinement_bind);
        frontend.addImport("generated_refinement_type", generated.refinement_type);
        frontend.addImport("generated_ownership", generated.ownership);
        frontend.addImport("generated_ir_body", generated.ir_body);
        frontend.addImport("generated_ir_tasks", generated.ir_tasks);
        frontend.addImport("generated_ir_functions", generated.ir_functions);
        frontend.addImport("generated_ir_expressions", generated.ir_expressions);
        frontend.addImport("generated_ir_contracts", generated.ir_contracts);
        frontend.addImport("generated_ir_contract_tables", generated.ir_contract_tables);
        frontend.addImport("generated_ir_task_call", generated.ir_task_call);
        frontend.addImport("generated_ir_program_pure", generated.ir_program_pure);
        frontend.addImport("generated_ir_stores", generated.ir_stores);
        frontend.addImport("generated_ir_store_call", generated.ir_store_call);
        frontend.addImport("generated_type_resolution", generated.type_resolution);
        frontend.addImport("generated_type_construction", generated.type_construction);
        frontend.addImport("generated_type_query", generated.type_query);
        frontend.addImport("generated_parser", generated.program);
        frontend.addImport("generated_expression", generated.expression);
        frontend.addImport("generated_xml", generated.xml);
        frontend.addImport("generated_specifier", generated.specifier);
        frontend.addImport("generated_integer", generated.integer);
        frontend.addImport("generated_type_lookup", generated.type_lookup);
        frontend.addImport("generated_nominal_lookup", generated.nominal_lookup);
        frontend.addImport("generated_origin_validation", generated.origin_validation);
        frontend.addImport("generated_origin_production", generated.origin_production);
        frontend.addImport("generated_merge_preflight", generated.merge_preflight);
        frontend.addImport("generated_artifact_roots", generated.artifact_roots);
        frontend.addImport("generated_artifact_prepare", generated.artifact_prepare);
        frontend.addImport("generated_artifact_remap", generated.artifact_remap);
        frontend.addImport("generated_type_merge", generated.type_merge);
        frontend.addImport("generated_type_validation", generated.type_validation);
    } else {
        frontend.addImport("refinement_seed", b.createModule(.{
            .root_source_file = b.path("bootstrap/refinement.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "zx", .module = b.dependency("core", .{ .target = target, .optimize = optimize }).module("core") }},
        }));

        frontend.addImport("ownership_seed", b.createModule(.{
            .root_source_file = b.path("bootstrap/ownership/check.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "zx", .module = b.dependency("core", .{ .target = target, .optimize = optimize }).module("core") }},
        }));
    }

    const module = b.createModule(.{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "frontend", .module = frontend },
            .{ .name = "dsl", .module = b.dependency("dsl", .{ .target = target, .optimize = optimize }).module("dsl") },
            .{ .name = "zx", .module = b.dependency("core", .{ .target = target, .optimize = optimize }).module("core") },
            .{ .name = "genz", .module = b.dependency("genz", .{ .target = target, .optimize = optimize }).module("genz") },
            .{ .name = "lint", .module = lint },
        },
    });

    return .{ .frontend = frontend, .compiler = module };
}

pub fn nominalData(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Module {
    return b.createModule(.{
        .root_source_file = b.path("src/zx/modules/nominal_origins/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "zx", .module = b.dependency("core", .{ .target = target, .optimize = optimize }).module("core") }},
    });
}

pub fn typeViews(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Module {
    return b.createModule(.{
        .root_source_file = b.path("src/zx/analysis/types/view.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "zx", .module = b.dependency("core", .{ .target = target, .optimize = optimize }).module("core") }},
    });
}
