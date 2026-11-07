const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Lower = @import("../lower.zig");
const Consumer = @import("../iteration_consumer.zig").Consumer;
const Cache = @import("../expression_map.zig").Map(ir.ExprId);
const enabled = @import("genz_options").generated_analysis;
const generated = if (enabled) @import("generated_iteration_result") else struct {};
pub const Output = if (enabled) std.meta.Child(generated.Output) else void;

pub fn analyze(allocator: std.mem.Allocator, program: *const ir.Program, cache: ?*const Cache, selected: Consumer, comptime mode: anytype, capture: bool) Lower.Error!*const Output {
    const Input = std.meta.Child(generated.Input);
    const Cached = std.meta.Child(@typeInfo(@FieldType(Input, "cached")).optional.child);
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), program.types);
    const cached: Cached = if (cache) |value| value.view(Cached) else undefined;

    const input: Input = .{
        .types = &types,
        .table = zx.columns.pointer(@FieldType(Input, "table"), &program.expressions),
        .symbol = @backingInt(selected.symbol),
        .result = @backingInt(selected.result),
        .cached = if (cache != null) &cached else null,
        .capture = capture,
        .mode = @field(@FieldType(Input, "mode"), @tagName(mode)),
    };

    return generated.executeIn(allocator, &input) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow => error.OutOfMemory,
        else => unreachable,
    };
}
