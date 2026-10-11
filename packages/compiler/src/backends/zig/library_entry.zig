const std = @import("std");
const ir = @import("zx").ir;
const Library = @import("../../library/root.zig").Result;

pub fn create(allocator: std.mem.Allocator, library: *const Library, index: usize) (std.mem.Allocator.Error || error{InvalidModule})!ir.Program {
    var program = try library.module(index);
    const function = library.exports[index].function orelse return program;

    if (program.stores.count() != 0) return program;

    const span = @import("zx").Span{ .start = 0, .end = 0 };

    program.symbols = try ir.SymbolTable.fromValues(allocator, &.{.{ .name = "$in", .type_id = program.input_type, .span = span }});

    program.expressions = try ir.ExpressionTable.fromValues(allocator, &.{
        .{
            .type_id = program.input_type,
            .span = span,
            .value = if (@backingInt(program.input_type) == @backingInt(ir.Scalar.void)) .unit else .{ .reference = @fromBackingInt(0) },
        },
        .{ .type_id = program.output_type, .span = span, .value = .{ .call = .{ .function = function, .argument = @fromBackingInt(0) } } },
    });

    program.body = try ir.ControlBody.fromValues(allocator, &.{.{ .result = @fromBackingInt(1) }});
    program.contracts = .{};

    return program;
}
