const std = @import("std");
pub const compiler = @import("compiler");
pub const ir = compiler.ir;

pub fn group(storage: *ir.TypeStorage, allocator: std.mem.Allocator, offset: usize) !void {
    const first = storage.count() + offset;
    const u64_id: ir.TypeId = @fromBackingInt(@intCast(@backingInt(ir.Scalar.u64)));
    const bool_id: ir.TypeId = @fromBackingInt(@intCast(@backingInt(ir.Scalar.bool)));
    const pair: ir.TypeId = @fromBackingInt(@intCast(first));
    const saved: ir.TypeId = @fromBackingInt(@intCast(first + 1));
    const record: ir.TypeId = @fromBackingInt(@intCast(first + 2));
    const errors: ir.TypeId = @fromBackingInt(@intCast(first + 4));

    try storage.append(allocator, .{ .tuple = &.{ u64_id, bool_id } });
    try storage.append(allocator, .{ .optional = u64_id });
    try storage.append(allocator, .{ .object = .{ .names = &.{ "pair", "saved" }, .types = &.{ @backingInt(pair), @backingInt(saved) }, .len = 2 } });
    try storage.append(allocator, .{ .list = record });
    try storage.append(allocator, .{ .error_set = &.{"Failure"} });
    try storage.append(allocator, .{ .enumeration = .{ .name = "Mode", .members = &.{ "First", "Second" } } });
    try storage.append(allocator, .{ .task = .{ .result = record, .errors = errors } });
}

pub fn seed(allocator: std.mem.Allocator) !ir.TypeStorage {
    var storage: ir.TypeStorage = .{};

    errdefer storage.deinit(allocator);

    inline for (@typeInfo(ir.Scalar).@"enum".field_names) |name| {
        try storage.append(allocator, .{ .scalar = @field(ir.Scalar, name) });
    }

    try group(&storage, allocator, 0);

    return storage;
}

pub fn equal(left: ir.TypeTable, right: ir.TypeTable) !void {
    inline for (@typeInfo(ir.TypeTable).@"struct".field_names) |name| {
        const actual = @field(left, name);
        const expected = @field(right, name);
        const Element = @typeInfo(@TypeOf(actual)).pointer.child;

        try std.testing.expectEqual(expected.len, actual.len);

        if (Element == []const u8) {
            for (actual, expected) |a, b| try std.testing.expectEqualStrings(b, a);
        } else try std.testing.expectEqualSlices(Element, expected, actual);
    }
}

pub fn valid(table: ir.TypeTable) !void {
    try std.testing.expect(table.validStructure());

    const program: ir.Program = .{
        .file_name = "storage.zx",
        .types = table,
        .symbols = .{},
        .expressions = &.{},
        .input_type = @fromBackingInt(0),
        .output_type = @fromBackingInt(0),
        .body = &.{},
        .type_only = true,
    };

    try std.testing.expect(try compiler.validateIr(std.testing.allocator, program) == null);
}
