const std = @import("std");
const window_limit = 256 * 1024;

/// The type of public function `name` in a generated file, as a `fn (...) R` expression: the parameter list
/// and return type, up to the brace that opens the body. Braces of error sets and container types inside the
/// return type stay part of it. An inline function yields the same type without the inline convention.
pub fn find(allocator: std.mem.Allocator, source: []const u8, name: []const u8) !?[]const u8 {
    const start = for ([_][]const u8{ "pub fn ", "pub inline fn " }) |keywords| {
        if (try parameters(allocator, source, keywords, name)) |offset| break offset;
    } else return null;

    const window = try allocator.dupeSentinel(u8, source[start..@min(source.len, start + window_limit)], 0);

    defer allocator.free(window);

    var tokenizer = std.zig.Tokenizer.init(window);
    var parens: u32 = 0;
    var braces: u32 = 0;
    var previous: std.zig.Token.Tag = .invalid;

    while (true) {
        const token = tokenizer.next();

        switch (token.tag) {
            .eof => return error.UnterminatedSignature,
            .l_paren => parens += 1,
            .r_paren => parens -= 1,
            .l_brace => if (parens == 0 and braces == 0 and !opensType(previous)) {
                const text = std.mem.trimEnd(u8, window[0..token.loc.start], " \t\r\n");

                return try std.mem.concat(allocator, u8, &.{ "fn ", text });
            } else {
                braces += 1;
            },
            .r_brace => braces -= 1,
            else => {},
        }

        previous = token.tag;
    }
}

fn opensType(tag: std.zig.Token.Tag) bool {
    return switch (tag) {
        .keyword_error, .keyword_struct, .keyword_union, .keyword_enum, .keyword_opaque => true,
        else => false,
    };
}

/// Names of the functions declared `pub inline fn` at the start of a line; callers must expand them in their
/// own unit.
pub fn inlineNames(allocator: std.mem.Allocator, source: []const u8) ![]const []const u8 {
    const marker = "pub inline fn ";
    var names: std.ArrayList([]const u8) = .empty;
    var cursor: usize = 0;

    while (std.mem.indexOfPos(u8, source, cursor, marker)) |at| {
        cursor = at + marker.len;

        if (at != 0 and source[at - 1] != '\n') continue;

        const end = std.mem.indexOfScalarPos(u8, source, cursor, '(') orelse break;

        try names.append(allocator, source[cursor..end]);
    }

    return names.items;
}

/// Offset of the parameter list of `name` declared with `keywords` at the start of a line.
fn parameters(allocator: std.mem.Allocator, source: []const u8, keywords: []const u8, name: []const u8) !?usize {
    const marker = try std.mem.concat(allocator, u8, &.{ "\n", keywords, name, "(" });

    defer allocator.free(marker);

    if (std.mem.startsWith(u8, source, marker[1..])) return marker.len - 2;

    const at = std.mem.indexOf(u8, source, marker) orelse return null;

    return at + marker.len - 1;
}
