const std = @import("std");
const zx = @import("zx");
const Parser = @import("parser.zig");
const lex = @import("lexer").lex;

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

    if (@import("parser_options").generated_parser) {
        const generated = @import("generated_expression");
        const adapter = @import("program_adapter/root.zig");
        var scratch = std.heap.ArenaAllocator.init(allocator);

        defer scratch.deinit();

        const output = generated.execute(&scratch, owned_source) catch |err| switch (err) {
            error.OutOfMemory, error.Overflow => return error.OutOfMemory,
            else => {
                const message = try std.fmt.allocPrint(temporary, "internal compiler error: generated expression parser failed with {s}", .{@errorName(err)});

                return .{ .arena = arena, .value = .{ .diagnostic = .{
                    .code = .contract,
                    .span = .{ .start = 0, .end = 0 },
                    .message = message,
                } } };
            },
        };

        const issue = output.diagnostic;

        if (issue.message.len != 0) {
            const message = try temporary.dupe(u8, issue.message);

            return .{ .arena = arena, .value = .{ .diagnostic = .{
                .code = std.meta.stringToEnum(@FieldType(zx.Diagnostic, "code"), issue.code) orelse unreachable,
                .span = .{ .start = @intCast(issue.start), .end = @intCast(issue.end) },
                .message = message,
            } } };
        }

        const expression = try adapter.expression(temporary, owned_source, output.state);
        const tokens = try adapter.lexed(temporary, output.state.prepared.lexical.lexed);

        return .{ .arena = arena, .value = .{ .parsed = .{ .source = owned_source, .file_name = owned_name, .lexed = tokens, .expression = expression } } };
    }

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
