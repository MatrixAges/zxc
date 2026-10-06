const std = @import("std");
const zx = @import("zx");
const Types = @import("../types.zig");

pub fn create(types: *Types, value: zx.ir.TypeValue) zx.Error!zx.ir.TypeId {
    const generated = @import("generated_type_construction");
    const Input = @typeInfo(generated.Input).pointer.child;
    const Table = @typeInfo(@FieldType(Input, "table")).pointer.child;
    const Candidate = @typeInfo(@FieldType(Input, "candidate")).pointer.child;
    const Fields = @typeInfo(@FieldType(Candidate, "fields")).pointer.child;

    const fields: Fields = .{
        .names = if (value == .object) value.object.names else &.{},
        .types = if (value == .object) value.object.types else &.{},
    };

    const table = zx.ir.TypeTable.borrow(Table, types.items.view());
    const candidate = @import("candidate.zig").borrow(Candidate, value, &fields);
    const input: Input = .{ .table = &table, .candidate = &candidate };
    var arena = std.heap.ArenaAllocator.init(types.allocator);

    defer arena.deinit();

    const result = generated.execute(&arena, &input) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow => return error.OutOfMemory,
        else => unreachable,
    };

    if (result.diagnostic.message.len != 0) return types.reporter.fail(
        std.meta.stringToEnum(@FieldType(zx.Diagnostic, "code"), result.diagnostic.code) orelse unreachable,
        .{ .start = 0, .end = 0 },
        result.diagnostic.message,
    );

    var delta: zx.ir.TypeTable = undefined;

    inline for (@typeInfo(zx.ir.TypeTable).@"struct".field_names) |name| @field(delta, name) = @field(result.delta.*, name);

    if (delta.count() == 0) return @fromBackingInt(result.id);

    if (value == .error_set) {
        const names = try types.allocator.alloc([]const u8, delta.names.len);

        defer types.allocator.free(names);

        var copied: usize = 0;

        errdefer for (names[0..copied]) |name| types.allocator.free(name);

        for (delta.names, names) |name, *owned| {
            owned.* = try types.allocator.dupe(u8, name);
            copied += 1;
        }

        delta.names = names;

        try types.items.appendDelta(types.allocator, delta);
    } else try types.items.appendDelta(types.allocator, delta);

    return @fromBackingInt(result.id);
}
