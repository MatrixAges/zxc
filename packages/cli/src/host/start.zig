const std = @import("std");

extern fn zxc_host_main(minimal: *const std.process.Init.Minimal) callconv(.c) u8;

export const zxc_cache_identity: [32]u8 = @import("cache_identity").digest;

pub fn main(minimal: std.process.Init.Minimal) u8 {
    return zxc_host_main(&minimal);
}
