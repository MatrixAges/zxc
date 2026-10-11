const std = @import("std");
const entries = @import("entries.zig");
pub const ParserModules = entries.ParserModules();
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

    const parser_options = options.createModule();

    frontend.addImport("parser_options", parser_options);
    frontend.addImport("type_views", if (parser) |generated| generated.type_views else typeViews(b, target, optimize));
    frontend.addImport("nominal_data", if (parser) |generated| generated.nominal_data else nominalData(b, target, optimize));

    frontend.addImport("xml_adapter", b.createModule(.{
        .root_source_file = b.path("src/rx/syntax_adapter/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "dsl", .module = b.dependency("dsl", .{ .target = target, .optimize = optimize }).module("dsl") }},
    }));

    if (parser) |generated| {
        inline for (entries.main) |entry| {
            if (entry.owner == .frontend) frontend.addImport(entry.importName(), @field(generated, entry.name));
        }
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

    const native_genz = parser != null and (b.option(bool, "native_genz", "Keep the hand-written genz analyses and printer in generated builds") orelse false);
    // The RX/ZX analyses stay opt-in until their generated output matches the hand-written analyses.
    const rx_analysis = parser != null and (b.option(bool, "genz_rx_analysis", "Run the RX/ZX function facts, iteration versions and inline preparation in generated builds") orelse false);
    // Each compiler instance owns its genz module: the generated imports below must not leak into another
    // instance that shares the genz dependency but generates its own modules.
    const genz_options = b.addOptions();

    genz_options.addOption(bool, "generated", parser != null and !native_genz);
    genz_options.addOption(bool, "generated_analysis", parser != null and !native_genz and rx_analysis);

    const genz = b.createModule(.{
        .root_source_file = b.dependency("genz", .{ .target = target, .optimize = optimize }).path("src/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zx", .module = b.dependency("core", .{ .target = target, .optimize = optimize }).module("core") },
            .{ .name = "genz_options", .module = genz_options.createModule() },
        },
    });

    const module = b.createModule(.{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "frontend", .module = frontend },
            .{ .name = "dsl", .module = b.dependency("dsl", .{ .target = target, .optimize = optimize }).module("dsl") },
            .{ .name = "zx", .module = b.dependency("core", .{ .target = target, .optimize = optimize }).module("core") },
            .{ .name = "genz", .module = genz },
            .{ .name = "lint", .module = lint },
        },
    });

    if (parser) |generated| {
        inline for (entries.main) |entry| {
            if (entry.owner == .compiler) module.addImport(entry.importName(), @field(generated, entry.name));
            if (entry.owner == .genz and !native_genz) genz.addImport(entry.importName(), @field(generated, entry.name));
        }
    }

    module.addImport("parser_options", parser_options);

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
