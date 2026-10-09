const std = @import("std");
const Self = @This();

facts: struct {
    nonnull: Buffer(u32) = .{},
    capture_errors: Buffer(u32) = .{},
    capture_results: Buffer(u32) = .{},
} = .{},
conditions: Buffer(u64) = .{},
truths: Buffer(bool) = .{},
fn Buffer(comptime Element: type) type {
    return struct {
        list: std.ArrayList(Element) = .empty,
        started: bool = false,
    };
}

pub fn deinit(self: *Self, allocator: std.mem.Allocator) void {
    self.facts.nonnull.list.deinit(allocator);
    self.facts.capture_errors.list.deinit(allocator);
    self.facts.capture_results.list.deinit(allocator);
    self.conditions.list.deinit(allocator);
    self.truths.list.deinit(allocator);
}

pub fn arguments(comptime generated: type, storage: anytype, comptime input_field: []const u8) @typeInfo(@TypeOf(generated.executeBuffered)).@"fn".param_types[2].? {
    const Target = @typeInfo(@TypeOf(generated.executeBuffered)).@"fn".param_types[2].?;

    if (comptime generated.buffer_lanes.len != columnCount(@TypeOf(storage.*))) @compileError("State storage requires one reusable lane per column");

    var result: Target = std.mem.zeroes(Target);

    inline for (generated.buffer_lanes) |lane| {
        if (comptime lane.input.len != lane.output.len + 1 or !std.mem.eql(u8, lane.input[0], input_field)) @compileError("State buffer input path mismatch");

        inline for (lane.output, 0..) |name, index| {
            if (comptime !std.mem.eql(u8, lane.input[index + 1], name)) @compileError("State buffers cannot exchange column ownership");
        }

        @field(result, lane.slot) = link(@FieldType(Target, lane.slot), storage, lane.output, 0);
    }

    return result;
}

fn link(comptime Slot: type, storage: anytype, comptime path: anytype, comptime index: usize) Slot {
    if (index == path.len) return .{ .buffer = &storage.list, .started = &storage.started };

    return link(Slot, &@field(storage.*, path[index]), path, index + 1);
}

fn columnCount(comptime Value: type) usize {
    if (@hasField(Value, "list")) return 1;

    var count: usize = 0;

    for (@typeInfo(Value).@"struct".field_names) |name| count += columnCount(@FieldType(Value, name));

    return count;
}
