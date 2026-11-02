const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Consumer = @import("../iteration_consumer.zig").Consumer;

pub const Plan = if (@import("genz_options").generated_analysis)
    @import("generated_simd_plan").Output

else
    void;

pub fn analyze(allocator: std.mem.Allocator, program: ir.Program, subject: ir.ExprId, consumer: ?Consumer) std.mem.Allocator.Error!Plan {
    const generated = @import("generated_simd_plan");
    const Input = std.meta.Child(generated.Input);
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), program.types);

    const input = Input{
        .types = &types,
        .expressions = zx.columns.pointer(@FieldType(Input, "expressions"), &program.expressions),
        .subject = @backingInt(subject),
        .consumer = if (consumer) |value| &.{ .symbol = @backingInt(value.symbol), .result = @backingInt(value.result) } else null,
    };

    return generated.executeIn(allocator, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };
}
