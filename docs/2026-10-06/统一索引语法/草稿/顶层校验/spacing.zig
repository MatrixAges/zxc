const std = @import("std");
const zx = @import("zx");
const shape = @import("shape.zig");

pub const Edit = struct {
    span: zx.Span,
    replacement: []const u8,
};

pub fn edits(allocator: std.mem.Allocator, source: []const u8, comments: []const zx.Span, program: zx.ast.Program) std.mem.Allocator.Error![]const Edit {
    return editsWithBody(allocator, source, comments, @import("header.zig").Native{ .program = program }, program.body);
}

pub fn headerEdits(allocator: std.mem.Allocator, source: []const u8, comments: []const zx.Span, view: anytype) std.mem.Allocator.Error![]const Edit {
    return editsWithBody(allocator, source, comments, view, null);
}

fn editsWithBody(allocator: std.mem.Allocator, source: []const u8, comments: []const zx.Span, view: anytype, body: ?zx.ast.Block) std.mem.Allocator.Error![]const Edit {
    var planner = Planner{ .allocator = allocator, .source = source, .comments = comments };

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

const Planner = struct {
    allocator: std.mem.Allocator,
    source: []const u8,
    comments: []const zx.Span,
    result: std.ArrayList(Edit) = .empty,
    fn block(self: *Planner, value: zx.ast.Block) std.mem.Allocator.Error!void {
        for (value.statements, 0..) |statement, index| {
            if (index > 0) {
                const previous = value.statements[index - 1];

                if (shape.separation(self.source, previous, statement)) |separate| {
                    try self.appendBoundary(previous.span.end, statement.span.start, separate);
                }
            }

            if (statement.value == .switch_stmt) {
                for (statement.value.switch_stmt.cases) |case| try self.block(case.body);
            }

            if (statement.value == .branch) {
                try self.block(statement.value.branch.yes);
                if (statement.value.branch.no) |no| try self.block(no);
            }
        }

        if (value.statements.len > 0 and self.source[value.span.start] == '{') {
            try self.appendBoundary(value.span.start + 1, value.statements[0].span.start, false);
            try self.appendBoundary(value.statements[value.statements.len - 1].span.end, value.span.end - 1, false);
        }
    }

    fn appendBoundary(self: *Planner, left: usize, right: usize, separate: bool) std.mem.Allocator.Error!void {
        if (boundary(self.source, self.comments, left, right, separate)) |edit| try self.result.append(self.allocator, edit);
    }
};

pub fn boundary(source: []const u8, comments: []const zx.Span, left: usize, right: usize, separate: bool) ?Edit {
    var start = left;
    var end = right;

    for (comments) |comment| {
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
