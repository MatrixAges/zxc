const std = @import("std");
const ir = @import("zx").ir;
const Loaded = @import("../../native.zig");
const Current = @import("../native_restore.zig").Current;
const borrow = @import("../../../ir/canonical/borrow.zig");

pub fn apply(allocator: std.mem.Allocator, output: anytype, current: Current) std.mem.Allocator.Error!Loaded.Result {
    const exports = try allocator.alloc(ir.Export, output.export_names.len);

    for (exports, output.export_names, output.export_types) |*item, name, id| {
        item.* = .{ .name = try allocator.dupe(u8, name), .type_id = @fromBackingInt(id) };
    }

    const functions = borrow.columns(ir.FunctionTable, output.functions.*);
    const members = try allocator.alloc(Loaded.Member, functions.count());

    for (members, output.member_names, 0..) |*member, name, index| {
        member.* = .{ .name = try allocator.dupe(u8, name), .function = try @import("../../compiled/host/function.zig").copy(allocator, functions.at(index)) };
    }

    try @import("../../../analysis/semantic/merging/commit.zig").append(allocator, current.types, &current.origins.items, output.types.*, output.origins.*);

    return .{ .types = current.types.view(), .exports = exports, .members = members };
}
