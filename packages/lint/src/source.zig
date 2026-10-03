const std = @import("std");
const zx = @import("zx");
const spacing = @import("spacing.zig");
pub const formatting_required = "blank lines require formatting";

pub const Input = struct {
    source: []const u8,
    comments: []const zx.Span,
    program: zx.ast.Program,
};

pub fn check(allocator: std.mem.Allocator, input: Input) std.mem.Allocator.Error!?zx.Diagnostic {
    if (@import("root.zig").checkNames(input.program)) |issue| return issue;

    const changes = try spacing.edits(allocator, input.source, input.comments, input.program);

    defer allocator.free(changes);

    if (changes.len == 0) return null;

    return .{ .code = .spacing, .span = changes[0].span, .message = "blank lines do not match AST grouping; run zxc fmt" };
}

pub fn format(allocator: std.mem.Allocator, input: Input) std.mem.Allocator.Error![]u8 {
    const changes = try spacing.edits(allocator, input.source, input.comments, input.program);

    defer allocator.free(changes);

    return spacing.format(allocator, input.source, changes);
}
