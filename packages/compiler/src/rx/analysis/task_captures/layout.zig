const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Binding = @import("frontend").expressions.Binding;
const enabled = @import("rx_options").generated_graph;
const Self = @This();

source_types: []const ir.TypeId = &.{},
elements: []const ir.ExprId = &.{},
narrows: bool = false,
pub fn admits(types: ir.TypeTable, children: []const ir.TypeId) bool {
    if (children.len == 0) return true;

    if (comptime !enabled) {
        for (children) |id| {
            if (types.at(@backingInt(id)) == .task) return false;
        }

        return true;
    }

    const rule = @import("generated_rx_task_capture_admission");
    const Input = std.meta.Child(rule.Input);
    const Tables = std.meta.Child(@FieldType(Input, "tables"));
    const Table = std.meta.Child(@FieldType(Tables, "base"));
    const base = ir.TypeTable.borrow(Table, types);
    const delta = ir.TypeTable.borrow(Table, .{});

    const input: Input = .{
        .tables = &.{ .base = &base, .delta = &delta },
        .candidate = &.{ .kind = .Tuple, .first = 0, .second = 0, .label = "", .children = @ptrCast(children), .fields = &.{ .names = &.{}, .types = &.{} }, .names = &.{} },
    };

    var empty = std.heap.FixedBufferAllocator.init(&.{});

    return (zx.columns.invoke(rule.executeValue, empty.allocator(), &input) catch unreachable) == .None;
}

pub fn plan(allocator: std.mem.Allocator, types: []const ir.TypeId, positions: []const u32, parameters: []const ir.TypeId) std.mem.Allocator.Error!Self {
    if (positions.len == 0) return .{};
    if (positions.len > (std.math.maxInt(u32) - 1) / 3) return error.OutOfMemory;
    if (comptime !enabled) return @import("layout/seed.zig").plan(allocator, types, positions, parameters);

    const rule = @import("generated_rx_task_capture_layout");
    const input: std.meta.Child(rule.Input) = .{ .types = @ptrCast(types), .positions = positions, .parameters = @ptrCast(parameters) };

    const result = zx.columns.invoke(rule.executeValue, allocator, &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    return .{
        .source_types = @ptrCast(result.source_types),
        .elements = @ptrCast(result.rows.elements),
        .narrows = result.rows.narrows,
    };
}

pub fn narrow(types: ir.TypeTable, bindings: []Binding, facts: []const []const u8) void {
    if (facts.len == 0) return;
    if (comptime !enabled) return @import("layout/seed.zig").narrow(types, bindings, facts);

    const rule = @import("generated_rx_task_capture_narrow");
    var empty = std.heap.FixedBufferAllocator.init(&.{});

    for (bindings) |*binding| {
        const index = @backingInt(binding.type_id);

        const input: std.meta.Child(rule.Input) = .{
            .type_id = index,
            .kind = types.kinds[index],
            .first = types.first[index],
            .name = binding.name,
            .facts = facts,
        };

        binding.type_id = @fromBackingInt(zx.columns.invoke(rule.executeValue, empty.allocator(), &input) catch unreachable);
    }
}
