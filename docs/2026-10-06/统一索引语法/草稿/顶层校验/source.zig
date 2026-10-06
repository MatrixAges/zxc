const std = @import("std");
const zx = @import("zx");
const spacing = @import("spacing.zig");
const Header = @import("header.zig");
pub const formatting_required = "import order or blank lines require formatting";

pub const Input = struct {
    source: []const u8,
    comments: []const zx.Span,
    program: zx.ast.Program,
};

pub fn check(allocator: std.mem.Allocator, input: Input) std.mem.Allocator.Error!?zx.Diagnostic {
    if (input.program.body == null and input.program.contracts.len == 0) return checkHeader(allocator, input.source, input.comments, Header.Native{ .program = input.program });
    if (@import("root.zig").checkNames(input.program)) |issue| return issue;

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const changes = try plan(arena.allocator(), input);

    return diagnostic(changes);
}

pub fn checkHeader(allocator: std.mem.Allocator, source: []const u8, comments: []const zx.Span, view: anytype) std.mem.Allocator.Error!?zx.Diagnostic {
    if (@import("root.zig").checkHeaderNames(view)) |issue| return issue;

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const ordered = try @import("imports/edits.zig").planView(arena.allocator(), source, comments, view);
    const spaced = try spacing.headerEdits(arena.allocator(), source, comments, view);
    const changes = try merge(arena.allocator(), view, ordered, spaced);

    return diagnostic(changes);
}

fn diagnostic(changes: []const spacing.Edit) ?zx.Diagnostic {
    if (changes.len == 0) return null;

    return .{ .code = .spacing, .span = changes[0].span, .message = "import order or blank lines do not match built-in rules; run zxc fmt" };
}

pub fn format(allocator: std.mem.Allocator, input: Input) std.mem.Allocator.Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const changes = try plan(arena.allocator(), input);

    return spacing.format(allocator, input.source, changes);
}

fn plan(allocator: std.mem.Allocator, input: Input) std.mem.Allocator.Error![]const spacing.Edit {
    const view = Header.Native{ .program = input.program };
    const ordered = try @import("imports/edits.zig").planView(allocator, input.source, input.comments, view);
    const spaced = try spacing.edits(allocator, input.source, input.comments, input.program);

    return merge(allocator, view, ordered, spaced);
}

fn merge(allocator: std.mem.Allocator, view: anytype, ordered: []const spacing.Edit, spaced: []const spacing.Edit) std.mem.Allocator.Error![]const spacing.Edit {
    var result: std.ArrayList(spacing.Edit) = .empty;

    try result.appendSlice(allocator, ordered);

    for (spaced) |edit| {
        if (view.importCount() != 0 and edit.span.start >= view.importAt(0).span.start and edit.span.end <= view.importAt(view.importCount() - 1).span.end) continue;
        try result.append(allocator, edit);
    }

    std.mem.sort(spacing.Edit, result.items, {}, struct {
        fn lessThan(_: void, left: spacing.Edit, right: spacing.Edit) bool {
            return left.span.start < right.span.start;
        }
    }.lessThan);

    return result.toOwnedSlice(allocator);
}
