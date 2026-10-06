const std = @import("std");
pub const ParserModules = struct { program: *std.Build.Module, expression: *std.Build.Module, xml: *std.Build.Module, specifier: *std.Build.Module, integer: *std.Build.Module, native: *std.Build.Module, type_lookup: *std.Build.Module };
pub const Modules = struct { frontend: *std.Build.Module, compiler: *std.Build.Module };

pub fn create(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, lexer: *std.Build.Module, parser: ?ParserModules) Modules {
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
            .{ .name = "lint", .module = b.dependency("lint", .{ .target = target, .optimize = optimize }).module("lint") },
            .{ .name = "standard_interfaces", .module = @import("standard.zig").create(b) },
        },
    });

    frontend.addOptions("parser_options", options);

    frontend.addImport("xml_adapter", b.createModule(.{
        .root_source_file = b.path("src/rx/syntax_adapter/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "dsl", .module = b.dependency("dsl", .{ .target = target, .optimize = optimize }).module("dsl") }},
    }));

    if (parser) |generated| {
        frontend.addImport("generated_parser", generated.program);
        frontend.addImport("generated_expression", generated.expression);
        frontend.addImport("generated_xml", generated.xml);
        frontend.addImport("generated_specifier", generated.specifier);
        frontend.addImport("generated_integer", generated.integer);
        frontend.addImport("generated_native", generated.native);
        frontend.addImport("generated_type_lookup", generated.type_lookup);
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
            .{ .name = "lint", .module = b.dependency("lint", .{ .target = target, .optimize = optimize }).module("lint") },
        },
    });

    return .{ .frontend = frontend, .compiler = module };
}
