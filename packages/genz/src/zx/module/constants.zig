const std = @import("std");
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
pub const namespace = "zx.constants";

pub fn append(self: *Lower, output: *std.ArrayList(node.Declaration)) Lower.Error!void {
    const exports = self.program.constant_exports;

    if (exports.len == 0) return;

    const fields = try self.allocator.alloc(node.Field, exports.len);

    for (exports, fields) |item, *field| {
        const value = switch (item.value) {
            .integer => |number| try self.builder.integer(number),
            .negative_integer => |magnitude| try self.builder.expression(.{ .unary = .{
                .operator = .negate,
                .operand = try self.builder.integer(magnitude),
            } }),
            .float => |number| try self.builder.builtin(.floatCast, &.{
                try self.builder.expression(.{ .float = number }),
            }),
            .boolean => |boolean| try self.builder.expression(.{ .boolean = boolean }),
            .string => |string| try self.builder.string(string),
            .enumeration => |member| try self.builder.expression(.{
                .enum_literal = self.program.typeOf(item.type_id).enumeration.members[member],
            }),
        };

        field.* = .{
            .name = item.name,
            .value = try self.builder.builtin(.as, &.{ try self.typeExpr(item.type_id), value }),
        };
    }

    try output.append(self.allocator, .{ .constant = .{
        .name = namespace,
        .value = try self.builder.object(fields),
        .exported = true,
    } });
}
