const std = @import("std");
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const intrinsic = @import("../intrinsics.zig");

pub fn less(self: *Lower, child: node.ExpressionId) Lower.Error!node.Declaration {
    const context = try self.builder.identifier("context");
    const failure = try self.field(context, "failure");
    const no = try self.builder.expression(.{ .boolean = false });
    var body: std.ArrayList(node.Statement) = .empty;

    try body.append(self.allocator, try self.builder.branch(try intrinsic.binary(self, .not_equal, failure, try self.builder.expression(.null_value)), &.{.{ .result = no }}, &.{}));

    const compared = try self.call(try self.builder.identifier("compare"), &.{ context, try self.builder.identifier("left"), try self.builder.identifier("right") }, false);
    const caught = try self.builder.expression(.{ .catch_scope = .{ .value = compared, .capture = "err", .body = try self.builder.statements(&.{ .{ .assignment = .{ .target = failure, .value = try self.builder.identifier("err") } }, .{ .result = no } }) } });

    try body.append(self.allocator, .{ .result = try intrinsic.binary(self, .less, caught, try self.builder.integer(0)) });

    const comparison: node.Declaration = .{ .function = .{
        .name = "less",
        .parameters = try self.allocator.dupe(node.Field, &.{ .{ .name = "context", .value = try self.builder.identifier("Context") }, .{ .name = "left", .value = child }, .{ .name = "right", .value = child } }),
        .return_type = try self.builder.expression(.{ .primitive = .bool }),
        .body = try self.builder.statements(body.items),
    } };

    return .{ .function = .{
        .name = "Ordering",
        .parameters = try self.allocator.dupe(node.Field, &.{.{ .name = "Context", .value = try self.builder.expression(.{ .primitive = .type }), .comptime_parameter = true }}),
        .return_type = try self.builder.expression(.{ .primitive = .type }),
        .body = try self.builder.statements(&.{.{ .result = try self.builder.expression(.{ .namespace_type = try self.allocator.dupe(node.Declaration, &.{comparison}) }) }}),
    } };
}

pub fn sort(self: *Lower, child: node.ExpressionId, errors: ?[]const []const u8) Lower.Error!node.Declaration {
    const context = try self.builder.identifier("context");
    const allocator = try self.field(context, "allocator");
    const items = try self.builder.identifier("items");
    var body: std.ArrayList(node.Statement) = .empty;

    try body.append(self.allocator, .{ .constant = .{ .name = "items", .value = try self.builder.expression(.{ .try_value = try self.call(try self.field(allocator, "dupe"), &.{ child, try self.builder.identifier("source") }, false) }) } });
    try body.append(self.allocator, .{ .errdefer_expression = try self.call(try self.field(allocator, "free"), &.{items}, false) });

    const ordering = try self.call(try self.builder.identifier("Ordering"), &.{try self.builtin(.TypeOf, &.{context})}, false);

    try body.append(self.allocator, .{ .expression = try intrinsic.standard(self, &.{ "mem", "sortUnstable" }, &.{ child, items, context, try self.field(ordering, "less") }, false) });

    try body.append(self.allocator, .{ .branch = .{
        .condition = try self.field(context, "failure"),
        .capture = "err",
        .yes = try self.builder.statements(&.{.{ .result = try self.builder.identifier("err") }}),
        .no = .{},
    } });

    try body.append(self.allocator, .{ .result = items });

    return .{ .function = .{
        .name = "sort",
        .parameters = try self.allocator.dupe(node.Field, &.{ .{ .name = "context", .value = try self.builder.expression(.{ .primitive = .@"anytype" }) }, .{ .name = "source", .value = try self.builder.expression(.{ .const_slice = child }) } }),
        .return_type = try self.builder.expression(.{ .error_union = .{ .payload = try self.builder.expression(.{ .mutable_slice = child }), .errors = errors } }),
        .body = try self.builder.statements(body.items),
    } };
}
