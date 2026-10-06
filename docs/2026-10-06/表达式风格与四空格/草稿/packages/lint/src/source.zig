const std = @import("std");
const zx = @import("zx");
const spacing = @import("spacing.zig");
const Header = zx.syntax.header;
pub const formatting_required = "import order, blank lines or indentation require formatting";

pub const Input = struct {
    source: []const u8,
    comments: []const zx.Span,
    program: zx.ast.Program,
};

pub fn check(allocator: std.mem.Allocator, input: Input) std.mem.Allocator.Error!?zx.Diagnostic {
    return checkView(allocator, input.source, input.comments, Header.Native{ .program = input.program }, input.program.contracts, input.program.body);
}

pub fn checkHeader(allocator: std.mem.Allocator, source: []const u8, comments: anytype, view: anytype) std.mem.Allocator.Error!?zx.Diagnostic {
    return checkView(allocator, source, comments, view, @as([]const zx.ast.Contract, &.{}), @as(?zx.ast.Block, null));
}

pub fn checkView(allocator: std.mem.Allocator, source: []const u8, comments: anytype, view: anytype, contracts: anytype, body: anytype) std.mem.Allocator.Error!?zx.Diagnostic {
    if (@import("root.zig").checkViewNames(view, contracts, body)) |issue| return issue;

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const changes = try planView(arena.allocator(), source, comments, view, body);

    return diagnostic(changes);
}

fn diagnostic(changes: []const spacing.Edit) ?zx.Diagnostic {
    if (changes.len == 0) return null;

    return .{ .code = .spacing, .span = changes[0].span, .message = "import order or blank lines do not match built-in rules; run zxc fmt" };
}

pub fn format(allocator: std.mem.Allocator, input: Input) std.mem.Allocator.Error![]u8 {
    return formatView(allocator, input.source, input.comments, Header.Native{ .program = input.program }, input.program.body);
}

pub fn formatView(allocator: std.mem.Allocator, source: []const u8, comments: anytype, view: anytype, body: anytype) std.mem.Allocator.Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const changes = try planView(arena.allocator(), source, comments, view, body);

    return spacing.format(allocator, source, changes);
}

fn planView(allocator: std.mem.Allocator, source: []const u8, comments: anytype, view: anytype, body: anytype) std.mem.Allocator.Error![]const spacing.Edit {
    const ordered = try @import("imports/edits.zig").planView(allocator, source, comments, view);
    const spaced = try spacing.viewEdits(allocator, source, comments, view, body);

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
