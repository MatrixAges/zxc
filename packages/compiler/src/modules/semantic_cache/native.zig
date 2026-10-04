const std = @import("std");
const zx = @import("zx");
const Native = @import("../interface.zig").Native;
const Loaded = @import("../native.zig");
const restoring = @import("native_restore.zig");
const entries = @import("entries.zig");
const Self = @This();
pub const Current = restoring.Current;
pub const empty_context = [_]u8{0} ** 32;

allocator: std.mem.Allocator,
items: entries.Map = .empty,
analyzed: usize = 0,
reused: usize = 0,
pub fn deinit(self: *Self) void {
    entries.deinit(self.allocator, &self.items);

    self.* = undefined;
}

pub fn load(self: *Self, allocator: std.mem.Allocator, entry: Native, current: Current, reporter: *zx.Reporter, span: zx.Span) zx.Error!Loaded.Result {
    const fingerprint = digest(entry);

    if (entries.get(&self.items, entry.specifier, fingerprint, empty_context)) |artifact| {
        const restored: ?Loaded.Result = restoring.restore(allocator, artifact.*, entry, current) catch |err| retry: {
            if (err == error.OutOfMemory) return error.OutOfMemory;

            break :retry null;
        };

        if (restored) |result| {
            self.reused += 1;

            return result;
        }
    }

    self.analyzed += 1;

    var artifact = try @import("native_artifact.zig").create(self.allocator, entry, fingerprint, allocator, reporter, span);

    errdefer artifact.deinit();

    const restored = restoring.restore(allocator, artifact.value, entry, current) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return reporter.fail(.module, span, "native interface artifact could not be mapped into the project");
    };

    try entries.put(self.allocator, &self.items, artifact, empty_context);

    return restored;
}

fn digest(entry: Native) [32]u8 {
    var hash = std.crypto.hash.sha2.Sha256.init(.{});

    for ([_][]const u8{ "zxc.native.interface.v1", entry.specifier, entry.path, entry.source, entry.module }) |part| field(&hash, part);
    for (entry.namespace) |part| field(&hash, part);

    var result: [32]u8 = undefined;

    hash.final(&result);

    return result;
}

fn field(hash: *std.crypto.hash.sha2.Sha256, bytes: []const u8) void {
    var length: [8]u8 = undefined;

    std.mem.writeInt(u64, &length, @intCast(bytes.len), .little);
    hash.update(&length);
    hash.update(bytes);
}
