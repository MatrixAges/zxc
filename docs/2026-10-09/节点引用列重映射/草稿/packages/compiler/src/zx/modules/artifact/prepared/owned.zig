const std = @import("std");
const ir = @import("zx").ir;
const Origins = @import("../../nominal_origins.zig");

pub fn types(allocator: std.mem.Allocator, value: anytype) std.mem.Allocator.Error!ir.TypeTable {
    const table = @import("../../../ir/canonical/borrow.zig").columns(ir.TypeTable, value.*);

    try strings(allocator, table.labels);
    try strings(allocator, table.field_names);
    try strings(allocator, table.names);

    return table;
}

pub fn origins(allocator: std.mem.Allocator, table: ir.TypeTable, value: anytype) std.mem.Allocator.Error!Origins.Table {
    try strings(allocator, value.owners);
    try strings(allocator, value.members);

    const names = try allocator.alloc([]const u8, value.ids.len);

    for (value.ids, names) |id, *name| name.* = table.labels[id];

    return .{ .ids = value.ids, .kinds = value.kinds, .owners = value.owners, .members = value.members, .names = names };
}

fn strings(allocator: std.mem.Allocator, values: []const []const u8) std.mem.Allocator.Error!void {
    for (@constCast(values)) |*value| value.* = try allocator.dupe(u8, value.*);
}
