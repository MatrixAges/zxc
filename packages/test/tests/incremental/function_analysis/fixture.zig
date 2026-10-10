const std = @import("std");
pub const ir = @import("zx").ir;
pub const checks = @import("checks");
pub const Capability = enum { none, io, process };
const scalar: ir.TypeId = @fromBackingInt(@backingInt(ir.Scalar.u64));
const span = @import("zx").Span{ .start = 0, .end = 0 };

fn function(allocator: std.mem.Allocator, previous: ?u32) !ir.Function {
    const expressions = try ir.ExpressionTable.fromValues(allocator, &.{
        .{ .type_id = scalar, .span = span, .value = .{ .reference = @fromBackingInt(0) } },
        .{ .type_id = scalar, .span = span, .value = if (previous) |id| .{ .call = .{ .function = @fromBackingInt(id), .argument = @fromBackingInt(0) } } else .{ .integer = 1 } },
    });

    return .{
        .file_name = "step.zx", .input_type = scalar, .output_type = scalar, .output_ownership = .copy,
        .symbols = try ir.SymbolTable.fromValues(allocator, &.{.{ .name = "in", .type_id = scalar, .span = span }}),
        .expressions = expressions,
        .body = try ir.ControlBody.fromValues(allocator, &.{.{ .result = @fromBackingInt(1) }}),
    };
}

pub fn program(allocator: std.mem.Allocator, count: usize, capability: Capability) !ir.Program {
    var types: ir.TypeStorage = .{};

    for (std.meta.tags(ir.Scalar)) |item| try types.append(allocator, .{ .scalar = item });

    const functions = try allocator.alloc(ir.Function, count);

    for (functions, 0..) |*selected, index| {
        selected.* = try function(allocator, if (index == 0) null else @intCast(index - 1));

        if (index == 0 and capability != .none) {
            selected.expressions = .{};
            selected.body = .{};
            selected.external = .{ .module = @fromBackingInt(0), .member = &.{"apply"}, .io_argument = capability == .io, .process_argument = capability == .process };
        }
    }

    const entry = try function(allocator, if (count == 0) null else @intCast(count - 1));

    const value: ir.Program = .{
        .file_name = "main.zx", .types = try types.finish(allocator),
        .input_type = scalar, .output_type = scalar, .output_ownership = .copy,
        .symbols = entry.symbols, .expressions = entry.expressions, .body = entry.body,
        .functions = try ir.FunctionTable.fromValues(allocator, functions),
        .native_modules = try ir.NativeModuleTable.fromValues(allocator, if (capability == .none) &.{} else &.{.{ .specifier = "zig:host", .import_name = "host" }}),
    };

    try std.testing.expect(value.types.validStructure());
    try std.testing.expect(value.functions.validStructure());
    try std.testing.expect(value.expressions.validStructure());
    try std.testing.expect(try value.body.validStructure(allocator));

    for (functions) |item| {
        try std.testing.expect(item.expressions.validStructure());
        try std.testing.expect(try item.body.validStructure(allocator));
    }

    return value;
}

pub fn expected(summary: checks.summary, count: usize, capability: Capability) !void {
    try std.testing.expectEqual(count, summary.value.pure.len);
    try std.testing.expectEqual(count, summary.buffers.len);
    try std.testing.expectEqual(count, summary.transfers.len);
    try std.testing.expectEqual(std.meta.tags(ir.Scalar).len, summary.value.state.selected.len);
    for (summary.value.state.selected) |selected| try std.testing.expect(!selected);

    for (0..count) |index| {
        try std.testing.expect(summary.value.pure[index]);
        try std.testing.expectEqual(capability == .none, summary.value.local[index]);
        try std.testing.expect(!summary.value.values[index]);
        try std.testing.expect(!summary.allocated[index]);
        try std.testing.expectEqual(capability == .io, summary.io[index]);
        try std.testing.expectEqual(capability == .process, summary.process[index]);
        try std.testing.expectEqual(@as(usize, 0), summary.buffers[index].len);
        try std.testing.expectEqual(@as(usize, 0), summary.transfers[index].len);
    }
}

pub fn check(count: usize, capability: Capability) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const value = try program(arena.allocator(), count, capability);
    const borrowed = try checks.summary.analyze(arena.allocator(), value);
    var owned = try checks.summary.create(std.testing.allocator, value);

    defer owned.deinit();

    try expected(owned.value, count, capability);
    try std.testing.expectEqualDeep(borrowed, owned.value);
}
