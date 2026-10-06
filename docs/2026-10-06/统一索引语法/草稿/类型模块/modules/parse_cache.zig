const std = @import("std");
const parser = @import("../frontend/parse.zig");
const Self = @This();
pub const ModuleResult = parser.ModuleResult;
pub const indexed_enabled = @import("../frontend/module_result.zig").indexed_enabled;

const Entry = struct { digest: [32]u8, result: ModuleResult };

allocator: std.mem.Allocator,
entries: std.StringHashMapUnmanaged(*Entry) = .empty,
parsed: usize = 0,
reused: usize = 0,
pub fn deinit(self: *Self) void {
    var entries = self.entries.iterator();

    while (entries.next()) |item| {
        item.value_ptr.*.result.deinit();
        self.allocator.destroy(item.value_ptr.*);
        self.allocator.free(item.key_ptr.*);
    }

    self.entries.deinit(self.allocator);

    self.* = undefined;
}

pub fn get(self: *Self, source: []const u8, path: []const u8) std.mem.Allocator.Error!*const parser.Result {
    const entry = try self.getEntry(true, source, path);

    return &entry.result.native;
}

pub fn getModule(self: *Self, source: []const u8, path: []const u8) std.mem.Allocator.Error!*const ModuleResult {
    const entry = try self.getEntry(false, source, path);

    return &entry.result;
}

fn getEntry(self: *Self, comptime native: bool, source: []const u8, path: []const u8) std.mem.Allocator.Error!*Entry {
    var digest: [32]u8 = undefined;

    std.crypto.hash.sha2.Sha256.hash(source, &digest, .{});

    if (self.entries.get(path)) |entry| {
        if (std.mem.eql(u8, &entry.digest, &digest)) {
            if (native and entry.result == .indexed) {
                const result = try parser.parse(self.allocator, source, path);

                entry.result.deinit();

                entry.result = .{ .native = result };
                self.parsed += 1;
            } else self.reused += 1;

            return entry;
        }

        const result = if (native) ModuleResult{ .native = try parser.parse(self.allocator, source, path) } else try parser.parseModule(self.allocator, source, path);

        entry.result.deinit();

        entry.* = .{ .digest = digest, .result = result };
        self.parsed += 1;

        return entry;
    }

    const key = try self.allocator.dupe(u8, path);

    errdefer self.allocator.free(key);

    const entry = try self.allocator.create(Entry);

    errdefer self.allocator.destroy(entry);

    entry.* = .{ .digest = digest, .result = if (native) .{ .native = try parser.parse(self.allocator, source, path) } else try parser.parseModule(self.allocator, source, path) };

    errdefer entry.result.deinit();

    try self.entries.put(self.allocator, key, entry);

    self.parsed += 1;

    return entry;
}
