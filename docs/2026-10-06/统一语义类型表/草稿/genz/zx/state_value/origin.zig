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

pub fn tuple(self: *Lower, id: ir.TypeId, value: *const node.Expression) Lower.Error!*const node.Expression {
    if (!@import("root.zig").selected(self, id) or self.program.typeOf(id) != .tuple) return value;

    if (value.* == .conditional) {
        var conditional = value.conditional;
        conditional.yes = try tuple(self, id, conditional.yes);
        conditional.no = try tuple(self, id, conditional.no);

        return self.builder.expression(.{ .conditional = conditional });
    }

    if (value.* != .tuple) return value;
    if (value.tuple.len != self.program.typeOf(id).tuple.len) return value;

    const items = try self.allocator.alloc(*const node.Expression, value.tuple.len + 1);

    @memcpy(items[0..value.tuple.len], value.tuple);

    items[value.tuple.len] = try self.builder.expression(.null_value);

    return self.builder.expression(.{ .tuple = items });
}

pub fn clear(self: *Lower, body: *std.ArrayList(node.Statement), id: ir.TypeId, value: *const node.Expression) Lower.Error!void {
    if (!@import("root.zig").selected(self, id)) return;

    try body.append(self.allocator, .{ .assignment = .{
        .target = try self.field(value, try name(self, id)),
        .value = try self.builder.expression(.null_value),
    } });
}
