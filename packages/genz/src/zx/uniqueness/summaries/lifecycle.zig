const std = @import("std");
const Summaries = @import("../summaries.zig");
const applying = @import("generated_uniqueness_summaries_lifecycle");
const Parameter = @typeInfo(@TypeOf(applying.executeValue)).@"fn".param_types[1].?;
const indirect = @typeInfo(Parameter) == .pointer;
const Input = if (indirect) std.meta.Child(Parameter) else Parameter;

pub const Mode = @FieldType(Input, "mode");

pub fn apply(summaries: Summaries, mode: Mode, native_modules: []const ?u32, known: []const bool) void {
    const input: Input = .{
        .mode = mode,
        .input = @ptrCast(&summaries.input),
        .output = @ptrCast(&summaries.output),
        .inputs = @ptrCast(&summaries.inputs),
        .outputs = @ptrCast(&summaries.outputs),
        .native_modules = native_modules,
        .known = known,
    };

    var memory = std.heap.FixedBufferAllocator.init(&.{});

    applying.executeValue(memory.allocator(), if (indirect) &input else input) catch |err| {
        std.debug.panic("summary lifecycle failed: {s}", .{@errorName(err)});
    };
}
