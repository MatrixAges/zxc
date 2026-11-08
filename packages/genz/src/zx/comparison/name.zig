const std = @import("std");
const zx = @import("zx");
const Lower = @import("../lower.zig");

pub fn lower(self: *Lower, type_id: zx.ir.TypeId) Lower.Error![]const u8 {
    const generated = @import("generated_comparison_name");
    const Input = std.meta.Child(generated.Input);

    const input: Input = .{
        .type_id = @backingInt(type_id),
        .scalar = @backingInt(self.program.typeOf(type_id).scalar),
        .named = self.type_names != null,
    };

    return zx.columns.invoke(generated.executeValue, self.allocator, @as(*const Input, &input)) catch |err| switch (err) {
        error.OutOfMemory, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };
}
