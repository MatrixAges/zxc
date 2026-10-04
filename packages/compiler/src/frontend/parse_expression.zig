const std = @import("std");
const zx = @import("zx");
const Parser = @import("parser.zig");
const lex = @import("lex.zig").lex;

pub const Parsed = struct {
    source: []const u8,
    file_name: []const u8,
    lexed: zx.syntax.Lexed,
    expression: *const zx.ast.Expression,
};

pub const Result = struct {
    arena: std.heap.ArenaAllocator,
    value: union(enum) { parsed: Parsed, diagnostic: zx.Diagnostic },
    pub fn deinit(self: *Result) void {
        self.arena.deinit();

        self.* = undefined;
    }
};

pub fn parse(allocator: std.mem.Allocator, source: []const u8, file_name: []const u8) std.mem.Allocator.Error!Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    var reporter: zx.Reporter = .{};
    const temporary = arena.allocator();
    const owned_source = try temporary.dupe(u8, source);
    const owned_name = try temporary.dupe(u8, file_name);

    const lexed = lex(temporary, owned_source, &reporter) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return .{ .arena = arena, .value = .{ .diagnostic = reporter.diagnostic.? } };
    };

    var parser = Parser{ .allocator = temporary, .source = owned_source, .tokens = lexed.tokens, .reporter = &reporter };

    const expression = parser.expression(0) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return .{ .arena = arena, .value = .{ .diagnostic = reporter.diagnostic.? } };
    };

    if (parser.current().kind != .eof) return .{ .arena = arena, .value = .{ .diagnostic = .{
        .code = .syntax,
        .span = parser.current().span,
        .message = "expected the end of the expression",
    } } };

    return .{ .arena = arena, .value = .{ .parsed = .{ .source = owned_source, .file_name = owned_name, .lexed = lexed, .expression = expression } } };
}
