const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");

pub fn name(self: *const Lower, id: ir.TypeId) Lower.Error![]const u8 {
    const value = self.program.typeOf(id);

    if (value == .tuple) return std.fmt.allocPrint(self.allocator, "{d}", .{value.tuple.len});

    var candidate: []const u8 = "zx_origin";
    var index: usize = 0;

    while (true) {
        const present = for (0..value.object.len) |view_index| {
            const field = value.object.at(view_index);

            if (std.mem.eql(u8, field.name, candidate)) break true;
        } else false;

        if (!present) return candidate;

        index += 1;
        candidate = try std.fmt.allocPrint(self.allocator, "zx_origin_{d}", .{index});
    }
}

pub fn tuple(self: *Lower, id: ir.TypeId, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("origin_seed.zig").tuple(self, id, value);

    return @import("../construction/origin.zig").lower(self, id, value);
}

pub fn clear(self: *Lower, body: *std.ArrayList(node.Statement), id: ir.TypeId, value: node.ExpressionId) Lower.Error!void {
    if (!@import("root.zig").selected(self, id)) return;

    if (self.state_plan.referenced(id)) {
        const copied = try @import("reference.zig").copy(self, body, id, value);

        try body.append(self.allocator, .{ .assignment = .{
            .target = try self.field(copied, try name(self, id)),
            .value = try self.builder.expression(.null_value),
        } });

        try body.append(self.allocator, .{ .assignment = .{
            .target = value,
            .value = try self.builder.expression(.{ .address_of = copied }),
        } });

        return;
    }

    try body.append(self.allocator, .{ .assignment = .{
        .target = try self.field(value, try name(self, id)),
        .value = try self.builder.expression(.null_value),
    } });
}
