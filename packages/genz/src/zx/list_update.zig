const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");
const aggregate = @import("aggregate.zig");
const intrinsics = @import("intrinsics.zig");

/// Writes one element: in place when the plan proves the target unique, into a copy otherwise, which keeps the header of
/// a headered target.
pub fn lower(self: *Lower, id: ir.ExprId) Lower.Error!node.ExpressionId {
    const update = self.program.expression(id).value.list_update;
    var body: std.ArrayList(node.Statement) = .empty;
    const type_id = self.program.expression(update.target).type_id;
    const selected = @import("state_value/list.zig").selected(self, type_id);
    const evaluated_source = try self.expr(update.target);
    const qualified_source = if (selected) try @import("state_value/ownership.zig").clip(self, &body, update.target, evaluated_source) else evaluated_source;
    const source_value = try aggregate.bind(self, &body, qualified_source);
    const source = try @import("state_value/list.zig").items(self, type_id, source_value);
    const index = try aggregate.bind(self, &body, try self.expr(update.index));

    try intrinsics.failIf(self, &body, try intrinsics.binary(self, .greater_equal, index, try self.field(source, "len")), "IndexOutOfBounds");

    const evaluated = try aggregate.bind(self, &body, try self.expr(update.value));
    const value = try @import("state_value/elements.zig").write(self, &body, type_id, evaluated);
    const element = try @import("state_value/elements.zig").typeExpr(self, type_id);
    const flags = self.plan.get(id);
    const deferred = selected and self.deferred_lists;

    const buffer = if (deferred) guarded: {
        var copied: std.ArrayList(node.Statement) = .empty;
        const private = try @import("growth.zig").reserve(self, &copied, element, source, try self.field(source, "len"), false);

        break :guarded try aggregate.bind(self, &body, try self.builder.expression(.{ .conditional = .{
            .condition = try @import("state_value/list.zig").exclusive(self, source_value),
            .yes = try self.builtin(.constCast, &.{source}),
            .no = try aggregate.finish(self, &copied, private),
        } }));
    } else if (flags.in_place)
        try aggregate.bind(self, &body, try self.builtin(.constCast, &.{source}))

    else if (selected) chosen: {
        var copied: std.ArrayList(node.Statement) = .empty;
        var plain: std.ArrayList(node.Statement) = .empty;
        const grown = try @import("growth.zig").reserve(self, &copied, element, source, try self.field(source, "len"), false);
        const duplicated = try aggregate.bind(self, &plain, try self.call(try self.field(try self.builder.identifier("allocator"), "dupe"), &.{ element, source }, true));
        const headered = if (flags.grow) try self.builder.expression(.{ .boolean = true }) else try @import("state_value/list.zig").headered(self, source_value);
        const exclusive = try @import("state_value/list.zig").exclusive(self, source_value);

        break :chosen try aggregate.bind(self, &body, try self.builder.expression(.{ .conditional = .{
            .condition = exclusive,
            .yes = try self.builtin(.constCast, &.{source}),
            .no = try self.builder.expression(.{ .conditional = .{
                .condition = headered,
                .yes = try aggregate.finish(self, &copied, grown),
                .no = try aggregate.finish(self, &plain, duplicated),
            } }),
        } }));
    } else if (flags.grow)
        try @import("growth.zig").reserve(self, &body, element, source, try self.field(source, "len"), false)
    else
        try aggregate.bind(self, &body, try self.call(try self.field(try self.builder.identifier("allocator"), "dupe"), &.{ element, source }, true));

    const slot = try self.builder.expression(.{ .index = .{ .target = buffer, .index = try self.builtin(.intCast, &.{index}) } });

    try body.append(self.allocator, .{ .assignment = .{ .target = slot, .value = value } });

    const result = if (selected) result: {
        const headered = if (flags.grow or deferred) try self.builder.expression(.{ .boolean = true }) else try @import("state_value/list.zig").headered(self, source_value);

        break :result try @import("state_value/list.zig").proven(self, type_id, buffer, headered, headered);
    } else buffer;

    return aggregate.finish(self, &body, result);
}
