const std = @import("std");
const zx = @import("zx");
const syntax = zx.syntax.borrow;
const Graph = @import("types.zig");
const Expression = @import("expression.zig");
const Construction = @import("construction.zig");
const generated = @import("rx_options").generated_graph;

pub fn infer(self: *Expression, expression: anytype, expected: ?Graph.Id) zx.Error!Graph.Id {
    const span = self.sourceSpan(expression.span);
    const fields = syntax.value(expression).object;
    const first = self.graph.construction_parts.len;

    try self.graph.construction_parts.resize(self.graph.allocator, first + fields.len);

    var buffer: [32]u32 = undefined;

    const hints = if (generated and expected != null and fields.len > 1)
        try markHints(self.graph, fields, first, &buffer)
    else
        &.{};

    defer if (hints.len > buffer.len) self.graph.scratch.free(hints);

    for (0..fields.len) |index| {
        const field = syntax.item(fields, index);
        var hint: ?Graph.Id = null;

        if (!field.spread and expected != null) {
            const final_field = if (generated) hints.len == 0 or hints[index] != 0 else seedHint(fields, index, field.name.text);

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

fn markHints(graph: *Graph, fields: anytype, first: usize, buffer: []u32) std.mem.Allocator.Error![]u32 {
    const hints = if (fields.len <= buffer.len) buffer[0..fields.len] else try graph.scratch.alloc(u32, fields.len);
    const names = graph.construction_parts.items(.name)[first..][0..fields.len];

    for (names, 0..) |*name, index| {
        const field = syntax.item(fields, index);

        name.* = if (field.spread) null else field.name.text;
    }

    @memset(hints, 0);

    var empty = std.heap.FixedBufferAllocator.init(&.{});

    _ = @import("generated_object_construction_hints").executeValue(empty.allocator(), &.{
        .names = names,
        .target = @ptrCast(&hints),
    }) catch unreachable;

    return hints;
}

fn seedHint(fields: anytype, index: usize, name: []const u8) bool {
    for (index + 1..fields.len) |later_index| {
        const later = syntax.item(fields, later_index);

        if (later.spread or std.mem.eql(u8, later.name.text, name)) return false;
    }

    return true;
}
