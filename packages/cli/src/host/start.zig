const std = @import("std");

extern fn zxc_host_main(minimal: *const std.process.Init.Minimal) callconv(.c) u8;

const identity = @import("cache_identity");

comptime {
    // A platform link defines the identity in an object of its own instead.
    if (@hasDecl(identity, "digest")) @export(&identity.digest, .{ .name = "zxc_cache_identity" });
}

pub fn main(minimal: std.process.Init.Minimal) u8 {
    return zxc_host_main(&minimal);
}
