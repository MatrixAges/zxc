const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");

pub fn append(self: *Lower, body: *std.ArrayList(node.Statement), type_id: ir.TypeId, target: node.ExpressionId, value: node.ExpressionId) Lower.Error!void {
    if (!self.state_active or !self.state_plan.selected[@backingInt(type_id)]) {
        return body.append(self.allocator, .{ .assignment = .{ .target = target, .value = value } });
    }

    const result = try aggregate.bind(self, body, value);
    var assignments: std.ArrayList(node.Statement) = .empty;

    try collect(self, body, &assignments, type_id, target, result);
    try body.appendSlice(self.allocator, assignments.items);
}

fn collect(self: *Lower, snapshots: *std.ArrayList(node.Statement), assignments: *std.ArrayList(node.Statement), type_id: ir.TypeId, target: node.ExpressionId, value: node.ExpressionId) Lower.Error!void {
    if (self.state_plan.selected[@backingInt(type_id)]) switch (self.program.typeOf(type_id)) {
        .object => |fields| {
            for (0..fields.len) |index| {
                const field = fields.at(index);

                try collect(self, snapshots, assignments, field.type_id, try self.field(target, field.name), try self.field(value, field.name));
            }

            const origin = try @import("../state_value/origin.zig").name(self, type_id);

            return save(self, snapshots, assignments, try self.field(target, origin), try self.field(value, origin));
        },
        .tuple => |fields| {
            for (0..fields.len) |index| {
                const name = try std.fmt.allocPrint(self.allocator, "{d}", .{index});

                try collect(self, snapshots, assignments, fields.at(index), try self.field(target, name), try self.field(value, name));
            }

            const origin = try @import("../state_value/origin.zig").name(self, type_id);

            return save(self, snapshots, assignments, try self.field(target, origin), try self.field(value, origin));
        },
        .list => {
            try save(self, snapshots, assignments, try self.field(target, "items"), try self.field(value, "items"));

            return save(self, snapshots, assignments, try self.field(target, "storage"), try self.field(value, "storage"));
        },
        else => {},
    };

    return save(self, snapshots, assignments, target, value);
}

fn save(self: *Lower, snapshots: *std.ArrayList(node.Statement), assignments: *std.ArrayList(node.Statement), target: node.ExpressionId, value: node.ExpressionId) Lower.Error!void {
    const snapshot = try aggregate.bind(self, snapshots, value);

    try assignments.append(self.allocator, .{ .assignment = .{ .target = target, .value = snapshot } });
}
