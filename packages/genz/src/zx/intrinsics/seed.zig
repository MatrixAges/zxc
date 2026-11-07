const std = @import("std");
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");
const intrinsics = @import("../intrinsics.zig");

pub fn index(self: *Lower, values: node.ExpressionId, position: node.ExpressionId) Lower.Error!node.ExpressionId {
    var body: std.ArrayList(node.Statement) = .empty;
    const source = try aggregate.bind(self, &body, values);
    const offset = try aggregate.bind(self, &body, position);

    try failIf(self, &body, try intrinsics.binary(self, .greater_equal, offset, try self.field(source, "len")), "IndexOutOfBounds");

    return aggregate.finish(self, &body, try self.builder.expression(.{ .index = .{ .target = source, .index = try self.builtin(.intCast, &.{offset}) } }));
}

pub fn failIf(self: *Lower, body: *std.ArrayList(node.Statement), condition: node.ExpressionId, name: []const u8) Lower.Error!void {
    const value = try self.builder.expression(.{ .error_value = name });

    const failure = if (self.capture) |boundary|
        try self.allocator.dupe(node.Statement, &.{ .{ .constant = .{ .name = boundary.name, .value = value } }, .{ .break_value = .{ .label = boundary.label, .value = boundary.failure } } })

    else
        try self.allocator.dupe(node.Statement, &.{.{ .result = value }});
    try body.append(self.allocator, .{ .branch = .{ .condition = condition, .yes = try self.builder.statements(failure), .no = .{} } });
}
