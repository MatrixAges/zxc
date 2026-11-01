const std = @import("std");
const generated = @import("generated");

pub const Token = struct {
    block: bool = false,
    boundary: bool = false,
    closing: bool = false,
    comment: bool = false,
    end: u64,
    gap: u64 = 0,
    newline: bool = false,
    object: bool = false,
    opening: bool = false,
    separator: bool = false,
    start: u64,
    text: []const u8,
};

pub const Break = struct { index: usize, level: usize, count: usize };

pub const Options = struct {
    width: usize = 0,
    level: usize = 0,
    indent_only: bool = false,
    prefix: usize = 0,
    suffix: usize = 0,
};

pub fn plan(allocator: std.mem.Allocator, tokens: []const Token, options: Options) std.mem.Allocator.Error![]const Break {
    const Input = std.meta.Child(generated.Input);
    const Item = std.meta.Child(std.meta.Child(@FieldType(Input, "tokens")));
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const temporary = arena.allocator();
    const values = try temporary.alloc(*const Item, tokens.len);

    for (tokens, values) |token, *slot| {
        const value = try temporary.create(Item);
        value.* = .{ .block = token.block, .boundary = token.boundary, .closing = token.closing, .comment = token.comment, .end = token.end, .gap = token.gap, .newline = token.newline, .object = token.object, .opening = token.opening, .separator = token.separator, .start = token.start, .text = token.text };
        slot.* = value;
    }

    const output = generated.executeIn(temporary, &.{ .tokens = values, .width = options.width, .level = options.level, .indent_only = options.indent_only, .prefix = options.prefix, .suffix = options.suffix }) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    const result = try allocator.alloc(Break, output.len);

    for (result, output) |*item, value| item.* = .{ .index = @intCast(value.index), .level = @intCast(value.level), .count = @intCast(value.count) };

    return result;
}
