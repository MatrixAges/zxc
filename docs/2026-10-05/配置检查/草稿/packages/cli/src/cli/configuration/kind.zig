const std = @import("std");
pub const Kind = enum { manifest, index, lock };

pub fn infer(path: []const u8) ?Kind {
    const name = std.fs.path.basename(path);

    if (std.mem.eql(u8, name, "pkg.yaml")) return .manifest;
    if (std.mem.eql(u8, name, "pkg.lock.json")) return .lock;

    return null;
}

pub fn maximumBytes(kind: Kind) usize {
    return switch (kind) {
        .manifest => 4 * 1024 * 1024,
        .index => 16 * 1024 * 1024,
        .lock => 32 * 1024 * 1024,
    };
}
