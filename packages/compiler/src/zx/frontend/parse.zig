const std = @import("std");
const zx = @import("zx");
const Parser = @import("parser.zig");
const lex = @import("lexer").lex;

pub const Parsed = struct {
    source: []const u8,
    file_name: []const u8,
    lexed: zx.syntax.Lexed,
    ast: zx.ast.Program,
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
    const owned_source = try arena.allocator().dupe(u8, source);
    const owned_name = try arena.allocator().dupe(u8, file_name);

    const lexed = lex(arena.allocator(), owned_source, &reporter) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return .{ .arena = arena, .value = .{ .diagnostic = reporter.diagnostic.? } };
    };

    var parser = Parser{ .allocator = arena.allocator(), .source = owned_source, .tokens = lexed.tokens, .reporter = &reporter };

    const tree = parser.program() catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return .{ .arena = arena, .value = .{ .diagnostic = reporter.diagnostic.? } };
    };

    return .{ .arena = arena, .value = .{ .parsed = .{ .source = owned_source, .file_name = owned_name, .lexed = lexed, .ast = tree } } };
}
