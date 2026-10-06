const std = @import("std");
pub const ParserModules = struct { type_construction: *std.Build.Module, type_query: *std.Build.Module, construction_writer: *std.Build.Module, type_resolution: *std.Build.Module, resolution_workspace: *std.Build.Module, type_views: *std.Build.Module, type_validation: *std.Build.Module, type_merge: *std.Build.Module, merge_writer_view: *std.Build.Module, type_extract: *std.Build.Module, extract_workspace_view: *std.Build.Module, program: *std.Build.Module, expression: *std.Build.Module, xml: *std.Build.Module, specifier: *std.Build.Module, integer: *std.Build.Module, native: *std.Build.Module, type_lookup: *std.Build.Module, nominal_lookup: *std.Build.Module, origin_validation: *std.Build.Module, origin_production: *std.Build.Module, origin_writer: *std.Build.Module, nominal_data: *std.Build.Module, name_sort: *std.Build.Module, named_view: *std.Build.Module, type_remap: *std.Build.Module, reference_view: *std.Build.Module, merge_preflight: *std.Build.Module, merge_workspace_view: *std.Build.Module };
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
    frontend.addImport("merge_workspace_view", if (parser) |generated| generated.merge_workspace_view else mergeWorkspace(b, target, optimize));
    frontend.addImport("reference_view", if (parser) |generated| generated.reference_view else referenceView(b, target, optimize));
    frontend.addImport("nominal_data", if (parser) |generated| generated.nominal_data else nominalData(b, target, optimize));

    frontend.addImport("named_view", if (parser) |generated| generated.named_view else b.createModule(.{
        .root_source_file = b.path("src/zx/analysis/semantic/ordering/view.zig"),
        .target = target,
        .optimize = optimize,
    }));

    frontend.addImport("xml_adapter", b.createModule(.{
        .root_source_file = b.path("src/rx/syntax_adapter/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "dsl", .module = b.dependency("dsl", .{ .target = target, .optimize = optimize }).module("dsl") }},
    }));

    if (parser) |generated| {
        frontend.addImport("generated_type_resolution", generated.type_resolution);
        frontend.addImport("generated_type_construction", generated.type_construction);
        frontend.addImport("generated_type_query", generated.type_query);
        frontend.addImport("construction_writer", generated.construction_writer);
        frontend.addImport("resolution_workspace", generated.resolution_workspace);
        frontend.addImport("generated_parser", generated.program);
        frontend.addImport("generated_expression", generated.expression);
        frontend.addImport("generated_xml", generated.xml);
        frontend.addImport("generated_specifier", generated.specifier);
        frontend.addImport("generated_integer", generated.integer);
        frontend.addImport("generated_native", generated.native);
        frontend.addImport("generated_type_lookup", generated.type_lookup);
        frontend.addImport("generated_nominal_lookup", generated.nominal_lookup);
        frontend.addImport("generated_origin_validation", generated.origin_validation);
        frontend.addImport("generated_origin_production", generated.origin_production);
        frontend.addImport("origin_writer", generated.origin_writer);
        frontend.addImport("generated_name_sort", generated.name_sort);
        frontend.addImport("generated_type_remap", generated.type_remap);
        frontend.addImport("generated_merge_preflight", generated.merge_preflight);
        frontend.addImport("generated_type_extract", generated.type_extract);
        frontend.addImport("generated_type_merge", generated.type_merge);
        frontend.addImport("generated_type_validation", generated.type_validation);
        frontend.addImport("merge_writer_view", generated.merge_writer_view);
        frontend.addImport("extract_workspace_view", generated.extract_workspace_view);
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

pub fn referenceView(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Module {
    return b.createModule(.{
        .root_source_file = b.path("src/zx/analysis/semantic/remapping/view.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "zx", .module = b.dependency("core", .{ .target = target, .optimize = optimize }).module("core") }},
    });
}

pub fn mergeWorkspace(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Module {
    return b.createModule(.{
        .root_source_file = b.path("src/zx/analysis/semantic/merging/workspace.zig"),
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
