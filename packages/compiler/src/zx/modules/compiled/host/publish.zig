const std = @import("std");
const ir = @import("zx").ir;
const model = @import("../../compiled.zig");
const Destination = @import("../load.zig").Destination;
const Output = std.meta.Child(@import("generated_compiled_library").Output);
const borrow = @import("../../../ir/canonical/borrow.zig");

pub fn apply(allocator: std.mem.Allocator, output: *const Output, destination: Destination) std.mem.Allocator.Error!model.Loaded {
    try @import("../../../analysis/semantic/merging/commit.zig").append(allocator, destination.types, &destination.origins.items, output.types.*, output.origins.*);

    const natives = borrow.columns(ir.NativeModuleTable, output.natives.*);

    for (0..natives.count()) |index| {
        try destination.native_modules.append(allocator, try @import("native.zig").copy(allocator, natives.at(index)));
    }

    const functions = borrow.columns(ir.FunctionTable, output.functions.*);

    for (0..functions.count()) |index| {
        try destination.functions.append(allocator, try @import("function.zig").copy(allocator, functions.at(index)));
    }

    const exports = try allocator.alloc(model.Export, output.exports.names.len);

    for (exports, 0..) |*exported, index| {
        const types = try allocator.alloc(ir.Export, output.exports.type_names[index].len);

        for (types, output.exports.type_names[index], output.exports.type_ids[index]) |*item, name, id| {
            item.* = .{ .name = try allocator.dupe(u8, name), .type_id = @fromBackingInt(id) };
        }

        exported.* = .{
            .name = try allocator.dupe(u8, output.exports.names[index]),
            .path = try allocator.dupe(u8, output.exports.paths[index]),
            .function = if (output.exports.functions[index]) |id| @fromBackingInt(id) else null,
            .types = types,
        };
    }

    const initializers = try allocator.alloc(model.StoreInitializer, output.initializers.identities.len);

    for (initializers, 0..) |*item, index| {
        item.* = .{ .identity = try allocator.dupe(u8, output.initializers.identities[index]), .schema_version = output.initializers.versions[index], .function = @fromBackingInt(output.initializers.functions[index]) };
    }

    return .{ .types = destination.types.view(), .nominal_types = destination.origins.items.view(), .exports = exports, .store_initializers = initializers };
}
