const std = @import("std");
const zx = @import("zx");
const generated = @import("parser_options").generated_parser;
pub const Digest = [zx.Sha256.digest_length]u8;
pub const batch_size = 64;

pub const Hash = struct {
    state: std.Io.Writer.Hashing(zx.Sha256),
    pub fn init(buffer: []u8) Hash {
        return .{ .state = .init(buffer) };
    }

    pub fn finish(self: *Hash) Digest {
        self.state.writer.flush() catch unreachable;

        var result: Digest = undefined;

        self.state.hasher.final(&result);

        return result;
    }
    fn out(self: *Hash) *const anyopaque {
        return &self.state.writer;
    }
};

pub fn frame(hash: *Hash, generator: *const Digest, manifest: []const u8, texts: bool, modules: anytype, interfaces: anytype) void {
    if (comptime generated) {
        const rule = @import("generated_input_frame_fingerprint");
        var buffer: [batch_size][]const u8 = undefined;
        var digests: [batch_size][]const u8 = undefined;
        var empty = std.heap.FixedBufferAllocator.init(&.{});
        const first = @min(batch_size, modules.len);
        const selected = columns(&buffer, &digests, modules[0..first], texts);

        rule.executeValue(empty.allocator(), &.{
            .out = @ptrCast(hash.out()),
            .generator = generator,
            .manifest = manifest,
            .texts = texts,
            .paths = selected.paths,
            .digests = selected.digests,
        }) catch unreachable;

        var remaining = modules[first..];

        while (remaining.len != 0) {
            const count = @min(batch_size, remaining.len);
            const batch = columns(&buffer, &digests, remaining[0..count], texts);

            files(hash, batch.paths, batch.digests);

            remaining = remaining[count..];
        }

        var rest = interfaces;

        while (rest.len != 0) {
            const count = @min(batch_size, rest.len);

            for (rest[0..count], buffer[0..count]) |interface, *text| text.* = interface.source;

            files(hash, buffer[0..count], &.{});

            rest = rest[count..];
        }

        return;
    }

    hash.state.hasher.update(generator);
    field(&hash.state.hasher, if (texts) "frame" else "shape");
    field(&hash.state.hasher, manifest);

    for (modules) |*module| {
        field(&hash.state.hasher, module.path);
        if (texts) hash.state.hasher.update(&module.digest);
    }

    for (interfaces) |interface| field(&hash.state.hasher, interface.source);
}

const Columns = struct { paths: []const []const u8, digests: []const []const u8 };

fn columns(paths: *[batch_size][]const u8, digests: *[batch_size][]const u8, modules: anytype, texts: bool) Columns {
    for (modules, paths[0..modules.len], digests[0..modules.len]) |*module, *path, *digest| {
        path.* = module.path;

        if (texts) digest.* = &module.digest;
    }

    return .{ .paths = paths[0..modules.len], .digests = if (texts) digests[0..modules.len] else &.{} };
}

pub fn files(hash: *Hash, paths: []const []const u8, digests: []const []const u8) void {
    if (comptime generated) {
        const rule = @import("generated_input_file_fingerprint");
        var empty = std.heap.FixedBufferAllocator.init(&.{});

        rule.executeValue(empty.allocator(), .{ .out = @ptrCast(hash.out()), .paths = paths, .digests = digests }) catch unreachable;

        return;
    }

    for (paths, 0..) |path, index| {
        field(&hash.state.hasher, path);

        if (digests.len != 0) hash.state.hasher.update(digests[index]);
    }
}

pub fn output(hash: *Hash, digest: *const Digest, partitions: u32) void {
    if (comptime generated) {
        const rule = @import("generated_input_output_fingerprint");
        var empty = std.heap.FixedBufferAllocator.init(&.{});

        rule.executeValue(empty.allocator(), &.{ .out = @ptrCast(hash.out()), .frame = digest, .partitions = partitions }) catch unreachable;

        return;
    }

    field(&hash.state.hasher, "zxc.bootstrap.inputs.v2");
    hash.state.hasher.update(digest);
    integer(u32, &hash.state.hasher, partitions);
}

pub fn snapshot(generator: *const Digest, partitions: u32, directory: []const u8, manifest: []const u8) Digest {
    var buffer: [1024]u8 = undefined;
    var hash = Hash.init(&buffer);

    if (comptime generated) {
        const rule = @import("generated_input_snapshot_fingerprint");
        var empty = std.heap.FixedBufferAllocator.init(&.{});

        rule.executeValue(empty.allocator(), &.{ .out = @ptrCast(hash.out()), .generator = generator, .partitions = partitions, .directory = directory, .manifest = manifest }) catch unreachable;
    } else {
        hash.state.hasher.update(generator);
        integer(u32, &hash.state.hasher, partitions);
        field(&hash.state.hasher, directory);
        hash.state.hasher.update(manifest);
    }

    return hash.finish();
}

fn field(hash: *zx.Sha256, bytes: []const u8) void {
    integer(u64, hash, bytes.len);
    hash.update(bytes);
}

fn integer(comptime T: type, hash: *zx.Sha256, value: T) void {
    var encoded: [@sizeOf(T)]u8 = undefined;

    std.mem.writeInt(T, &encoded, value, .little);
    hash.update(&encoded);
}
