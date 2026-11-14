const std = @import("std");
const zx = @import("zx");
const Analysis = @import("../../analysis/analyze.zig");
const Cache = @import("../semantic_cache.zig");
const extract = @import("../artifact/extract.zig").validated;

pub const Context = struct {
    root: [32]u8 = undefined,
    dependency: ?[32]u8 = null,
    pub fn get(self: *Context, allocator: std.mem.Allocator, entry: bool, context: Analysis.Context) std.mem.Allocator.Error!*const [32]u8 {
        if (entry) {
            self.root = try Cache.contextDigest(allocator, context);

            return &self.root;
        }

        if (self.dependency == null) self.dependency = try Cache.contextDigest(allocator, .{});

        return &self.dependency.?;
    }
};

pub fn publish(allocator: std.mem.Allocator, cache: *Cache, result: *const Analysis.Result, records: []const usize, context: *const Context, entry: []const u8) std.mem.Allocator.Error!?zx.Diagnostic {
    if (records.len == 0) return null;

    var scratch = zx.Arena.init(allocator);

    defer scratch.deinit();

    for (records) |index| {
        const record = &result.modules[index];

        defer scratch.reset(std.math.maxInt(usize));

        var artifact = extract(cache.allocator, scratch.allocator(), result, record.*) catch |err| switch (err) {
            error.OutOfMemory => return error.OutOfMemory,
            error.MissingNominalOrigin => {
                cache.uncacheable += 1;

                continue;
            },
            error.InvalidAnalysis, error.InvalidModule, error.InvalidIr => return .{
                .code = .contract,
                .span = .{ .start = 0, .end = 0 },
                .message = "module artifact extraction requires valid project IR and module metadata",
            },
        };

        errdefer artifact.deinit();

        const digest = if (std.mem.eql(u8, record.path, entry)) &context.root else &context.dependency.?;

        try cache.put(artifact, digest.*);
    }

    return null;
}
