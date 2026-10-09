const std = @import("std");
const build = @import("reduce_build");

test "reduce trace build registration compiles against Zig Build APIs" {
    std.mem.doNotOptimizeAway(&build.add);
}
