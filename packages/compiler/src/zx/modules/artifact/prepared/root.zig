const std = @import("std");
const Analysis = @import("../../../analysis/analyze.zig");
const Record = @import("../../module_record.zig");
const Nodes = @import("../nodes.zig");
const model = @import("../model.zig");
const owned = @import("owned.zig");
const contents = @import("contents.zig");

pub fn extract(arena: *std.heap.ArenaAllocator, temporary: *std.heap.ArenaAllocator, analysis: *const Analysis.Result, record: Record) model.Error!model.Module {
    const allocator = arena.allocator();
    const program = analysis.value.ir;
    const plan = try @import("run.zig").execute(arena, temporary, analysis, record);
    const prepared = plan.output;
    const materialized = prepared.value orelse return error.InvalidModule;
    const types = try owned.types(allocator, materialized.table);
    const origins = try owned.origins(allocator, types, materialized.origins);

    var nodes = Nodes{
        .allocator = allocator,
        .types = .{ .planned = prepared.plan.state.mapping },
        .functions = .{ .planned = prepared.plan.functions.mapping },
        .native_modules = .{ .planned = prepared.plan.natives.mapping },
    };

    const native_modules = try owned.natives(allocator, prepared.natives orelse return error.InvalidModule);
    const functions = try owned.signatures(allocator, prepared.signatures orelse return error.InvalidModule);
    const body = prepared.body orelse return error.InvalidModule;
    const function = try contents.function(&nodes, program, body);

    const stores: @import("zx").ir.StoreTable = if (body.copy_entry_stores)
        try nodes.stores(program.stores)

    else if (function) |value|
        value.stores
    else
        .{};

    const surface = try @import("../surface.zig").publish(temporary.allocator(), &nodes, .{
        .exports = record.exports,
        .constant_exports = record.constant_exports,
        .constant_imports = record.constant_imports,
        .type_imports = record.type_imports,
        .function_imports = record.function_imports,
        .members = record.reexports.functions,
    }, plan.references);

    return .{
        .path = try allocator.dupe(u8, record.path),
        .source_digest = record.source_digest,
        .dependencies = try contents.dependencies(&nodes, record.imports),
        .types = types,
        .nominal_types = origins,
        .exports = surface.exports,
        .constant_exports = surface.constant_exports,
        .constant_imports = surface.constant_imports,
        .type_imports = surface.type_imports,
        .function_imports = surface.function_imports,
        .members = surface.members,
        .functions = functions,
        .native_modules = native_modules,
        .function = function,
        .stores = stores,
    };
}
