const std = @import("std");
const cache_key = @import("cache_key.zig");
const rules = @import("partition_rules");
const partition_width = std.fmt.count("{d}", .{std.math.maxInt(u32)});
const Encoded = @TypeOf(std.fmt.bytesToHex(@as(cache_key.Digest, @splat(0)), .lower));

pub const Keys = struct {
    hex: []const []const u8,
    pub fn init(allocator: std.mem.Allocator, digests: []const cache_key.Digest) std.mem.Allocator.Error!Keys {
        const encoded = try allocator.alloc(Encoded, digests.len);
        const hex = try allocator.alloc([]const u8, digests.len);

        for (digests, encoded, hex) |digest, *text, *view| {
            text.* = std.fmt.bytesToHex(digest, .lower);
            view.* = text;
        }

        return .{ .hex = hex };
    }
    pub fn pending(self: Keys, allocator: std.mem.Allocator, previous: []const u8, present: []const bool) ![]const u32 {
        return rules.partition_cache_check.executeValue(allocator, &.{
            .previous = previous,
            .digests = self.hex,
            .present = present,
        });
    }
    pub fn write(self: Keys, io: std.Io, allocator: std.mem.Allocator, path: []const u8, valid: []const bool) !void {
        const numbers = try allocator.alloc([partition_width]u8, self.hex.len);
        const prefixes = try allocator.alloc([]const u8, self.hex.len);

        for (numbers, prefixes, 0..) |*number, *prefix, index| {
            prefix.* = std.fmt.bufPrint(number, "{d}", .{@as(u32, @intCast(index))}) catch unreachable;
        }

        var text = std.Io.Writer.Allocating.init(allocator);

        try rules.partition_cache_publish.executeValue(allocator, &.{
            .out = @ptrCast(&text.writer),
            .prefixes = prefixes,
            .digests = self.hex,
            .valid = valid,
        });

        var file = try std.Io.Dir.cwd().createFileAtomic(io, path, .{ .replace = true });

        defer file.deinit(io);

        try file.file.writeStreamingAll(io, text.written());
        try file.replace(io);
    }
};
