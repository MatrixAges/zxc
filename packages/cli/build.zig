const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const stage0 = b.option([]const u8, "stage0", "Pinned bootstrap generator executable") orelse "";
    const partitions = b.option(u32, "generated-partitions", "Compile generated bootstrap functions as this many separately cached objects (0 = one unit)") orelse 0;
    const compiler = b.dependency("compiler", .{ .target = target, .optimize = optimize, .stage0 = stage0, .@"generated-partitions" = partitions });
    const module = compiler.module("compiler");
    const standard = compiler.module("standard");
    const generated_objects = compiler.builder.modules.get("generated_objects");

    const host = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "rx", .module = compiler.module("rx") },
            .{ .name = "rx_analysis", .module = compiler.module("rx_analysis") },
            .{ .name = "lint", .module = compiler.module("lint") },
            .{ .name = "pkgs", .module = b.dependency("pkgs", .{ .target = target, .optimize = optimize }).module("pkgs") },
            .{ .name = "compiler", .module = module },
            .{ .name = "napi_resources", .module = b.dependency("napi", .{ .target = target, .optimize = optimize }).module("resources") },
            .{ .name = "napi_declarations", .module = b.dependency("napi", .{ .target = target, .optimize = optimize }).module("declarations") },
            .{ .name = "zx", .module = b.dependency("core", .{ .target = target, .optimize = optimize }).module("core") },
        },
    });

    const yaml = @import("build/yaml.zig").link(b, host, target, optimize);

    if (b.option(bool, "strip", "Omit debug information from hand-written zxc code as well (generated modules already omit it); faster and lighter to compile, without source locations in stack traces")) |strip| host.strip = strip;

    const cache_identity = @import("build/cache_identity.zig").create(b, target, optimize, compiler);
    const identity = b.createModule(.{ .root_source_file = b.path("src/host/identity.zig"), .target = target, .optimize = optimize });

    // The identity changes with every compiler source; with a separate host object only the entry unit embeds it.
    if (partitions == 0) identity.addImport("cache_identity_embedded", cache_identity.module(b)) else identity.addOptions("cache_identity_embedded", b.addOptions());
    host.addImport("cache_identity", identity);

    const pkgs_index = b.dependency("pkgs", .{ .target = target, .optimize = optimize }).namedLazyPath("index");

    const bundle = @import("build/toolchain.zig").create(b, target, pkgs_index, compiler.builder.root.join(b.allocator, "standard/src") catch @panic("OOM"));
    // Debug builds read the official Zig archive from the build cache instead of embedding it, so linking zxc does
    // not copy it into the binary each time.
    const zig_archive = b.addOptions();

    zig_archive.addOption(bool, "embedded", b.option(bool, "embed-zig", "Embed the official Zig archive in zxc (default: all but Debug builds)") orelse (optimize != .debug));
    zig_archive.addOptionPath("path", bundle.zig_archive);
    // The path may be relative to the directory the build ran in.
    zig_archive.addOption([]const u8, "base", std.process.currentPathAlloc(b.graph.io, b.allocator) catch @panic("unable to read the working directory"));
    host.addImport("bundle", bundle.module);
    host.addOptions("zig_archive", zig_archive);

    const binary = @import("build/binary.zig").create(b, target, optimize, .{
        .host = host,
        .yaml = yaml,
        .cache_identity = cache_identity,
        .partitions = if (partitions == 0) null else generated_objects.?,
        .self_hosted_partitions = compiler.builder.named_lazy_paths.get("generated_objects_self_hosted"),
        .partition_count = partitions,
    });

    b.addNamedLazyPath("pkgs_index", pkgs_index);
    b.addNamedLazyPath("zxc", binary.path());
    binary.install(b);

    const runtime_tests_module = b.createModule(.{ .root_source_file = b.path("tests/runtime/generated_test.zig"), .target = target, .optimize = optimize });

    for ([_][]const u8{ "collections", "transforms", "optional", "enums", "spread", "index", "modules", "splice", "arithmetic", "short_circuit", "operators", "control_flow", "aggregate_values", "string_values", "collection_boundaries", "void_return", "splice_ranges", "overwritten_evaluation", "numeric_u8", "numeric_u16", "numeric_u32", "numeric_u64", "numeric_i32", "numeric_i64", "numeric_f32", "numeric_f64" }) |case_name| {
        const compile_case = binary.run(b);

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

    if (generated_objects) |objects| external_generator.root_module.addImport("zxc_generated_objects", objects);

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

    if (generated_objects) |objects| store_generator.root_module.addImport("zxc_generated_objects", objects);

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

    const generate = binary.run(b);

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
