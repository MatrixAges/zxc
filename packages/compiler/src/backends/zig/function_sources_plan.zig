const std = @import("std");
const Cache = @import("cache.zig");

pub const Plan = struct {
    reused: []const u64,
    pending: []const u64,
    offsets: []const u64,
    size: u64,
};

pub fn create(allocator: std.mem.Allocator, fetched: []const Cache.Fetched) std.mem.Allocator.Error!Plan {
    if (comptime !@import("parser_options").generated_parser) return @import("function_sources_seed.zig").create(allocator, fetched);

    const generated = @import("generated_function_sources_plan");
    const Input = @typeInfo(@TypeOf(generated.executeValue)).@"fn".param_types[1].?;
    const Fetch = std.meta.Child(Input);
    const rows = try allocator.alloc(Fetch, fetched.len);

    for (fetched, rows) |value, *row| row.* = .{
        .kind = switch (value) {
            inline else => |_, tag| @field(@FieldType(Fetch, "kind"), @tagName(tag)),
        },
        .length = switch (value) {
            .held, .stored => |source| source.len,
            else => 0,
        },
    };

    const output = generated.executeValue(allocator, rows) catch |err| switch (err) {
        error.OutOfMemory, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    return .{ .reused = output.reused, .pending = output.pending, .offsets = output.offsets, .size = output.size };
}
