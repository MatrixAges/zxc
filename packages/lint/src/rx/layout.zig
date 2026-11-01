const std = @import("std");
const dsl = @import("dsl");
const spacing = @import("../spacing.zig");
const rule = @import("layout_rule");
const bounds = @import("rx_bounds");
const indentation = @import("../indentation/root.zig");
const width = @import("../layout/root.zig").use_default_width;

pub fn format(allocator: std.mem.Allocator, source: []const u8, node: dsl.ast.Node) std.mem.Allocator.Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    var planner = Planner{ .allocator = arena.allocator(), .source = source };

    try planner.element(node, 0);

    return spacing.format(allocator, source, planner.edits.items);
}

const Planner = struct {
    allocator: std.mem.Allocator,
    source: []const u8,
    edits: std.ArrayList(spacing.Edit) = .empty,
    fn element(self: *Planner, node: dsl.ast.Node, level: usize) std.mem.Allocator.Error!void {
        if (node.attributes.len != 0) try self.tag(node, level);
        for (node.children) |child| try self.element(child, level + 1);
    }
    fn tag(self: *Planner, node: dsl.ast.Node, level: usize) std.mem.Allocator.Error!void {
        const tokens = try self.allocator.alloc(rule.Token, node.attributes.len + 2);
        const start = node.location.offset;
        const head_end = start + node.name.len + 1;
        var force = false;

        tokens[0] = .{ .text = self.source[start..head_end], .start = start, .end = head_end, .opening = true };

        for (node.attributes, 0..) |attribute, index| {
            const end = attribute.value_location.offset + attribute.raw_value.?.len + 1;
            const text = self.source[attribute.location.offset..end];
            const newline = std.mem.indexOfScalar(u8, text, '\n') != null;
            const previous_end: usize = @intCast(tokens[index].end);
            force = force or newline or std.mem.indexOfScalar(u8, self.source[previous_end..attribute.location.offset], '\n') != null;

            tokens[index + 1] = .{
                .text = text,
                .start = attribute.location.offset,
                .end = end,
                .separator = index + 1 < node.attributes.len,
                .gap = 1,
            };
        }

        const end: usize = @intCast(tokens[node.attributes.len].end);
        const open = bounds.opening(self.source, end);
        tokens[0].object = force;

        tokens[tokens.len - 1] = .{
            .text = self.source[open.marker..open.end],
            .start = open.marker,
            .end = open.end,
            .closing = true,
            .gap = @intFromBool(open.marker > end),
        };

        const planned = try rule.plan(self.allocator, tokens, .{ .width = width, .level = level, .prefix = node.location.column - 1 - @min(node.location.column - 1, level * indentation.width) });
        const newline: []const u8 = if (std.mem.indexOf(u8, self.source, "\r\n") != null) "\r\n" else "\n";

        for (planned) |item| {
            if (item.index == 0) continue;

            const left: usize = @intCast(tokens[item.index - 1].end);
            const right: usize = @intCast(tokens[item.index].start);

            if (std.mem.indexOfScalar(u8, self.source[left..right], '\n') != null) continue;

            const target = level + @intFromBool(item.index + 1 < tokens.len);
            const replacement = try self.allocator.alloc(u8, newline.len + target * indentation.width);

            @memcpy(replacement[0..newline.len], newline);
            @memset(replacement[newline.len..], ' ');

            try self.edits.append(self.allocator, .{ .span = .{ .start = left, .end = right }, .replacement = replacement });
        }
    }
};
