const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const compiler = b.dependency("compiler", .{ .target = target, .optimize = optimize });
    const test_step = b.step("test", "Run ZX conformance catalogs and their integrity checks");
    const suites = @import("build/catalog.zig").load(b);

    test_step.dependOn(@import("build/frontend.zig").add(b, compiler, target, optimize, suites.frontend));
    test_step.dependOn(@import("build/runtime.zig").add(b, compiler, target, optimize, suites.runtime));
    test_step.dependOn(@import("build/safety.zig").add(b, compiler, target, optimize, suites.safety));
    test_step.dependOn(@import("build/stores.zig").add(b, compiler, target, optimize, suites.stores));
    test_step.dependOn(@import("build/evaluation_order.zig").add(b, compiler, target, optimize));

    const contracts_step = b.step("test-contracts", "Validate contract analysis and code generation gates");

    for ([_][]const u8{ "contracts", "ir" }) |name| {
        const contracts = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/contracts/{s}_test.zig", .{name})),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
            }),
        });

        contracts_step.dependOn(&b.addRunArtifact(contracts).step);
    }

    test_step.dependOn(contracts_step);

    const native_step = b.step("test-native-declarations", "Validate native declaration diagnostics and allocation failures");

    for ([_][]const u8{ "declarations", "configuration", "type_import" }) |name| {
        const native_tests = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/native/{s}_test.zig", .{name})),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
            }),
        });

        native_step.dependOn(&b.addRunArtifact(native_tests).step);
    }

    test_step.dependOn(native_step);

    const ownership_step = b.step("test-ownership-contracts", "Validate function ownership summaries and forged IR rejection");

    const ownership_tests = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/ownership/returns_test.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
        }),
    });

    ownership_step.dependOn(&b.addRunArtifact(ownership_tests).step);
    test_step.dependOn(ownership_step);

    const verification_step = b.step("test-verification", "Validate formal verification with a real Z3 solver");
    const verification = b.addSystemCommand(&.{"node"});

    verification.addFileArg(b.path("tests/verification/verify_test.ts"));
    verification.addArtifactArg(compiler.artifact("zxc"));
    verification_step.dependOn(&verification.step);
    test_step.dependOn(verification_step);

    const resources_step = b.step("test-verification-resources", "Validate verification allocation failures and invalid IR");

    const resources = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/verification/resources_test.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
        }),
    });

    resources_step.dependOn(&b.addRunArtifact(resources).step);
    test_step.dependOn(resources_step);

    const modes_step = b.step("test-build-modes", "Install compiler and consume app and relocated library outputs");
    const modes = b.addSystemCommand(&.{"node"});

    modes.addFileArg(b.path("tests/build_modes/build_test.ts"));
    modes.addDirectoryArg(compiler.path("."));
    modes_step.dependOn(&modes.step);
    test_step.dependOn(modes_step);

    const evaluation_step = b.step("test-hardware-evaluation", "Compare real RTL behavior using external Yosys");
    const evaluation = b.addSystemCommand(&.{"node"});

    evaluation.addFileArg(b.path("tests/hardware/evaluation_test.ts"));
    evaluation.addArtifactArg(compiler.artifact("zxc"));
    evaluation_step.dependOn(&evaluation.step);

    const hardware_step = b.step("test-hardware-resources", "Validate hardware graph boundaries and allocation cleanup");

    for ([_][]const u8{ "resources", "validate" }) |name| {
        const hardware_tests = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/hardware/{s}_test.zig", .{name})),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
            }),
        });

        hardware_step.dependOn(&b.addRunArtifact(hardware_tests).step);
    }

    test_step.dependOn(hardware_step);

    const rx = b.dependency("rx", .{ .target = target, .optimize = optimize });
    const text_step = b.step("test-rx-text", "Validate real RX text parsing and module diagnostics");

    for ([_][]const u8{ "parser", "modules", "resources" }) |name| {
        const tests = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/rx/text/{s}_test.zig", .{name})),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "rx", .module = rx.module("rx") }},
            }),
        });

        const run = b.addRunArtifact(tests);

        text_step.dependOn(&run.step);
    }

    test_step.dependOn(text_step);

    const cli_step = b.step("test-rx-cli", "Validate RX command line file loading and diagnostics");
    const cli = b.addSystemCommand(&.{"node"});

    cli.addFileArg(b.path("tests/rx/cli/check_test.ts"));
    cli.addArtifactArg(compiler.artifact("zxc"));
    cli_step.dependOn(&cli.step);
    test_step.dependOn(cli_step);

    const standard_step = b.step("test-standard-resources", "Validate standard library errors and allocation cleanup");

    for ([_][]const u8{ "allocation", "crypto", "querystring", "zlib/compress", "zlib/decompress" }) |name| {
        const standard_tests = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/standard/resources/{s}_test.zig", .{name})),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "standard", .module = compiler.module("standard") }},
            }),
        });

        const standard_run = b.addRunArtifact(standard_tests);

        standard_step.dependOn(&standard_run.step);
    }

    test_step.dependOn(standard_step);
    test_step.dependOn(@import("build/module_graphs.zig").add(b, rx, target, optimize, suites.module_graphs));

    const graph_check = b.addSystemCommand(&.{"node"});

    graph_check.addFileArg(b.path("src/generate_module_graphs.ts"));
    graph_check.addArg("--check");
    test_step.dependOn(&graph_check.step);

    for ([_][]const u8{ "src/generate_zlib.ts", "src/generate_querystring.ts", "src/generate_crypto_kdf.ts", "src/generate_crypto_aead.ts", "src/generate_primitive_equality.ts", "src/generate_remainder.ts", "src/generate_path_resolution.ts", "src/generate_paths.ts", "src/generate_addition_grouping.ts", "src/generate_subtraction.ts", "src/generate_addition.ts", "src/generate_operand_errors.ts", "src/generate_multiplication_names.ts", "src/generate_multiplication_grouping.ts", "src/generate_multiplication.ts", "src/generate_standard_errors.ts", "src/generate_standard.ts", "src/generate_division.ts", "src/generate_comments.ts", "src/generate_store.ts", "src/generate_logical_not.ts", "src/generate_block_comments.ts", "src/generate_unary_minus.ts", "src/generate_module_paths.ts", "src/generate_float_comparisons.ts", "src/generate_division_grouping.ts", "src/generate_lexical.ts", "src/generate_numeric_boundaries.ts", "src/generate_string_lexical.ts", "src/generate_control.ts", "src/generate_operator_types.ts", "src/generate_integer_safety.ts", "src/generate_numeric_literals.ts", "src/generate_ownership.ts", "src/generate_collections.ts", "src/generate_strings.ts", "src/audit_matrix.ts" }) |script| {
        const check = b.addSystemCommand(&.{"node"});

        check.addFileArg(b.path(script));

        if (!std.mem.eql(u8, script, "src/audit_matrix.ts")) check.addArg("--check");

        test_step.dependOn(&check.step);
    }
}
