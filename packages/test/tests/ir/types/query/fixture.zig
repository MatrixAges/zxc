const std = @import("std");
pub const frontend = @import("frontend");
pub const query = @import("query");
pub const ir = frontend.ir;
pub const Mode = enum { native_reference, list };

pub fn scalar(value: ir.Scalar) ir.TypeId {
    return @fromBackingInt(@intCast(@backingInt(value)));
}

pub fn base(memory: std.mem.Allocator) !ir.TypeStorage {
    var result: ir.TypeStorage = .{};

    for (std.enums.values(ir.Scalar)) |value| try result.append(memory, .{ .scalar = value });

    return result;
}

pub fn add(memory: std.mem.Allocator, storage: *ir.TypeStorage, value: ir.TypeValue) !ir.TypeId {
    const id: ir.TypeId = @fromBackingInt(@intCast(storage.count()));

    try storage.append(memory, value);

    return id;
}

pub fn run(memory: std.mem.Allocator, types: ir.TypeTable, id: ir.TypeId, mode: Mode) !bool {
    const Input = @typeInfo(query.Input).pointer.child;
    const Table = @typeInfo(@FieldType(Input, "table")).pointer.child;
    const borrowed = ir.TypeTable.borrow(Table, types);
    const input: Input = .{ .table = &borrowed, .id = @backingInt(id), .native_references = mode == .native_reference };
    var arena = std.heap.ArenaAllocator.init(memory);

    defer arena.deinit();

    return query.execute(&arena, &input);
}

pub fn copyColumns(memory: std.mem.Allocator, value: ir.TypeTable) !ir.TypeTable {
    var result: ir.TypeTable = .{};

    inline for (@typeInfo(ir.TypeTable).@"struct".field_names) |name| {
        const column = @field(value, name);
        const copied = try memory.dupe(@typeInfo(@TypeOf(column)).pointer.child, column);

        if (@typeInfo(@TypeOf(column)).pointer.child == []const u8) {
            for (column, copied) |text, *item| item.* = try memory.dupe(u8, text);
        }

        @field(result, name) = copied;
    }

    return result;
}

pub fn unchanged(before: ir.TypeTable, after: ir.TypeTable) !void {
    inline for (@typeInfo(ir.TypeTable).@"struct".field_names) |name| {
        const left = @field(before, name);
        const right = @field(after, name);

        try std.testing.expectEqual(left.len, right.len);

        if (@typeInfo(@TypeOf(left)).pointer.child == []const u8) {
            for (left, right) |a, b| try std.testing.expectEqualStrings(a, b);
        } else try std.testing.expectEqualSlices(@typeInfo(@TypeOf(left)).pointer.child, left, right);
    }
}

pub fn valid(types: ir.TypeTable) !void {
    try std.testing.expect(frontend.validateTypes(types));
}
