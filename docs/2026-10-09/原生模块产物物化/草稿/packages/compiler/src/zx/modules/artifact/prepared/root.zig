const std = @import("std");
const Analysis = @import("../../../analysis/analyze.zig");
const Record = @import("../../module_record.zig");
const Nodes = @import("../nodes.zig");
const model = @import("../model.zig");
const owned = @import("owned.zig");
const declarations = @import("declarations.zig");
const contents = @import("contents.zig");

pub fn extract(arena: *std.heap.ArenaAllocator, temporary: *std.heap.ArenaAllocator, analysis: *const Analysis.Result, record: Record) model.Error!model.Module {
    const allocator = arena.allocator();
    const program = analysis.value.ir;
    const prepared = try @import("run.zig").execute(arena, temporary, analysis, record);
    const materialized = prepared.value orelse return error.InvalidModule;
    const types = try owned.types(allocator, materialized.table);
    const origins = try owned.origins(allocator, types, materialized.origins);

    var nodes = Nodes{
        .allocator = allocator,
        .types = .{ .planned = prepared.plan.state.mapping },
        .functions = .{ .planned = prepared.plan.functions.mapping },
        .native_modules = .{ .planned = prepared.plan.natives.mapping },
        .arena = arena,
    };

    const native_modules = try owned.natives(allocator, prepared.natives orelse return error.InvalidModule);
    const functions = try declarations.functions(&nodes, program, prepared.plan.functions.order[0..@intCast(prepared.plan.functions.count)]);
    const function = try contents.function(&nodes, program, record);
    const stores = try nodes.stores(if (record.body == .entry) program.stores else if (record.body == .function) program.functions.at(@backingInt(record.body.function)).stores else .{});

    return .{
        .path = try allocator.dupe(u8, record.path),
        .source_digest = record.source_digest,
        .dependencies = try contents.dependencies(&nodes, record.imports),
        .types = types,
        .nominal_types = origins,
        .exports = try contents.exports(&nodes, record.exports),
        .type_imports = try contents.exports(&nodes, record.type_imports),
        .function_imports = try contents.imports(&nodes, record.function_imports),
        .functions = functions,
        .native_modules = native_modules,
        .function = function,
        .stores = stores,
    };
}
