const std = @import("std");
const checker = @import("checker");

export fn instantiate() void {
    std.mem.doNotOptimizeAway(&checker.programPure);
    std.mem.doNotOptimizeAway(&checker.functions);
}
