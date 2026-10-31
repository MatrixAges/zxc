const std = @import("std");
const zx = @import("zx");

pub fn normalize(allocator: std.mem.Allocator, name: zx.ast.Name) std.mem.Allocator.Error!zx.ast.Name {
    if (std.mem.indexOfAny(u8, name.text, " \t\r\n/") == null) return name;

    var reporter: zx.Reporter = .{};

    const lexed = @import("lexer").lex(allocator, name.text, &reporter) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return name;
    };

    if (lexed.tokens.len < 2 or lexed.tokens.len % 2 != 0) return name;

    var text: std.ArrayList(u8) = .empty;

    errdefer text.deinit(allocator);

    for (lexed.tokens[0 .. lexed.tokens.len - 1], 0..) |token, index| {
        if (if (index % 2 == 0) token.kind != .identifier else !std.mem.eql(u8, token.text(name.text), ".")) {
            text.deinit(allocator);

            return name;
        }

        try text.appendSlice(allocator, token.text(name.text));
    }

    return .{ .text = try text.toOwnedSlice(allocator), .span = name.span };
}
