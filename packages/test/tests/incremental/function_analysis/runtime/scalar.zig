const std = @import("std");
const f = @import("../fixture.zig");
const ir = f.ir;
const span = @import("zx").Span{ .start = 0, .end = 0 };

pub fn program(allocator: std.mem.Allocator, count: usize) !ir.Program {
    var value = try f.program(allocator, count, .none);
    const functions = try allocator.alloc(ir.Function, count);

    for (functions, 0..) |*function, index| {
        function.* = value.functions.at(index);
        const scalar = function.input_type;

        function.expressions = try ir.ExpressionTable.fromValues(allocator, &.{
            .{ .type_id = scalar, .span = span, .value = .{ .reference = @fromBackingInt(0) } },
            .{ .type_id = scalar, .span = span, .value = .{ .integer = 1 } },
            .{ .type_id = scalar, .span = span, .value = if (index == 0) .{ .reference = @fromBackingInt(0) } else .{ .call = .{ .function = @fromBackingInt(@intCast(index - 1)), .argument = @fromBackingInt(0) } } },
            .{ .type_id = scalar, .span = span, .value = .{ .binary = .{ .operator = .add, .left = @fromBackingInt(2), .right = @fromBackingInt(1) } } },
        });

        function.body = try ir.ControlBody.fromValues(allocator, &.{.{ .result = @fromBackingInt(3) }});

        try std.testing.expect(function.expressions.validStructure());
        try std.testing.expect(try function.body.validStructure(allocator));
    }

    value.functions = try ir.FunctionTable.fromValues(allocator, functions);

    try std.testing.expect(value.functions.validStructure());

    return value;
}
