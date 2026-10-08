const std = @import("std");
const ir = @import("zx").ir;
const Nodes = @import("../nodes.zig");
const model = @import("../model.zig");

pub fn natives(nodes: *Nodes, program: ir.Program, order: []const u32) model.Error!ir.NativeModuleTable {
    var storage: ir.NativeModuleStorage = .{};

    for (order) |index| {
        const value = program.native_modules.at(index);
        const names = try nodes.strings(value.types.names);
        const ids = try nodes.allocator.alloc(u32, value.types.type_ids.len);

        for (value.types.type_ids, ids) |type_id, *id| id.* = @backingInt(try nodes.types.include(@fromBackingInt(type_id)));

        try storage.append(nodes.allocator, .{
            .specifier = try nodes.allocator.dupe(u8, value.specifier),
            .identity = if (value.identity) |key| try nodes.allocator.dupe(u8, key) else null,
            .import_name = try nodes.allocator.dupe(u8, value.import_name),
            .type_namespace = try nodes.strings(value.type_namespace),
            .types = .{ .names = names, .type_ids = ids },
        });
    }

    return storage.view();
}

pub fn functions(nodes: *Nodes, program: ir.Program, order: []const u32) model.Error![]const model.Signature {
    const values = try nodes.allocator.alloc(model.Signature, order.len);

    for (order, values) |index, *result| {
        const value = program.functions.at(index);

        result.* = .{
            .file_name = try nodes.allocator.dupe(u8, value.file_name),
            .input_type = try nodes.types.include(value.input_type),
            .output_type = try nodes.types.include(value.output_type),
            .output_ownership = value.output_ownership,
            .external = if (value.external) |external| try nodes.external(external) else null,
        };
    }

    return values;
}
