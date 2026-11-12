const std = @import("std");
const ir = @import("zx").ir;
const Call = @import("host.zig").Call;

pub fn write(allocator: std.mem.Allocator, program: *ir.Program, call: Call) std.mem.Allocator.Error!void {
    const stores = try allocator.alloc(u32, call.store_types.len);

    for (stores, 0..) |*store, index| store.* = @intCast(index);

    const parameter = call.parameter;
    program.symbols = try ir.SymbolTable.fromValues(allocator, &.{parameter});

    program.expressions = try ir.ExpressionTable.fromValues(allocator, &.{
        .{ .type_id = program.input_type, .span = parameter.span, .value = if (call.unit) .unit else .{ .reference = @fromBackingInt(@as(u32, 0)) } },
        .{ .type_id = program.output_type, .span = parameter.span, .value = .{ .call = .{ .function = call.id, .argument = @fromBackingInt(@as(u32, 0)), .stores = stores } } },
    });

    program.body = try ir.ControlBody.fromValues(allocator, &.{.{ .result = @fromBackingInt(@as(u32, 1)) }});
}
