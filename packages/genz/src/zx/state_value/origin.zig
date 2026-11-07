const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");

pub fn name(self: *const Lower, id: ir.TypeId) Lower.Error![]const u8 {
    if (!@import("genz_options").generated_analysis) return @import("origin_seed.zig").name(self, id);

    const generated = @import("generated_origin_name");
    const Input = std.meta.Child(generated.Input);
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), self.program.types);
    const input: Input = .{ .types = &types, .id = @backingInt(id) };

    return @import("zx").columns.invoke(generated.executeValue, self.allocator, &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };
}

pub fn tuple(self: *Lower, id: ir.TypeId, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("origin_seed.zig").tuple(self, id, value);

    return @import("../construction/origin.zig").lower(self, id, value);
}
