const std = @import("std");
const zx = @import("zx");
const Parsed = @import("../frontend/parse.zig").Parsed;
const Analyzer = @import("analyzer.zig");
const Input = @import("../modules/module_input.zig");
const ModuleResult = @import("../frontend/module_result.zig");
const Origins = @import("../modules/nominal_origins.zig");
pub const Resolved = @import("../modules/resolved.zig");

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

pub const ResolvedResult = struct {
    value: @FieldType(Result, "value"),
    nominal_types: Origins.Table = .{},
    store_initializers: []const @import("../modules/compiled.zig").StoreInitializer = &.{},
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

pub fn analyzeResolvedIn(allocator: std.mem.Allocator, parsed: *const ModuleResult.Result, context: Context, resolved: Resolved.Input) std.mem.Allocator.Error!ResolvedResult {
    return switch (parsed.*) {
        .native => |result| analyzeInputIn(allocator, Input.Native{ .value = result.value.parsed }, result.value.parsed.file_name, context, resolved),
        .indexed => |*result| if (ModuleResult.indexed_enabled) analyzeInputIn(allocator, Input.Indexed{ .value = result }, result.file_name, context, resolved) else unreachable,
    };
}

fn analyzeInput(allocator: std.mem.Allocator, input: anytype, file_name: []const u8, context: Context) std.mem.Allocator.Error!Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const result = try analyzeInputIn(arena.allocator(), input, file_name, context, null);

    return .{ .arena = arena, .value = result.value, .nominal_types = result.nominal_types, .store_initializers = result.store_initializers };
}

fn analyzeInputIn(allocator: std.mem.Allocator, input: anytype, file_name: []const u8, context: Context, resolved: ?Resolved.Input) std.mem.Allocator.Error!ResolvedResult {
    const header = input.header();

    if (resolved == null and header.importCount() > 0) return .{ .value = .{ .diagnostic = .{ .code = .module, .span = header.importAt(0).span, .message = "modules with imports require the project analysis entry point" } } };

    var reporter: zx.Reporter = .{};

    if (context.types.count() != 0 and !@import("../ir/type_rules.zig").validate(context.types)) return .{ .value = .{ .diagnostic = .{
        .code = .contract,
        .span = .{ .start = 0, .end = 0 },
        .message = "invalid shared type table",
    } } };

    if (!@import("../modules/native_context.zig").valid(context.types, context.native_modules)) return .{ .value = .{ .diagnostic = .{
        .code = .contract,
        .span = .{ .start = 0, .end = 0 },
        .message = "invalid shared native module table",
    } } };

    if (resolved) |bindings| {
        if (!Resolved.valid(header, bindings, context.types)) return .{ .value = .{ .diagnostic = .{ .code = .contract, .span = .{ .start = 0, .end = 0 }, .message = "resolved imports do not match the source declarations and function signatures" } } };
    }

    const functions = if (resolved) |bindings| bindings.functions else zx.ir.FunctionTable{};
    const copied_types = try @import("type_table.zig").storage(allocator, context.types);
    var origins = Origins{ .allocator = allocator };

    origins.seed(copied_types.view(), context.nominal_types) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return .{ .value = .{ .diagnostic = .{ .code = .contract, .span = .{ .start = 0, .end = 0 }, .message = "invalid shared nominal type table" } } };
    };

    var analyzer = Analyzer{
        .allocator = allocator,
        .store_bindings = context.stores,
        .store_type_count = context.types.count(),
        .reporter = &reporter,
        .functions = functions,
        .function_imports = if (resolved) |bindings| bindings.imports else &.{},
        .types = .{ .allocator = allocator, .reporter = &reporter, .declarations = &.{}, .aliases = if (resolved) |bindings| bindings.aliases else &.{}, .shared = .{ .origins = &origins, .origin = .{ .source = file_name } } },
    };

    analyzer.types.items = copied_types;

    var program = input.analyze(&analyzer, file_name) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return .{ .value = .{ .diagnostic = reporter.diagnostic.? } };
    };

    program.functions = functions;
    program.native_modules = if (resolved != null) context.native_modules else try @import("../modules/native_context.zig").copy(allocator, context.native_modules);

    if (!@TypeOf(input).completes_ownership) program.output_ownership = @import("../ownership/check.zig").analyze(allocator, program, &reporter) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return .{ .value = .{ .diagnostic = reporter.diagnostic.? } };
    };

    if (resolved) |bindings| {
        if (try @import("../ir/validate.zig").validateExtending(allocator, program, bindings.verified_functions)) |issue| return .{ .value = .{ .diagnostic = issue } };
    }

    const initializers = if (resolved) |bindings| bindings.store_initializers else &.{};

    for (initializers) |initializer| {
        if (@backingInt(initializer.function) >= functions.count()) return .{ .value = .{ .diagnostic = .{ .code = .contract, .span = .{ .start = 0, .end = 0 }, .message = "resolved Store initializer references a missing function" } } };
    }

    return .{ .value = .{ .ir = program }, .nominal_types = origins.items.view(), .store_initializers = initializers };
}
