const std = @import("std");
const ir = @import("zx").ir;
const Flags = @import("type_flags_view");

pub fn contains(allocator: std.mem.Allocator, table: ir.TypeTable, id: ir.TypeId, native_references: bool) std.mem.Allocator.Error!bool {
    var state: Flags.State = .{};
    const flags = Flags{ .allocator = allocator, .state = &state };

    defer flags.deinit();

    const generated = @import("generated_type_query");
    const Input = @typeInfo(generated.Input).pointer.child;
    const Table = @typeInfo(@FieldType(Input, "table")).pointer.child;
    const borrowed = ir.TypeTable.borrow(Table, table);
    const input: Input = .{ .table = &borrowed, .id = @backingInt(id), .flags = @ptrCast(&flags), .native_references = native_references };
    var storage: [0]u8 = undefined;
    var fixed = std.heap.FixedBufferAllocator.init(&storage);
    var arena = std.heap.ArenaAllocator.init(fixed.allocator());

    defer arena.deinit();

    return generated.execute(&arena, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };
}
