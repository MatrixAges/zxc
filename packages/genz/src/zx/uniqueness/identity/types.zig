const std = @import("std");
const zx = @import("zx");
const generated = @import("generated_uniqueness_types_identity");
const Input = std.meta.Child(generated.Input);

pub fn build(value: zx.ir.TypeTable) [32]u8 {
    var hash: zx.Sha256 = undefined;
    const types = zx.ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), value);

    const input: Input = .{
        .hash = @ptrCast(&hash),
        .types = &types,
    };

    var memory = std.heap.FixedBufferAllocator.init(&.{});

    generated.executeIn(memory.allocator(), &input) catch |err| std.debug.panic("types identity failed: {s}", .{@errorName(err)});

    return hash.finalResult();
}
