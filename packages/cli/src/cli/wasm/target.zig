const std = @import("std");

pub fn freestanding(target: ?[]const u8) !bool {
    const query = try std.Target.Query.parse(.{ .arch_os_abi = target orelse return false });

    return query.cpu_arch == .wasm32 and query.os_tag == .freestanding;
}

pub fn runner(stateful: bool) []const u8 {
    return if (stateful)
        "const stateful = true;\n" ++ @embedFile("runner.zig") ++ "\n" ++ @embedFile("scalar.zig")

    else
        "const stateful = false;\n" ++ @embedFile("runner.zig") ++ "\n" ++ @embedFile("scalar.zig");
}
