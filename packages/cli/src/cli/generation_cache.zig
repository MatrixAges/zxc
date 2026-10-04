const std = @import("std");
const Cache = @import("compiler").zig.GenerationCache;
const Options = @import("options.zig").Options;

pub fn init(io: std.Io, allocator: std.mem.Allocator, root: []const u8) std.mem.Allocator.Error!Cache {
    const identity = @import("cache_identity").digest;
    const directory = try std.fs.path.join(allocator, &.{ root, ".zxc", "cache", "zig", &std.fmt.bytesToHex(identity, .lower) });

    defer allocator.free(directory);

    return Cache.initPersistent(allocator, io, directory, identity);
}

pub fn report(cache: *const Cache, options: Options, writer: *std.Io.Writer) std.Io.Writer.Error!void {
    if (cache.last_io_error) |err| try writer.print("zxc generation cache IO: {s} ({d} errors)\n", .{ @errorName(err), cache.io_errors });
    if (!options.cache_stats) return;
    if (!options.cache) return writer.writeAll("zxc generation: disabled\n");
    try writer.print("zxc generation: generated={d} reused={d} loaded={d} written={d} discarded={d} io_errors={d}\n", .{ cache.generated, cache.reused, cache.loaded, cache.written, cache.discarded, cache.io_errors });
}
