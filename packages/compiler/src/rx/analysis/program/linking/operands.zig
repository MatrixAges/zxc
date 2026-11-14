const std = @import("std");
const ir = @import("zx").ir;
const Builder = @import("../builder.zig");
const Mapping = @import("../mapping.zig");
const enabled = @import("rx_options").generated_graph;

pub fn expressions(mapping: *const Mapping, source: []const u32, target: []u32) Builder.Error!void {
    std.debug.assert(source.len == target.len);

    if (source.len == 0) return;

    if (comptime enabled) {
        const rule = @import("generated_rx_link_expression_operands");

        return invoke(rule, .{ .source = source, .mapping = mapping.expressions[0..mapping.available], .target = @ptrCast(&target) });
    }

    for (source, target) |id, *output| output.* = @backingInt(try mapping.seedId(@fromBackingInt(id)));
}

pub fn symbols(mapping: *const Mapping, source: []const u32, target: []u32) Builder.Error!void {
    std.debug.assert(source.len == target.len);

    if (source.len == 0) return;

    if (comptime enabled) {
        const rule = @import("generated_rx_link_symbol_operands");

        return invoke(rule, .{ .source = source, .symbols = &.{ .bindings = mapping.bindings, .locals_base = mapping.locals_base, .count = mapping.symbol_count }, .target = @ptrCast(&target) });
    }

    for (source, target) |id, *output| output.* = @backingInt(try mapping.seedSymbol(@fromBackingInt(id)));
}

pub fn optionalSymbols(mapping: *const Mapping, source: []const ?u32, target: []?u32) Builder.Error!void {
    std.debug.assert(source.len == target.len);

    if (source.len == 0) return;

    if (comptime enabled) {
        const rule = @import("generated_rx_link_optional_symbol_operands");

        return invoke(rule, .{ .source = source, .symbols = &.{ .bindings = mapping.bindings, .locals_base = mapping.locals_base, .count = mapping.symbol_count }, .target = @ptrCast(&target) });
    }

    for (source, target) |id, *output| output.* = if (id) |value| @backingInt(try mapping.seedSymbol(@fromBackingInt(value))) else null;
}

fn invoke(comptime rule: type, input: std.meta.Child(rule.Input)) Builder.Error!void {
    var empty = std.heap.FixedBufferAllocator.init(&.{});

    const valid = @import("zx").columns.invoke(rule.executeValue, empty.allocator(), &input) catch |err| switch (@as(anyerror, err)) {
        error.IndexOutOfBounds, error.IntegerOverflow => return error.InvalidModule,
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    if (!valid) return error.InvalidModule;
}
