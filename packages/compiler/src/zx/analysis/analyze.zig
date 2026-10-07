const std = @import("std");
const zx = @import("zx");
const Parsed = @import("../frontend/parse.zig").Parsed;
const Analyzer = @import("analyzer.zig");
const Input = @import("../modules/module_input.zig");
const ModuleResult = @import("../frontend/module_result.zig");
const Origins = @import("../modules/nominal_origins.zig");

pub const Result = struct {
    arena: std.heap.ArenaAllocator,
    value: union(enum) { ir: zx.ir.Program, diagnostic: zx.Diagnostic },
    nominal_types: @import("../modules/nominal_origins.zig").Table = .{},
    store_initializers: []const @import("../modules/compiled.zig").StoreInitializer = &.{},
    modules: []const @import("../modules/module_record.zig") = &.{},
    pub fn deinit(self: *Result) void {
        self.arena.deinit();

        self.* = undefined;
    }
};

pub const StoreBinding = struct { handle: []const u8, path: []const u8, type_name: ?[]const u8 = null, type_id: ?zx.ir.TypeId = null, readable: bool = true, writable: bool = true };
pub const Context = struct { types: zx.ir.TypeTable = .{}, nominal_types: Origins.Table = .{}, native_modules: zx.ir.NativeModuleTable = .{}, stores: []const StoreBinding = &.{} };

pub fn analyze(allocator: std.mem.Allocator, parsed: Parsed) std.mem.Allocator.Error!Result {
    return analyzeWithContext(allocator, parsed, .{});
}

pub fn analyzeWithContext(allocator: std.mem.Allocator, parsed: Parsed, context: Context) std.mem.Allocator.Error!Result {
    return analyzeInput(allocator, Input.Native{ .value = parsed }, parsed.file_name, context);
}

pub fn analyzeModule(allocator: std.mem.Allocator, parsed: *const ModuleResult.Result, context: Context) std.mem.Allocator.Error!Result {
    return switch (parsed.*) {
        .native => |result| analyzeWithContext(allocator, result.value.parsed, context),
        .indexed => |*result| if (ModuleResult.indexed_enabled) analyzeInput(allocator, Input.Indexed{ .value = result }, result.file_name, context) else unreachable,
    };
}

fn analyzeInput(allocator: std.mem.Allocator, input: anytype, file_name: []const u8, context: Context) std.mem.Allocator.Error!Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const header = input.header();

    if (header.importCount() > 0) return .{ .arena = arena, .value = .{ .diagnostic = .{ .code = .module, .span = header.importAt(0).span, .message = "modules with imports require the project analysis entry point" } } };

    var reporter: zx.Reporter = .{};

    if (context.types.count() != 0 and !@import("../ir/type_rules.zig").validate(context.types)) return .{ .arena = arena, .value = .{ .diagnostic = .{
        .code = .contract,
        .span = .{ .start = 0, .end = 0 },
        .message = "invalid shared type table",
    } } };

    if (!@import("../modules/native_context.zig").valid(context.types, context.native_modules)) return .{ .arena = arena, .value = .{ .diagnostic = .{
        .code = .contract,
        .span = .{ .start = 0, .end = 0 },
        .message = "invalid shared native module table",
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
        .store_type_count = context.types.count(),
        .reporter = &reporter,
        .types = .{ .allocator = arena.allocator(), .reporter = &reporter, .declarations = &.{}, .shared = .{ .origins = &origins, .origin = .{ .source = file_name } } },
    };

    try analyzer.types.items.appendDelta(arena.allocator(), copied_types);

    var program = input.analyze(&analyzer, file_name) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return .{ .arena = arena, .value = .{ .diagnostic = reporter.diagnostic.? } };
    };

    program.native_modules = try @import("../modules/native_context.zig").copy(arena.allocator(), context.native_modules);

    program.output_ownership = @import("../ownership/check.zig").analyze(arena.allocator(), program, &reporter) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return .{ .arena = arena, .value = .{ .diagnostic = reporter.diagnostic.? } };
    };

    return .{ .arena = arena, .value = .{ .ir = program }, .nominal_types = origins.items.view() };
}
