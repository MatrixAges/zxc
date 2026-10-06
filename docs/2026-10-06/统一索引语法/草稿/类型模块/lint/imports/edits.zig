const std = @import("std");
const zx = @import("zx");
const spacing = @import("../spacing.zig");
const order = @import("order.zig");
const Header = zx.syntax.header;
const Unit = struct { declaration: Header.Import, end: usize };

pub fn plan(allocator: std.mem.Allocator, source: []const u8, comments: []const zx.Span, imports: []const zx.ast.Import) std.mem.Allocator.Error![]const spacing.Edit {
    return planView(allocator, source, comments, Imports{ .items = imports });
}

const Imports = struct {
    items: []const zx.ast.Import,
    fn importCount(self: Imports) usize {
        return self.items.len;
    }
    fn importAt(self: Imports, index: usize) Header.Import {
        const item = self.items[index];

        return .{ .kind = item.kind, .path = item.path, .span = item.span };
    }
};

pub fn planView(allocator: std.mem.Allocator, source: []const u8, comments: anytype, view: anytype) std.mem.Allocator.Error![]const spacing.Edit {
    var result: std.ArrayList(spacing.Edit) = .empty;
    var start: usize = 0;
    var pinned = false;

    if (view.importCount() != 0) for (comments) |position| {
        const comment = Header.span(position);

        if (comment.end <= view.importAt(0).span.start) pinned = true;
    };

    for (0..view.importCount()) |index| {
        const item = view.importAt(index);
        const next = if (index + 1 < view.importCount()) view.importAt(index + 1).span.start else source.len;
        const end = trailingEnd(source, comments, item.span.end, next);
        var barrier = false;

        for (comments) |position| {
            const comment = Header.span(position);

            if (comment.start >= end and comment.end <= next) barrier = true;
        }

        if (!pinned and !barrier and index + 1 != view.importCount()) continue;
        if (try section(allocator, source, comments, view, start, index + 1, next)) |edit| try result.append(allocator, edit);

        start = index + 1;
        pinned = barrier;
    }

    return result.toOwnedSlice(allocator);
}

fn section(allocator: std.mem.Allocator, source: []const u8, comments: anytype, view: anytype, start: usize, stop: usize, limit: usize) std.mem.Allocator.Error!?spacing.Edit {
    if (stop - start < 2) return null;

    const sorted = try allocator.alloc(Unit, stop - start);

    for (start..stop, sorted) |index, *unit| {
        const item = view.importAt(index);
        unit.* = .{ .declaration = item, .end = trailingEnd(source, comments, item.span.end, if (index + 1 < stop) view.importAt(index + 1).span.start else limit) };
    }

    std.mem.sort(Unit, sorted, {}, struct {
        fn lessThan(_: void, left: Unit, right: Unit) bool {
            return order.lessThan({}, left.declaration, right.declaration);
        }
    }.lessThan);

    var replacement: std.ArrayList(u8) = .empty;
    const newline: []const u8 = if (std.mem.indexOf(u8, source, "\r\n") != null) "\r\n" else "\n";

    for (sorted, 0..) |unit, index| {
        const item = unit.declaration;

        if (index > 0) {
            try replacement.appendSlice(allocator, newline);
            if (order.group(sorted[index - 1].declaration) != order.group(item)) try replacement.appendSlice(allocator, newline);
        }

        try replacement.appendSlice(allocator, source[item.span.start..unit.end]);
    }

    const span = zx.Span{ .start = view.importAt(start).span.start, .end = trailingEnd(source, comments, view.importAt(stop - 1).span.end, limit) };

    if (std.mem.eql(u8, source[span.start..span.end], replacement.items)) return null;

    return .{ .span = span, .replacement = try replacement.toOwnedSlice(allocator) };
}

fn trailingEnd(source: []const u8, comments: anytype, start: usize, limit: usize) usize {
    var end = start;

    for (comments) |position| {
        const comment = Header.span(position);

        if (comment.start < end or comment.end > limit) continue;
        if (std.mem.indexOfAny(u8, source[end..comment.start], "\r\n") != null) break;

        end = comment.end;
    }

    return end;
}
