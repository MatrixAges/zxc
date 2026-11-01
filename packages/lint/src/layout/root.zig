const std = @import("std");
const rule = @import("layout_rule");
const spacing = @import("../spacing.zig");
const line_rule = @import("indentation_line");
pub const Token = rule.Token;
pub const Projection = @import("projection.zig").Projection;
pub const use_default_width = 0;

pub fn format(allocator: std.mem.Allocator, source: []const u8, tokens: []const Token, width: usize, level: usize) std.mem.Allocator.Error![]u8 {
    const newline: []const u8 = if (std.mem.indexOf(u8, source, "\r\n") != null) "\r\n" else "\n";

    return apply(allocator, source, tokens, .{ .width = width, .level = level }, newline);
}

pub fn indent(allocator: std.mem.Allocator, source: []const u8, tokens: []const Token, level: usize) std.mem.Allocator.Error![]u8 {
    return apply(allocator, source, tokens, .{ .level = level, .indent_only = true }, "\n");
}

pub fn formatAttribute(allocator: std.mem.Allocator, source: []const u8, tokens: []const Token, level: usize, prefix: usize, newline: []const u8) std.mem.Allocator.Error![]u8 {
    return apply(allocator, source, tokens, .{ .level = level, .prefix = prefix, .suffix = 1 }, newline);
}

fn apply(allocator: std.mem.Allocator, source: []const u8, tokens: []const Token, options: rule.Options, newline: []const u8) std.mem.Allocator.Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const temporary = arena.allocator();
    const planned = try rule.plan(temporary, tokens, options);
    var edits: std.ArrayList(spacing.Edit) = .empty;

    for (planned) |item| {
        const offset: usize = @intCast(tokens[item.index].start);

        if (item.index == 0 or tokens[item.index].newline) {
            const change = line_rule.plan(source, offset, item.level) orelse continue;
            const replacement = try temporary.alloc(u8, item.count);

            @memset(replacement, ' ');

            try edits.append(temporary, .{ .span = .{ .start = change.start, .end = change.end }, .replacement = replacement });

            continue;
        }

        const start: usize = @intCast(tokens[item.index - 1].end);
        const gap = source[start..offset];

        if (std.mem.trim(u8, gap, " \t\r\n").len != 0 or std.mem.indexOfScalar(u8, gap, '\n') != null) continue;

        const replacement = try temporary.alloc(u8, newline.len + item.count);

        @memcpy(replacement[0..newline.len], newline);
        @memset(replacement[newline.len..], ' ');

        try edits.append(temporary, .{ .span = .{ .start = start, .end = offset }, .replacement = replacement });
    }

    return spacing.format(allocator, source, edits.items);
}
