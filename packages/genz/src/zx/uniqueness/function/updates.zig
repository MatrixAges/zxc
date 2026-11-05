const std = @import("std");
const Level = @import("../level.zig").Level;
const merging = @import("generated_uniqueness_function_updates");

pub fn merge(rows: [][]Level, row: u32, first: u32, levels: []const Level, joining: bool) usize {
    comptime {
        std.debug.assert(@sizeOf(Level) == @sizeOf(u8));
        std.debug.assert(@alignOf(Level) == @alignOf(u8));
    }

    const Parameter = @typeInfo(@TypeOf(merging.executeValue)).@"fn".param_types[1].?;
    const indirect = @typeInfo(Parameter) == .pointer;
    const Input = if (indirect) std.meta.Child(Parameter) else Parameter;

    const input: Input = .{
        .rows = @ptrCast(&rows),
        .row = row,
        .first = first,
        .levels = std.mem.sliceAsBytes(levels),
        .joining = joining,
    };

    var memory = std.heap.FixedBufferAllocator.init(&.{});

    return @intCast(merging.executeValue(memory.allocator(), if (indirect) &input else input) catch |err| {
        std.debug.panic("summary merge failed: {s}", .{@errorName(err)});
    });
}
