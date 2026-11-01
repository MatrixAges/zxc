const std = @import("std");
const Bindings = @import("../bindings.zig");
const ir = @import("zx").ir;

pub fn compare(request: Bindings.Request) Bindings.Comparison {
    if (request.name) |name| {
        for (request.previous) |left| {
            if (!std.mem.eql(u8, left.name, name)) continue;

            for (request.current) |right| {
                if (std.mem.eql(u8, right.name, name)) return if (same(left, right, request)) .Equal else .Different;
            }

            return .Different;
        }

        return .Missing;
    }

    if (request.previous.len != request.current.len) return .Different;

    for (request.previous, request.current) |left, right| {
        if (!std.mem.eql(u8, left.name, right.name) or !same(left, right, request)) return .Different;
    }

    return .Equal;
}

fn same(left: ir.Constant, right: ir.Constant, request: Bindings.Request) bool {
    if (@backingInt(left.type_id) >= request.mapping.len) return false;

    const right_type = if (request.current_mapping) |mapping| blk: {
        if (@backingInt(right.type_id) >= mapping.len) return false;

        break :blk mapping[@backingInt(right.type_id)];
    } else right.type_id;

    if (request.mapping[@backingInt(left.type_id)] != right_type or std.meta.activeTag(left.value) != std.meta.activeTag(right.value)) return false;

    return switch (left.value) {
        .float => |value| @as(u64, @bitCast(value)) == @as(u64, @bitCast(right.value.float)),
        .string => |value| std.mem.eql(u8, value, right.value.string),
        inline else => |value, tag| value == @field(right.value, @tagName(tag)),
    };
}
