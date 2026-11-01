const std = @import("std");
const zx = @import("zx");

pub fn validate(allocator: std.mem.Allocator, types: zx.ir.TypeTable, values: []const zx.ir.Constant) std.mem.Allocator.Error!bool {
    if (values.len == 0) return true;
    if (comptime !@import("parser_options").generated_parser) return @import("input.zig").nativeValid(types, values);

    const generated = @import("generated_constant_values");
    const Input = std.meta.Child(generated.Input);
    const Tables = std.meta.Child(@FieldType(Input, "types"));
    const Table = std.meta.Child(@FieldType(Tables, "base"));
    const Delta = std.meta.Child(@FieldType(Tables, "delta"));
    const Values = std.meta.Child(@typeInfo(@FieldType(Input, "constants")).optional.child);
    var arena = zx.Arena.init(allocator);

    defer arena.deinit();

    const table = zx.ir.TypeTable.borrow(Table, types);
    const delta = zx.ir.TypeTable.borrow(Delta, .{});
    const tables: Tables = .{ .base = &table, .delta = &delta };

    const input: Input = .{
        .types = &tables,
        .constants = try @import("input.zig").marshal(Values, arena.allocator(), values),
    };

    return generated.executeIn(arena.allocator(), &input) catch |err| switch (err) {
        error.OutOfMemory => error.OutOfMemory,
        else => false,
    };
}
