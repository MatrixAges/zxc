const std = @import("std");
const Trace = @import("trace.zig");
const Self = @This();
const Error = std.mem.Allocator.Error;

const Entry = struct {
    output: []const u32,
    scanned: usize = 0,
    inputs: std.ArrayList([]const u32) = .empty,
};

const Context = struct {
    pub fn hash(_: @This(), path: []const u32) u64 {
        return std.hash.Wyhash.hash(0, std.mem.sliceAsBytes(path));
    }

    pub fn eql(_: @This(), left: []const u32, right: []const u32) bool {
        return std.mem.eql(u32, left, right);
    }
};

entries: std.HashMapUnmanaged([]const u32, *Entry, Context, std.hash_map.default_max_load_percentage) = .empty,
pub fn iterate(self: *Self, trace: *Trace, output: []const u32) Error!Iterator {
    if (self.entries.get(output)) |entry| return .{ .trace = trace, .entry = entry };

    const entry = try trace.allocator.create(Entry);

    entry.* = .{ .output = try trace.allocator.dupe(u32, output) };

    try self.entries.put(trace.allocator, entry.output, entry);

    return .{ .trace = trace, .entry = entry };
}

pub const Iterator = struct {
    trace: *Trace,
    entry: *Entry,
    position: usize = 0,
    pub fn next(self: *Iterator) Error!?[]const u32 {
        const inputs = try self.trace.inputPaths();

        while (true) {
            if (self.position < self.entry.inputs.items.len) {
                const input = self.entry.inputs.items[self.position];

                self.position += 1;

                return input;
            }

            if (self.entry.scanned == inputs.len) return null;

            const input = inputs[self.entry.scanned];

            const dependent = for (self.trace.results.items) |result| {
                if (try @import("may.zig").contains(self.trace, result, self.entry.output, input)) break true;
            } else false;

            if (dependent) try self.entry.inputs.append(self.trace.allocator, input);

            self.entry.scanned += 1;

            if (self.entry.scanned == inputs.len) self.trace.queries.clear();
        }
    }
};
