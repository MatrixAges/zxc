const std = @import("std");
const ir = @import("zx").ir;
const generated = @import("generated_uniqueness_slots");
const Slots = @import("../slots.zig");

pub fn build(allocator: std.mem.Allocator, types: ir.TypeTable) std.mem.Allocator.Error!Slots.Built {
    const Input = std.meta.Child(generated.Input);

    const input = Input{
        .kinds = types.kinds,
        .first = types.first,
        .second = types.second,
        .children = types.children,
        .field_types = types.field_types,
    };

    const output = @import("zx").columns.invoke(generated.executeValue, allocator, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    comptime std.debug.assert(@typeInfo(ir.TypeId).@"enum".tag_type == u32);

    return .{ .slots = .{
        .types = types,
        .counts = output.counts,
        .offsets = output.offsets,
        .members = @ptrCast(output.members),
        .unwrapped = @ptrCast(output.unwrapped),
    }, .texts = output.texts };
}
