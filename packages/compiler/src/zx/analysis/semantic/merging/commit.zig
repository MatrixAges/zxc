const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Origins = @import("nominal_data");

pub fn appendTypes(allocator: std.mem.Allocator, target: *ir.TypeStorage, delta: anytype) std.mem.Allocator.Error!void {
    try append(allocator, target, null, delta, @as(Origins.Table, .{}));
}

pub fn append(allocator: std.mem.Allocator, target: *ir.TypeStorage, origins: ?*Origins.Storage, delta: anytype, bindings: anytype) std.mem.Allocator.Error!void {
    try appendWithPayload(allocator, allocator, target, origins, delta, bindings);
}

pub fn appendWithPayload(allocator: std.mem.Allocator, payload: std.mem.Allocator, target: *ir.TypeStorage, origins: ?*Origins.Storage, delta: anytype, bindings: anytype) std.mem.Allocator.Error!void {
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

    if (first.len != 0 or bindings.ids.len != 0) {
        try materialize(payload, sources, tails, .{
            .kinds = table.kinds,
            .first = table.first,
            .target = &first,
            .children = @intCast(target.children.items.len),
            .fields = @intCast(target.field_types.items.len),
            .names = @intCast(target.names.items.len),
        });
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

const generated = @import("generated_type_merge_publication");
const Input = std.meta.Child(generated.Input);
const Column = std.meta.Child(std.meta.Child(@FieldType(Input, "columns")));

const Rebase = struct {
    kinds: []const u8,
    first: []const u32,
    target: *const []u32,
    children: u32,
    fields: u32,
    names: u32,
};

fn materialize(allocator: std.mem.Allocator, sources: anytype, tails: anytype, offsets: Rebase) std.mem.Allocator.Error!void {
    var columns: [tails.len]Column = undefined;
    var pointers: [tails.len]*const Column = undefined;

    inline for (sources, 0..) |source, index| {
        columns[index] = .{ .source = source, .target = @ptrCast(&tails[index]) };
        pointers[index] = &columns[index];
    }

    var completed: [1]u64 = .{0};
    const progress: []u64 = &completed;

    errdefer inline for (tails, 0..) |tail, index| {
        if (index < completed[0]) for (tail) |text| allocator.free(text);
    };

    const input: Input = .{
        .columns = &pointers,
        .progress = @ptrCast(&progress),
        .kinds = offsets.kinds,
        .first = offsets.first,
        .target = @ptrCast(offsets.target),
        .children = offsets.children,
        .fields = offsets.fields,
        .names = offsets.names,
    };

    zx.columns.invoke(generated.executeValue, allocator, &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };
}
