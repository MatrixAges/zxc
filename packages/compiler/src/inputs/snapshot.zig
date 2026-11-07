const std = @import("std");
const zx = @import("zx");
const generated = @import("generated_input_snapshot");
pub const Input = std.meta.Child(generated.Input);
pub const Files = std.meta.Child(@FieldType(Input, "current"));
pub const Snapshot = std.meta.Child(@FieldType(Input, "previous"));

pub fn reuse(allocator: std.mem.Allocator, input: Input) std.mem.Allocator.Error!bool {
    return zx.columns.invoke(generated.executeValue, allocator, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => return false,
    };
}
