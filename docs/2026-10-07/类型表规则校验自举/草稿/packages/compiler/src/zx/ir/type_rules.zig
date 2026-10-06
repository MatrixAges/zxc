const std = @import("std");
const ir = @import("zx").ir;

pub fn validate(types: ir.TypeTable) bool {
    if (!@import("parser_options").generated_parser) return @import("seed_type_rules.zig").validate(types);

    const generated = @import("generated_type_validation");
    const Input = @typeInfo(generated.Input).pointer.child;
    const Table = @typeInfo(@FieldType(Input, "table")).pointer.child;
    const table = ir.TypeTable.borrow(Table, types);
    const names = @import("type_names").View{ .labels = types.labels, .fields = types.field_names, .members = types.names };
    const input: Input = .{ .table = &table, .scalar_count = std.enums.values(ir.Scalar).len, .maximum_count = std.math.maxInt(u32), .names = @ptrCast(&names) };
    var storage: [0]u8 = undefined;
    var fixed = std.heap.FixedBufferAllocator.init(&storage);
    var arena = std.heap.ArenaAllocator.init(fixed.allocator());

    defer arena.deinit();

    return generated.execute(&arena, &input) catch unreachable;
}
