const std = @import("std");
const zx = @import("zx");
const spacing = @import("spacing.zig");
pub const formatting_required = "import order or blank lines require formatting";

pub const Input = struct {
    source: []const u8,
    comments: []const zx.Span,
    program: zx.ast.Program,
};

pub fn check(allocator: std.mem.Allocator, input: Input) std.mem.Allocator.Error!?zx.Diagnostic {
    if (@import("root.zig").checkNames(input.program)) |issue| return issue;

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const changes = try plan(arena.allocator(), input);

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
    const imports = input.program.imports;
    const ordered = try @import("imports/edits.zig").plan(allocator, input.source, input.comments, imports);
    const spaced = try spacing.edits(allocator, input.source, input.comments, input.program);
    var result: std.ArrayList(spacing.Edit) = .empty;

    try result.appendSlice(allocator, ordered);

    for (spaced) |edit| {
        if (imports.len != 0 and edit.span.start >= imports[0].span.start and edit.span.end <= imports[imports.len - 1].span.end) continue;
        try result.append(allocator, edit);
    }

    std.mem.sort(spacing.Edit, result.items, {}, struct {
        fn lessThan(_: void, left: spacing.Edit, right: spacing.Edit) bool {
            return left.span.start < right.span.start;
        }
    }.lessThan);

    return result.toOwnedSlice(allocator);
}
