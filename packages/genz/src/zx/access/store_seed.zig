const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");

pub fn lower(self: *Lower, slot: u32, type_id: ir.TypeId) Lower.Error!node.ExpressionId {
    self.uses_context = true;

    const name = try std.fmt.allocPrint(self.allocator, "store_{d}", .{slot});
    const current = try self.builder.expression(.{ .dereference = try self.field(try self.builder.identifier("context"), name) });
    const stored = if (self.transaction()) try self.builder.expression(.{ .binary = .{ .operator = .coalesce, .left = try self.field(try self.builder.identifier("pending"), name), .right = current } }) else current;

    if (!self.state_active or !self.state_plan.represented(self.program, type_id)) return stored;
    if (self.program.typeOf(type_id) == .list) return @import("../state_value/list.zig").borrowed(self, type_id, stored);

    var body: std.ArrayList(node.Statement) = .empty;
    const source = try @import("../aggregate.zig").bind(self, &body, stored);
    const converted = try @import("../state_value/conversion.zig").convert(self, &body, type_id, source, .value);

    return @import("../aggregate.zig").finish(self, &body, converted);
}
