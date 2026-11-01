const std = @import("std");
const zx = @import("zx");
const syntax = zx.syntax.borrow;
const Header = zx.syntax.header;
const shape = @import("shape.zig");
const boundary_rule = @import("spacing_boundary");
const import_order = @import("import_order");

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

    var import_index: usize = 0;
    var declaration_index: usize = 0;
    var constant_index: usize = 0;

    while (import_index < view.importCount() or declaration_index < view.declarationCount() or constant_index < view.constantCount()) {
        const import_start = if (import_index < view.importCount()) view.importAt(import_index).span.start else source.len;
        const declaration_start = exportStart(view, declaration_index, constant_index);
        const imported = import_start < declaration_start;
        const constant = !imported and constant_index < view.constantCount() and (declaration_index == view.declarationCount() or view.constantAt(constant_index).span.start < view.declarationAt(declaration_index).span.start);
        const span = if (imported) view.importAt(import_index).span else if (constant) view.constantAt(constant_index).span else view.declarationAt(declaration_index).span;
        const exported = imported and view.importAt(import_index).exported;

        if (imported) import_index += 1 else if (constant) constant_index += 1 else declaration_index += 1;

        const next_import = if (import_index < view.importCount()) view.importAt(import_index).span.start else source.len;
        const next_declaration = exportStart(view, declaration_index, constant_index);
        const next = @min(next_import, next_declaration);
        const adjacent_imports = imported and next_import < next_declaration;

        const separate = if (adjacent_imports)
            exported != view.importAt(import_index).exported or !import_order.sameGroup(view.importAt(import_index - 1), view.importAt(import_index))

        else
            next < source.len;

        try planner.appendBoundary(span.end, next, separate);
    }

    if (body) |value| try planner.block(value);

    std.mem.sort(Edit, planner.result.items, {}, struct {
        fn lessThan(_: void, left: Edit, right: Edit) bool {
            return left.span.start < right.span.start;
        }
    }.lessThan);

    return planner.result.toOwnedSlice(allocator);
}

fn exportStart(view: anytype, declaration_index: usize, constant_index: usize) usize {
    const declaration = if (declaration_index < view.declarationCount()) view.declarationAt(declaration_index).span.start else view.functionStart();
    const constant = if (constant_index < view.constantCount()) view.constantAt(constant_index).span.start else view.functionStart();

    return @min(declaration, constant);
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

    const edit = boundary_rule.resolve(source, start, end, separate) orelse return null;

    return .{
        .span = .{ .start = edit.span.start, .end = edit.span.end },
        .replacement = edit.replacement,
    };
}
