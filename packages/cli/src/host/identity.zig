//! The compiler identity that names persistent caches. It covers every compiler source, so a partitioned
//! build defines it in the executable's entry unit: editing compiler sources then relinks the host object
//! instead of recompiling it.
const embedded = @import("cache_identity_embedded");

pub fn digest() [32]u8 {
    if (@hasDecl(embedded, "digest")) return embedded.digest;

    return @extern(*const [32]u8, .{ .name = "zxc_cache_identity" }).*;
}
