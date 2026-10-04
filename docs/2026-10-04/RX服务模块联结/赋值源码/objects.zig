const std = @import("std");
const zx = @import("zx");
const Graph = @import("types.zig");
const Expression = @import("expression.zig");
const Construction = @import("construction.zig");

pub fn infer(self: *Expression, expression: *const zx.ast.Expression, expected: ?Graph.Id) zx.Error!Graph.Id {
    const span = self.sourceSpan(expression.span);
    const parts = try self.graph.allocator.alloc(Construction.Part, expression.value.object.len);

    for (expression.value.object, parts, 0..) |field, *part, index| {
        var hint: ?Graph.Id = null;

        if (!field.spread and expected != null) {
            var final_field = true;

            for (expression.value.object[index + 1 ..]) |later| {
                if (later.spread or std.mem.eql(u8, later.name.text, field.name.text)) final_field = false;
            }

            if (final_field) hint = try self.graph.field(expected.?, field.name.text, self.sourceSpan(field.name.span));
        }

        part.* = .{
            .name = if (field.spread) null else try self.graph.allocator.dupe(u8, field.name.text),
            .value = try self.infer(field.value, hint),
            .span = self.sourceSpan(field.value.span),
        };

        if (field.spread and self.graph.shape(part.value) == .unknown) {
            try self.graph.unify(part.value, try self.graph.add(.{ .object = &.{} }, part.span), part.span);
        }
    }

    const result = try self.graph.add(.{ .object = &.{} }, span);

    if (expected) |target| try self.graph.expect(result, target, span);

    try self.graph.constructions.append(self.graph.allocator, .{ .result = result, .parts = parts, .span = span });

    return result;
}
