const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");

pub fn lower(self: *Lower, output: *std.ArrayList(node.Declaration)) Lower.Error!void {
    for (self.program.types, 0..) |value, index| {
        if (value == .task) continue;

        var fields: std.ArrayList(node.Field) = .empty;

        const kind: []const u8 = switch (value) {
            .scalar => |scalar| if (scalar == .string) "string" else "scalar",
            .enumeration, .error_set => "scalar",
            .optional => "optional",
            .list => "list",
            .object, .tuple => "object",
            .native_reference => "native_reference",
            .task => unreachable,
        };

        try fields.append(self.allocator, .{ .name = "kind", .value = try self.builder.expression(.{ .enum_literal = kind }) });

        switch (value) {
            .list, .optional => |child| try fields.append(self.allocator, .{ .name = "child", .value = try reference(self, child) }),
            .object, .tuple => {
                var children: std.ArrayList(node.Field) = .empty;

                switch (value) {
                    .object => |items| for (items) |field| {
                        try children.append(self.allocator, .{ .name = field.name, .value = try reference(self, field.type_id) });
                    },
                    .tuple => |items| for (items, 0..) |child, child_index| {
                        try children.append(self.allocator, .{ .name = try std.fmt.allocPrint(self.allocator, "{d}", .{child_index}), .value = try reference(self, child) });
                    },
                    else => unreachable,
                }

                try fields.append(self.allocator, .{ .name = "fields", .value = try self.builder.expression(.{ .object = .{ .fields = try children.toOwnedSlice(self.allocator) } }) });
            },
            else => {},
        }

        try output.append(self.allocator, .{ .constant = .{
            .name = try std.fmt.allocPrint(self.allocator, "zx_shape_{d}", .{index}),
            .value = try self.builder.expression(.{ .object = .{ .fields = try fields.toOwnedSlice(self.allocator) } }),
        } });
    }

    try output.append(self.allocator, .{ .constant = .{ .name = "input_shape", .value = try reference(self, self.program.input_type), .exported = true } });
    try output.append(self.allocator, .{ .constant = .{ .name = "output_shape", .value = try reference(self, self.program.output_type), .exported = true } });
}

fn reference(self: *Lower, id: ir.TypeId) Lower.Error!*const node.Expression {
    return self.builder.identifier(try std.fmt.allocPrint(self.allocator, "zx_shape_{d}", .{@backingInt(id)}));
}
