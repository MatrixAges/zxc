const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Origins = @import("nominal_data");

pub fn appendTypes(allocator: std.mem.Allocator, target: *ir.TypeStorage, delta: anytype) std.mem.Allocator.Error!void {
    try append(allocator, target, null, delta, @as(Origins.Table, .{}));
}

pub fn append(allocator: std.mem.Allocator, target: *ir.TypeStorage, origins: ?*Origins.Storage, delta: anytype, bindings: anytype) std.mem.Allocator.Error!void {
    var table: ir.TypeTable = undefined;

    inline for (@typeInfo(ir.TypeTable).@"struct".field_names) |name| {
        @field(table, name) = @field(delta, name);
    }

    if (origins) |storage| try storage.ensureUnusedCapacity(allocator, bindings.ids.len);

    const first = try target.reserveDelta(allocator, table);
    const labels = target.labels.unusedCapacitySlice()[0..table.labels.len];
    const fields = target.field_names.unusedCapacitySlice()[0..table.field_names.len];
    const names = target.names.unusedCapacitySlice()[0..table.names.len];
    const owners: [][]const u8 = if (origins) |storage| storage.owners.unusedCapacitySlice()[0..bindings.owners.len] else &.{};
    const members: [][]const u8 = if (origins) |storage| storage.members.unusedCapacitySlice()[0..bindings.members.len] else &.{};
    const sources = .{ table.labels, table.field_names, table.names, bindings.owners, bindings.members };
    const tails = .{ labels, fields, names, owners, members };
    var copied: [tails.len]usize = @splat(0);

    errdefer inline for (tails, 0..) |tail, index| {
        for (tail[0..copied[index]]) |item| allocator.free(item);
    };

    inline for (sources, tails, 0..) |column, tail, index| {
        for (column, tail) |text, *item| {
            item.* = try allocator.dupe(u8, text);
            copied[index] += 1;
        }
    }

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

    target.publishOwnedDelta(table);

    if (origins) |storage| {
        storage.ids.appendSliceAssumeCapacity(bindings.ids);
        storage.kinds.appendSliceAssumeCapacity(bindings.kinds);

        _ = storage.owners.addManyAsSliceAssumeCapacity(owners.len);
        _ = storage.members.addManyAsSliceAssumeCapacity(members.len);

        for (bindings.ids) |id| storage.names.appendAssumeCapacity(target.labels.items[id]);
    }
}
