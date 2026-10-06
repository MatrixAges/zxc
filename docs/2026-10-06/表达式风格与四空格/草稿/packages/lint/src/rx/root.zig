const std = @import("std");
const dsl = @import("dsl");
const zx = @import("zx");
const spacing = @import("../spacing.zig");
const bounds = @import("bounds.zig");
const indentation = @import("../indentation/root.zig");

pub fn format(allocator: std.mem.Allocator, source: []const u8, node: dsl.ast.Node) std.mem.Allocator.Error![]u8 {
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
    fn element(self: *Planner, node: dsl.ast.Node, level: usize, structural: bool) std.mem.Allocator.Error!zx.Span {
        const start = node.location.offset;

        if (structural) try self.indent(start, level);
        for (node.attributes) |attribute| try self.indent(attribute.location.offset, level + 1);

        const after_attributes = if (node.attributes.len == 0) start else block: {
            const last = node.attributes[node.attributes.len - 1];

            break :block last.value_location.offset + last.raw_value.?.len + 1;
        };

        const opening_end = bounds.tagEnd(self.source, after_attributes);
        const marker = opening_end - if (self.source[opening_end - 2] == '/') @as(usize, 2) else 1;

        try self.indent(marker, level);
        if (self.source[opening_end - 2] == '/') return .{ .start = start, .end = opening_end };

        var whitespace_only = true;

        for (node.text) |text| {
            if (std.mem.trim(u8, text.value, " \t\r\n").len != 0) whitespace_only = false;
        }

        var previous_end = opening_end;
        var previous_span: zx.Span = .{ .start = start, .end = opening_end };

        for (node.children, 0..) |child, index| {
            const span = try self.element(child, level + 1, whitespace_only);
            const separate = index != 0 and (multiline(self.source, previous_span) or multiline(self.source, span) or !sameShape(node.children[index - 1], child));

            if (whitespace_only) try self.gap(previous_end, span.start, separate, level + 1);

            previous_end = span.end;
            previous_span = span;
        }

        const closing_start = bounds.closingStart(self.source, previous_end);

        if (whitespace_only) {
            try self.gap(previous_end, closing_start, false, level + 1);
            try self.indent(closing_start, level);
        }

        return .{ .start = start, .end = bounds.tagEnd(self.source, closing_start) };
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

fn sameShape(left: dsl.ast.Node, right: dsl.ast.Node) bool {
    if (!std.mem.eql(u8, left.name, right.name) or left.attributes.len != right.attributes.len or left.children.len != right.children.len) return false;

    for (left.attributes, right.attributes) |a, b| {
        if (!std.mem.eql(u8, a.name, b.name)) return false;
    }

    for (left.children, right.children) |a, b| if (!sameShape(a, b)) return false;

    return true;
}
