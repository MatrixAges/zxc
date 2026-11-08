const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");
const emission = @import("capture/emit.zig");

pub const Boundary = struct { name: []const u8, label: []const u8, failure: node.ExpressionId };

pub fn lower(self: *Lower, type_id: ir.TypeId, child: ir.ExprId) Lower.Error!node.ExpressionId {
    return self.construct(type_id, try lowerValue(self, type_id, child));
}

pub fn lowerValue(self: *Lower, type_id: ir.TypeId, child: ir.ExprId) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("capture/seed.zig").lowerValue(self, type_id, child);

    const children = self.program.typeOf(type_id).tuple;
    const payload = self.program.expression(child).type_id;
    const names = try emission.names(self);
    const layout = try self.layoutExpr(type_id);
    const prepared = try emission.prepare(self, names.name, payload);
    const previous = self.capture;

    const captured = blk: {
        self.capture = .{ .name = names.name, .label = names.label, .failure = try self.cast(layout, try @import("state_value/origin.zig").tuple(self, type_id, prepared.value)) };
        defer self.capture = previous;

        break :blk try self.expr(child);
    };

    var body: std.ArrayList(node.Statement) = .empty;
    const payload_type = if (prepared.is_void) @as(node.ExpressionId, @fromBackingInt(0)) else try self.typeExpr(children.at(1));
    const succeeded = try emission.result(self, &body, captured, payload_type, prepared.is_void);
    const originated = try @import("state_value/origin.zig").tuple(self, type_id, succeeded);

    return emission.finish(self, &body, originated, layout, names.label);
}
