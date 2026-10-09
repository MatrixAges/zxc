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
    try collection.collect(init.io, allocator, args[args.len - 1], "lint/naming/", &sources, &modules);

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
    }, .{
        .specifier = "zig:merge_writer",
        .path = "zx/analysis/semantic/native/merge_writer.d.zx",
        .source = @embedFile("merge_writer_interface"),
        .module = "merge_writer",
    }, .{
        .specifier = "zig:extract_workspace",
        .path = "zx/analysis/semantic/native/extract_workspace.d.zx",
        .source = @embedFile("extract_workspace_interface"),
        .module = "extract_workspace",
    }, .{
        .specifier = "zig:references",
        .path = "zx/analysis/semantic/native/references.d.zx",
        .source = @embedFile("references_interface"),
        .module = "references",
    }, .{
        .specifier = "zig:origin_writer",
        .path = "zx/analysis/semantic/native/origin_writer.d.zx",
        .source = @embedFile("origin_writer_interface"),
        .module = "origin_writer",
    }, .{
        .specifier = "zig:named_columns",
        .path = "zx/analysis/semantic/ordering/columns.d.zx",
        .source = @embedFile("named_columns_interface"),
        .module = "named_columns",
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
        const output = try generate(allocator, inputs, sources.items, entry, false, &interfaces);

        try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = output_path, .data = output.source });
    }

    const semantic = try generate(allocator, inputs, sources.items, "zx/analysis/semantic/lookup.rx", true, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[2 + entries.len], .data = semantic.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[3 + entries.len], .data = semantic.types });

    const nominal = try generate(allocator, inputs, sources.items, "zx/analysis/semantic/nominal.rx", true, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[4 + entries.len], .data = nominal.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[5 + entries.len], .data = nominal.types });

    const ordering = try generate(allocator, inputs, sources.items, "zx/analysis/semantic/ordering/sort.rx", true, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[6 + entries.len], .data = ordering.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[7 + entries.len], .data = ordering.types });

    const origins = try generate(allocator, inputs, sources.items, "zx/analysis/semantic/origins.rx", true, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[8 + entries.len], .data = origins.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[9 + entries.len], .data = origins.types });

    const production = try generate(allocator, inputs, sources.items, "zx/analysis/semantic/produce.rx", true, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[10 + entries.len], .data = production.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[11 + entries.len], .data = production.types });

    const remap = try generate(allocator, inputs, sources.items, "zx/analysis/semantic/remap.rx", true, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[12 + entries.len], .data = remap.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[13 + entries.len], .data = remap.types });

    const preflight = try generate(allocator, inputs, sources.items, "zx/analysis/semantic/preflight.rx", true, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[14 + entries.len], .data = preflight.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[15 + entries.len], .data = preflight.types });

    const extract = try generate(allocator, inputs, sources.items, "zx/analysis/semantic/extract.rx", true, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[16 + entries.len], .data = extract.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[17 + entries.len], .data = extract.types });

    const merge = try generate(allocator, inputs, sources.items, "zx/analysis/semantic/merge.rx", true, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[18 + entries.len], .data = merge.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[19 + entries.len], .data = merge.types });

    const validation = try generate(allocator, inputs, sources.items, "zx/analysis/semantic/validate_types.rx", true, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[20 + entries.len], .data = validation.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[21 + entries.len], .data = validation.types });

    const resolution = try generate(allocator, inputs, sources.items, "zx/analysis/semantic/resolve.rx", true, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[22 + entries.len], .data = resolution.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[23 + entries.len], .data = resolution.types });

    const construction = try generate(allocator, inputs, sources.items, "zx/analysis/semantic/construct_type.rx", true, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[24 + entries.len], .data = construction.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[25 + entries.len], .data = construction.types });

    const query = try generate(allocator, inputs, sources.items, "zx/analysis/semantic/query_types.rx", true, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[26 + entries.len], .data = query.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[27 + entries.len], .data = query.types });

    const ownership = try generate(allocator, inputs, sources.items, "zx/ownership/check.rx", true, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[28 + entries.len], .data = ownership.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[29 + entries.len], .data = ownership.types });

    const ir_body = try generate(allocator, inputs, sources.items, "zx/ir/canonical/body_check.rx", true, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[30 + entries.len], .data = ir_body.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[31 + entries.len], .data = ir_body.types });

    const ir_stores = try generate(allocator, inputs, sources.items, "zx/ir/canonical/stores_check.rx", true, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[32 + entries.len], .data = ir_stores.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[33 + entries.len], .data = ir_stores.types });

    const ir_store_call = try generate(allocator, inputs, sources.items, "zx/ir/canonical/store_call_check.rx", true, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[34 + entries.len], .data = ir_store_call.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[35 + entries.len], .data = ir_store_call.types });

    const ir_tasks = try generate(allocator, inputs, sources.items, "zx/ir/canonical/tasks_check.rx", true, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[36 + entries.len], .data = ir_tasks.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[37 + entries.len], .data = ir_tasks.types });

    const ir_functions = try generate(allocator, inputs, sources.items, "zx/ir/canonical/functions_check.rx", true, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[38 + entries.len], .data = ir_functions.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[39 + entries.len], .data = ir_functions.types });

    const ir_task_call = try generate(allocator, inputs, sources.items, "zx/ir/canonical/task_call_check.rx", true, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[40 + entries.len], .data = ir_task_call.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[41 + entries.len], .data = ir_task_call.types });

    const ir_program_pure = try generate(allocator, inputs, sources.items, "zx/ir/canonical/program_pure_check.rx", true, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[42 + entries.len], .data = ir_program_pure.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[43 + entries.len], .data = ir_program_pure.types });

    const ir_expressions = try generate(allocator, inputs, sources.items, "zx/ir/canonical/expressions_check.rx", true, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[44 + entries.len], .data = ir_expressions.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[45 + entries.len], .data = ir_expressions.types });

    const ir_contracts = try generate(allocator, inputs, sources.items, "zx/ir/canonical/contracts_check.rx", true, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[46 + entries.len], .data = ir_contracts.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[47 + entries.len], .data = ir_contracts.types });

    const ir_contract_tables = try generate(allocator, inputs, sources.items, "zx/ir/canonical/contract_tables_check.rx", true, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[48 + entries.len], .data = ir_contract_tables.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[49 + entries.len], .data = ir_contract_tables.types });

    const ir_scopes = try generate(allocator, inputs, sources.items, "zx/ir/canonical/scopes_check.rx", true, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[50 + entries.len], .data = ir_scopes.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[51 + entries.len], .data = ir_scopes.types });

    const refinement_assume = try generate(allocator, inputs, sources.items, "zx/ir/canonical/refinement_assume.rx", true, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[52 + entries.len], .data = refinement_assume.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[53 + entries.len], .data = refinement_assume.types });

    const refinement_bind = try generate(allocator, inputs, sources.items, "zx/ir/canonical/refinement_bind.rx", true, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[54 + entries.len], .data = refinement_bind.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[55 + entries.len], .data = refinement_bind.types });

    const refinement_type = try generate(allocator, inputs, sources.items, "zx/ir/canonical/refinement_type_of.rx", true, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[56 + entries.len], .data = refinement_type.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[57 + entries.len], .data = refinement_type.types });

    const native_modules = try generate(allocator, inputs, sources.items, "zx/ir/canonical/native_modules_check.rx", true, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[58 + entries.len], .data = native_modules.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[59 + entries.len], .data = native_modules.types });

    const native_export = try generate(allocator, inputs, sources.items, "zx/ir/canonical/native_export_check.rx", true, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[60 + entries.len], .data = native_export.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[61 + entries.len], .data = native_export.types });

    const native_type = try generate(allocator, inputs, sources.items, "zx/ir/canonical/native_type_check.rx", true, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[62 + entries.len], .data = native_type.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[63 + entries.len], .data = native_type.types });

    const native_names = try generate(allocator, inputs, sources.items, "zx/modules/native_names.rx", true, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[64 + entries.len], .data = native_names.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[65 + entries.len], .data = native_names.types });

    const native_interface = try generate(allocator, inputs, sources.items, "zx/modules/native/load.rx", true, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[66 + entries.len], .data = native_interface.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[67 + entries.len], .data = native_interface.types });

    const artifact_roots = try generate(allocator, inputs, sources.items, "zx/modules/artifact/roots.rx", true, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[68 + entries.len], .data = artifact_roots.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[69 + entries.len], .data = artifact_roots.types });

    const artifact_prepare = try generate(allocator, inputs, sources.items, "zx/modules/artifact/planning/materialize.rx", true, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[70 + entries.len], .data = artifact_prepare.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[71 + entries.len], .data = artifact_prepare.types });

    const artifact_remap = try generate(allocator, inputs, sources.items, "zx/modules/artifact/remapping/columns.rx", true, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[72 + entries.len], .data = artifact_remap.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[73 + entries.len], .data = artifact_remap.types });

    const refinement_mark = try generate(allocator, inputs, sources.items, "zx/ir/canonical/refinement/facts/mark.rx", false, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[74 + entries.len], .data = refinement_mark.source });

    const refinement_restore = try generate(allocator, inputs, sources.items, "zx/ir/canonical/refinement/facts/restore.rx", false, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[75 + entries.len], .data = refinement_restore.source });

    const refinement_add = try generate(allocator, inputs, sources.items, "zx/ir/canonical/refinement/facts/add.rx", false, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[76 + entries.len], .data = refinement_add.source });

    const naming = try generate(allocator, inputs, sources.items, "lint/naming/check.rx", false, &interfaces);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[args.len - 2], .data = naming.source });
}

fn generate(allocator: std.mem.Allocator, modules: []const rx.ModuleSource, sources: []const compiler.project.Source, entry: []const u8, shared_abi: bool, interfaces: []const compiler.project.NativeInterface) !compiler.zig.Bundle {
    const selected = try @import("parser_inputs.zig").reachable(allocator, modules, entry);

    defer allocator.free(selected);

    var analyzed = try analysis.project.infer(allocator, .{
        .entry = entry,
        .modules = selected,
        .sources = sources,
        .project = .{ .entry = "", .native_interfaces = interfaces, .packages = &.{
            .{ .specifier = "lint/naming", .entry = "lint/naming/check.zx" },
            .{ .specifier = "lint/naming/model", .entry = "lint/naming/model.zx" },
        } },
    });

    defer analyzed.deinit();

    if (analyzed.value == .diagnostic) {
        const issue = analyzed.value.diagnostic;

        std.debug.print("{s}: {s}\n", .{ issue.path, issue.message });

        return error.InvalidParserSource;
    }

    if (shared_abi) return compiler.zig.emitBundle(allocator, analyzed.value.contract.program);

    return .{ .source = try compiler.zig.emit(allocator, analyzed.value.contract.program), .types = &.{} };
}
