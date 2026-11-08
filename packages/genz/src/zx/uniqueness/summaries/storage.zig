const std = @import("std");
const ir = @import("zx").ir;
const Level = @import("../level.zig").Level;
const Summaries = @import("../summaries.zig");
const Basis = @import("../basis.zig");
const creating = @import("generated_uniqueness_summaries_create");
const effects = @import("generated_uniqueness_effects");
const lifecycle = @import("lifecycle.zig");
pub const Model = @typeInfo(@typeInfo(@TypeOf(creating.executeValue)).@"fn".return_type.?).error_union.payload;

pub fn create(allocator: std.mem.Allocator, program: ir.Program, basis: *const Basis) std.mem.Allocator.Error!Summaries {
    const Parameter = @typeInfo(@TypeOf(creating.executeValue)).@"fn".param_types[1].?;
    const indirect = @typeInfo(Parameter) == .pointer;
    const Input = if (indirect) std.meta.Child(Parameter) else Parameter;

    const input: Input = .{
        .counts = basis.slots.counts,
        .input_types = program.functions.input_types,
        .output_types = program.functions.output_types,
    };

    const storage = creating.executeValue(allocator, if (indirect) &input else input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => std.debug.panic("summary storage failed: {s}", .{@errorName(err)}),
    };

    const held = effects.executeIn(allocator, &.{ .held = basis.flow.held, .written = basis.flow.written, .return_only = basis.return_only }) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    const result = Summaries{
        .input = try rows(allocator, storage.input, storage.layout.input_first),
        .output = try rows(allocator, storage.output, storage.layout.output_first),
        .inputs = try rows(allocator, storage.inputs, storage.layout.input_first),
        .outputs = try rows(allocator, storage.outputs, storage.layout.output_first),
        .held = basis.flow.held,
        .written = basis.flow.written,
        .return_only = basis.return_only,
        .effects = held,
        .storage = storage,
    };

    lifecycle.apply(result, .Initialize, program.functions.native_modules, &.{});

    return result;
}

fn rows(allocator: std.mem.Allocator, values: []const u8, first: []const u64) std.mem.Allocator.Error![][]Level {
    comptime {
        std.debug.assert(@sizeOf(Level) == @sizeOf(u8));
        std.debug.assert(@alignOf(Level) == @alignOf(u8));
    }

    const result = try allocator.alloc([]Level, first.len);
    const cells: []Level = @ptrCast(@constCast(values));

    for (result, 0..) |*row, index| {
        const end = if (index + 1 < first.len) first[index + 1] else cells.len;

        row.* = cells[@intCast(first[index])..@intCast(end)];
    }

    return result;
}
