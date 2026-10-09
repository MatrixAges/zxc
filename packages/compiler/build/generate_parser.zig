const std = @import("std");
const compiler = @import("compiler");
const rx = @import("rx");
const analysis = @import("rx_analysis");
const collection = @import("source_collection.zig");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
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

    const entries = [_][]const u8{
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

    for (entries, args[2 .. 2 + entries.len]) |entry, output_path| {
        try generate(init, inputs, sources.items, entry, output_path, null, &interfaces);
    }

    try generate(init, inputs, sources.items, "zx/analysis/semantic/lookup.rx", args[2 + entries.len], args[3 + entries.len], &interfaces);
    try generate(init, inputs, sources.items, "zx/analysis/semantic/nominal.rx", args[4 + entries.len], args[5 + entries.len], &interfaces);
    try generate(init, inputs, sources.items, "zx/analysis/semantic/origins.rx", args[6 + entries.len], args[7 + entries.len], &interfaces);
    try generate(init, inputs, sources.items, "zx/analysis/semantic/produce.rx", args[8 + entries.len], args[9 + entries.len], &interfaces);
    try generate(init, inputs, sources.items, "zx/analysis/semantic/preflight.rx", args[10 + entries.len], args[11 + entries.len], &interfaces);
    try generate(init, inputs, sources.items, "zx/analysis/semantic/merge.rx", args[12 + entries.len], args[13 + entries.len], &interfaces);
    try generate(init, inputs, sources.items, "zx/analysis/semantic/validate_types.rx", args[14 + entries.len], args[15 + entries.len], &interfaces);
    try generate(init, inputs, sources.items, "zx/analysis/semantic/resolve.rx", args[16 + entries.len], args[17 + entries.len], &interfaces);
    try generate(init, inputs, sources.items, "zx/analysis/semantic/construct_type.rx", args[18 + entries.len], args[19 + entries.len], &interfaces);
    try generate(init, inputs, sources.items, "zx/analysis/semantic/query_types.rx", args[20 + entries.len], args[21 + entries.len], &interfaces);
    try generate(init, inputs, sources.items, "zx/ownership/check.rx", args[22 + entries.len], args[23 + entries.len], &interfaces);
    try generate(init, inputs, sources.items, "zx/ir/canonical/body_check.rx", args[24 + entries.len], args[25 + entries.len], &interfaces);
    try generate(init, inputs, sources.items, "zx/ir/canonical/stores_check.rx", args[26 + entries.len], args[27 + entries.len], &interfaces);
    try generate(init, inputs, sources.items, "zx/ir/canonical/store_call_check.rx", args[28 + entries.len], args[29 + entries.len], &interfaces);
    try generate(init, inputs, sources.items, "zx/ir/canonical/tasks_check.rx", args[30 + entries.len], args[31 + entries.len], &interfaces);
    try generate(init, inputs, sources.items, "zx/ir/canonical/functions_check.rx", args[32 + entries.len], args[33 + entries.len], &interfaces);
    try generate(init, inputs, sources.items, "zx/ir/canonical/task_call_check.rx", args[34 + entries.len], args[35 + entries.len], &interfaces);
    try generate(init, inputs, sources.items, "zx/ir/canonical/program_pure_check.rx", args[36 + entries.len], args[37 + entries.len], &interfaces);
    try generate(init, inputs, sources.items, "zx/ir/canonical/expressions_check.rx", args[38 + entries.len], args[39 + entries.len], &interfaces);
    try generate(init, inputs, sources.items, "zx/ir/canonical/contracts_check.rx", args[40 + entries.len], args[41 + entries.len], &interfaces);
    try generate(init, inputs, sources.items, "zx/ir/canonical/contract_tables_check.rx", args[42 + entries.len], args[43 + entries.len], &interfaces);
    try generate(init, inputs, sources.items, "zx/ir/canonical/scopes_check.rx", args[44 + entries.len], args[45 + entries.len], &interfaces);
    try generate(init, inputs, sources.items, "zx/ir/canonical/refinement_assume.rx", args[46 + entries.len], args[47 + entries.len], &interfaces);
    try generate(init, inputs, sources.items, "zx/ir/canonical/refinement_bind.rx", args[48 + entries.len], args[49 + entries.len], &interfaces);
    try generate(init, inputs, sources.items, "zx/ir/canonical/refinement_type_of.rx", args[50 + entries.len], args[51 + entries.len], &interfaces);
    try generate(init, inputs, sources.items, "zx/ir/canonical/native_modules_check.rx", args[52 + entries.len], args[53 + entries.len], &interfaces);
    try generate(init, inputs, sources.items, "zx/ir/canonical/native_export_check.rx", args[54 + entries.len], args[55 + entries.len], &interfaces);
    try generate(init, inputs, sources.items, "zx/ir/canonical/native_type_check.rx", args[56 + entries.len], args[57 + entries.len], &interfaces);
    try generate(init, inputs, sources.items, "zx/modules/native_names.rx", args[58 + entries.len], args[59 + entries.len], &interfaces);
    try generate(init, inputs, sources.items, "zx/modules/native/load.rx", args[60 + entries.len], args[61 + entries.len], &interfaces);
    try generate(init, inputs, sources.items, "zx/modules/artifact/roots.rx", args[62 + entries.len], args[63 + entries.len], &interfaces);
    try generate(init, inputs, sources.items, "zx/modules/artifact/planning/materialize.rx", args[64 + entries.len], args[65 + entries.len], &interfaces);
    try generate(init, inputs, sources.items, "zx/modules/artifact/remapping/columns.rx", args[66 + entries.len], args[67 + entries.len], &interfaces);
    try generate(init, inputs, sources.items, "zx/ir/canonical/refinement/facts/mark.rx", args[68 + entries.len], null, &interfaces);
    try generate(init, inputs, sources.items, "zx/ir/canonical/refinement/facts/restore.rx", args[69 + entries.len], null, &interfaces);
    try generate(init, inputs, sources.items, "zx/ir/canonical/refinement/facts/add.rx", args[70 + entries.len], null, &interfaces);
    try generate(init, inputs, sources.items, "zx/analysis/analyzer/analyze.rx", args[71 + entries.len], args[72 + entries.len], &interfaces);
    try generate(init, inputs, sources.items, "zx/modules/source_signature/analyze.rx", args[73 + entries.len], args[74 + entries.len], &interfaces);
    try generate(init, inputs, sources.items, "zx/analysis/expression_program/compile.rx", args[75 + entries.len], args[76 + entries.len], &interfaces);
    try generate(init, inputs, sources.items, "zx/ir/canonical/validation/validate.rx", args[77 + entries.len], args[78 + entries.len], &interfaces);
    try generate(init, inputs, sources.items, "zx/modules/compiled/execute.rx", args[79 + entries.len], args[80 + entries.len], &interfaces);
    try generate(init, inputs, sources.items, "lint/naming/check.rx", args[args.len - 3], null, &interfaces);
}

fn generate(init: std.process.Init, modules: []const rx.ModuleSource, sources: []const compiler.project.Source, entry: []const u8, output_path: []const u8, types_path: ?[]const u8, interfaces: []const compiler.project.NativeInterface) !void {
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
