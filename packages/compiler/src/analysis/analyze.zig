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
pub const ContextBinding = struct { id: []const u8, type_name: ?[]const u8 = null, type_id: ?zx.ir.TypeId = null };
pub const Context = struct { types: []const zx.ir.Type = &.{}, stores: []const StoreBinding = &.{}, contexts: []const ContextBinding = &.{} };

pub fn analyze(allocator: std.mem.Allocator, parsed: Parsed) std.mem.Allocator.Error!Result {
    return analyzeWithContext(allocator, parsed, .{});
}

pub fn analyzeWithContext(allocator: std.mem.Allocator, parsed: Parsed, context: Context) std.mem.Allocator.Error!Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    if (parsed.ast.imports.len > 0) return .{ .arena = arena, .value = .{ .diagnostic = .{ .code = .module, .span = parsed.ast.imports[0].span, .message = "modules with imports require the project analysis entry point" } } };

    var reporter: zx.Reporter = .{};

    if (context.types.len != 0 and !@import("../ir/type_rules.zig").validate(context.types)) return .{ .arena = arena, .value = .{ .diagnostic = .{
        .code = .contract,
        .span = .{ .start = 0, .end = 0 },
        .message = "invalid shared type table",
    } } };

    var analyzer = Analyzer{
        .allocator = arena.allocator(),
        .store_bindings = context.stores,
        .context_bindings = context.contexts,
        .context_type_count = context.types.len,
        .reporter = &reporter,
        .types = .{ .allocator = arena.allocator(), .reporter = &reporter, .declarations = parsed.ast.declarations },
    };

    try analyzer.types.items.appendSlice(arena.allocator(), try @import("type_table.zig").copy(arena.allocator(), context.types));

    var program = analyzer.run(parsed.ast, parsed.file_name) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return .{ .arena = arena, .value = .{ .diagnostic = reporter.diagnostic.? } };
    };

    program.output_ownership = @import("../ownership/check.zig").analyze(arena.allocator(), program, &reporter) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return .{ .arena = arena, .value = .{ .diagnostic = reporter.diagnostic.? } };
    };

    return .{ .arena = arena, .value = .{ .ir = program } };
}
