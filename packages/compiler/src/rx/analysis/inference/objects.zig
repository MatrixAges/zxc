const std = @import("std");
const zx = @import("zx");
const syntax = zx.syntax.borrow;
const Graph = @import("types.zig");
const Expression = @import("expression.zig");
const Construction = @import("construction.zig");

pub fn infer(self: *Expression, expression: anytype, expected: ?Graph.Id) zx.Error!Graph.Id {
    const span = self.sourceSpan(expression.span);
    const fields = syntax.value(expression).object;
    const first = self.graph.construction_parts.len;

    try self.graph.construction_parts.resize(self.graph.allocator, first + fields.len);

    for (0..fields.len) |index| {
        const field = syntax.item(fields, index);
        var hint: ?Graph.Id = null;

        if (!field.spread and expected != null) {
            var final_field = true;

            for (index + 1..fields.len) |later_index| {
                const later = syntax.item(fields, later_index);

                if (later.spread or std.mem.eql(u8, later.name.text, field.name.text)) final_field = false;
            }

            if (final_field) hint = try self.graph.field(expected.?, field.name.text, self.sourceSpan(field.name.span));
        }

        const part: Construction.Part = .{
            .name = if (field.spread) null else try self.graph.allocator.dupe(u8, field.name.text),
            .value = try self.infer(field.value, hint),
            .span = self.sourceSpan(field.value.span),
        };

        self.graph.construction_parts.set(first + index, part);

        if (field.spread and self.graph.shape(part.value) == .unknown) {
            try self.graph.unify(part.value, try self.graph.add(.{ .object = .{} }, part.span), part.span);
        }
    }

    const result = try self.graph.add(.{ .object = .{} }, span);

    if (expected) |target| try self.graph.expect(result, target, span);

    try self.graph.constructions.append(self.graph.allocator, .{ .result = result, .first = first, .count = fields.len, .span = span });

    return result;
}
