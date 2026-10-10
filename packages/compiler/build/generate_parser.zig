const std = @import("std");
const compiler = @import("compiler");
const rx = @import("rx");
const analysis = @import("rx_analysis");
const collection = @import("source_collection.zig");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    if (std.mem.eql(u8, args[1], "--standard-abi")) return @import("generate_types.zig").generate(init, args[2]);

    var sources: std.ArrayList(compiler.project.Source) = .empty;
    var modules: std.ArrayList(rx.TextSource) = .empty;

    try collection.collect(init.io, allocator, args[1], "", &sources, &modules);
    try collection.collect(init.io, allocator, args[args.len - 2], "lint/naming/", &sources, &modules);
    try collection.collect(init.io, allocator, args[args.len - 1], "core/", &sources, &modules);

    std.mem.sort(compiler.project.Source, sources.items, {}, collection.lessSource);
    std.mem.sort(rx.TextSource, modules.items, {}, collection.lessModule);

    var parsed = try rx.parseModules(allocator, modules.items);

    defer parsed.deinit();

    if (parsed.value == .diagnostic) {
        std.debug.print("{s}: {s}\n", .{ modules.items[parsed.value.diagnostic.source_index].path, parsed.value.diagnostic.issue.message });

        return error.InvalidParserModule;
    }

    const inputs = try allocator.alloc(rx.ModuleSource, modules.items.len);

    for (inputs, modules.items, parsed.parsed) |*item, source, module| item.* = .{ .path = source.path, .node = module.value.node };

    const interfaces = [_]compiler.project.NativeInterface{ .{
        .specifier = "zig:floats",
        .path = "zx/analysis/semantic/native/floats.d.zx",
        .source = @embedFile("semantic_floats"),
        .module = "floats",
    }, .{
        .specifier = "zig:integers",
        .path = "zx/analysis/semantic/native/integers.d.zx",
        .source = @embedFile("semantic_integers"),
        .module = "integers",
    } };

    const plain = [_][]const u8{
        "zx/frontend/parser/program.rx",
        "zx/frontend/parser/expression_text.rx",
        "rx/syntax/parse.rx",
        "rx/path_segments/normalize.rx",
        "rx/dependency_graph/validate.rx",
        "rx/schema/attribute/classify.rx",
        "rx/schema/content/validate.rx",
        "rx/schema/call/validate.rx",
        "rx/path_kind/validate.rx",
        "rx/schema/file/classify.rx",
        "zx/modules/specifier/classify.rx",
        "zx/analysis/integer/decode.rx",
    };

    const typed = [_]struct { []const u8, bool }{
        .{ "zx/analysis/semantic/lookup.rx", true },
        .{ "zx/analysis/semantic/nominal.rx", true },
        .{ "zx/analysis/semantic/origins.rx", true },
        .{ "zx/analysis/semantic/produce.rx", true },
        .{ "zx/analysis/semantic/preflight.rx", true },
        .{ "zx/analysis/semantic/merge.rx", true },
        .{ "zx/analysis/semantic/validate_types.rx", true },
        .{ "zx/analysis/semantic/resolve.rx", true },
        .{ "zx/analysis/semantic/construct_type.rx", true },
        .{ "zx/analysis/semantic/query_types.rx", true },
        .{ "zx/ownership/check.rx", true },
        .{ "zx/ir/canonical/body_check.rx", true },
        .{ "zx/ir/canonical/stores_check.rx", true },
        .{ "zx/ir/canonical/store_call_check.rx", true },
        .{ "zx/ir/canonical/tasks_check.rx", true },
        .{ "zx/ir/canonical/functions_check.rx", true },
        .{ "zx/ir/canonical/task_call_check.rx", true },
        .{ "zx/ir/canonical/program_pure_check.rx", true },
        .{ "zx/ir/canonical/expressions_check.rx", true },
        .{ "zx/ir/canonical/contracts_check.rx", true },
        .{ "zx/ir/canonical/contract_tables_check.rx", true },
        .{ "zx/ir/canonical/scopes_check.rx", true },
        .{ "zx/ir/canonical/refinement_assume.rx", true },
        .{ "zx/ir/canonical/refinement_bind.rx", true },
        .{ "zx/ir/canonical/refinement_type_of.rx", true },
        .{ "zx/ir/canonical/native_modules_check.rx", true },
        .{ "zx/ir/canonical/native_export_check.rx", true },
        .{ "zx/ir/canonical/native_type_check.rx", true },
        .{ "zx/modules/native_names.rx", true },
        .{ "zx/modules/native/load.rx", true },
        .{ "zx/modules/artifact/roots.rx", true },
        .{ "zx/modules/artifact/planning/materialize.rx", true },
        .{ "zx/modules/artifact/remapping/columns.rx", true },
        .{ "zx/ir/canonical/refinement/facts/mark.rx", false },
        .{ "zx/ir/canonical/refinement/facts/restore.rx", false },
        .{ "zx/ir/canonical/refinement/facts/add.rx", false },
        .{ "zx/analysis/analyzer/analyze.rx", true },
        .{ "zx/modules/source_signature/analyze.rx", true },
        .{ "zx/analysis/expression_program/compile.rx", true },
        .{ "zx/ir/canonical/validation/validate.rx", true },
        .{ "zx/modules/compiled/execute.rx", true },
        .{ "zx/modules/semantic_cache/restoring/native/restore.rx", true },
    };

    var jobs: std.ArrayList(Job) = .empty;
    var next: usize = 2;

    for (plain) |entry| {
        try jobs.append(allocator, .{ .entry = entry, .output = args[next] });

        next += 1;
    }

    for (typed) |item| {
        try jobs.append(allocator, .{ .entry = item[0], .output = args[next], .types = if (item[1]) args[next + 1] else null });

        next += if (item[1]) 2 else 1;
    }

    try jobs.append(allocator, .{ .entry = "lint/naming/check.rx", .output = args[args.len - 3] });
    try @import("parallel_generation.zig").run(init, jobs.items, .{ .modules = inputs, .sources = sources.items, .interfaces = &interfaces }, generate);
}

pub const Job = @import("parallel_generation.zig").Job;
pub const Inputs = @import("parallel_generation.zig").Inputs;

fn generate(init: std.process.Init, inputs: Inputs, job: Job) !void {
    const modules = inputs.modules;
    const sources = inputs.sources;
    const interfaces = inputs.interfaces;
    const entry = job.entry;
    const output_path = job.output;
    const types_path = job.types;
    const temporary = init.gpa;
    const project = compiler.project.Options{ .entry = "", .native_interfaces = interfaces, .packages = @import("source_packages.zig").entries };
    const selected = try @import("source_inputs.zig").reachable(temporary, modules, sources, entry, project);

    defer temporary.free(selected);

    var analyzed = try analysis.project.infer(temporary, .{
        .entry = entry,
        .modules = selected,
        .sources = sources,
        .project = project,
    });

    defer analyzed.deinit();

    if (analyzed.value == .diagnostic) {
        const issue = analyzed.value.diagnostic;

        std.debug.print("{s}:{d}:{d}: {s}: {s}\n", .{ issue.path, issue.location.line, issue.location.column, issue.code, issue.message });

        return error.InvalidParserSource;
    }

    const bundle = if (types_path != null)
        try compiler.zig.emitBundle(temporary, analyzed.value.contract.program)
    else
        compiler.zig.Bundle{ .source = try compiler.zig.emit(temporary, analyzed.value.contract.program), .types = &.{} };

    defer bundle.deinit(temporary);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = output_path, .data = bundle.source });
    if (types_path) |path| try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = path, .data = bundle.types });
}
