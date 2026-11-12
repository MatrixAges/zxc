const std = @import("std");
const zx = @import("zx");
const Indexed = @import("frontend").ExpressionInput.Indexed;
const Binding = @import("../store.zig").Binding;
const Setter = struct { list: bool, position: ?usize, offset: usize };

pub fn reads(allocator: std.mem.Allocator, backing: std.mem.Allocator, parsed: Indexed, bindings: []const Binding) std.mem.Allocator.Error![]Binding {
    var arena = std.heap.ArenaAllocator.init(backing);
    var buffer: [std.heap.page_size_min / 8]u8 = undefined;
    var scratch = std.heap.BufferFirstAllocator.init(&buffer, arena.allocator());

    defer arena.deinit();

    const positions = try select(@import("generated_rx_store_reads").executeValue, scratch.allocator(), parsed, bindings);
    const result = try allocator.alloc(Binding, positions.len);

    for (result, positions) |*binding, index| binding.* = bindings[@intCast(index)];

    return result;
}

pub fn setter(backing: std.mem.Allocator, parsed: Indexed, bindings: []const Binding) std.mem.Allocator.Error!Setter {
    var arena = std.heap.ArenaAllocator.init(backing);
    var buffer: [std.heap.page_size_min / 8]u8 = undefined;
    var scratch = std.heap.BufferFirstAllocator.init(&buffer, arena.allocator());

    defer arena.deinit();

    const selected = try select(@import("generated_rx_store_setter").executeValue, scratch.allocator(), parsed, bindings);

    return .{ .list = selected.list, .position = if (selected.position) |index| @intCast(index) else null, .offset = @intCast(selected.offset) };
}

fn select(comptime rule: anytype, allocator: std.mem.Allocator, parsed: Indexed, bindings: []const Binding) std.mem.Allocator.Error!@typeInfo(@typeInfo(@TypeOf(rule)).@"fn".return_type.?).error_union.payload {
    const names = try allocator.alloc([]const u8, bindings.len);

    for (names, bindings) |*name, binding| name.* = binding.name;

    const view: []const []const u8 = names;

    return zx.columns.invoke(rule, allocator, &.{ .source = parsed.source, .tree = parsed.output.expressions, .root = parsed.output.result, .names = view }) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => unreachable,
    };
}
