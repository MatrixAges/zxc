const std = @import("std");
pub const f = @import("type_merge_fixture");
pub const Boundary = enum { empty, scalar, tuple, object, errors, enumeration, native, full };
pub const Scenario = enum { repeated, distinct, conflict };
pub const State = struct { table: f.Table, original: f.ir.TypeStorage, origins: f.Origins.Storage, first: usize, origin_count: usize, ids: f.Ids, repeated: f.Ids };

pub fn create(memory: std.mem.Allocator, boundary: Boundary, scenario: Scenario) !State {
    var table = try f.Table.init(memory);
    const ids = try f.fill(&table, .base);

    const first = switch (boundary) {
        .empty => 0,
        .scalar => std.enums.values(f.ir.Scalar).len,
        .tuple => @backingInt(ids.pair) + 1,
        .object => @backingInt(ids.record) + 1,
        .errors => @backingInt(ids.errors) + 1,
        .enumeration => @backingInt(ids.mode) + 1,
        .native => @backingInt(ids.node) + 1,
        .full => table.items.count(),
    };

    const origin_count = countOrigins(table.origins.items.view(), first);
    const previous_origins = table.origins.items.view().count();
    const repeated = try f.fill(&table, if (scenario == .conflict) .enum_member else .base);

    if (scenario == .distinct) {
        for (table.origins.items.owners.items[previous_origins..], table.origins.items.kinds.items[previous_origins..]) |*owner, kind| {
            owner.* = if (kind == 1) "zig:other" else "/fixture/other.zx";
        }
    }

    const tuple = try f.add(&table, .{ .tuple = &.{ repeated.node, repeated.mode, repeated.record } });

    _ = try f.add(&table, .{ .object = .{ .names = &.{ "later", "pair" }, .types = &.{ @backingInt(tuple), @backingInt(repeated.pair) }, .len = 2 } });

    var original: f.ir.TypeStorage = .{};
    var origins: f.Origins.Storage = .{};

    try original.appendDelta(memory, table.items.view());
    try origins.appendTable(memory, table.origins.items.view());

    return .{ .table = table, .original = original, .origins = origins, .first = first, .origin_count = origin_count, .ids = ids, .repeated = repeated };
}

pub fn countOrigins(origins: f.Bindings, first: usize) usize {
    var count: usize = 0;

    for (origins.ids) |id| {
        if (id < first) count += 1;
    }

    return count;
}

pub fn prefixOrigins(origins: f.Bindings, count: usize) f.Bindings {
    var value = origins;

    inline for (@typeInfo(f.Bindings).@"struct".field_names) |name| {
        @field(value, name) = @field(value, name)[0..count];
    }

    return value;
}

pub fn prefixUnchanged(state: State) !void {
    try f.columnsEqual(state.original.view().prefix(state.first), state.table.items.view().prefix(state.first));
    try f.columnsEqual(prefixOrigins(state.origins.view(), state.origin_count), prefixOrigins(state.table.origins.items.view(), state.origin_count));
}

pub fn pointersEqual(before: anytype, after: @TypeOf(before)) !void {
    inline for (@typeInfo(@TypeOf(before)).@"struct".field_names) |name| {
        try std.testing.expect(@field(before, name).ptr == @field(after, name).ptr);
    }
}
