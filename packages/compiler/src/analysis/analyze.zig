const std = @import("std");
const zx = @import("zx");
const Parsed = @import("../frontend/parse.zig").Parsed;
const Analyzer = @import("analyzer.zig");

pub const Result = struct {
    arena: std.heap.ArenaAllocator,
    value: union(enum) { ir: zx.ir.Program, diagnostic: zx.Diagnostic },
    pub fn deinit(self: *Result) void {
        self.arena.deinit();

        self.* = undefined;
    }
};

pub const StoreBinding = struct { handle: []const u8, path: []const u8, type_name: []const u8, readable: bool = true, writable: bool = true };
pub const Context = struct { stores: []const StoreBinding = &.{} };

pub fn analyze(allocator: std.mem.Allocator, parsed: Parsed) std.mem.Allocator.Error!Result {
    return analyzeWithContext(allocator, parsed, .{});
}

pub fn analyzeWithContext(allocator: std.mem.Allocator, parsed: Parsed, context: Context) std.mem.Allocator.Error!Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    if (parsed.ast.imports.len > 0) return .{ .arena = arena, .value = .{ .diagnostic = .{ .code = .module, .span = parsed.ast.imports[0].span, .message = "modules with imports require the project analysis entry point" } } };

    var reporter: zx.Reporter = .{};

    var analyzer = Analyzer{
        .allocator = arena.allocator(),
        .store_bindings = context.stores,
        .reporter = &reporter,
        .types = .{ .allocator = arena.allocator(), .reporter = &reporter, .declarations = parsed.ast.declarations },
    };

    const program = analyzer.run(parsed.ast, parsed.file_name) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return .{ .arena = arena, .value = .{ .diagnostic = reporter.diagnostic.? } };
    };

    @import("../ownership/check.zig").check(arena.allocator(), program, &reporter) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return .{ .arena = arena, .value = .{ .diagnostic = reporter.diagnostic.? } };
    };

    return .{ .arena = arena, .value = .{ .ir = program } };
}
