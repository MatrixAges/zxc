const std = @import("std");
const zx = @import("zx");
const generated = @import("generated_ir_control_structure");

pub fn valid(allocator: std.mem.Allocator, value: zx.ir.ControlBody) std.mem.Allocator.Error!bool {
    const Input = std.meta.Child(generated.Input);
    const Control = @FieldType(Input, "control");

    const input: Input = .{
        .control = zx.columns.pointer(Control, value.control),
        .root = if (value.root) |root| @backingInt(root) else null,
    };

    var arena = std.heap.ArenaAllocator.init(allocator);
    var buffer: [2048]u8 = undefined;
    var scratch = std.heap.BufferFirstAllocator.init(&buffer, arena.allocator());

    defer arena.deinit();

    return zx.columns.invoke(generated.executeValue, scratch.allocator(), &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.Overflow => error.OutOfMemory,
        else => false,
    };
}
