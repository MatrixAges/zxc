const std = @import("std");
const ir = @import("zx").ir;
const Origins = @import("nominal_data");
const Preflight = @import("preflight.zig");

pub fn prepare(allocator: std.mem.Allocator, temporary: std.mem.Allocator, values: ir.TypeTable, nominal_types: Origins.Table, target: ir.TypeTable, first: usize) Preflight.Error!Preflight.Result {
    if (!nominal_types.hasValidShape()) return error.InvalidModule;

    const origins = try temporary.alloc(?usize, values.count());

    @memset(origins, null);

    for (0..nominal_types.count()) |origin_index| {
        const item = nominal_types.at(origin_index);
        const index = @backingInt(item.type_id);

        if (index >= values.count() or origins[index] != null) return error.InvalidModule;

        const name = values.at(index).nominalName() orelse return error.InvalidModule;

        if (!std.mem.eql(u8, name, item.name)) return error.InvalidModule;
        if (values.at(index) == .native_reference and item.origin != .native) return error.InvalidModule;

        origins[index] = origin_index;
    }

    if (first > values.count() or (first != 0 and first != target.count())) return error.InvalidModule;

    const mapping = try allocator.alloc(ir.TypeId, values.count());

    for (0..first) |index| {
        const value = values.at(index);
        const existing = target.at(index);

        if (!sameType(value, existing)) return error.InvalidModule;

        mapping[index] = @fromBackingInt(@intCast(index));
    }

    return .{ .origins = origins, .mapping = mapping };
}

fn sameType(left: ir.Type, right: ir.Type) bool {
    if (std.meta.activeTag(left) != std.meta.activeTag(right)) return false;

    return switch (left) {
        .scalar => |value| value == right.scalar,
        .native_reference => |name| std.mem.eql(u8, name, right.native_reference),
        .task => |task| task.result == right.task.result and task.errors == right.task.errors,
        .error_set => |members| blk: {
            if (members.len != right.error_set.len) break :blk false;

            for (members, right.error_set) |left_name, right_name| {
                if (!std.mem.eql(u8, left_name, right_name)) break :blk false;
            }

            break :blk true;
        },
        .optional => |child| child == right.optional,
        .list => |child| child == right.list,
        .tuple => |children| blk: {
            if (children.len != right.tuple.len) break :blk false;

            for (0..children.len) |position| {
                const child = right.tuple.at(position);

                if (children.at(position) != child) break :blk false;
            }

            break :blk true;
        },
        .object => |fields| blk: {
            if (fields.len != right.object.len) break :blk false;

            for (0..fields.len) |position| {
                const a = fields.at(position);
                const b = right.object.at(position);

                if (a.type_id != b.type_id or !std.mem.eql(u8, a.name, b.name)) break :blk false;
            }

            break :blk true;
        },
        .enumeration => |value| blk: {
            if (!std.mem.eql(u8, value.name, right.enumeration.name) or value.members.len != right.enumeration.members.len) break :blk false;

            for (value.members, right.enumeration.members) |a, b| {
                if (!std.mem.eql(u8, a, b)) break :blk false;
            }

            break :blk true;
        },
    };
}
