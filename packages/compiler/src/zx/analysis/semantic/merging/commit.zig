const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
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

    const first = try target.reserveDelta(allocator, table);

    if (first.len != 0) {
        const generated = @import("generated_type_merge_rebase");
        const Input = std.meta.Child(generated.Input);

        const input: Input = .{
            .kinds = table.kinds,
            .first = table.first,
            .target = @ptrCast(&first),
            .children = @intCast(target.children.items.len),
            .fields = @intCast(target.field_types.items.len),
            .names = @intCast(target.names.items.len),
        };

        var empty = std.heap.FixedBufferAllocator.init(&.{});

        zx.columns.invoke(generated.executeValue, empty.allocator(), &input) catch unreachable;
    }

    target.publishDelta(table);

    inline for (.{ "ids", "kinds", "owners", "members" }) |name| {
        @field(origins, name).appendSliceAssumeCapacity(@field(bindings, name));
    }

    for (bindings.ids) |id| origins.names.appendAssumeCapacity(target.labels.items[id]);
}
