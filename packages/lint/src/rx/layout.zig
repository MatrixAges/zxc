const std = @import("std");
const dsl = @import("dsl");
const NodeView = @import("node_view.zig");
const spacing = @import("../spacing.zig");
const rule = @import("layout_rule");
const bounds = @import("rx_bounds");
const indentation = @import("../indentation/root.zig");
const width = @import("../layout/root.zig").use_default_width;
const tag_scratch_bytes = 2048;

pub fn format(allocator: std.mem.Allocator, source: []const u8, node: dsl.ast.Node) std.mem.Allocator.Error![]u8 {
    return formatView(allocator, source, NodeView{ .node = node });
}

pub fn formatView(allocator: std.mem.Allocator, source: []const u8, node: anytype) std.mem.Allocator.Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    var planner = Planner{
        .allocator = arena.allocator(),
        .backing = allocator,
        .source = source,
        .newline = if (std.mem.indexOf(u8, source, "\r\n") != null) "\r\n" else "\n",
    };

    try planner.element(node, 0);

    return spacing.format(allocator, source, planner.edits.items);
}

const Planner = struct {
    allocator: std.mem.Allocator,
    backing: std.mem.Allocator,
    source: []const u8,
    newline: []const u8,
    edits: std.ArrayList(spacing.Edit) = .empty,
    fn element(self: *Planner, node: anytype, level: usize) std.mem.Allocator.Error!void {
        if (node.attributeCount() != 0) try self.tag(node, level);

        var children = node.children();

        while (children.next()) |child| try self.element(child, level + 1);
    }
    fn tag(self: *Planner, node: anytype, level: usize) std.mem.Allocator.Error!void {
        var storage: [tag_scratch_bytes]u8 align(@alignOf(rule.Token)) = undefined;
        var buffer = std.heap.BufferFirstAllocator.init(&storage, self.backing);
        var scratch = std.heap.ArenaAllocator.init(buffer.allocator());

        defer scratch.deinit();

        const temporary = scratch.allocator();
        const count = node.attributeCount();
        const location = node.location();
        const tokens = try temporary.alloc(rule.Token, count + 2);
        const start = location.offset;
        const head_end = start + node.name().len + 1;
        var force = false;

        tokens[0] = .{ .text = self.source[start..head_end], .start = start, .end = head_end, .opening = true };

        for (0..count) |index| {
            const attribute = node.attribute(index);
            const end = attribute.value_offset + attribute.raw.?.len + 1;
            const text = self.source[attribute.offset..end];
            const newline = std.mem.indexOfScalar(u8, text, '\n') != null;
            const previous_end: usize = @intCast(tokens[index].end);
            force = force or newline or std.mem.indexOfScalar(u8, self.source[previous_end..attribute.offset], '\n') != null;

            tokens[index + 1] = .{
                .text = text,
                .start = attribute.offset,
                .end = end,
                .separator = index + 1 < count,
                .gap = 1,
            };
        }

        const end: usize = @intCast(tokens[count].end);
        const open = bounds.opening(self.source, end);
        tokens[0].object = force;

        tokens[tokens.len - 1] = .{
            .text = self.source[open.marker..open.end],
            .start = open.marker,
            .end = open.end,
            .closing = true,
            .gap = @intFromBool(open.marker > end),
        };

        const planned = try rule.plan(temporary, tokens, .{ .width = width, .level = level, .prefix = location.column - 1 - @min(location.column - 1, level * indentation.width) });
        const newline = self.newline;

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
