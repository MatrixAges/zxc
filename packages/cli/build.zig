const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const compiler = b.dependency("compiler", .{ .target = target, .optimize = optimize });
    const module = compiler.module("compiler");
    const standard = compiler.module("standard");

    const executable = b.addExecutable(.{
        .name = "zxc",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "rx", .module = compiler.module("rx") },
                .{ .name = "rx_analysis", .module = compiler.module("rx_analysis") },
                .{ .name = "lint", .module = b.dependency("lint", .{ .target = target, .optimize = optimize }).module("lint") },
                .{ .name = "pkgs", .module = b.dependency("pkgs", .{ .target = target, .optimize = optimize }).module("pkgs") },
                .{ .name = "compiler", .module = module },
                .{ .name = "napi_resources", .module = b.dependency("napi", .{ .target = target, .optimize = optimize }).module("resources") },
                .{ .name = "napi_declarations", .module = b.dependency("napi", .{ .target = target, .optimize = optimize }).module("declarations") },
                .{ .name = "zx", .module = b.dependency("core", .{ .target = target, .optimize = optimize }).module("core") },
            },
        }),
    });

    @import("build/yaml.zig").link(b, executable, target, optimize);

    executable.root_module.addOptions("cache_identity", @import("build/cache_identity.zig").create(b, target, optimize));

    const pkgs_index = b.dependency("pkgs", .{ .target = target, .optimize = optimize }).namedLazyPath("index");

    executable.root_module.addImport("bundle", @import("build/toolchain.zig").create(b, target, pkgs_index, compiler.builder.root.join(b.allocator, "standard/src") catch @panic("OOM")));
    b.addNamedLazyPath("pkgs_index", pkgs_index);
    b.installArtifact(executable);

    const runtime_tests_module = b.createModule(.{ .root_source_file = b.path("tests/runtime/generated_test.zig"), .target = target, .optimize = optimize });

    for ([_][]const u8{ "collections", "transforms", "optional", "enums", "spread", "index", "modules", "splice", "arithmetic", "short_circuit", "operators", "control_flow", "aggregate_values", "string_values", "collection_boundaries", "void_return", "splice_ranges", "overwritten_evaluation", "numeric_u8", "numeric_u16", "numeric_u32", "numeric_u64", "numeric_i32", "numeric_i64", "numeric_f32", "numeric_f64" }) |case_name| {
        const compile_case = b.addRunArtifact(executable);

        compile_case.setCwd(b.path("."));
        compile_case.addFileArg(b.path(b.fmt("tests/runtime/cases/{s}.zx", .{case_name})));
        compile_case.addArg("--out");

        const output_file = compile_case.addOutputFileArg(b.fmt("{s}.zig", .{case_name}));

        runtime_tests_module.addImport(case_name, b.createModule(.{
            .root_source_file = output_file,
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "zxc_standard", .module = standard }},
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
    const external_types = generate_external.addOutputFileArg("abi.zig");
    const external_abi = b.createModule(.{ .root_source_file = external_types, .target = target, .optimize = optimize });

    const native_fixture = b.createModule(.{
        .root_source_file = b.path("tests/runtime/native_fixture.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "zxc_abi", .module = external_abi }},
    });

    const external = b.createModule(.{
        .root_source_file = external_file,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zxc_abi", .module = external_abi },
            .{ .name = "native_fixture", .module = native_fixture },
        },
    });

    runtime_tests_module.addImport("external", external);

    const native_tests = b.addTest(.{
        .filters = &.{"runtime: explicitly registered native function executes"},
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/runtime/generated_test.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "external", .module = external }},
        }),
    });

    b.step("test-native-runtime", "Run the existing native invocation runtime case").dependOn(&b.addRunArtifact(native_tests).step);

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
            .imports = &.{.{ .name = "zxc_standard", .module = standard }},
        }) }},
    }) });

    const run_store_tests = b.addRunArtifact(store_tests);

    b.step("test-stores", "Run generated Store snapshot and commit tests").dependOn(&run_store_tests.step);

    const runtime_tests = b.addTest(.{ .name = "zx-runtime-tests", .root_module = runtime_tests_module });
    const run_runtime_tests = b.addRunArtifact(runtime_tests);

    b.step("test-runtime", "Run generated ZX runtime regression cases").dependOn(&run_runtime_tests.step);

    const test_step = b.step("test", "Run CLI generated program regressions");

    test_step.dependOn(&run_runtime_tests.step);
    test_step.dependOn(&run_store_tests.step);

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
                .imports = &.{.{ .name = "zxc_standard", .module = standard }},
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
