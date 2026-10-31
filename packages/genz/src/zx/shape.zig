const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");

pub fn lower(self: *Lower, output: *std.ArrayList(node.Declaration)) Lower.Error!void {
    const plan = try @import("shape/planning.zig").create(self.allocator, self.program.types, self.program.input_type, self.program.output_type);

    for (plan.type_ids) |index| {
        const value = self.program.types.at(index);

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
            .list, .optional => |child| try fields.append(self.allocator, .{ .name = "child", .value = try reference(self, plan.numbers, child) }),
            .object, .tuple => {
                var children: std.ArrayList(node.Field) = .empty;

                switch (value) {
                    .object => |items| for (0..items.len) |view_index| {
                        const field = items.at(view_index);

                        try children.append(self.allocator, .{ .name = field.name, .value = try reference(self, plan.numbers, field.type_id) });
                    },
                    .tuple => |items| for (0..items.len, 0..) |item_index, child_index| {
                        const child = items.at(item_index);

                        try children.append(self.allocator, .{ .name = try std.fmt.allocPrint(self.allocator, "{d}", .{child_index}), .value = try reference(self, plan.numbers, child) });
                    },
                    else => unreachable,
                }

                try fields.append(self.allocator, .{ .name = "fields", .value = try self.builder.expression(.{ .object = .{ .fields = try children.toOwnedSlice(self.allocator) } }) });
            },
            else => {},
        }

        try output.append(self.allocator, .{ .constant = .{
            .name = try std.fmt.allocPrint(self.allocator, "zx_shape_{d}", .{plan.numbers[index]}),
            .value = try self.builder.expression(.{ .object = .{ .fields = try fields.toOwnedSlice(self.allocator) } }),
        } });
    }

    try output.append(self.allocator, .{ .constant = .{ .name = "input_shape", .value = try reference(self, plan.numbers, self.program.input_type), .exported = true } });
    try output.append(self.allocator, .{ .constant = .{ .name = "output_shape", .value = try reference(self, plan.numbers, self.program.output_type), .exported = true } });
}

fn reference(self: *Lower, numbers: []const u32, id: ir.TypeId) Lower.Error!node.ExpressionId {
    return self.builder.identifier(try std.fmt.allocPrint(self.allocator, "zx_shape_{d}", .{numbers[@backingInt(id)]}));
}
