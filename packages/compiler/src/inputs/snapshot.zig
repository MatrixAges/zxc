const std = @import("std");
const zx = @import("zx");
pub const available = @import("parser_options").generated_parser;
const generated = if (available) @import("generated_input_snapshot") else struct {};
pub const Input = if (available) std.meta.Child(generated.Input) else void;
pub const Files = if (available) std.meta.Child(@FieldType(Input, "current")) else void;
pub const Snapshot = if (available) std.meta.Child(@FieldType(Input, "previous")) else void;

pub fn reuse(allocator: std.mem.Allocator, input: Input) std.mem.Allocator.Error!bool {
    if (!available) unreachable;

    return zx.columns.invoke(generated.executeValue, allocator, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => return false,
    };
}
