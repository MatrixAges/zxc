const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const stage0 = b.option([]const u8, "stage0", "Pinned bootstrap generator executable; empty uses the initial seed") orelse "";
    const standard = b.addModule("standard", .{ .root_source_file = b.path("standard/src/root.zig"), .target = target, .optimize = optimize });
    const lexer = @import("build/lexer.zig");
    const lexer_source = lexer.generate(b, optimize, stage0);
    const parser = @import("build/parser.zig");
    const generated_partitions = b.option(u32, "generated-partitions", "Compile generated bootstrap functions as this many separately cached objects; artifacts link them by importing `generated_objects` (0 = one unit)") orelse 0;
    const parser_source = parser.generate(b, optimize, stage0, generated_partitions);
    const generated_debug = b.option(bool, "generated-debug", "Keep debug information in generated bootstrap modules (slower and heavier zxc compiles)") orelse false;
    const generated_strip: ?bool = if (generated_debug) null else true;

    b.addNamedLazyPath("naming", parser_source.main.path(b, "naming.zig"));
    b.addNamedLazyPath("length", parser_source.main.path(b, "length.zig"));

    const lint = b.dependency("lint", .{
        .target = target,
        .optimize = optimize,
        .generated_name = parser_source.main.path(b, "naming.zig"),
        .generated_length = parser_source.main.path(b, "length.zig"),
    }).module("lint");

    b.modules.put(b.allocator, "lint", lint) catch @panic("out of memory");

    const natives = parser.shared(b, target, optimize, parser_source, generated_strip, generated_partitions);

    lint.import_table.get("naming").?.import_table.get("generated").?.addImport("generated", natives.generated);
    lint.import_table.get("length").?.import_table.get("generated").?.addImport("generated", natives.generated);

    const modules = @import("build/compiler.zig").create(b, target, optimize, lexer.module(b, target, optimize, lexer_source, generated_strip), parser.modules(b, target, optimize, parser_source, natives, generated_strip), lint);
    const frontend = modules.frontend;
    const module = modules.compiler;

    b.modules.put(b.allocator, "frontend", frontend) catch @panic("out of memory");
    b.modules.put(b.allocator, "compiler", module) catch @panic("out of memory");
    b.modules.put(b.allocator, "frontend_checks", parser.checks(b, target, optimize, parser_source, natives, generated_strip)) catch @panic("out of memory");

    if (natives.objects) |objects| b.modules.put(b.allocator, "generated_objects", objects) catch @panic("out of memory");
    if (natives.self_hosted_objects) |objects| b.addNamedLazyPath("generated_objects_self_hosted", objects);

    const rx = b.addModule("rx", .{
        .root_source_file = b.path("src/rx/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "dsl", .module = b.dependency("dsl", .{ .target = target, .optimize = optimize }).module("dsl") },
            .{ .name = "frontend", .module = frontend },
        },
    });

    const rx_options = b.addOptions();

    rx_options.addOption(bool, "generated_paths", true);
    rx_options.addOption(bool, "generated_graph", true);
    rx_options.addOption(bool, "generated_rules", true);
    rx.addOptions("rx_options", rx_options);

    inline for (@import("build/entries.zig").main) |entry| {
        if (entry.owner == .rx) {
            rx.addImport(entry.importName(), b.createModule(.{
                .root_source_file = parser_source.main.path(b, entry.name ++ ".zig"),
                .imports = &.{.{ .name = "generated", .module = natives.generated }},
                .target = target,
                .optimize = optimize,
                .strip = generated_strip,
            }));
        }
    }

    const rx_analysis = b.addModule("rx_analysis", .{
        .root_source_file = b.path("src/rx/analysis/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "rx", .module = rx },
            .{ .name = "dsl", .module = b.dependency("dsl", .{ .target = target, .optimize = optimize }).module("dsl") },
            .{ .name = "zx", .module = b.dependency("core", .{ .target = target, .optimize = optimize }).module("core") },
            .{ .name = "frontend", .module = frontend },
            .{ .name = "lint", .module = lint },
        },
    });

    const bootstrap_tool = b.addExecutable(.{ .name = "zxc-bootstrap", .root_module = b.createModule(.{
        .root_source_file = b.path("build/generate_parser.zig"),
        .target = target,
        .optimize = if (optimize == .debug or optimize == .safe) .small else optimize,
        .imports = &.{ .{ .name = "compiler", .module = module }, .{ .name = "rx", .module = rx }, .{ .name = "rx_analysis", .module = rx_analysis } },
    }) });

    @import("build/compiler_rt.zig").configure(b, bootstrap_tool);

    linkGenerated(bootstrap_tool, natives);
    b.step("bootstrap-stage", "Build the next bootstrap generator using the selected stage0").dependOn(&b.addInstallArtifact(bootstrap_tool, .{}).step);

    const rx_tests = b.addTest(.{ .root_module = b.createModule(.{
        .root_source_file = b.path("tests/rx/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "rx", .module = rx }},
    }) });

    linkGenerated(rx_tests, natives);

    const run_rx_tests = b.addRunArtifact(rx_tests);

    b.step("test-rx", "Run RX syntax and dependency graph tests").dependOn(&run_rx_tests.step);
    b.step("bootstrap-lexer", "Generate the ZX lexer with the host seed compiler").dependOn(&b.addInstallFile(lexer_source, "bootstrap/lexer.zig").step);

    const bootstrap_parser = b.step("bootstrap-parser", "Generate RX and ZX syntax parsers with the host seed compiler");

    bootstrap_parser.dependOn(&b.addInstallFile(parser_source.main.path(b, "program.zig"), "bootstrap/parser.zig").step);
    bootstrap_parser.dependOn(&b.addInstallFile(parser_source.main.path(b, "expression.zig"), "bootstrap/expression.zig").step);
    bootstrap_parser.dependOn(&b.addInstallFile(parser_source.main.path(b, "xml.zig"), "bootstrap/xml.zig").step);
    bootstrap_parser.dependOn(&b.addInstallFile(parser_source.main.path(b, "paths.zig"), "bootstrap/paths.zig").step);
    bootstrap_parser.dependOn(&b.addInstallFile(parser_source.main.path(b, "graph.zig"), "bootstrap/graph.zig").step);
    bootstrap_parser.dependOn(&b.addInstallFile(parser_source.main.path(b, "attribute_role.zig"), "bootstrap/attribute_role.zig").step);
    bootstrap_parser.dependOn(&b.addInstallFile(parser_source.main.path(b, "attribute_content.zig"), "bootstrap/attribute_content.zig").step);
    bootstrap_parser.dependOn(&b.addInstallFile(parser_source.main.path(b, "call_rule.zig"), "bootstrap/call_rule.zig").step);
    bootstrap_parser.dependOn(&b.addInstallFile(parser_source.main.path(b, "path_kind.zig"), "bootstrap/path_kind.zig").step);
    bootstrap_parser.dependOn(&b.addInstallFile(parser_source.main.path(b, "file_kind.zig"), "bootstrap/file_kind.zig").step);
    bootstrap_parser.dependOn(&b.addInstallFile(parser_source.main.path(b, "specifier.zig"), "bootstrap/specifier.zig").step);
    bootstrap_parser.dependOn(&b.addInstallFile(parser_source.main.path(b, "integer.zig"), "bootstrap/integer.zig").step);
    standard.addImport("zxc_abi", b.createModule(.{ .root_source_file = parser_source.standard_abi, .target = target, .optimize = optimize }));

    const library = b.addLibrary(.{ .name = "zxc_compiler", .root_module = module });

    const frontend_tests = b.addTest(.{
        .name = "zx-frontend-tests",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/root.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "compiler", .module = frontend },
                .{ .name = "zx", .module = b.dependency("core", .{ .target = target, .optimize = optimize }).module("core") },
            },
        }),
    });

    linkGenerated(frontend_tests, natives);

    const run_frontend_tests = b.addRunArtifact(frontend_tests);
    const frontend_test_step = b.step("test-frontend", "Run ZX grammar and semantic analysis tests");

    frontend_test_step.dependOn(&run_frontend_tests.step);
    b.installArtifact(library);

    const integration_tests = b.addTest(.{ .name = "zx-integration-tests", .root_module = b.createModule(.{
        .root_source_file = b.path("tests/integration_root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = module }},
    }) });

    linkGenerated(integration_tests, natives);

    const run_integration_tests = b.addRunArtifact(integration_tests);
    const test_step = b.step("test", "Run compiler language and API tests");

    test_step.dependOn(&run_rx_tests.step);
    test_step.dependOn(&run_frontend_tests.step);
    test_step.dependOn(&run_integration_tests.step);
}

fn linkGenerated(artifact: *std.Build.Step.Compile, natives: @import("build/parser.zig").Shared) void {
    if (natives.objects) |objects| artifact.root_module.addImport("zxc_generated_objects", objects);
}
