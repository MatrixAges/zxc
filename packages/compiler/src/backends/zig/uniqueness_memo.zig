const std = @import("std");
const Cache = @import("cache.zig");
const Memo = @import("genz").zx.function_analysis.Uniqueness.Memo;

/// The uniqueness body analyses of the last build, kept as one record in the generation cache's storage. The compiler
/// digest in the record header ties it to the generator that wrote it, so a changed generator starts from nothing.
const key = digest: {
    @setEvalBranchQuota(10_000);

    var value: [32]u8 = undefined;

    std.crypto.hash.sha2.Sha256.hash("zxc.uniqueness.memo", &value, .{});

    break :digest value;
};

/// A memo seeded from the last build, or null when the cache does not persist.
pub fn load(allocator: std.mem.Allocator, cache: ?*Cache) std.mem.Allocator.Error!?Memo {
    const storage = (cache orelse return null).storage orelse return null;
    var memo = Memo.init(allocator, true);

    errdefer memo.deinit();

    const bytes = storage.read(allocator, key) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => null,
    } orelse return memo;

    defer allocator.free(bytes);

    try memo.load(bytes);

    return memo;
}

/// The memo a cache keeps across generations, read from storage the first time; null when the cache does not persist.
pub fn kept(cache: *Cache) std.mem.Allocator.Error!?*Memo {
    if (cache.memo == null) cache.memo = try load(cache.allocator, cache);

    return if (cache.memo) |*memo| memo else null;
}

/// Keeps the analyses this build used for the next one; a failed write only costs that build its reuse.
pub fn save(allocator: std.mem.Allocator, cache: ?*Cache, memo: *const Memo) std.mem.Allocator.Error!void {
    const storage = (cache orelse return).storage orelse return;

    if (!memo.stale()) return;

    const bytes = try memo.save(allocator);

    defer allocator.free(bytes);

    _ = storage.write(allocator, key, bytes) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => {},
    };
}
