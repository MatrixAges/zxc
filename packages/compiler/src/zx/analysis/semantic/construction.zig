const std = @import("std");
const zx = @import("zx");
const Types = @import("../types.zig");

pub fn create(types: *Types, value: zx.ir.TypeValue) zx.Error!zx.ir.TypeId {
    const generated = @import("generated_type_construction");
    const Input = @typeInfo(generated.Input).pointer.child;
    const Tables = @typeInfo(@FieldType(Input, "tables")).pointer.child;
    const Table = @typeInfo(@FieldType(Tables, "base")).pointer.child;
    const Candidate = @typeInfo(@FieldType(Input, "candidate")).pointer.child;
    const Fields = @typeInfo(@FieldType(Candidate, "fields")).pointer.child;

    const fields: Fields = .{
        .names = if (value == .object) value.object.names else &.{},
        .types = if (value == .object) value.object.types else &.{},
    };

    const base = zx.ir.TypeTable.borrow(Table, types.items.view());
    const empty = zx.ir.TypeTable.borrow(Table, .{});
    const tables: Tables = .{ .base = &base, .delta = &empty };
    const candidate = @import("candidate.zig").borrow(Candidate, value, &fields);
    const input: Input = .{ .tables = &tables, .candidate = &candidate };
    var arena = std.heap.ArenaAllocator.init(types.scratch orelse types.allocator);

    defer arena.deinit();

    const result = zx.columns.invoke(generated.executeValue, arena.allocator(), &input) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    return commit(types, arena.allocator(), result, .{ .start = 0, .end = 0 }, value == .error_set);
}

pub fn commit(types: *Types, scratch: std.mem.Allocator, result: anytype, span: zx.Span, owns_names: bool) zx.Error!zx.ir.TypeId {
    if (result.diagnostic.message.len != 0) return types.reporter.fail(
        std.meta.stringToEnum(@FieldType(zx.Diagnostic, "code"), result.diagnostic.code) orelse unreachable,
        span,
        if (types.scratch != null) try types.allocator.dupe(u8, result.diagnostic.message) else result.diagnostic.message,
    );

    const row = result.row orelse return @fromBackingInt(result.id);

    var delta: zx.ir.TypeTable = .{
        .kinds = &.{row.layout.kind},
        .first = &.{row.layout.first},
        .second = &.{row.layout.second},
        .labels = &.{row.label},
        .children = row.children,
        .field_types = row.fields.types,
        .field_names = row.fields.names,
        .names = row.names,
    };

    if (owns_names) {
        const names = try scratch.alloc([]const u8, delta.names.len);
        var copied: usize = 0;

        errdefer for (names[0..copied]) |name| types.allocator.free(name);

        for (delta.names, names) |name, *owned| {
            owned.* = try types.allocator.dupe(u8, name);
            copied += 1;
        }

        delta.names = names;

        try publish(types, delta);
    } else try publish(types, delta);

    return @fromBackingInt(result.id);
}

fn publish(types: *Types, row: zx.ir.TypeTable) zx.Error!void {
    const first = try types.items.reserveDelta(types.allocator, row);

    first[0] = row.first[0];

    types.items.publishDelta(row);
}
