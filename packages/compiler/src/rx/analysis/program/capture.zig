const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Binding = @import("frontend").expressions.Binding;
const Builder = @import("builder.zig");

pub fn bind(builder: *Builder, input_type: ir.TypeId, captures: []const Binding, span: zx.Span) std.mem.Allocator.Error!void {
    const input = try builder.symbol("@environment", input_type, span);
    const reference = try builder.expression(.{ .type_id = input_type, .span = span, .value = .{ .reference = input } });

    for (captures, 0..) |capture, index| {
        const symbol = try builder.symbol(capture.name, capture.type_id, span);
        const value = try builder.expression(.{ .type_id = capture.type_id, .span = span, .value = .{ .tuple_field = .{ .target = reference, .index = @intCast(index) } } });

        try builder.body.append(builder.allocator, .{ .constant = .{ .symbol = symbol, .value = value } });
        try builder.bindings.append(builder.allocator, symbol);
    }
}

pub fn argument(allocator: std.mem.Allocator, owner: []const u8, types: ir.TypeTable, environment_type: ir.TypeId, environment: []const Binding, input_type: ir.TypeId, captures: []const Binding, span: zx.Span) std.mem.Allocator.Error!ir.Program {
    var builder = Builder{ .allocator = allocator, .types = types, .native_modules = &.{} };

    try bind(&builder, environment_type, environment, span);

    const elements = try allocator.alloc(ir.ExprId, captures.len);

    for (captures, elements) |capture, *value| {
        for (environment, builder.bindings.items) |binding, symbol| {
            if (!std.mem.eql(u8, binding.name, capture.name)) continue;

            value.* = try builder.expression(.{ .type_id = capture.type_id, .span = span, .value = .{ .reference = symbol } });

            break;
        } else unreachable;
    }

    const result = try builder.expression(.{ .type_id = input_type, .span = span, .value = .{ .tuple = elements } });

    try builder.body.append(allocator, .{ .result = result });

    return .{ .file_name = owner, .types = types, .input_type = environment_type, .output_type = input_type, .symbols = builder.symbols.view(), .expressions = builder.expressions.view(), .body = try ir.ControlBody.fromValues(allocator, builder.body.items) };
}
