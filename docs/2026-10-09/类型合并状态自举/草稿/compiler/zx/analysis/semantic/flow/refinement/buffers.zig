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

pub const arguments = @import("../../buffers.zig").arguments;
