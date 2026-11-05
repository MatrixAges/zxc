const std = @import("std");
const ir = @import("zx").ir;

pub fn check(types: ir.TypeTable, type_id: ir.TypeId) bool {
    if (@import("genz_options").generated_analysis) {
        const generated = @import("generated_scalar_type");
        var memory = std.heap.FixedBufferAllocator.init(&.{});

        return generated.executeIn(memory.allocator(), &.{ .kinds = types.kinds, .first = types.first, .type_id = @backingInt(type_id) }) catch |err| std.debug.panic("scalar type query failed: {s}", .{@errorName(err)});
    }

    var value = types.get(type_id);

    while (value == .optional) value = types.get(value.optional);

    return switch (value) {
        .scalar, .enumeration, .error_set => true,
        else => false,
    };
}
