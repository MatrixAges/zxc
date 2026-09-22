const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const runtime = b.addModule("runtime", .{ .root_source_file = b.path("src/runtime/root.zig"), .target = target, .optimize = optimize });

    const frontend = b.addModule("frontend", .{
        .root_source_file = b.path("src/frontend.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "zx", .module = b.dependency("zx", .{ .target = target, .optimize = optimize }).module("zx") }},
    });

    const module = b.addModule("compiler", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "frontend", .module = frontend },
            .{ .name = "zx", .module = b.dependency("zx", .{ .target = target, .optimize = optimize }).module("zx") },
            .{ .name = "genz", .module = b.dependency("genz", .{ .target = target, .optimize = optimize }).module("genz") },
            .{ .name = "lint", .module = b.dependency("lint", .{ .target = target, .optimize = optimize }).module("lint") },
        },
    });

    const library = b.addLibrary(.{ .name = "zxc_compiler", .root_module = module });

    const frontend_tests = b.addTest(.{
        .name = "zx-frontend-tests",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/root.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "compiler", .module = frontend },
                .{ .name = "zx", .module = b.dependency("zx", .{ .target = target, .optimize = optimize }).module("zx") },
            },
        }),
    });

    const run_frontend_tests = b.addRunArtifact(frontend_tests);
    const frontend_test_step = b.step("test-frontend", "Run ZX grammar and semantic analysis tests");

    frontend_test_step.dependOn(&run_frontend_tests.step);
    b.installArtifact(library);

    const executable = b.addExecutable(.{
        .name = "zxc",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "compiler", .module = module },
                .{ .name = "zx", .module = b.dependency("zx", .{ .target = target, .optimize = optimize }).module("zx") },
            },
        }),
    });

    b.installArtifact(executable);

    const runtime_tests_module = b.createModule(.{ .root_source_file = b.path("tests/runtime/generated_test.zig"), .target = target, .optimize = optimize });

    for ([_][]const u8{ "collections", "transforms", "optional", "enums", "spread", "index", "modules", "splice", "arithmetic", "short_circuit", "operators", "control_flow", "aggregate_values", "string_values", "collection_boundaries", "void_return", "splice_ranges", "overwritten_evaluation", "deep_clone", "numeric_u8", "numeric_u16", "numeric_u32", "numeric_u64", "numeric_i32", "numeric_i64", "numeric_f32", "numeric_f64" }) |case_name| {
        const compile_case = b.addRunArtifact(executable);

        compile_case.setCwd(b.path("."));
        compile_case.addFileArg(b.path(b.fmt("tests/runtime/cases/{s}.zx", .{case_name})));
        compile_case.addArg("--out");

        const output_file = compile_case.addOutputFileArg(b.fmt("{s}.zig", .{case_name}));

        runtime_tests_module.addImport(case_name, b.createModule(.{
            .root_source_file = output_file,
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "zx_runtime", .module = runtime }},
        }));
    }

    const external_generator = b.addExecutable(.{ .name = "external-generator", .root_module = b.createModule(.{
        .root_source_file = b.path("tests/runtime/generate_external.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = module }},
    }) });

    const generate_external = b.addRunArtifact(external_generator);
    const external_file = generate_external.addOutputFileArg("external.zig");

    runtime_tests_module.addImport("external", b.createModule(.{
        .root_source_file = external_file,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zx_runtime", .module = runtime },
            .{ .name = "native_fixture", .module = b.createModule(.{ .root_source_file = b.path("tests/runtime/native_fixture.zig"), .target = target, .optimize = optimize }) },
        },
    }));

    const store_generator = b.addExecutable(.{ .name = "store-generator", .root_module = b.createModule(.{
        .root_source_file = b.path("tests/runtime/generate_store.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = module }},
    }) });

    const generate_store = b.addRunArtifact(store_generator);
    const store_file = generate_store.addOutputFileArg("store.zig");

    const store_tests = b.addTest(.{ .name = "zx-store-tests", .root_module = b.createModule(.{
        .root_source_file = b.path("tests/runtime/store_test.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "store", .module = b.createModule(.{
            .root_source_file = store_file,
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "zx_runtime", .module = runtime }},
        }) }},
    }) });

    const run_store_tests = b.addRunArtifact(store_tests);
    const runtime_tests = b.addTest(.{ .name = "zx-runtime-tests", .root_module = runtime_tests_module });
    const run_runtime_tests = b.addRunArtifact(runtime_tests);

    const support_tests = b.addTest(.{ .name = "zx-runtime-support-tests", .root_module = b.createModule(.{
        .root_source_file = b.path("tests/runtime/sort_test.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "runtime", .module = runtime }},
    }) });

    const run_support_tests = b.addRunArtifact(support_tests);

    const integration_tests = b.addTest(.{ .name = "zx-integration-tests", .root_module = b.createModule(.{
        .root_source_file = b.path("tests/integration_root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = module }},
    }) });

    const run_integration_tests = b.addRunArtifact(integration_tests);
    const test_step = b.step("test", "Run compiler frontend and generated Zig runtime tests");

    test_step.dependOn(&run_frontend_tests.step);
    test_step.dependOn(&run_runtime_tests.step);
    test_step.dependOn(&run_support_tests.step);
    test_step.dependOn(&run_store_tests.step);
    test_step.dependOn(&run_integration_tests.step);

    const generate = b.addRunArtifact(executable);

    generate.addFileArg(b.path("examples/quote.zx"));
    generate.addArg("--out");

    const generated = generate.addOutputFileArg("quote.zig");

    const example = b.addExecutable(.{
        .name = "zx-example",
        .root_module = b.createModule(.{
            .root_source_file = b.path("examples/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "quote", .module = b.createModule(.{
                .root_source_file = generated,
                .imports = &.{.{ .name = "zx_runtime", .module = runtime }},
                .target = target,
                .optimize = optimize,
            }) }},
        }),
    });

    b.installArtifact(example);

    const run_example = b.addRunArtifact(example);
    const example_step = b.step("example", "Compile and run the ZX example");

    example_step.dependOn(&run_example.step);
}
