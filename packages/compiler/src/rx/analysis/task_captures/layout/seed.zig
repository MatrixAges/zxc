const std = @import("std");
const ir = @import("zx").ir;
const Binding = @import("frontend").expressions.Binding;
const Layout = @import("../layout.zig");

pub fn plan(allocator: std.mem.Allocator, types: []const ir.TypeId, positions: []const u32, parameters: []const ir.TypeId) std.mem.Allocator.Error!Layout {
    const source_types = try allocator.alloc(ir.TypeId, positions.len);
    const elements = try allocator.alloc(ir.ExprId, positions.len);
    var cursor = 1 + positions.len;
    var narrows = false;

    for (positions, parameters, source_types, elements) |position, parameter, *source, *element| {
        source.* = types[position];
        const narrowed = source.* != parameter;

        cursor += if (narrowed) @as(usize, 2) else 1;
        element.* = @fromBackingInt(@intCast(cursor - 1));
        narrows = narrows or narrowed;
    }

    return .{ .source_types = source_types, .elements = elements, .narrows = narrows };
}

pub fn narrow(types: ir.TypeTable, bindings: []Binding, facts: []const []const u8) void {
    for (bindings) |*binding| {
        const value = types.at(@backingInt(binding.type_id));

        if (value != .optional) continue;

        for (facts) |name| {
            if (!std.mem.eql(u8, name, binding.name)) continue;

            binding.type_id = value.optional;

            break;
        }
    }
}
