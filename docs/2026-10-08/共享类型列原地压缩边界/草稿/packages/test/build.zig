const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const compiler = b.dependency("compiler", .{ .target = target, .optimize = optimize });
    const zig_archive = b.option([]const u8, "zig-archive", "Official Zig archive for the zxc host");
    const cli_dependency = if (zig_archive) |path| b.dependency("cli", .{ .target = target, .optimize = optimize, .@"zig-archive" = path }) else b.dependency("cli", .{ .target = target, .optimize = optimize });
    const test_step = b.step("test", "Run ZX conformance catalogs and their integrity checks");
    const suites = @import("build/catalog.zig").load(b);

    test_step.dependOn(@import("build/function_updates.zig").add(b, compiler, target, optimize));
    test_step.dependOn(@import("build/predicates.zig").add(b, compiler, target, optimize));
    test_step.dependOn(@import("build/reduce_runtime.zig").add(b, cli_dependency, target, optimize));
    test_step.dependOn(@import("build/multiple_append.zig").add(b, compiler, target, optimize));
    test_step.dependOn(@import("build/store_ownership_proof.zig").add(b, compiler, target, optimize));
    test_step.dependOn(@import("build/store_reclamation.zig").add(b, compiler, target, optimize));
    test_step.dependOn(@import("build/store_alias_lifetime.zig").add(b, compiler, target, optimize));
    test_step.dependOn(@import("build/cached_ownership.zig").add(b, compiler, target, optimize));
    test_step.dependOn(@import("build/field_ownership.zig").add(b, compiler, target, optimize));
    test_step.dependOn(@import("build/object_append.zig").add(b, compiler, target, optimize));
    test_step.dependOn(@import("build/object_reduce.zig").add(b, compiler, target, optimize));
    test_step.dependOn(@import("build/value_return.zig").add(b, compiler, target, optimize));
    test_step.dependOn(@import("build/owned_input.zig").add(b, compiler, target, optimize));
    test_step.dependOn(@import("build/process_entry.zig").add(b, cli_dependency, optimize));
    test_step.dependOn(@import("build/url_api_library.zig").add(b, cli_dependency, optimize));
    test_step.dependOn(@import("build/wasm_protocol.zig").add(b, cli_dependency, optimize));
    test_step.dependOn(@import("build/napi_protocol.zig").add(b, cli_dependency, optimize));
    test_step.dependOn(@import("build/napi_bindings.zig").add(b, cli_dependency, optimize));
    test_step.dependOn(@import("build/simd_semantics.zig").add(b, cli_dependency, optimize));
    test_step.dependOn(@import("build/gateway.zig").add(b, cli_dependency, compiler, target, optimize));
    test_step.dependOn(@import("build/frontend.zig").add(b, compiler, target, optimize, suites.frontend));
    test_step.dependOn(@import("build/scanner_metadata.zig").add(b, compiler, target, optimize));
    test_step.dependOn(@import("build/type_parser.zig").add(b, cli_dependency, compiler, target, optimize));
    test_step.dependOn(@import("build/type_resolution.zig").add(b, compiler, target, optimize));
    test_step.dependOn(@import("build/type_query.zig").add(b, compiler, target, optimize));
    test_step.dependOn(@import("build/function_effects.zig").add(b, compiler, target, optimize));
    test_step.dependOn(@import("build/native_modules.zig").add(b, compiler, target, optimize));
    test_step.dependOn(@import("build/template_preparation.zig").add(b, cli_dependency, compiler, target, optimize));
    test_step.dependOn(@import("build/expression_preparation.zig").add(b, cli_dependency, compiler, target, optimize));
    test_step.dependOn(@import("build/import_paths.zig").add(b, cli_dependency, compiler, target, optimize));
    test_step.dependOn(@import("build/import_order.zig").add(b, cli_dependency, compiler, target, optimize));
    test_step.dependOn(@import("build/runtime.zig").add(b, compiler, cli_dependency, target, optimize, suites.runtime));
    test_step.dependOn(@import("build/object_shorthand.zig").add(b, compiler, target, optimize, suites.runtime));
    test_step.dependOn(@import("build/iterate.zig").add(b, cli_dependency, compiler, target, optimize));
    test_step.dependOn(@import("build/loop_initial_ownership.zig").add(b, compiler, target, optimize));
    test_step.dependOn(@import("build/loop_call_origins.zig").add(b, compiler, target, optimize));
    test_step.dependOn(@import("build/reverse_ownership.zig").add(b, compiler, target, optimize));
    test_step.dependOn(@import("build/iterate_buffer.zig").add(b, cli_dependency, target, optimize));
    test_step.dependOn(@import("build/aggregate_loop.zig").add(b, compiler, target, optimize));
    test_step.dependOn(@import("build/loop_columns.zig").add(b, compiler, target, optimize));
    test_step.dependOn(@import("build/modular_loop.zig").add(b, compiler, target, optimize));
    test_step.dependOn(@import("build/detached_reader.zig").add(b, compiler, target, optimize));
    test_step.dependOn(@import("build/native_value_boundary.zig").add(b, compiler, target, optimize));
    test_step.dependOn(@import("build/native_borrowed_runtime.zig").add(b, compiler, target, optimize));
    test_step.dependOn(@import("build/iterate_calls.zig").add(b, compiler, cli_dependency, target, optimize));
    test_step.dependOn(@import("build/loop_policy.zig").add(b, compiler, cli_dependency, target, optimize));
    test_step.dependOn(@import("build/rx_value_policy.zig").add(b, compiler, cli_dependency, target, optimize));
    test_step.dependOn(@import("build/rx_task_output.zig").add(b, compiler, cli_dependency, target, optimize));
    test_step.dependOn(@import("build/typed_try.zig").add(b, compiler, target, optimize));

    const native_reference_tests = @import("build/native_references.zig").add(b, compiler, target, optimize);

    native_reference_tests.dependOn(@import("build/native_reference_targets.zig").add(b, cli_dependency, optimize));
    test_step.dependOn(native_reference_tests);
    test_step.dependOn(@import("build/tasks.zig").add(b, compiler, target, optimize));
    test_step.dependOn(@import("build/safety.zig").add(b, compiler, cli_dependency, target, optimize, suites.safety));
    test_step.dependOn(@import("build/stores.zig").add(b, compiler, target, optimize, suites.stores));
    test_step.dependOn(@import("build/evaluation_order.zig").add(b, compiler, target, optimize, suites.evaluation_order));

    const expression_step = b.step("test-expression-bindings", "Validate standalone expression binding paths and programs");

    const expression_tests = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/expressions/bindings/input_test.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
        }),
    });

    expression_tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
    expression_step.dependOn(&b.addRunArtifact(expression_tests).step);
    test_step.dependOn(expression_step);
    test_step.dependOn(@import("build/rx_runtime.zig").add(b, compiler, target, optimize));
    test_step.dependOn(@import("build/rx_parallel_runtime.zig").add(b, compiler, target, optimize));
    test_step.dependOn(@import("build/rx_parallel_inference.zig").add(b, compiler, target, optimize));
    test_step.dependOn(@import("build/expression_runtime.zig").add(b, compiler, target, optimize));

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

        contracts.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        contracts_step.dependOn(&b.addRunArtifact(contracts).step);
    }

    test_step.dependOn(contracts_step);
    test_step.dependOn(@import("build/link_runtime.zig").add(b, compiler, target, optimize));
    test_step.dependOn(@import("build/native_runtime.zig").add(b, compiler, target, optimize));

    const type_validation_step = b.step("test-type-validation", "Validate generated type table rules without runtime allocation");

    for ([_][]const u8{ "shape", "references", "names", "allowed" }) |name| {
        const tests = b.addTest(.{ .name = b.fmt("type-validation-{s}", .{name}), .root_module = b.createModule(.{
            .root_source_file = b.path(b.fmt("tests/ir/types/validation/{s}_test.zig", .{name})),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
        }) });

        type_validation_step.dependOn(&b.addRunArtifact(tests).step);
    }

    test_step.dependOn(type_validation_step);

    const type_merge_step = b.step("test-type-merge", "Validate structural and nominal module type merging");

    for ([_][]const u8{ "identity", "invalid", "resources", "storage", "storage_append", "preflight/prefix", "preflight/origins", "preflight/resources", "bulk/mapping", "bulk/nominal", "bulk/ownership", "bulk/resources", "compaction/mapping", "compaction/resources" }) |name| {
        const type_tests = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/incremental/type_merge/{s}_test.zig", .{name})),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
            }),
        });

        type_tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });

        if (std.mem.startsWith(u8, name, "compaction/")) {
            type_tests.root_module.addAnonymousImport("type_merge_fixture", .{
                .root_source_file = b.path("tests/incremental/type_merge/preflight/fixture.zig"),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
            });
        }

        type_merge_step.dependOn(&b.addRunArtifact(type_tests).step);
    }

    test_step.dependOn(type_merge_step);

    const library_step = b.step("test-library-link", "Validate unified public module linkage identity ownership and failures");

    for ([_][]const u8{ "identity", "resources", "store", "bundle", "bundle_cache", "imports/identity", "imports/rejection", "imports/native", "compiled_store" }) |name| {
        const library_tests = b.addTest(.{ .root_module = b.createModule(.{
            .root_source_file = b.path(b.fmt("tests/library/{s}_test.zig", .{name})),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "compiler", .module = compiler.module("compiler") },
                .{ .name = "rx", .module = compiler.module("rx") },
                .{ .name = "rx_analysis", .module = compiler.module("rx_analysis") },
            },
        }) });

        library_tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        library_step.dependOn(&b.addRunArtifact(library_tests).step);
    }

    test_step.dependOn(library_step);
    test_step.dependOn(@import("build/library_initializers.zig").add(b, compiler, target, optimize));

    const library_codec_step = b.step("test-library-codec", "Validate unified library encoding ownership integrity and semantic rejection");

    const library_fixture = b.createModule(.{
        .root_source_file = b.path("tests/library/fixture.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    });

    for ([_][]const u8{ "roundtrip", "rejection", "type_columns" }) |name| {
        const codec_tests = b.addTest(.{ .root_module = b.createModule(.{
            .root_source_file = b.path(b.fmt("tests/library/codec/{s}_test.zig", .{name})),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "compiler", .module = compiler.module("compiler") },
                .{ .name = "library_fixture", .module = library_fixture },
            },
        }) });

        if (std.mem.eql(u8, name, "type_columns")) codec_tests.root_module.addAnonymousImport("type_column_fixture", .{ .root_source_file = b.path("tests/support/type_column_fixture.zig"), .target = target, .optimize = optimize });

        codec_tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        library_codec_step.dependOn(&b.addRunArtifact(codec_tests).step);
    }

    test_step.dependOn(library_codec_step);
    test_step.dependOn(@import("build/library_runtime.zig").add(b, compiler, target, optimize));

    const native_link_step = b.step("test-native-link", "Validate native artifact linking identity ABI and resources");

    for ([_][]const u8{ "link", "resources" }) |name| {
        const native_tests = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/incremental/native_link/{s}_test.zig", .{name})),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
            }),
        });

        native_tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        native_link_step.dependOn(&b.addRunArtifact(native_tests).step);
    }

    test_step.dependOn(native_link_step);

    const slots_step = b.step("test-artifact-slots", "Validate module artifact capability slots and ownership");

    for ([_][]const u8{ "slots", "resources" }) |name| {
        const slots_tests = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/incremental/artifact_slots/{s}_test.zig", .{name})),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
            }),
        });

        slots_tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        slots_step.dependOn(&b.addRunArtifact(slots_tests).step);
    }

    test_step.dependOn(slots_step);

    const artifact_step = b.step("test-module-artifacts", "Validate local module extraction remapping and ownership");

    const record_fixture = b.createModule(.{
        .root_source_file = b.path("tests/incremental/module_records/fixture.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    });

    const link_boundaries_step = b.step("test-link-boundaries", "Validate module link graph interface and allocation failure boundaries");
    const generation_step = b.step("test-module-generation", "Validate split generation cache gates and ownership");

    for ([_][]const u8{ "cache", "gates", "resources", "value_eligibility", "buffer_eligibility", "buffer_resources", "buffer_recovery" }) |name| {
        const generation_tests = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/incremental/module_generation/{s}_test.zig", .{name})),
                .target = target,
                .optimize = optimize,
                .imports = &.{ .{ .name = "compiler", .module = compiler.module("compiler") }, .{ .name = "record_fixture", .module = record_fixture } },
            }),
        });

        generation_tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        generation_step.dependOn(&b.addRunArtifact(generation_tests).step);
    }

    test_step.dependOn(generation_step);

    const codec_step = b.step("test-cache-codec", "Validate persistent semantic artifact encoding integrity and resources");

    for ([_][]const u8{ "roundtrip", "invalid", "resources", "type_columns" }) |name| {
        const codec_tests = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/incremental/cache_codec/{s}_test.zig", .{name})),
                .target = target,
                .optimize = optimize,
                .imports = &.{ .{ .name = "compiler", .module = compiler.module("compiler") }, .{ .name = "record_fixture", .module = record_fixture } },
            }),
        });

        if (std.mem.eql(u8, name, "type_columns")) codec_tests.root_module.addAnonymousImport("type_column_fixture", .{ .root_source_file = b.path("tests/support/type_column_fixture.zig"), .target = target, .optimize = optimize });

        codec_tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        codec_step.dependOn(&b.addRunArtifact(codec_tests).step);
    }

    test_step.dependOn(codec_step);

    const backend_step = b.step("test-backend-protocol", "Validate backend framing ownership and malformed diagnostics");

    const backend_protocol = b.createModule(.{
        .root_source_file = cli_dependency.path("src/cli/backend/protocol.zig"),
        .target = target,
        .optimize = optimize,
    });

    for ([_][]const u8{ "state", "invalid", "edges", "resources", "graph", "source" }) |name| {
        const backend_tests = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/incremental/backend_protocol/{s}_test.zig", .{name})),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "backend_protocol", .module = backend_protocol }},
            }),
        });

        backend_tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        backend_step.dependOn(&b.addRunArtifact(backend_tests).step);
    }

    test_step.dependOn(backend_step);

    const publish_step = b.step("test-backend-publish", "Validate real artifact publication gates and preserved outputs");
    const observed_sources = b.addWriteFiles();
    _ = observed_sources.addCopyDirectory(cli_dependency.path("src"), "source", .{});
    const observed_root = observed_sources.add("root.zig", "pub const Output = @import(\"source/cli/watch/output.zig\");\npub const Backend = @import(\"source/cli/backend/process.zig\");\npub const Observed = @import(\"source/cli/build/observed.zig\");\npub const Inputs = @import(\"source/cli/watch/inputs.zig\");\npub const Options = @import(\"source/cli/options.zig\").Options;\n");

    const observed = b.createModule(.{
        .root_source_file = observed_root,
        .target = target,
        .optimize = optimize,
    });

    for ([_][]const u8{ "publish", "resolve", "paths" }) |name| {
        const publish_tests = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/incremental/backend_publish/{s}_test.zig", .{name})),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "observed", .module = observed }},
            }),
        });

        publish_tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        publish_step.dependOn(&b.addRunArtifact(publish_tests).step);
    }

    test_step.dependOn(publish_step);

    const backend_runtime_step = b.step("test-backend-runtime", "Build and publish through real backend protocol processes");

    const backend_driver = b.addExecutable(.{
        .name = "backend-driver",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/incremental/backend_runtime/driver.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "observed", .module = observed }},
        }),
    });

    const backend_runtime = b.addSystemCommand(&.{"node"});

    backend_runtime.addFileArg(b.path("tests/incremental/backend_runtime/runtime_test.ts"));
    backend_runtime.addArtifactArg(backend_driver);
    backend_runtime.addArg(b.graph.zig_exe);
    backend_runtime.addDirectoryArg(.zig_lib);
    backend_runtime_step.dependOn(&backend_runtime.step);
    test_step.dependOn(backend_runtime_step);

    const watch_step = b.step("test-watch-recovery", "Validate CLI watch rebuilding failure preservation and recovery");
    const watch_tests = b.addSystemCommand(&.{"node"});

    watch_tests.addFileArg(b.path("tests/incremental/watch/recovery_test.ts"));
    watch_tests.addArtifactArg(cli_dependency.artifact("zxc"));
    watch_step.dependOn(&watch_tests.step);
    test_step.dependOn(watch_step);

    const watch_library_step = b.step("test-watch-library", "Consume watched library exports across updates and failures");
    const watch_library = b.addSystemCommand(&.{"node"});

    watch_library.addFileArg(b.path("tests/incremental/watch/library_test.ts"));
    watch_library.addFileInput(b.path("tests/incremental/watch/consume_library.ts"));
    watch_library.addArtifactArg(cli_dependency.artifact("zxc"));
    watch_library.addArg(b.graph.zig_exe);
    watch_library_step.dependOn(&watch_library.step);
    test_step.dependOn(watch_library_step);

    const watch_headers_step = b.step("test-watch-headers", "Validate missing native headers retry and watch recovery");
    const watch_headers = b.addSystemCommand(&.{"node"});

    watch_headers.addFileArg(b.path("tests/incremental/watch/headers_test.ts"));
    watch_headers.addArtifactArg(cli_dependency.artifact("zxc"));
    watch_headers_step.dependOn(&watch_headers.step);
    test_step.dependOn(watch_headers_step);

    const semantic_step = b.step("test-semantic-cache", "Validate semantic cache reuse invalidation and result ownership");

    const parse_fixture = b.createModule(.{
        .root_source_file = b.path("tests/incremental/parse_cache/fixture.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    });

    for ([_][]const u8{ "project", "resources" }) |name| {
        const semantic_tests = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/incremental/semantic_cache/{s}_test.zig", .{name})),
                .target = target,
                .optimize = optimize,
                .imports = &.{ .{ .name = "compiler", .module = compiler.module("compiler") }, .{ .name = "parse_fixture", .module = parse_fixture } },
            }),
        });

        semantic_tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        semantic_step.dependOn(&b.addRunArtifact(semantic_tests).step);
    }

    test_step.dependOn(semantic_step);

    for ([_][]const u8{ "graph", "interfaces", "resources" }) |name| {
        const link_tests = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/incremental/link_boundaries/{s}_test.zig", .{name})),
                .target = target,
                .optimize = optimize,
                .imports = &.{ .{ .name = "compiler", .module = compiler.module("compiler") }, .{ .name = "record_fixture", .module = record_fixture } },
            }),
        });

        link_tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        link_boundaries_step.dependOn(&b.addRunArtifact(link_tests).step);
    }

    test_step.dependOn(link_boundaries_step);

    for ([_][]const u8{ "extract", "invalid", "resources", "mixed/extract", "mixed/resources" }) |name| {
        const artifact_tests = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/incremental/artifact/{s}_test.zig", .{name})),
                .target = target,
                .optimize = optimize,
                .imports = &.{ .{ .name = "compiler", .module = compiler.module("compiler") }, .{ .name = "record_fixture", .module = record_fixture } },
            }),
        });

        artifact_tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        artifact_step.dependOn(&b.addRunArtifact(artifact_tests).step);
    }

    test_step.dependOn(artifact_step);

    const nominal_step = b.step("test-nominal-origins", "Validate source native and external enum origins");

    for ([_][]const u8{ "origins", "resources" }) |name| {
        const nominal_tests = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/incremental/nominal/{s}_test.zig", .{name})),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
            }),
        });

        nominal_tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        nominal_step.dependOn(&b.addRunArtifact(nominal_tests).step);
    }

    test_step.dependOn(nominal_step);

    const records_step = b.step("test-module-records", "Validate project module metadata ownership and dependencies");

    for ([_][]const u8{ "records", "resources" }) |name| {
        const records_tests = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/incremental/module_records/{s}_test.zig", .{name})),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
            }),
        });

        records_tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        records_step.dependOn(&b.addRunArtifact(records_tests).step);
    }

    test_step.dependOn(records_step);

    const cache_step = b.step("test-parse-cache", "Validate parsing cache invalidation ownership and allocation failures");

    for ([_][]const u8{ "cache", "project", "resources" }) |name| {
        const cache_tests = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/incremental/parse_cache/{s}_test.zig", .{name})),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
            }),
        });

        cache_tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        cache_step.dependOn(&b.addRunArtifact(cache_tests).step);
    }

    test_step.dependOn(cache_step);

    const native_step = b.step("test-native-declarations", "Validate native declaration diagnostics and allocation failures");

    for ([_][]const u8{ "declarations", "configuration", "type_import", "signatures/root" }) |name| {
        const native_tests = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/native/{s}_test.zig", .{name})),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
            }),
        });

        native_tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        native_step.dependOn(&b.addRunArtifact(native_tests).step);
    }

    test_step.dependOn(native_step);

    const module_types_step = b.step("test-match-module-types", "Validate types and ownership in cross module match expressions");

    for ([_][]const u8{ "match", "match_ownership", "match_import_order" }) |name| {
        const module_types = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/modules/{s}_test.zig", .{name})),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
            }),
        });

        module_types_step.dependOn(&b.addRunArtifact(module_types).step);
    }

    test_step.dependOn(module_types_step);

    const ownership_step = b.step("test-ownership-contracts", "Validate function ownership summaries and forged IR rejection");

    const ownership_tests = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/ownership/returns_test.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
        }),
    });

    ownership_tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
    ownership_step.dependOn(&b.addRunArtifact(ownership_tests).step);
    test_step.dependOn(ownership_step);

    const verification_step = b.step("test-verification", "Validate formal verification with a real Z3 solver");
    const verification = b.addSystemCommand(&.{"node"});

    verification.addFileArg(b.path("tests/verification/verify_test.ts"));
    verification.addArtifactArg(cli_dependency.artifact("zxc"));
    verification_step.dependOn(&verification.step);
    test_step.dependOn(verification_step);

    const public_verification_step = b.step("test-public-verification", "Verify every declared public ZX and RX library entry");
    const public_verification = b.addSystemCommand(&.{"node"});

    public_verification.addFileArg(b.path("tests/verification/public_test.ts"));
    public_verification.addFileInput(b.path("tests/verification/public_cases.ts"));
    public_verification.addArtifactArg(cli_dependency.artifact("zxc"));
    public_verification_step.dependOn(&public_verification.step);
    verification_step.dependOn(public_verification_step);

    const enum_verification_step = b.step("test-enum-verification", "Verify finite enum domains, counterexamples and infeasible preconditions");
    const enum_verification = b.addSystemCommand(&.{"node"});

    enum_verification.addFileArg(b.path("tests/verification/enumeration/verify_test.ts"));
    enum_verification.addFileInput(b.path("tests/verification/enumeration/cases.ts"));
    enum_verification.addArtifactArg(cli_dependency.artifact("zxc"));
    enum_verification_step.dependOn(&enum_verification.step);
    verification_step.dependOn(enum_verification_step);

    const resources_step = b.step("test-verification-resources", "Validate verification allocation failures and invalid IR");

    const resources = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/verification/resources_test.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
        }),
    });

    resources.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
    resources_step.dependOn(&b.addRunArtifact(resources).step);
    test_step.dependOn(resources_step);

    const modes_step = b.step("test-build-modes", "Install compiler and consume app and relocated library outputs");
    const modes = b.addSystemCommand(&.{"node"});

    modes.addFileArg(b.path("tests/build_modes/build_test.ts"));
    modes.addFileInput(b.path("tests/build_modes/native_declaration_test.ts"));
    modes.addFileInput(b.path("tests/support/allocation_testing.zig"));
    modes.addDirectoryArg(cli_dependency.path("."));

    if (zig_archive) |path| modes.addFileArg(.{ .cwd_relative = path });

    modes_step.dependOn(&modes.step);
    test_step.dependOn(modes_step);

    const evaluation_step = b.step("test-hardware-evaluation", "Compare real RTL behavior using external Yosys");
    const evaluation = b.addSystemCommand(&.{"node"});

    evaluation.addFileArg(b.path("tests/hardware/evaluation_test.ts"));
    evaluation.addArtifactArg(cli_dependency.artifact("zxc"));
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

        hardware_tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        hardware_step.dependOn(&b.addRunArtifact(hardware_tests).step);
    }

    test_step.dependOn(hardware_step);

    const rx = compiler;
    const rx_inference_step = b.step("test-rx-inference", "Validate inferred RX contracts through real XML");

    const rx_inference_tests = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/rx/inference/root.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "rx", .module = compiler.module("rx") },
                .{ .name = "rx_analysis", .module = compiler.module("rx_analysis") },
                .{ .name = "compiler", .module = compiler.module("compiler") },
            },
        }),
    });

    rx_inference_tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
    rx_inference_tests.root_module.addAnonymousImport("rx_collection_fixtures", .{ .root_source_file = b.path("tests/rx/support/collections/root.zig"), .target = target, .optimize = optimize });
    rx_inference_step.dependOn(&b.addRunArtifact(rx_inference_tests).step);
    test_step.dependOn(rx_inference_step);

    const xml_expression_step = b.step("test-xml-expression", "Validate XML expression source positions and ownership");

    const xml_expression_tests = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/expressions/xml/position_test.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "compiler", .module = compiler.module("compiler") },
                .{ .name = "rx_compiler", .module = compiler.module("rx_analysis") },
                .{ .name = "rx", .module = rx.module("rx") },
            },
        }),
    });

    xml_expression_tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
    xml_expression_step.dependOn(&b.addRunArtifact(xml_expression_tests).step);
    test_step.dependOn(xml_expression_step);

    const text_step = b.step("test-rx-text", "Validate real RX text parsing and module diagnostics");

    for ([_][]const u8{ "parser", "modules", "resources", "flow", "gateway_values", "gateway_invalid", "gateway_structure", "store/invalid", "store/values" }) |name| {
        const tests = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/rx/text/{s}_test.zig", .{name})),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "rx", .module = rx.module("rx") }},
            }),
        });

        tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });

        const run = b.addRunArtifact(tests);

        text_step.dependOn(&run.step);
    }

    test_step.dependOn(text_step);
    test_step.dependOn(@import("build/rx_attributes.zig").add(b, compiler, cli_dependency, target, optimize));

    const cli_step = b.step("test-rx-cli", "Validate RX command line file loading and diagnostics");
    const cli = b.addSystemCommand(&.{"node"});

    cli.addFileArg(b.path("tests/rx/cli/check_test.ts"));
    cli.addArtifactArg(cli_dependency.artifact("zxc"));
    cli_step.dependOn(&cli.step);
    test_step.dependOn(cli_step);

    const store_paths_step = b.step("test-rx-store-paths", "Validate Store physical paths through the CLI");
    const store_paths = b.addSystemCommand(&.{"node"});

    store_paths.addFileArg(b.path("tests/rx/cli/store_paths_test.ts"));
    store_paths.addArtifactArg(cli_dependency.artifact("zxc"));
    store_paths_step.dependOn(&store_paths.step);
    cli_step.dependOn(store_paths_step);

    const state_app_step = b.step("test-rx-state-app", "Execute generated application lifetime Store state without persistence");
    const state_app = b.addSystemCommand(&.{"node"});

    state_app.addFileArg(b.path("tests/rx/cli/state_app_test.ts"));

    for ([_][]const u8{ "main.rx", "write_left.rx", "write_right.rx", "left.store.rx", "right.store.rx", "advance.zx", "snapshot.zx" }) |name| {
        state_app.addFileInput(b.path(b.fmt("tests/rx/runtime/store/dual/fixtures/{s}", .{name})));
    }

    state_app.addArtifactArg(cli_dependency.artifact("zxc"));
    state_app_step.dependOn(&state_app.step);
    cli_step.dependOn(state_app_step);

    const rx_project_cli_step = b.step("test-rx-project-cli", "Build and validate real RX disk projects");
    const rx_project_cli = b.addSystemCommand(&.{"node"});

    rx_project_cli.addFileArg(b.path("tests/rx/cli/project_test.ts"));
    rx_project_cli.addFileInput(b.path("tests/rx/cli/project_cases.ts"));
    rx_project_cli.addArtifactArg(cli_dependency.artifact("zxc"));
    rx_project_cli_step.dependOn(&rx_project_cli.step);
    cli_step.dependOn(rx_project_cli_step);

    const rx_watch_step = b.step("test-rx-watch", "Validate RX watch dependency tracking and recovery");
    const rx_watch = b.addSystemCommand(&.{"node"});

    rx_watch.addFileArg(b.path("tests/rx/cli/watch_test.ts"));
    rx_watch.addFileInput(b.path("tests/rx/cli/project_cases.ts"));
    rx_watch.addArtifactArg(cli_dependency.artifact("zxc"));
    rx_watch_step.dependOn(&rx_watch.step);
    cli_step.dependOn(rx_watch_step);

    const manifest_step = b.step("test-package-manifest", "Validate package manifests and workspace discovery through public commands");

    for ([_][]const u8{ "inspect", "workspace", "graph", "import", "init" }) |name| {
        const manifest = b.addSystemCommand(&.{"node"});

        manifest.addFileArg(b.path(b.fmt("tests/package_manifest/{s}_test.ts", .{name})));
        manifest.addFileInput(b.path(b.fmt("tests/package_manifest/{s}_cases.ts", .{name})));

        if (std.mem.eql(u8, name, "graph")) manifest.addFileInput(b.path("tests/package_manifest/range_cases.ts"));

        if (std.mem.eql(u8, name, "inspect")) {
            manifest.addFileInput(b.path("tests/package_manifest/native_cases.ts"));
            manifest.addFileInput(b.path("tests/package_manifest/native_flags_cases.ts"));
            manifest.addFileInput(b.path("tests/package_manifest/module_scope_cases.ts"));
            manifest.addFileInput(b.path("tests/package_manifest/export_cases.ts"));
        }

        if (std.mem.eql(u8, name, "import")) manifest.addFileInput(b.path("tests/package_manifest/export_import_cases.ts"));

        manifest.addArtifactArg(cli_dependency.artifact("zxc"));
        manifest_step.dependOn(&manifest.step);
    }

    test_step.dependOn(manifest_step);
    test_step.dependOn(@import("build/library_publish.zig").add(b, cli_dependency));
    test_step.dependOn(@import("build/semantic_lint.zig").add(b, cli_dependency));
    test_step.dependOn(@import("build/rx_formatting.zig").add(b, cli_dependency, compiler, target, optimize));
    test_step.dependOn(@import("build/configuration_formatting.zig").add(b, cli_dependency, compiler, target, optimize));
    test_step.dependOn(@import("build/compiled_packages.zig").add(b, cli_dependency, compiler, target, optimize));
    test_step.dependOn(@import("build/manifest_resources.zig").add(b, cli_dependency, compiler, target, optimize));

    const archive_step = b.step("test-package-archive", "Validate package archive integrity paths extraction and resources");

    const archive_module = b.createModule(.{
        .root_source_file = cli_dependency.path("src/package/archive.zig"),
        .target = target,
        .optimize = optimize,
    });

    for ([_][]const u8{ "content", "structure", "paths" }) |name| {
        const archive_tests = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/package_archive/{s}_test.zig", .{name})),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "package_archive", .module = archive_module }},
            }),
        });

        archive_tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        archive_step.dependOn(&b.addRunArtifact(archive_tests).step);
    }

    const archive_check = b.addSystemCommand(&.{"node"});

    archive_check.addFileArg(b.path("src/generate_package_archives.ts"));
    archive_check.addFileInput(b.path("src/shared/tar.ts"));
    archive_check.addArg("--check");
    archive_step.dependOn(&archive_check.step);
    test_step.dependOn(archive_step);

    const install_step = b.step("test-package-install", "Validate installed transitive versions real applications offline recovery and failure preservation");

    for ([_][]const u8{ "runtime", "failure", "boundaries", "integrity" }) |name| {
        const install_tests = b.addSystemCommand(&.{"node"});

        install_tests.addFileArg(b.path(b.fmt("tests/package_install/{s}_test.ts", .{name})));
        install_tests.addFileInput(b.path("tests/package_install/fixture.ts"));
        install_tests.addFileInput(b.path("tests/package_install/registry.ts"));
        install_tests.addFileInput(b.path("src/shared/tar.ts"));
        install_tests.addArtifactArg(cli_dependency.artifact("zxc"));
        install_step.dependOn(&install_tests.step);
    }

    test_step.dependOn(install_step);

    const install_watch_step = b.step("test-package-install-watch", "Validate live watch recovery across install lock and mapping changes");
    const install_watch = b.addSystemCommand(&.{"node"});

    install_watch.addFileArg(b.path("tests/package_install/watch_test.ts"));
    install_watch.addFileInput(b.path("tests/package_install/fixture.ts"));
    install_watch.addFileInput(b.path("tests/package_install/registry.ts"));
    install_watch.addFileInput(b.path("src/shared/tar.ts"));
    install_watch.addArtifactArg(cli_dependency.artifact("zxc"));
    install_watch_step.dependOn(&install_watch.step);
    test_step.dependOn(install_watch_step);

    const native_packages_step = b.step("test-native-packages", "Validate installed native module isolation object ABI and republished libraries");
    const native_packages = b.addSystemCommand(&.{"node"});

    native_packages.addFileArg(b.path("tests/package_native/runtime_test.ts"));
    native_packages.addFileInput(b.path("tests/package_native/fixture.ts"));
    native_packages.addFileInput(b.path("tests/package_native/archive.ts"));
    native_packages.addFileInput(b.path("src/shared/tar.ts"));
    native_packages.addArtifactArg(cli_dependency.artifact("zxc"));
    native_packages_step.dependOn(&native_packages.step);
    test_step.dependOn(native_packages_step);

    const native_aliases_step = b.step("test-native-aliases", "Validate native ABI alias resolution canonical identity and rejection");
    const native_aliases = b.addSystemCommand(&.{"node"});

    native_aliases.addFileArg(b.path("tests/package_native/alias_test.ts"));
    native_aliases.addFileInput(b.path("tests/package_native/alias_fixture.ts"));
    native_aliases.addArtifactArg(cli_dependency.artifact("zxc"));
    native_aliases_step.dependOn(&native_aliases.step);
    test_step.dependOn(native_aliases_step);

    const index_step = b.step("test-package-index", "Validate package indexes and release selection through public commands");
    const index_tests = b.addSystemCommand(&.{"node"});

    index_tests.addFileArg(b.path("tests/package_index/index_test.ts"));
    index_tests.addFileInput(b.path("tests/package_index/cases.ts"));
    index_tests.addArtifactArg(cli_dependency.artifact("zxc"));
    index_step.dependOn(&index_tests.step);
    test_step.dependOn(index_step);

    const pkgs = b.dependency("pkgs", .{ .target = target, .optimize = optimize });
    const store_step = b.step("test-package-store", "Validate package store publication offline cache integrity and resources");

    const store_module = b.createModule(.{
        .root_source_file = cli_dependency.path("src/package/store.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "pkgs", .module = pkgs.module("pkgs") }},
    });

    const archive_data = b.createModule(.{
        .root_source_file = b.path("tests/package_archive/data.zig"),
        .target = target,
        .optimize = optimize,
    });

    for ([_][]const u8{ "lifecycle", "integrity", "resources" }) |name| {
        const store_tests = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/package_store/{s}_test.zig", .{name})),
                .target = target,
                .optimize = optimize,
                .imports = &.{ .{ .name = "package_store", .module = store_module }, .{ .name = "pkgs", .module = pkgs.module("pkgs") }, .{ .name = "archive_data", .module = archive_data } },
            }),
        });

        store_tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        store_step.dependOn(&b.addRunArtifact(store_tests).step);
    }

    store_step.dependOn(&archive_check.step);
    test_step.dependOn(store_step);

    const package_http_step = b.step("test-package-http", "Validate real HTTP package downloads and concurrent cache publication");

    const package_driver = b.addExecutable(.{
        .name = "package-store-driver",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/package_store/http/driver.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "package_store", .module = store_module }},
        }),
    });

    for ([_][]const u8{ "download", "cache", "rejection" }) |name| {
        const package_http = b.addSystemCommand(&.{"node"});

        package_http.addFileArg(b.path(b.fmt("tests/package_store/http/{s}_test.ts", .{name})));
        package_http.addFileInput(b.path("tests/package_store/http/run_driver.ts"));
        package_http.addFileInput(b.path("tests/package_store/http/server.ts"));
        package_http.addFileInput(b.path("tests/package_archive/fixtures/valid.tgz"));
        package_http.addArtifactArg(package_driver);
        package_http_step.dependOn(&package_http.step);
    }

    package_http_step.dependOn(&archive_check.step);
    test_step.dependOn(package_http_step);

    const lock_graph_step = b.step("test-package-lock-graphs", "Validate locked dependency graph cycles depth order and resources");

    for ([_][]const u8{ "graphs", "resources", "workspace/target" }) |name| {
        const lock_tests = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/package_lock/{s}_test.zig", .{name})),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "pkgs", .module = pkgs.module("pkgs") }},
            }),
        });

        lock_tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        lock_graph_step.dependOn(&b.addRunArtifact(lock_tests).step);
    }

    test_step.dependOn(lock_graph_step);

    const lock_parse_step = b.step("test-package-lock-parsing", "Validate strict lock parsing source ownership and allocation failures");

    for ([_][]const u8{ "invalid", "ownership" }) |name| {
        const lock_tests = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/package_lock/parsing/{s}_test.zig", .{name})),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "pkgs", .module = pkgs.module("pkgs") }},
            }),
        });

        lock_tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        lock_parse_step.dependOn(&b.addRunArtifact(lock_tests).step);
    }

    test_step.dependOn(lock_parse_step);

    const index_resources_step = b.step("test-package-index-resources", "Validate package index allocation failures and owned data");

    const index_resources = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/package_index/resources_test.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "pkgs", .module = pkgs.module("pkgs") }},
        }),
    });

    index_resources.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
    index_resources_step.dependOn(&b.addRunArtifact(index_resources).step);
    test_step.dependOn(index_resources_step);

    const json_enum_step = b.step("test-json-enum", "Validate generated application enum JSON input and output");
    const json_enum_tests = b.addSystemCommand(&.{"node"});

    json_enum_tests.addFileArg(b.path("tests/runtime/json/enum_test.ts"));
    json_enum_tests.addFileInput(b.path("tests/runtime/json/enum_cases.ts"));
    json_enum_tests.addArtifactArg(cli_dependency.artifact("zxc"));
    json_enum_step.dependOn(&json_enum_tests.step);
    test_step.dependOn(json_enum_step);

    const json_integer_step = b.step("test-json-integer", "Validate exact integer JSON precision and range in applications");
    const json_integer_tests = b.addSystemCommand(&.{"node"});

    json_integer_tests.addFileArg(b.path("tests/runtime/json/integer_test.ts"));
    json_integer_tests.addFileInput(b.path("tests/runtime/json/integer_cases.ts"));
    json_integer_tests.addArtifactArg(cli_dependency.artifact("zxc"));
    json_integer_step.dependOn(&json_integer_tests.step);
    test_step.dependOn(json_integer_step);

    const protocol_step = b.step("test-app-protocol", "Validate generated application arguments output and failure protocol");
    const protocol_tests = b.addSystemCommand(&.{"node"});

    protocol_tests.addFileArg(b.path("tests/runtime/json/protocol_test.ts"));
    protocol_tests.addFileInput(b.path("tests/runtime/json/protocol_cases.ts"));
    protocol_tests.addArtifactArg(cli_dependency.artifact("zxc"));
    protocol_step.dependOn(&protocol_tests.step);
    test_step.dependOn(protocol_step);

    const toolchain_step = b.step("test-toolchain", "Build and run with only the relocated embedded compiler");
    const toolchain_tests = b.addSystemCommand(&.{"node"});

    toolchain_tests.addFileArg(b.path("tests/toolchain/standalone_test.ts"));
    toolchain_tests.addArtifactArg(cli_dependency.artifact("zxc"));
    toolchain_step.dependOn(&toolchain_tests.step);
    test_step.dependOn(toolchain_step);

    const toolchain_concurrency_step = b.step("test-toolchain-concurrency", "Validate concurrent embedded toolchain extraction");
    const persistent_step = b.step("test-persistent-cache", "Validate cross process semantic cache persistence and recovery");
    const persistent = b.addSystemCommand(&.{"node"});

    persistent.addFileArg(b.path("tests/incremental/persistent_cache/cache_test.ts"));
    persistent.addArtifactArg(cli_dependency.artifact("zxc"));
    persistent.addArg(b.graph.zig_exe);
    persistent_step.dependOn(&persistent.step);
    test_step.dependOn(persistent_step);

    const generation_runtime_step = b.step("test-generation-runtime", "Execute split apps with persistent generation cache and recovery");
    const generation_runtime = b.addSystemCommand(&.{"node"});

    generation_runtime.addFileArg(b.path("tests/incremental/generation_runtime/runtime_test.ts"));
    generation_runtime.addArtifactArg(cli_dependency.artifact("zxc"));
    generation_runtime_step.dependOn(&generation_runtime.step);
    test_step.dependOn(generation_runtime_step);

    const native_generation_step = b.step("test-native-generation", "Execute native object ABI across generation cache reuse and type reordering");
    const native_generation = b.addSystemCommand(&.{"node"});

    native_generation.addFileArg(b.path("tests/incremental/generation_runtime/native_test.ts"));
    native_generation.addArtifactArg(cli_dependency.artifact("zxc"));
    native_generation_step.dependOn(&native_generation.step);
    test_step.dependOn(native_generation_step);

    const toolchain_concurrency = b.addSystemCommand(&.{"node"});

    toolchain_concurrency.addFileArg(b.path("tests/toolchain/concurrent_test.ts"));
    toolchain_concurrency.addArtifactArg(cli_dependency.artifact("zxc"));
    toolchain_concurrency_step.dependOn(&toolchain_concurrency.step);
    test_step.dependOn(toolchain_concurrency_step);

    const standard_step = b.step("test-standard-resources", "Validate standard library errors and allocation cleanup");

    for ([_][]const u8{ "allocation", "crypto", "querystring", "zlib/compress", "zlib/decompress", "url_search_params/codec", "url_search_params/update", "url_search_params/lists", "url_search_params/views" }) |name| {
        const standard_tests = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/standard/resources/{s}_test.zig", .{name})),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "standard", .module = compiler.module("standard") }},
            }),
        });

        standard_tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });

        const standard_run = b.addRunArtifact(standard_tests);

        standard_step.dependOn(&standard_run.step);
    }

    standard_step.dependOn(@import("build/url_file.zig").add(b, compiler, target, optimize));
    standard_step.dependOn(@import("build/url_api_resources.zig").add(b, compiler, target, optimize));
    standard_step.dependOn(@import("build/url_parser.zig").add(b, compiler, target, optimize));
    standard_step.dependOn(@import("build/url_host.zig").add(b, compiler, target, optimize));
    standard_step.dependOn(@import("build/url_idna.zig").add(b, compiler, target, optimize));
    standard_step.dependOn(@import("build/url_punycode.zig").add(b, compiler, target, optimize));
    standard_step.dependOn(@import("build/url_nfc.zig").add(b, compiler, target, optimize));
    standard_step.dependOn(@import("build/url_primitives.zig").add(b, compiler, target, optimize));
    standard_step.dependOn(@import("build/standard_fs.zig").add(b, compiler, target, optimize));
    standard_step.dependOn(@import("build/child_input.zig").add(b, compiler, target, optimize));
    standard_step.dependOn(@import("build/child_process.zig").add(b, compiler, cli_dependency, target, optimize));
    standard_step.dependOn(@import("build/process_context.zig").add(b, compiler, target, optimize));
    standard_step.dependOn(@import("build/process_stdio.zig").add(b, compiler, cli_dependency, target, optimize));
    standard_step.dependOn(@import("build/http.zig").add(b, compiler, cli_dependency, target, optimize));
    test_step.dependOn(standard_step);
    test_step.dependOn(@import("build/module_graphs.zig").add(b, rx, target, optimize, suites.module_graphs));

    const graph_check = b.addSystemCommand(&.{"node"});

    graph_check.addFileArg(b.path("src/generate_module_graphs.ts"));
    graph_check.addArg("--check");
    test_step.dependOn(&graph_check.step);

    for ([_][]const u8{ "src/generate_arrow_bodies.ts", "src/generate_regexp_comments.ts", "src/generate_primitive_literals.ts", "src/generate_string_source.ts", "src/generate_exponent_names.ts", "src/generate_decimal_literals.ts", "src/generate_identifier_digits.ts", "src/generate_ascii_identifiers.ts", "src/generate_keyword_bindings.ts", "src/generate_comment_characters.ts", "src/generate_comment_terminators.ts", "src/generate_comment_exposure.ts", "src/generate_whitespace_positions.ts", "src/generate_whitespace_rejections.ts", "src/generate_string_terminators.ts", "src/generate_call_remaining.ts", "src/generate_call_spread_protocols.ts", "src/generate_call_object_spread.ts", "src/generate_call_arguments.ts", "src/generate_optional_chain_remaining.ts", "src/generate_optional_chain_boundary.ts", "src/generate_member_base.ts", "src/generate_call_basics.ts", "src/generate_property_remaining.ts", "src/generate_property_lookup.ts", "src/generate_property_primitives.ts", "src/generate_coalesce_mixing.ts", "src/generate_grouping_values.ts", "src/generate_template_remaining.ts", "src/generate_template_segments.ts", "src/generate_template_escapes.ts", "src/generate_template_calls.ts", "src/generate_template_newlines.ts", "src/generate_template_members.ts", "src/generate_template_order.ts", "src/generate_template_primitives.ts", "src/generate_template_delimiters.ts", "src/generate_template_characters.ts", "src/generate_template_nested.ts", "src/generate_nested_collections.ts", "src/generate_bare_blocks.ts", "src/generate_block_syntax.ts", "src/generate_switch_redeclarations.ts", "src/generate_switch_declarations.ts", "src/generate_switch_environment.ts", "src/generate_switch_nested.ts", "src/generate_switch_scope.ts", "src/generate_switch_scalars.ts", "src/generate_switch_statement.ts", "src/generate_return_top_level.ts", "src/generate_return_statement.ts", "src/generate_if_remaining.ts", "src/generate_if_declarations.ts", "src/generate_if_truthiness.ts", "src/generate_if_nested.ts", "src/generate_if_statement.ts", "src/generate_object_computed.ts", "src/generate_object_shorthand.ts", "src/generate_object_fields.ts", "src/generate_array_spread_protocols.ts", "src/generate_array_spread_errors.ts", "src/generate_array_spread.ts", "src/generate_object_duplicate.ts", "src/generate_object_construction.ts", "src/generate_array_order.ts", "src/generate_array_callbacks.ts", "src/generate_array_pop.ts", "src/generate_tuple_bindings.ts", "src/generate_const_initializers.ts", "src/generate_array_literal.ts", "src/generate_unary_plus_boundary.ts", "src/generate_match_ownership.ts", "src/generate_match_modules.ts", "src/generate_relational_names.ts", "src/generate_relational_whitespace.ts", "src/generate_less_than_conversion.ts", "src/generate_relational_conversion.ts", "src/generate_relational_string_conversion.ts", "src/generate_relational_assignment.ts", "src/generate_relational_string_order.ts", "src/generate_subtraction_names.ts", "src/generate_subtraction_order.ts", "src/generate_subtraction_conversion.ts", "src/generate_subtraction_whitespace.ts", "src/generate_multiplication_conversion.ts", "src/generate_multiplication_whitespace.ts", "src/generate_multiplication_order.ts", "src/generate_division_conversion.ts", "src/generate_division_whitespace.ts", "src/generate_division_order.ts", "src/generate_division_names.ts", "src/generate_modulus_conversion.ts", "src/generate_modulus_whitespace.ts", "src/generate_modulus_order.ts", "src/generate_modulus_names.ts", "src/generate_addition_names.ts", "src/generate_addition_whitespace.ts", "src/generate_addition_order.ts", "src/generate_addition_strings.ts", "src/generate_addition_conversion.ts", "src/generate_equality_names.ts", "src/generate_equality_assignment.ts", "src/generate_equality_whitespace.ts", "src/generate_aggregate_equality.ts", "src/generate_optional_equality.ts", "src/generate_null_inequality.ts", "src/generate_reverse_projections.ts", "src/generate_json_lexical.ts", "src/generate_string_storage.ts", "src/generate_optional_floating.ts", "src/generate_equality_conversion.ts", "src/generate_boolean_inequality.ts", "src/generate_optional_enum.ts", "src/generate_relational_strings.ts", "src/generate_relational_source.ts", "src/generate_comparison_trace.ts", "src/generate_match_default.ts", "src/generate_match_scalars.ts", "src/generate_match_floating.ts", "src/generate_match_frontend.ts", "src/generate_match_trace.ts", "src/generate_selection_identity.ts", "src/generate_coalesce_values.ts", "src/generate_coalesce_logical.ts", "src/generate_coalesce_trace.ts", "src/generate_conditional.ts", "src/generate_logical_assignment.ts", "src/generate_logical_trace.ts", "src/generate_logical_binary.ts", "src/generate_zlib.ts", "src/generate_url_api.ts", "src/generate_url_search_params.ts", "src/generate_querystring.ts", "src/generate_crypto_kdf.ts", "src/generate_crypto_aead.ts", "src/generate_primitive_equality.ts", "src/generate_remainder.ts", "src/generate_path_resolution.ts", "src/generate_paths.ts", "src/generate_addition_grouping.ts", "src/generate_subtraction.ts", "src/generate_addition.ts", "src/generate_operand_errors.ts", "src/generate_multiplication_names.ts", "src/generate_multiplication_grouping.ts", "src/generate_multiplication.ts", "src/generate_standard_errors.ts", "src/generate_standard.ts", "src/generate_division.ts", "src/generate_comments.ts", "src/generate_store.ts", "src/generate_logical_not.ts", "src/generate_block_comments.ts", "src/generate_unary_minus.ts", "src/generate_module_paths.ts", "src/generate_float_comparisons.ts", "src/generate_division_grouping.ts", "src/generate_lexical.ts", "src/generate_numeric_boundaries.ts", "src/generate_string_lexical.ts", "src/generate_control.ts", "src/generate_operator_types.ts", "src/generate_integer_safety.ts", "src/generate_compound_integer.ts", "src/generate_numeric_literals.ts", "src/generate_ownership.ts", "src/generate_collections.ts", "src/generate_strings.ts", "src/generate_state_updates.ts", "src/generate_compound_whitespace.ts", "src/generate_compound_references.ts", "src/generate_assignment_boundaries.ts", "src/audit_matrix.ts" }) |script| {
        const check = b.addSystemCommand(&.{"node"});

        check.addFileArg(b.path(script));

        if (std.mem.eql(u8, script, "src/generate_compound_integer.ts")) {
            for ([_][]const u8{ "source.ts", "cases.ts", "evaluate.ts" }) |name| {
                check.addFileInput(b.path(b.fmt("src/compound_integer/{s}", .{name})));
            }
        }

        if (std.mem.eql(u8, script, "src/generate_assignment_boundaries.ts")) check.addFileInput(b.path("src/data/assignment_boundaries.json"));

        if (std.mem.eql(u8, script, "src/generate_compound_whitespace.ts")) {
            check.addFileInput(b.path("src/compound_whitespace/source.ts"));
            check.addFileInput(b.path("src/data/compound_whitespace.json"));
        }

        if (std.mem.eql(u8, script, "src/generate_compound_references.ts")) {
            check.addFileInput(b.path("src/compound_references/source.ts"));
            check.addFileInput(b.path("src/data/compound_references.json"));
        }

        if (std.mem.eql(u8, script, "src/generate_state_updates.ts")) {
            check.addFileInput(b.path("src/state_updates/source.ts"));
            check.addFileInput(b.path("src/data/state_update_upstream.json"));

            for ([_][]const u8{ "addition", "subtraction", "multiplication", "division", "modulus" }) |model| {
                for ([_][]const u8{ "f32", "f64" }) |scalar| {
                    check.addFileInput(b.path(b.fmt("tests/language/expressions/{s}/{s}.jsonl", .{ model, scalar })));
                }
            }
        }

        if (std.mem.eql(u8, script, "src/generate_url_search_params.ts")) for ([_][]const u8{ "samples.ts", "parse_cases.ts", "write_suite.ts" }) |name| {
            check.addFileInput(b.path(b.fmt("src/url_search_params/{s}", .{name})));
        };

        if (std.mem.eql(u8, script, "src/generate_url_api.ts")) {
            for ([_][]const u8{ "record.ts", "write_suite.ts", "wpt.ts", "file_cases.ts" }) |name| {
                check.addFileInput(b.path(b.fmt("src/url_api/{s}", .{name})));
            }

            check.addFileInput(b.path("upstream/wpt/lock.json"));
            check.addFileInput(b.path("upstream/wpt/url/resources/urltestdata.json"));
            check.addFileInput(b.path("../../docs/2026-10-05/文件URL验证/参考用例.json"));
        }

        if (std.mem.eql(u8, script, "src/generate_querystring.ts")) {
            check.addFileInput(b.path("src/querystring/percent_cases.ts"));
            check.addFileInput(b.path("src/data/querystring_uri.jsonl"));
        }

        if (std.mem.eql(u8, script, "src/generate_switch_statement.ts")) check.addFileInput(b.path("src/data/switch_statement.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_return_top_level.ts")) check.addFileInput(b.path("src/data/return_top_level.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_return_statement.ts")) check.addFileInput(b.path("src/data/return_statement.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_switch_nested.ts")) check.addFileInput(b.path("src/data/switch_nested.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_switch_environment.ts")) check.addFileInput(b.path("src/data/switch_environment.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_block_syntax.ts")) check.addFileInput(b.path("src/data/block_syntax.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_template_nested.ts")) check.addFileInput(b.path("src/data/template_nested.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_template_characters.ts")) check.addFileInput(b.path("src/data/template_characters.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_template_primitives.ts")) check.addFileInput(b.path("src/data/template_primitives.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_template_order.ts")) check.addFileInput(b.path("src/data/template_order.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_template_members.ts")) check.addFileInput(b.path("src/data/template_members.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_string_source.ts")) check.addFileInput(b.path("src/data/string_source.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_string_terminators.ts")) check.addFileInput(b.path("src/data/string_terminators.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_whitespace_rejections.ts")) check.addFileInput(b.path("src/data/whitespace_rejections.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_whitespace_positions.ts")) check.addFileInput(b.path("src/data/whitespace_positions.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_comment_exposure.ts")) check.addFileInput(b.path("src/data/comment_exposure.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_comment_terminators.ts")) check.addFileInput(b.path("src/data/comment_terminators.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_comment_characters.ts")) check.addFileInput(b.path("src/data/comment_characters.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_keyword_bindings.ts")) check.addFileInput(b.path("src/data/keyword_bindings.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_ascii_identifiers.ts")) check.addFileInput(b.path("src/data/ascii_identifiers.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_decimal_literals.ts")) check.addFileInput(b.path("src/data/decimal_literals.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_call_remaining.ts")) check.addFileInput(b.path("src/data/call_remaining.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_call_spread_protocols.ts")) check.addFileInput(b.path("src/data/call_spread_protocols.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_call_object_spread.ts")) check.addFileInput(b.path("src/data/call_object_spread.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_call_arguments.ts")) check.addFileInput(b.path("src/data/call_arguments.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_optional_chain_remaining.ts")) check.addFileInput(b.path("src/data/optional_chain_remaining.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_optional_chain_boundary.ts")) check.addFileInput(b.path("src/data/optional_chain_boundary.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_member_base.ts")) check.addFileInput(b.path("src/data/member_base.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_arrow_bodies.ts")) check.addFileInput(b.path("src/data/arrow_bodies.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_call_basics.ts")) check.addFileInput(b.path("src/data/call_basics.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_property_remaining.ts")) check.addFileInput(b.path("src/data/property_remaining.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_property_lookup.ts")) check.addFileInput(b.path("src/data/property_lookup.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_property_primitives.ts")) check.addFileInput(b.path("src/data/property_primitives.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_coalesce_mixing.ts")) check.addFileInput(b.path("src/data/coalesce_mixing.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_grouping_values.ts")) check.addFileInput(b.path("src/data/grouping_values.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_template_remaining.ts")) check.addFileInput(b.path("src/data/template_remaining.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_template_segments.ts")) check.addFileInput(b.path("src/data/template_segments.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_template_escapes.ts")) check.addFileInput(b.path("src/data/template_escapes.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_template_calls.ts")) check.addFileInput(b.path("src/data/template_calls.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_template_newlines.ts")) check.addFileInput(b.path("src/data/template_newlines.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_if_remaining.ts")) check.addFileInput(b.path("src/data/if_remaining.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_if_declarations.ts")) check.addFileInput(b.path("src/data/if_declarations.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_if_truthiness.ts")) check.addFileInput(b.path("src/data/if_truthiness.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_if_nested.ts")) check.addFileInput(b.path("src/data/if_nested.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_if_statement.ts")) check.addFileInput(b.path("src/data/if_statement.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_object_computed.ts")) check.addFileInput(b.path("src/data/object_computed.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_object_shorthand.ts")) check.addFileInput(b.path("src/data/object_shorthand.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_object_fields.ts")) check.addFileInput(b.path("src/data/object_fields.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_array_spread_protocols.ts")) check.addFileInput(b.path("src/data/array_spread_protocols.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_array_spread_errors.ts")) check.addFileInput(b.path("src/data/array_spread_errors.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_array_spread.ts")) check.addFileInput(b.path("src/data/array_spread.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_object_duplicate.ts")) check.addFileInput(b.path("src/data/object_duplicate.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_object_construction.ts")) check.addFileInput(b.path("src/data/object_construction.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_array_order.ts")) check.addFileInput(b.path("src/data/array_properties.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_array_callbacks.ts")) check.addFileInput(b.path("src/data/array_callbacks.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_const_initializers.ts")) check.addFileInput(b.path("src/data/const_initializers.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_array_pop.ts")) check.addFileInput(b.path("src/data/array_pop.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_array_literal.ts")) check.addFileInput(b.path("src/data/array_literal.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_unary_plus_boundary.ts")) check.addFileInput(b.path("src/data/unary_plus_boundary.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_relational_whitespace.ts")) check.addFileInput(b.path("src/data/relational_whitespace.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_less_than_conversion.ts")) check.addFileInput(b.path("src/data/less_than_conversion.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_relational_conversion.ts")) check.addFileInput(b.path("src/data/relational_conversion.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_relational_string_conversion.ts")) check.addFileInput(b.path("src/data/relational_string_conversion.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_relational_assignment.ts")) check.addFileInput(b.path("src/data/relational_assignment.jsonl"));
        if (std.mem.eql(u8, script, "src/generate_relational_string_order.ts")) check.addFileInput(b.path("src/data/relational_string_order.jsonl"));
        if (!std.mem.eql(u8, script, "src/audit_matrix.ts")) check.addArg("--check");

        test_step.dependOn(&check.step);
    }
}
