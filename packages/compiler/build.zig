const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const standard = b.addModule("standard", .{ .root_source_file = b.path("standard/src/root.zig"), .target = target, .optimize = optimize });
    const lexer = @import("build/lexer.zig");
    const lexer_source = lexer.generate(b, optimize);
    const modules = @import("build/compiler.zig").create(b, target, optimize, lexer.module(b, target, optimize, lexer_source));
    const frontend = modules.frontend;
    const module = modules.compiler;

    b.modules.put(b.allocator, "frontend", frontend) catch @panic("out of memory");
    b.modules.put(b.allocator, "compiler", module) catch @panic("out of memory");

    const rx = b.addModule("rx", .{
        .root_source_file = b.path("src/rx/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "dsl", .module = b.dependency("dsl", .{ .target = target, .optimize = optimize }).module("dsl") },
            .{ .name = "frontend", .module = frontend },
        },
    });

    _ = b.addModule("rx_analysis", .{
        .root_source_file = b.path("src/rx/analysis/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "rx", .module = rx },
            .{ .name = "dsl", .module = b.dependency("dsl", .{ .target = target, .optimize = optimize }).module("dsl") },
            .{ .name = "zx", .module = b.dependency("core", .{ .target = target, .optimize = optimize }).module("core") },
            .{ .name = "frontend", .module = frontend },
            .{ .name = "lint", .module = b.dependency("lint", .{ .target = target, .optimize = optimize }).module("lint") },
        },
    });

    const rx_tests = b.addTest(.{ .root_module = b.createModule(.{
        .root_source_file = b.path("tests/rx/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "rx", .module = rx }},
    }) });

    const run_rx_tests = b.addRunArtifact(rx_tests);

    b.step("test-rx", "Run RX syntax and dependency graph tests").dependOn(&run_rx_tests.step);

    const host_compiler = @import("build/compiler.zig").create(b, b.graph.host, optimize, lexer.module(b, b.graph.host, optimize, lexer_source)).compiler;

    b.step("bootstrap-lexer", "Generate the ZX lexer with the host seed compiler").dependOn(&b.addInstallFile(lexer_source, "bootstrap/lexer.zig").step);

    const type_generator = b.addExecutable(.{ .name = "standard-types", .root_module = b.createModule(.{
        .root_source_file = b.path("build/generate_types.zig"),
        .target = b.graph.host,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = host_compiler }},
    }) });

    const generate_types = b.addRunArtifact(type_generator);
    const types_file = generate_types.addOutputFileArg("standard_abi.zig");

    standard.addImport("zxc_abi", b.createModule(.{ .root_source_file = types_file, .target = target, .optimize = optimize }));

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

    const run_integration_tests = b.addRunArtifact(integration_tests);
    const test_step = b.step("test", "Run compiler language and API tests");

    test_step.dependOn(&run_rx_tests.step);
    test_step.dependOn(&run_frontend_tests.step);
    test_step.dependOn(&run_integration_tests.step);
}
