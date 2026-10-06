const std = @import("std");
const zx = @import("zx");
const syntax = zx.syntax.borrow;
const Header = zx.syntax.header;
const shape = @import("shape.zig");

pub const Edit = struct {
    span: zx.Span,
    replacement: []const u8,
};

pub fn edits(allocator: std.mem.Allocator, source: []const u8, comments: []const zx.Span, program: zx.ast.Program) std.mem.Allocator.Error![]const Edit {
    return viewEdits(allocator, source, comments, Header.Native{ .program = program }, program.body);
}

pub fn headerEdits(allocator: std.mem.Allocator, source: []const u8, comments: anytype, view: anytype) std.mem.Allocator.Error![]const Edit {
    return viewEdits(allocator, source, comments, view, @as(?zx.ast.Block, null));
}

pub fn viewEdits(allocator: std.mem.Allocator, source: []const u8, comments: anytype, view: anytype, body: anytype) std.mem.Allocator.Error![]const Edit {
    var planner = Planner(@TypeOf(comments)){ .allocator = allocator, .source = source, .comments = comments };

    errdefer planner.result.deinit(allocator);

    for (0..view.importCount()) |index| {
        const item = view.importAt(index);
        const next = if (index + 1 < view.importCount()) view.importAt(index + 1).span.start else if (view.declarationCount() > 0) view.declarationAt(0).span.start else view.functionStart();
        const separate = index + 1 == view.importCount() or shape.multiline(source, item.span) or shape.multiline(source, view.importAt(index + 1).span);

        try planner.appendBoundary(item.span.end, next, separate);
    }

    for (0..view.declarationCount()) |index| {
        const declaration = view.declarationAt(index);
        const next = if (index + 1 < view.declarationCount()) view.declarationAt(index + 1).span.start else view.functionStart();

        try planner.appendBoundary(declaration.span.end, next, index + 1 < view.declarationCount() or view.hasBody());
    }

    if (body) |value| try planner.block(value);

    std.mem.sort(Edit, planner.result.items, {}, struct {
        fn lessThan(_: void, left: Edit, right: Edit) bool {
            return left.span.start < right.span.start;
        }
    }.lessThan);

    return planner.result.toOwnedSlice(allocator);
}

pub fn format(allocator: std.mem.Allocator, source: []const u8, changes: []const Edit) std.mem.Allocator.Error![]u8 {
    var result: std.ArrayList(u8) = .empty;

    errdefer result.deinit(allocator);

    var offset: usize = 0;

    for (changes) |change| {
        try result.appendSlice(allocator, source[offset..change.span.start]);
        try result.appendSlice(allocator, change.replacement);

        offset = change.span.end;
    }

    try result.appendSlice(allocator, source[offset..]);

    return result.toOwnedSlice(allocator);
}

fn Planner(comptime Comments: type) type {
    return struct {
        const Self = @This();
        allocator: std.mem.Allocator,
        source: []const u8,
        comments: Comments,
        result: std.ArrayList(Edit) = .empty,
        fn block(self: *Self, value: anytype) std.mem.Allocator.Error!void {
            for (0..value.statements.len) |index| {
                const statement = syntax.item(value.statements, index);

                if (index > 0) {
                    const previous = syntax.item(value.statements, index - 1);

                    if (shape.separation(self.source, previous, statement)) |separate| {
                        try self.appendBoundary(previous.span.end, statement.span.start, separate);
                    }
                }

                if (statement.value == .switch_stmt) {
                    for (0..statement.value.switch_stmt.cases.len) |case_index| try self.block(syntax.item(statement.value.switch_stmt.cases, case_index).body);
                }

                if (statement.value == .branch) {
                    try self.block(statement.value.branch.yes);
                    if (statement.value.branch.no) |no| try self.block(no);
                }
            }

            if (value.statements.len > 0 and self.source[value.span.start] == '{') {
                try self.appendBoundary(value.span.start + 1, syntax.item(value.statements, 0).span.start, false);
                try self.appendBoundary(syntax.item(value.statements, value.statements.len - 1).span.end, value.span.end - 1, false);
            }
        }
        fn appendBoundary(self: *Self, left: usize, right: usize, separate: bool) std.mem.Allocator.Error!void {
            if (boundaryView(self.source, self.comments, left, right, separate)) |edit| try self.result.append(self.allocator, edit);
        }
    };
}

pub fn boundary(source: []const u8, comments: []const zx.Span, left: usize, right: usize, separate: bool) ?Edit {
    return boundaryView(source, comments, left, right, separate);
}

fn boundaryView(source: []const u8, comments: anytype, left: usize, right: usize, separate: bool) ?Edit {
    var start = left;
    var end = right;

    for (comments) |position| {
        const comment = Header.span(position);

        if (comment.start < left or comment.end > right) continue;

        if (std.mem.indexOfScalar(u8, source[start..comment.start], '\n') == null) {
            start = comment.end;
        } else {
            end = comment.start;

            break;
        }
    }

    const gap = source[start..end];
    const first = std.mem.indexOfScalar(u8, gap, '\n') orelse return null;
    const last = std.mem.lastIndexOfScalar(u8, gap, '\n').?;
    const crlf = first > 0 and gap[first - 1] == '\r';
    const newline_start = first - @intFromBool(crlf);
    const replacement: []const u8 = if (crlf) (if (separate) "\r\n\r\n" else "\r\n") else (if (separate) "\n\n" else "\n");
    const old = gap[newline_start .. last + 1];

    if (std.mem.eql(u8, old, replacement)) return null;

    return .{
        .span = .{ .start = start + newline_start, .end = start + last + 1 },
        .replacement = replacement,
    };
}
