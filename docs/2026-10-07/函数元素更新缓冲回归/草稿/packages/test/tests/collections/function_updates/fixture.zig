const std = @import("std");
const compiler = @import("compiler");

pub fn sources(mode: []const u8) ![4]compiler.project.Source {
    const step = inline for (.{ "flat", "branch", "chain", "captured", "duplicate", "fallback", "mixed" }) |name| {
        if (std.mem.eql(u8, mode, name)) break if (comptime std.mem.eql(u8, name, "fallback")) @embedFile("fixtures/flat.zx") else @embedFile("fixtures/" ++ name ++ ".zx");
    } else return error.InvalidMode;

    const main = if (std.mem.eql(u8, mode, "mixed")) @embedFile("fixtures/mixed_main.zx") else if (std.mem.eql(u8, mode, "captured")) @embedFile("fixtures/captured_main.zx") else if (std.mem.eql(u8, mode, "duplicate")) @embedFile("fixtures/duplicate_main.zx") else if (std.mem.eql(u8, mode, "fallback")) @embedFile("fixtures/fallback_main.zx") else @embedFile("fixtures/plain_main.zx");

    return .{
        .{ .path = "main.zx", .source = main },
        .{ .path = "types.zx", .source = @embedFile("fixtures/types.zx") },
        .{ .path = "step.zx", .source = step },
        .{ .path = "flat.zx", .source = @embedFile("fixtures/flat.zx") },
    };
}
