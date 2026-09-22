const std = @import("std");
const zx = @import("zx");

pub const Edit = struct {
    span: zx.Span,
    replacement: []const u8,
};

pub fn edits(allocator: std.mem.Allocator, source: []const u8, comments: []const zx.Span, program: zx.ast.Program) std.mem.Allocator.Error![]const Edit {
    var planner = Planner{ .allocator = allocator, .source = source, .comments = comments };

    errdefer planner.result.deinit(allocator);

    for (program.imports, 0..) |item, index| {
        const next = if (index + 1 < program.imports.len) program.imports[index + 1].span.start else if (program.declarations.len > 0) program.declarations[0].span.start else program.function_start;

        try planner.boundary(item.span.end, next, index + 1 == program.imports.len);
    }

    for (program.declarations, 0..) |declaration, index| {
        const next = if (index + 1 < program.declarations.len) program.declarations[index + 1].span.start else program.function_start;

        try planner.boundary(declaration.span.end, next, index + 1 < program.declarations.len or program.body != null);
    }

    if (program.body) |body| try planner.block(body);

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
                const separate = !isDeclaration(previous) or !isDeclaration(statement);

                try self.boundary(previous.span.end, statement.span.start, separate);
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
            try self.boundary(value.span.start + 1, value.statements[0].span.start, false);
            try self.boundary(value.statements[value.statements.len - 1].span.end, value.span.end - 1, false);
        }
    }
    fn boundary(self: *Planner, left: usize, right: usize, separate: bool) std.mem.Allocator.Error!void {
        var start = left;
        var end = right;

        for (self.comments) |comment| {
            if (comment.start < left or comment.end > right) continue;

            if (std.mem.indexOfScalar(u8, self.source[start..comment.start], '\n') == null) {
                start = comment.end;
            } else {
                end = comment.start;

                break;
            }
        }

        const gap = self.source[start..end];
        const first = std.mem.indexOfScalar(u8, gap, '\n') orelse return;
        const last = std.mem.lastIndexOfScalar(u8, gap, '\n').?;
        const crlf = first > 0 and gap[first - 1] == '\r';
        const newline_start = first - @intFromBool(crlf);
        const replacement: []const u8 = if (crlf) (if (separate) "\r\n\r\n" else "\r\n") else (if (separate) "\n\n" else "\n");
        const old = gap[newline_start .. last + 1];

        if (std.mem.eql(u8, old, replacement)) return;

        try self.result.append(self.allocator, .{
            .span = .{ .start = start + newline_start, .end = start + last + 1 },
            .replacement = replacement,
        });
    }
};

fn isDeclaration(statement: zx.ast.Statement) bool {
    return statement.value == .constant or statement.value == .destructure;
}
