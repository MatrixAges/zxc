const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;

pub fn writes(values: ir.Block) bool {
    if (!@import("genz_options").generated_analysis) return @import("seed.zig").writes(values);

    const entry = @import("generated_control_writes");
    const Input = std.meta.Child(entry.Input);

    const input: Input = .{
        .control = zx.columns.pointer(@FieldType(Input, "control"), values.control),
        .first = values.first,
        .count = values.len,
    };

    var memory = std.heap.FixedBufferAllocator.init(&.{});

    return zx.columns.invoke(entry.executeValue, memory.allocator(), &input) catch unreachable;
}
