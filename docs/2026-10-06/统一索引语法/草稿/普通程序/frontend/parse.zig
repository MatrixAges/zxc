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

pub const ModuleResult = @import("module_result.zig").Result;

pub fn parse(allocator: std.mem.Allocator, source: []const u8, file_name: []const u8) std.mem.Allocator.Error!Result {
    const result = try parseWithMode(false, allocator, source, file_name);

    return result.native;
}

pub fn parseModule(allocator: std.mem.Allocator, source: []const u8, file_name: []const u8) std.mem.Allocator.Error!ModuleResult {
    return parseWithMode(true, allocator, source, file_name);
}

fn parseWithMode(comptime retain_indexed: bool, allocator: std.mem.Allocator, source: []const u8, file_name: []const u8) std.mem.Allocator.Error!ModuleResult {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    var reporter: zx.Reporter = .{};
    const owned_source = try arena.allocator().dupe(u8, source);
    const owned_name = try arena.allocator().dupe(u8, file_name);

    if (@import("parser_options").generated_parser) {
        const generated = @import("generated_parser");
        const adapter = @import("program_adapter/root.zig");
        var temporary = std.heap.ArenaAllocator.init(allocator);
        var retained = false;

        defer if (!retained) temporary.deinit();

        const output = generated.execute(&temporary, owned_source) catch |err| switch (err) {
            error.OutOfMemory, error.Overflow => return error.OutOfMemory,
            else => {
                const message = try std.fmt.allocPrint(arena.allocator(), "internal compiler error: generated parser failed with {s}", .{@errorName(err)});

                return .{ .native = .{ .arena = arena, .value = .{ .diagnostic = .{
                    .code = .contract,
                    .span = .{ .start = 0, .end = 0 },
                    .message = message,
                } } } };
            },
        };

        if (output.diagnostic.message.len != 0) {
            const message = try arena.allocator().dupe(u8, output.diagnostic.message);

            return .{ .native = .{ .arena = arena, .value = .{ .diagnostic = .{
                .code = std.meta.stringToEnum(@FieldType(zx.Diagnostic, "code"), output.diagnostic.code) orelse unreachable,
                .span = .{ .start = @intCast(output.diagnostic.start), .end = @intCast(output.diagnostic.end) },
                .message = message,
            } } } };
        }

        if (retain_indexed) {
            retained = true;

            return .{ .indexed = .{
                .arena = arena,
                .syntax_arena = temporary,
                .source = owned_source,
                .file_name = owned_name,
                .output = output,
            } };
        }

        const tree = try adapter.convert(arena.allocator(), owned_source, output);
        const tokens = try adapter.lexed(arena.allocator(), output);

        return .{ .native = .{ .arena = arena, .value = .{ .parsed = .{ .source = owned_source, .file_name = owned_name, .lexed = tokens, .ast = tree } } } };
    }

    const lexed = lex(arena.allocator(), owned_source, &reporter) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return .{ .native = .{ .arena = arena, .value = .{ .diagnostic = reporter.diagnostic.? } } };
    };

    var parser = Parser{ .allocator = arena.allocator(), .source = owned_source, .tokens = lexed.tokens, .reporter = &reporter };

    const tree = parser.program() catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return .{ .native = .{ .arena = arena, .value = .{ .diagnostic = reporter.diagnostic.? } } };
    };

    return .{ .native = .{ .arena = arena, .value = .{ .parsed = .{ .source = owned_source, .file_name = owned_name, .lexed = lexed, .ast = tree } } } };
}
