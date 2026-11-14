const std = @import("std");
const zx = @import("zx");
const Native = @import("../interface.zig").Native;
const Loaded = @import("../native.zig");
const restoring = @import("native_restore.zig");
const entries = @import("entries.zig");
const Self = @This();
pub const Current = restoring.Current;
pub const empty_context: [32]u8 = @splat(0);

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

    if (entries.find(&self.items, entry.key(), &fingerprint, &empty_context)) |cached| {
        const restored: ?Loaded.Result = restoring.restore(allocator, &cached.result.value, entry, current, cached.native_admitted) catch |err| retry: {
            if (err == error.OutOfMemory) return error.OutOfMemory;

            break :retry null;
        };

        if (restored) |result| {
            cached.native_admitted = true;
            self.reused += 1;

            return result;
        }
    }

    self.analyzed += 1;

    var artifact = try @import("native_artifact.zig").create(self.allocator, entry, fingerprint, allocator, reporter, span);

    errdefer artifact.deinit();

    const publication = try entries.prepare(self.allocator, &self.items, artifact.value.path);

    errdefer publication.cancel(self.allocator);

    const restored = restoring.restore(allocator, &artifact.value, entry, current, false) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;
        if (err == error.InvalidIr) return reporter.fail(.module, span, "native declarations produced invalid interface IR");

        return reporter.fail(.module, span, "native interface artifact could not be mapped into the project");
    };

    publication.commit(&self.items, .{ .result = artifact, .context_digest = empty_context, .native_admitted = true });

    return restored;
}

fn digest(entry: Native) [32]u8 {
    var hash: zx.Sha256 = undefined;
    const fields = [_][]const u8{ entry.key(), entry.specifier, entry.path, entry.source, entry.module };

    if (comptime @import("parser_options").generated_parser) {
        const generated = @import("generated_semantic_cache_native_fingerprint");
        const reference: zx.Sha256State = .{ .value = &hash };
        const input: std.meta.Child(generated.Input) = .{ .hash = @ptrCast(&reference), .fields = &fields, .namespace = entry.namespace };
        var empty = std.heap.FixedBufferAllocator.init(&.{});

        zx.columns.invoke(generated.executeValue, empty.allocator(), &input) catch unreachable;
    } else {
        hash = zx.Sha256.init(.{});

        field(&hash, "zxc.native.interface.v2");

        for (fields) |part| field(&hash, part);
        for (entry.namespace) |part| field(&hash, part);
    }

    var result: [32]u8 = undefined;

    hash.final(&result);

    return result;
}

fn field(hash: *@import("zx").Sha256, bytes: []const u8) void {
    var length: [8]u8 = undefined;

    std.mem.writeInt(u64, &length, @intCast(bytes.len), .little);
    hash.update(&length);
    hash.update(bytes);
}
