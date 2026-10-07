const std = @import("std");
const Suite = @import("catalog.zig").RuntimeSuite;
const application_json = @import("application_json.zig");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, cli: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, suites: []const Suite) *std.Build.Step {
    const step = b.step("test-runtime", "Run conformance cases through generated Zig");
    const owned_step = b.step("test-owned-collections", "Run collection cases with locally constructed owners");
    const floating_step = b.step("test-floating", "Run exact floating bit-pattern conformance cases");
    const standard_step = b.step("test-standard-runtime", "Run standard interfaces through their shared ABI");
    const logical_step = b.step("test-logical-binary", "Run logical AND and OR source and short circuit cases");
    const zlib_step = b.step("test-zlib", "Run independent compressed input and decompression boundary cases");
    const url_search_params_step = b.step("test-url-search-params", "Execute immutable URL query list operations and encoding boundaries");
    const url_api_step = b.step("test-url-api", "Execute all public URL APIs through ZX and shared native ABI");
    const querystring_step = b.step("test-querystring", "Run querystring semantic cases through the shared ABI");
    const match_modules_step = b.step("test-match-modules", "Execute cross module match enum identity and lazy patterns");
    const relational_whitespace_step = b.step("test-relational-whitespace", "Run original relational whitespace expressions and numeric boundaries");
    const null_inequality_step = b.step("test-null-inequality", "Execute typed null inequality observations and existing boolean numeric controls");
    const call_object_spread_step = b.step("test-call-object-spread", "Execute object spread arguments across imported functions");
    const call_arguments_step = b.step("test-call-arguments", "Execute imported single-input calls with trailing commas");
    const call_whitespace_step = b.step("test-call-whitespace", "Execute imported calls separated from arguments by whitespace");
    const property_whitespace_step = b.step("test-property-whitespace", "Execute static member access with whitespace");
    const property_lookup_step = b.step("test-property-lookup", "Execute own property lookup assertions");
    const property_step = b.step("test-property-primitives", "Execute supported primitive property access assertions");
    const arrow_bodies_step = b.step("test-arrow-bodies", "Execute inline arrow expression bodies and post-arrow line endings");
    const grouping_step = b.step("test-grouping-values", "Execute grouping values and whitespace cases");
    const template_segments_step = b.step("test-template-segments", "Execute empty and nonempty template text segments");
    const template_calls_step = b.step("test-template-calls", "Execute function results in template interpolation positions");
    const template_newlines_step = b.step("test-template-newlines", "Execute raw template newline normalization and escape controls");
    const template_members_step = b.step("test-template-members", "Execute member values inside template interpolation");
    const template_primitives_step = b.step("test-template-primitives", "Execute primitive template interpolation values");
    const template_delimiters_step = b.step("test-template-delimiters", "Execute quoted and commented interpolation boundaries");
    const template_characters_step = b.step("test-template-characters", "Execute template escapes and literal interpolation markers");
    const template_step = b.step("test-template-nesting", "Execute original and dynamic nested template literals");
    const tuple_bindings_step = b.step("test-tuple-bindings", "Execute static tuple binding order mixed types and discarded slots");
    const application_json_step = b.step("test-application-json", "Execute raw JSON lexical cases through generated native Wasm and WASI applications");
    const application_json_output_step = b.step("test-application-json-output", "Execute finite and non-finite JSON output boundaries in native Wasm and WASI applications");
    const application_json_gateway_step = @import("application_json_gateway.zig").add(b, cli, optimize, suites);
    const list_reverse_step = b.step("test-list-reverse", "Execute owned reverse cases and original dense value projections");
    const array_pop_step = b.step("test-array-pop", "Execute empty pop after explicit list removal");
    const array_callbacks_step = b.step("test-array-callbacks", "Execute upstream dense array callback values seed and ordering");
    const reduce_observers_step = b.step("test-reduce-observers", "Execute reduce invocation counts and accumulator argument traces");
    const every_observers_step = b.step("test-every-observers", "Execute universal predicate results stopping counts and input preservation");
    const nested_collections_step = b.step("test-nested-collections", "Execute nested collection callbacks and restored scopes");
    const nested_step = b.step("test-switch-nested", "Execute nested switch selection");
    const scope_step = b.step("test-switch-scope", "Execute switch branch-local bindings");
    const switch_step = b.step("test-switch-scalars", "Execute switch scalar and enum matching");
    const return_step = b.step("test-return-statements", "Execute return line terminator semantics");
    const object_step = b.step("test-object-construction", "Execute object spread merge and override values");
    const array_literal_step = b.step("test-array-literal", "Execute original dense and nested array literal checks");
    const whitespace_positions_step = b.step("test-whitespace-positions", "Execute raw whitespace in code and strings");
    const comment_terminators_step = b.step("test-comment-terminators", "Execute code immediately following comment line terminators");
    const comment_characters_step = b.step("test-comment-characters", "Execute original comment control and Unicode characters");
    const regexp_comments_step = b.step("test-regexp-comments", "Execute comment boundaries found in regular expression cases");
    const string_source_step = b.step("test-string-source", "Execute original Unicode string source characters");
    const identifier_digits_step = b.step("test-identifier-digits", "Execute digit positions and distinct identifier bindings");
    const identifiers_step = b.step("test-ascii-identifiers", "Execute original ASCII identifier bindings");
    const decimal_step = b.step("test-decimal-original", "Execute original decimal and exponent literal values");
    const strings_step = b.step("test-strings", "Run string values and owned string collection cases");
    const list_range_step = b.step("test-list-range", "Execute strict dynamic list ranges and preserve caller values");
    const string_index_step = b.step("test-string-index", "Execute UTF-8 string byte indexing bounds decoding and lazy reads");

    step.dependOn(application_json_gateway_step);
    application_json_output_step.dependOn(application_json_gateway_step);

    for (suites) |suite| {
        if (suite.kind == .application_json) {
            const run = application_json.add(b, cli, optimize, suite);

            step.dependOn(run);
            application_json_step.dependOn(run);

            if (std.mem.startsWith(u8, suite.name, "application-json-output-")) application_json_output_step.dependOn(run);

            continue;
        }

        const base = b.fmt("tests/{s}", .{suite.path});
        const compile_case = b.addRunArtifact(cli.artifact("zxc"));

        compile_case.addFileArg(b.path(b.fmt("{s}.zx", .{base})));

        for (suite.sources) |source| compile_case.addFileInput(b.path(b.fmt("tests/{s}", .{source})));

        compile_case.addArg("--out");

        const program_source = compile_case.addOutputFileArg("program.zig");
        const generate = b.addSystemCommand(&.{"node"});
        const uses_bits = suite.kind == .floating or suite.kind == .floating_comparison or suite.kind == .floating_unary or suite.kind == .floating_ternary;
        const emitter = if (uses_bits) "floating" else "control";

        generate.addFileArg(b.path(b.fmt("src/emit_{s}_tests.ts", .{emitter})));
        generate.addFileInput(b.path("src/zig_string.ts"));
        generate.addFileInput(b.path("src/shared/json.ts"));

        if (!uses_bits) generate.addFileInput(b.path("src/shared/zig_literal.ts"));

        generate.addFileArg(b.path(b.fmt("{s}.jsonl", .{base})));

        const test_source = generate.addOutputFileArg("cases.zig");

        const support = b.createModule(.{
            .root_source_file = b.path(b.fmt("tests/support/{s}.zig", .{@tagName(suite.kind)})),
            .target = target,
            .optimize = optimize,
        });

        const program = b.createModule(.{
            .root_source_file = program_source,
            .target = target,
            .optimize = optimize,
        });

        if (suite.shared_abi) {
            const abi = b.createModule(.{
                .root_source_file = program_source.dirname().path(b, "program.zig.abi.zig"),
                .target = target,
                .optimize = optimize,
            });

            const standard = b.createModule(.{
                .root_source_file = compiler.path("standard/src/root.zig"),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "zxc_abi", .module = abi }},
            });

            program.addImport("zxc_abi", abi);
            program.addImport("zxc_standard", standard);
        }

        const tests = b.addTest(.{
            .name = suite.name,
            .root_module = b.createModule(.{
                .root_source_file = test_source,
                .target = target,
                .optimize = optimize,
                .imports = &.{
                    .{ .name = "support", .module = support },
                    .{ .name = "program", .module = program },
                },
            }),
        });

        const run = b.addRunArtifact(tests);

        step.dependOn(&run.step);

        if (std.mem.startsWith(u8, suite.name, "arrow-bodies-")) arrow_bodies_step.dependOn(&run.step);
        if (std.mem.startsWith(u8, suite.name, "call-object-spread-")) call_object_spread_step.dependOn(&run.step);
        if (std.mem.startsWith(u8, suite.name, "call-arguments-")) call_arguments_step.dependOn(&run.step);
        if (std.mem.startsWith(u8, suite.name, "regexp-comment-")) regexp_comments_step.dependOn(&run.step);
        if (std.mem.eql(u8, suite.name, "string-source")) string_source_step.dependOn(&run.step);
        if (std.mem.startsWith(u8, suite.name, "whitespace-positions-")) whitespace_positions_step.dependOn(&run.step);
        if (std.mem.startsWith(u8, suite.name, "comment-terminators-")) comment_terminators_step.dependOn(&run.step);
        if (std.mem.startsWith(u8, suite.name, "comment-characters-")) comment_characters_step.dependOn(&run.step);
        if (std.mem.startsWith(u8, suite.name, "identifier-digits-")) identifier_digits_step.dependOn(&run.step);
        if (std.mem.eql(u8, suite.name, "ascii-identifiers")) identifiers_step.dependOn(&run.step);
        if (std.mem.eql(u8, suite.name, "decimal-original")) decimal_step.dependOn(&run.step);
        if (std.mem.startsWith(u8, suite.name, "call-whitespace-")) call_whitespace_step.dependOn(&run.step);
        if (std.mem.startsWith(u8, suite.name, "property-whitespace-")) property_whitespace_step.dependOn(&run.step);
        if (std.mem.startsWith(u8, suite.name, "property-lookup-")) property_lookup_step.dependOn(&run.step);
        if (std.mem.startsWith(u8, suite.name, "property-primitives-")) property_step.dependOn(&run.step);
        if (std.mem.startsWith(u8, suite.name, "grouping-values-")) grouping_step.dependOn(&run.step);
        if (std.mem.startsWith(u8, suite.name, "template-segments-")) template_segments_step.dependOn(&run.step);
        if (std.mem.startsWith(u8, suite.name, "template-calls-")) template_calls_step.dependOn(&run.step);
        if (std.mem.startsWith(u8, suite.name, "template-newlines-")) template_newlines_step.dependOn(&run.step);
        if (std.mem.startsWith(u8, suite.name, "template-members-")) template_members_step.dependOn(&run.step);
        if (std.mem.startsWith(u8, suite.name, "template-primitives-")) template_primitives_step.dependOn(&run.step);
        if (std.mem.startsWith(u8, suite.name, "template-delimiters-")) template_delimiters_step.dependOn(&run.step);
        if (std.mem.startsWith(u8, suite.name, "template-characters-")) template_characters_step.dependOn(&run.step);
        if (std.mem.startsWith(u8, suite.name, "template-nested-")) template_step.dependOn(&run.step);
        if (std.mem.startsWith(u8, suite.name, "array-callbacks-")) array_callbacks_step.dependOn(&run.step);
        if (std.mem.eql(u8, suite.name, "array-callbacks-reduce-observers")) reduce_observers_step.dependOn(&run.step);
        if (std.mem.startsWith(u8, suite.name, "every-observers-")) every_observers_step.dependOn(&run.step);
        if (std.mem.startsWith(u8, suite.name, "tuple-bindings-")) tuple_bindings_step.dependOn(&run.step);
        if (std.mem.eql(u8, suite.name, "array-pop-after-removal")) array_pop_step.dependOn(&run.step);
        if (std.mem.startsWith(u8, suite.name, "nested-collections-")) nested_collections_step.dependOn(&run.step);
        if (std.mem.startsWith(u8, suite.name, "switch-nested-")) nested_step.dependOn(&run.step);
        if (std.mem.startsWith(u8, suite.name, "switch-scope-")) scope_step.dependOn(&run.step);
        if (std.mem.startsWith(u8, suite.name, "switch-scalars-")) switch_step.dependOn(&run.step);
        if (std.mem.startsWith(u8, suite.name, "return-statement-")) return_step.dependOn(&run.step);
        if (std.mem.startsWith(u8, suite.name, "object-construction-")) object_step.dependOn(&run.step);
        if (std.mem.startsWith(u8, suite.name, "array-literal-")) array_literal_step.dependOn(&run.step);
        if (std.mem.eql(u8, suite.name, "comparison-whitespace")) relational_whitespace_step.dependOn(&run.step);
        if (std.mem.startsWith(u8, suite.path, "language/expressions/comparison/null_inequality/") or std.mem.eql(u8, suite.path, "language/expressions/comparison/optional/bool") or std.mem.eql(u8, suite.path, "language/expressions/comparison/optional/f64")) null_inequality_step.dependOn(&run.step);
        if (std.mem.startsWith(u8, suite.path, "built_ins/list/reverse/")) list_reverse_step.dependOn(&run.step);
        if (std.mem.indexOf(u8, suite.path, "/owned/") != null) owned_step.dependOn(&run.step);
        if (std.mem.startsWith(u8, suite.path, "standard/url/search_params/")) url_search_params_step.dependOn(&run.step);
        if (std.mem.startsWith(u8, suite.path, "standard/url/api/")) url_api_step.dependOn(&run.step);
        if (std.mem.startsWith(u8, suite.path, "standard/querystring/")) querystring_step.dependOn(&run.step);
        if (std.mem.startsWith(u8, suite.path, "language/expressions/match/modules/")) match_modules_step.dependOn(&run.step);
        if (std.mem.startsWith(u8, suite.path, "standard/zlib/")) zlib_step.dependOn(&run.step);
        if (std.mem.startsWith(u8, suite.path, "language/expressions/logical_and/") or std.mem.startsWith(u8, suite.path, "language/expressions/logical_or/")) logical_step.dependOn(&run.step);
        if (uses_bits or suite.kind == .floating_optional) floating_step.dependOn(&run.step);
        if (suite.shared_abi) standard_step.dependOn(&run.step);
        if (std.mem.startsWith(u8, suite.path, "built_ins/string/")) strings_step.dependOn(&run.step);
        if (std.mem.startsWith(u8, suite.path, "built_ins/list/range_extract/")) list_range_step.dependOn(&run.step);
        if (std.mem.startsWith(u8, suite.path, "built_ins/string/index/")) string_index_step.dependOn(&run.step);
    }

    return step;
}
