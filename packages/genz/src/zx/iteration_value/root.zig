const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const analysis = @import("../iteration_layout.zig");
const Self = @This();

lowering: *Lower,
declarations: *std.ArrayList(node.Statement),
inline_lists: bool = false,
types: @import("../expression_map.zig").Map(ir.TypeId) = .empty,
symbols: @import("../members.zig") = .empty,
cache: @import("../expression_map.zig").Map(ir.ExprId) = .empty,
reads: @import("../counter.zig") = .empty,
transfers: @import("../transfers.zig") = .empty,
argument: ?struct { id: ir.ExprId, value: node.ExpressionId } = null,
pub fn represented(self: *const Self, id: ir.TypeId) bool {
    return analysis.represented(self.lowering, id) or self.buffered(id);
}

pub fn buffered(self: *const Self, id: ir.TypeId) bool {
    return self.inline_lists and self.lowering.program.typeOf(id) == .list;
}

pub fn bufferedPath(self: *const Self, id: ir.TypeId, path: []const u32) bool {
    if (@import("genz_options").generated_analysis) return @import("../growth/renew.zig").bufferedPath(self.lowering, id, path, self.inline_lists);

    var current = id;

    for (path) |step| {
        while (self.lowering.program.typeOf(current) == .optional) current = self.lowering.program.typeOf(current).optional;

        current = switch (self.lowering.program.typeOf(current)) {
            .object => |fields| fields.at(step).type_id,
            .tuple => |items| items.at(step),
            else => return false,
        };
    }

    return self.buffered(current);
}

pub const expression = if (@import("genz_options").generated_analysis)
    @import("evaluation.zig").lower
else
    @import("evaluation_seed.zig").lower;
