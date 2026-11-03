const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");
const aggregate = @import("aggregate.zig");
const intrinsic = @import("intrinsics.zig");

pub fn lower(self: *Lower, value: ir.Transform) Lower.Error!node.ExpressionId {
    var body: std.ArrayList(node.Statement) = .empty;
    const source = try aggregate.bind(self, &body, try @import("state_value/list.zig").expression(self, value.target));
    const label = try self.fresh("predicate");
    const identity = value.kind == .every;
    const callback = try self.expr(value.body);
    const element = value.parameters[0];
    const stop = node.Statement{ .break_value = .{ .label = label, .value = try self.builder.expression(.{ .boolean = !identity }) } };

    const decision = node.Statement{ .branch = .{
        .condition = try intrinsic.binary(self, .not_equal, callback, try self.builder.expression(.{ .boolean = identity })),
        .yes = try self.builder.statements(&.{stop}),
        .no = .{},
    } };

    try @import("transform/context.zig").bind(self, &body, value);

    var loop: std.ArrayList(node.Statement) = .empty;

    try loop.append(self.allocator, decision);

    const capture = try @import("state_value/elements.zig").captureName(self, &loop, self.program.expression(value.target).type_id, element);

    try body.append(self.allocator, .{ .for_loop = .{
        .iterable = source,
        .capture = capture,
        .body = try self.builder.statements(loop.items),
    } });

    try body.append(self.allocator, .{ .break_value = .{ .label = label, .value = try self.builder.expression(.{ .boolean = identity }) } });

    return self.builder.expression(.{ .block = .{ .label = label, .statements = try self.builder.statements(body.items) } });
}
