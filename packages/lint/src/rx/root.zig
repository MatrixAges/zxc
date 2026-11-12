const std = @import("std");
const dsl = @import("dsl");
const zx = @import("zx");
const spacing = @import("../spacing.zig");
const bounds = @import("rx_bounds");
pub const structure = @import("layout.zig").format;
pub const structureView = @import("layout.zig").formatView;
pub const NodeView = @import("node_view.zig");
const indentation = @import("../indentation/root.zig");

pub fn format(allocator: std.mem.Allocator, source: []const u8, node: dsl.ast.Node) std.mem.Allocator.Error![]u8 {
    return formatView(allocator, source, NodeView{ .node = node });
}

pub fn formatView(allocator: std.mem.Allocator, source: []const u8, node: anytype) std.mem.Allocator.Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    var planner = Planner{ .allocator = arena.allocator(), .source = source };

    _ = try planner.element(node, 0, true);

    std.mem.sort(spacing.Edit, planner.edits.items, {}, struct {
        fn lessThan(_: void, left: spacing.Edit, right: spacing.Edit) bool {
            return left.span.start < right.span.start;
        }
    }.lessThan);

    return spacing.format(allocator, source, planner.edits.items);
}

const Planner = struct {
    allocator: std.mem.Allocator,
    source: []const u8,
    edits: std.ArrayList(spacing.Edit) = .empty,
    fn element(self: *Planner, node: anytype, level: usize, structural: bool) std.mem.Allocator.Error!zx.Span {
        const start = node.location().offset;
        const count = node.attributeCount();

        if (structural) try self.indent(start, level);
        for (0..count) |index| try self.indent(node.attribute(index).offset, level + 1);

        const after_attributes = if (count == 0) start else block: {
            const last = node.attribute(count - 1);

            break :block last.value_offset + last.raw.?.len + 1;
        };

        const open = bounds.opening(self.source, after_attributes);

        try self.indent(open.marker, level);
        if (open.self_closing) return .{ .start = start, .end = open.end };

        const whitespace_only = node.whitespaceOnly();
        var previous_end = open.end;
        var previous_span: zx.Span = .{ .start = start, .end = open.end };
        var previous: ?@TypeOf(node) = null;
        var children = node.children();

        while (children.next()) |child| {
            const span = try self.element(child, level + 1, whitespace_only);
            const separate = if (previous) |before| multiline(self.source, previous_span) or multiline(self.source, span) or !sameShape(before, child) else false;

            if (whitespace_only) try self.gap(previous_end, span.start, separate, level + 1);

            previous_end = span.end;
            previous_span = span;
            previous = child;
        }

        const close = bounds.closing(self.source, previous_end);

        if (whitespace_only) {
            try self.gap(previous_end, close.start, false, level + 1);
            try self.indent(close.start, level);
        }

        return .{ .start = start, .end = close.end };
    }
    fn indent(self: *Planner, offset: usize, level: usize) std.mem.Allocator.Error!void {
        if (try indentation.line(self.allocator, self.source, offset, level)) |edit| try self.edits.append(self.allocator, edit);
    }
    fn gap(self: *Planner, left: usize, right: usize, separate: bool, level: usize) std.mem.Allocator.Error!void {
        var comments: std.ArrayList(zx.Span) = .empty;

        defer comments.deinit(self.allocator);

        var offset = left;

        while (offset < right) {
            if (std.mem.startsWith(u8, self.source[offset..right], "<!--")) {
                const end = bounds.commentEnd(self.source, offset);

                try self.indent(offset, level);
                try comments.append(self.allocator, .{ .start = offset, .end = end });

                offset = end;
            } else if (std.mem.indexOfScalar(u8, " \t\r\n", self.source[offset]) != null) {
                offset += 1;
            } else return;
        }

        if (spacing.boundary(self.source, comments.items, left, right, separate)) |edit| try self.edits.append(self.allocator, edit);
    }
};

fn multiline(source: []const u8, span: zx.Span) bool {
    return std.mem.indexOfScalar(u8, source[span.start..span.end], '\n') != null;
}

fn sameShape(left: anytype, right: @TypeOf(left)) bool {
    if (!std.mem.eql(u8, left.name(), right.name()) or left.attributeCount() != right.attributeCount() or left.childCount() != right.childCount()) return false;

    for (0..left.attributeCount()) |index| {
        if (!std.mem.eql(u8, left.attribute(index).name, right.attribute(index).name)) return false;
    }

    var a = left.children();
    var b = right.children();

    while (a.next()) |child| if (!sameShape(child, b.next().?)) return false;

    return true;
}
