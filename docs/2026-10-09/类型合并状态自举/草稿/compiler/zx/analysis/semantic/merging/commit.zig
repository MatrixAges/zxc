const std = @import("std");
const ir = @import("zx").ir;
const Origins = @import("nominal_data");

pub fn append(allocator: std.mem.Allocator, target: *ir.TypeStorage, origins: *Origins.Storage, delta: anytype, bindings: anytype) std.mem.Allocator.Error!void {
    var table: ir.TypeTable = undefined;

    inline for (@typeInfo(ir.TypeTable).@"struct".field_names) |name| {
        @field(table, name) = @field(delta, name);
    }

    var copied: [5]usize = @splat(0);
    const columns = .{ table.labels, table.field_names, table.names, bindings.owners, bindings.members };

    errdefer inline for (columns, 0..) |column, index| {
        for (column[0..copied[index]]) |item| allocator.free(item);
    };

    inline for (columns, 0..) |column, index| {
        for (@constCast(column)) |*item| {
            item.* = try allocator.dupe(u8, item.*);
            copied[index] += 1;
        }
    }

    try origins.ensureUnusedCapacity(allocator, bindings.ids.len);
    try target.appendDelta(allocator, table);

    inline for (.{ "ids", "kinds", "owners", "members" }) |name| {
        @field(origins, name).appendSliceAssumeCapacity(@field(bindings, name));
    }

    for (bindings.ids) |id| origins.names.appendAssumeCapacity(target.labels.items[id]);
}
