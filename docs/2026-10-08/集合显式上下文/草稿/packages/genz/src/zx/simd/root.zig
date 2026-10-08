const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");
const intrinsic = @import("../intrinsics.zig");
const expression = @import("expression.zig");

pub fn lower(self: *Lower, id: ir.ExprId, value: ir.Transform) Lower.Error!?*const node.Expression {
    if (value.kind != .map or value.initial != null) return null;

    const input = self.program.typeOf(self.program.expression(value.target).type_id).list;
    const output = self.program.typeOf(self.program.expression(id).type_id).list;
    const scalar = self.program.typeOf(input);

    if (input != output or scalar != .scalar or (scalar.scalar != .f32 and scalar.scalar != .f64)) return null;

    const symbol = value.parameters[0];

    if (!expression.supported(self.program, value.body, symbol, input)) return null;

    var body: std.ArrayList(node.Statement) = .empty;
    const source = try aggregate.bind(self, &body, try self.expr(value.target));
    const element_type = self.types[@backingInt(input)];
    const length = try self.field(source, "len");
    const result = try aggregate.bind(self, &body, try self.call(try self.field(try self.builder.identifier("allocator"), "alloc"), &.{ element_type, length }, true));
    const suggested = try intrinsic.standard(self, &.{ "simd", "suggestVectorLength" }, &.{element_type}, false);
    const width = try aggregate.bind(self, &body, try self.builder.expression(.{ .comptime_value = try intrinsic.binary(self, .coalesce, suggested, try self.builder.integer(1)) }));
    const vector_type = try self.builtin(.Vector, &.{ width, element_type });
    const chunks = try aggregate.bind(self, &body, try intrinsic.binary(self, .divide, length, width));
    const chunk_name = try self.fresh("chunk");
    var vector_body: std.ArrayList(node.Statement) = .empty;
    const offset = try aggregate.bind(self, &vector_body, try intrinsic.binary(self, .multiply, try self.builder.identifier(chunk_name), width));
    const element = try self.cast(vector_type, try chunk(self, source, offset, width));

    try vector_body.append(self.allocator, .{ .assignment = .{
        .target = try chunk(self, result, offset, width),
        .value = try expression.lower(self, value.body, vector_type, element),
    } });

    try body.append(self.allocator, .{ .for_loop = .{
        .iterable = try self.builder.expression(.{ .range = .{ .start = try self.builder.integer(0), .end = chunks } }),
        .capture = chunk_name,
        .body = try vector_body.toOwnedSlice(self.allocator),
    } });

    const tail = try aggregate.bind(self, &body, try intrinsic.binary(self, .multiply, chunks, width));
    const index_name = try self.fresh("index");
    const callback = try self.expr(value.body);

    const assignment = node.Statement{ .assignment = .{
        .target = try self.builder.expression(.{ .index = .{ .target = result, .index = try intrinsic.binary(self, .add, tail, try self.builder.identifier(index_name)) } }),
        .value = callback,
    } };

    try body.append(self.allocator, .{ .for_loop = .{
        .iterable = try self.builder.expression(.{ .slice = .{ .target = source, .start = tail } }),
        .capture = if (self.used[@backingInt(symbol)]) self.names[@backingInt(symbol)] else "_",
        .index_capture = index_name,
        .body = try self.allocator.dupe(node.Statement, &.{assignment}),
    } });

    return try aggregate.finish(self, &body, result);
}

fn chunk(self: *Lower, target: *const node.Expression, offset: *const node.Expression, width: *const node.Expression) Lower.Error!*const node.Expression {
    const remaining = try self.builder.expression(.{ .slice = .{ .target = target, .start = offset } });
    const values = try self.builder.expression(.{ .slice = .{ .target = remaining, .start = try self.builder.integer(0), .end = width } });

    return self.builder.expression(.{ .dereference = values });
}
