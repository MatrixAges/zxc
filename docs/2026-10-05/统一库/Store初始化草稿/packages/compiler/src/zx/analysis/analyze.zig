const std = @import("std");
const zx = @import("zx");
const Parsed = @import("../frontend/parse.zig").Parsed;
const Analyzer = @import("analyzer.zig");
const Origins = @import("../modules/nominal_origins.zig");

pub const Result = struct {
    arena: std.heap.ArenaAllocator,
    value: union(enum) { ir: zx.ir.Program, diagnostic: zx.Diagnostic },
    nominal_types: []const @import("../modules/nominal_origins.zig").Item = &.{},
    store_initializers: []const @import("../modules/compiled.zig").StoreInitializer = &.{},
    modules: []const @import("../modules/module_record.zig") = &.{},
    pub fn deinit(self: *Result) void {
        self.arena.deinit();

        self.* = undefined;
    }
};

pub const StoreBinding = struct { handle: []const u8, path: []const u8, type_name: ?[]const u8 = null, type_id: ?zx.ir.TypeId = null, readable: bool = true, writable: bool = true };
pub const Context = struct { types: []const zx.ir.Type = &.{}, nominal_types: []const Origins.Item = &.{}, stores: []const StoreBinding = &.{} };

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

    const copied_types = try @import("type_table.zig").copy(arena.allocator(), context.types);
    var origins = Origins{ .allocator = arena.allocator() };

    origins.seed(copied_types, context.nominal_types) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return .{ .arena = arena, .value = .{ .diagnostic = .{ .code = .contract, .span = .{ .start = 0, .end = 0 }, .message = "invalid shared nominal type table" } } };
    };

    var analyzer = Analyzer{
        .allocator = arena.allocator(),
        .store_bindings = context.stores,
        .store_type_count = context.types.len,
        .reporter = &reporter,
        .types = .{ .allocator = arena.allocator(), .reporter = &reporter, .declarations = parsed.ast.declarations, .shared = .{ .origins = &origins, .origin = .{ .source = parsed.file_name } } },
    };

    try analyzer.types.items.appendSlice(arena.allocator(), copied_types);

    var program = analyzer.run(parsed.ast, parsed.file_name) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return .{ .arena = arena, .value = .{ .diagnostic = reporter.diagnostic.? } };
    };

    program.output_ownership = @import("../ownership/check.zig").analyze(arena.allocator(), program, &reporter) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return .{ .arena = arena, .value = .{ .diagnostic = reporter.diagnostic.? } };
    };

    return .{ .arena = arena, .value = .{ .ir = program }, .nominal_types = origins.items.items };
}
