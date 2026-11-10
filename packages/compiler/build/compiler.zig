const std = @import("std");
const entries = @import("entries.zig");
pub const ModuleBinding = struct { metadata: entries.ModuleEntry, module: *std.Build.Module };

pub const ParserModules = struct {
    host_metadata: *std.Build.Step.Compile,
    type_views: *std.Build.Module,
    nominal_data: *std.Build.Module,
    bindings: []const ModuleBinding,
    pub fn get(self: @This(), name: []const u8) *std.Build.Module {
        for (self.bindings) |binding| {
            if (std.mem.eql(u8, binding.metadata.entry.name, name)) return binding.module;
        }

        unreachable;
    }
};

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
            .{ .name = "standard_interfaces", .module = @import("standard.zig").create(b, if (parser) |generated| generated.host_metadata else null) },
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
        for (generated.bindings) |binding| {
            if (binding.metadata.entry.owner == .frontend) frontend.addImport(binding.metadata.import_name, binding.module);
        }
    } else {
        frontend.addImport("generated_resource_scan", b.createModule(.{
            .root_source_file = b.path("bootstrap/resource_scan.zig"),
            .target = target,
            .optimize = optimize,
        }));

        frontend.addImport("generated_constant_fold", @import("constant_seed.zig").create(b, target, optimize));

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
    // Generated builds run the RX/ZX analyses; the hand-written ones remain for the seed and can be selected here.
    const rx_analysis = parser != null and (b.option(bool, "genz_rx_analysis", "Run the RX/ZX backend analyses in generated builds") orelse true);
    // Each compiler instance owns its genz module: the generated imports below must not leak into another
    // instance that shares the genz dependency but generates its own modules.
    const genz_options = b.addOptions();

    genz_options.addOption(bool, "generated", parser != null and !native_genz);
    genz_options.addOption(bool, "generated_analysis", parser != null and !native_genz and rx_analysis);
    genz_options.addOption(bool, "partition_groups", true);

    const genz = b.createModule(.{
        .root_source_file = b.dependency("genz", .{ .target = target, .optimize = optimize }).path("src/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zx", .module = b.dependency("core", .{ .target = target, .optimize = optimize }).module("core") },
            .{ .name = "genz_options", .module = genz_options.createModule() },
        },
    });

    genz.addImport("generated_partition_groups", if (parser) |generated| generated.get("partition_groups") else bootstrapModule(b, target, optimize, "partition", "partition_groups"));

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
        for (generated.bindings) |binding| {
            if (binding.metadata.entry.owner == .compiler) module.addImport(binding.metadata.import_name, binding.module);
            if (binding.metadata.entry.owner == .genz and !native_genz) genz.addImport(binding.metadata.import_name, binding.module);
        }
    } else {
        const query_types = b.createModule(.{ .root_source_file = b.path("bootstrap/query/types.zig"), .target = target, .optimize = optimize });
        const query_string = b.createModule(.{ .root_source_file = b.dependency("zxc_std", .{}).path("src/string.zig"), .target = target, .optimize = optimize });

        const query = b.createModule(.{
            .root_source_file = b.path("bootstrap/query/root.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{ .{ .name = "zxc_abi", .module = query_types }, .{ .name = "zxc_string", .module = query_string } },
        });

        module.addImport("query_seed", query);
        module.addImport("generated_input_snapshot", bootstrapModule(b, target, optimize, "input_snapshot", "input_snapshot"));
    }

    module.addImport("parser_options", parser_options);

    return .{ .frontend = frontend, .compiler = module };
}

fn bootstrapModule(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, directory: []const u8, entry: []const u8) *std.Build.Module {
    const abi = b.createModule(.{ .root_source_file = b.path(b.fmt("bootstrap/{s}/types.zig", .{directory})), .target = target, .optimize = optimize });
    const standard = b.dependency("zxc_std", .{ .target = target, .optimize = optimize }).module("zxc_std");

    const generated = b.createModule(.{
        .root_source_file = b.path(b.fmt("bootstrap/{s}/root.zig", .{directory})),
        .target = target,
        .optimize = optimize,
        .imports = &.{ .{ .name = "zxc_abi", .module = abi }, .{ .name = "zxc_standard", .module = standard } },
    });

    return b.createModule(.{
        .root_source_file = b.path(b.fmt("bootstrap/{s}/{s}.zig", .{ directory, entry })),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "generated", .module = generated }},
    });
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
