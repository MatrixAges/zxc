const std = @import("std");
pub const ir = @import("zx").ir;
pub const checks = @import("checks");
const scalar: ir.TypeId = @fromBackingInt(@backingInt(ir.Scalar.u64));

comptime {
    if (!checks.generated) @compileError("function effect tests require the generated parser path");
}

pub const Effect = union(enum) {
    none,
    call: struct { target: u32, bound: bool = false },
    store_get,
    task,
    await_task,
    cancel_task,
    parallel,
};

pub const Function = struct {
    native: bool = false,
    concurrent: bool = false,
    store: bool = false,
    effect: Effect = .none,
};

pub fn expressions(allocator: std.mem.Allocator, effect: Effect) !ir.ExpressionTable {
    const literal: ir.Expression = .{ .type_id = scalar, .span = .{ .start = 0, .end = 0 }, .value = .{ .integer = 1 } };

    if (effect == .none) return ir.ExpressionTable.fromValues(allocator, &.{literal});

    const value: @FieldType(ir.Expression, "value") = switch (effect) {
        .none => unreachable,
        .call => |call| .{ .call = .{ .function = @fromBackingInt(call.target), .argument = @fromBackingInt(0), .stores = if (call.bound) &.{0} else &.{} } },
        .store_get => .{ .store_get = 0 },
        .task => .{ .task = .{ .body = @fromBackingInt(0), .captures = &.{} } },
        .await_task => .{ .await_task = @fromBackingInt(0) },
        .cancel_task => .{ .cancel_task = @fromBackingInt(0) },
        .parallel => .{ .parallel = &.{.{ .task = @fromBackingInt(0), .field = null }} },
    };

    const table = try ir.ExpressionTable.fromValues(allocator, &.{ literal, .{ .type_id = scalar, .span = .{ .start = 0, .end = 0 }, .value = value } });

    try std.testing.expect(table.validStructure());

    return table;
}

pub fn stores(allocator: std.mem.Allocator, enabled: bool) !ir.StoreTable {
    return ir.StoreTable.fromValues(allocator, if (enabled) &.{.{ .path = "shared", .type_id = scalar }} else &.{});
}

pub fn program(allocator: std.mem.Allocator, functions: []const Function, root: Effect) !ir.Program {
    const values = try allocator.alloc(ir.Function, functions.len);

    for (functions, values) |source, *value| {
        value.* = .{
            .file_name = "effect.zx",
            .input_type = scalar,
            .output_type = scalar,
            .output_ownership = .copy,
            .symbols = .{},
            .expressions = try expressions(allocator, source.effect),
            .body = .{},
            .stores = try stores(allocator, source.store),
            .external = if (source.native) .{ .module = @fromBackingInt(0), .member = &.{"probe"}, .concurrent = source.concurrent } else null,
        };
    }

    const table = try ir.FunctionTable.fromValues(allocator, values);

    try std.testing.expect(table.validStructure());

    return .{ .file_name = "main.zx", .types = .{}, .symbols = .{}, .expressions = try expressions(allocator, root), .input_type = scalar, .output_type = scalar, .body = .{}, .functions = table };
}

pub fn summary(specifications: []const Function, expected: []const bool, task_expected: []const bool) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const value = try program(arena.allocator(), specifications, .none);
    var result = try checks.parallel.functions(std.testing.allocator, value);

    defer result.deinit();

    try std.testing.expectEqualSlices(bool, expected, result.values);
    for (task_expected, 0..) |allowed, index| try std.testing.expectEqual(allowed, try checks.tasks.callSafe(std.testing.allocator, value.functions, @fromBackingInt(@intCast(index))));
}
