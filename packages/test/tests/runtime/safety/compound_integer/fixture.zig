const std = @import("std");
const compiler = @import("compiler");

pub fn sources(mode: []const u8) ![1]compiler.project.Source {
    const source: []const u8 = search: inline for (.{ "u8", "u16", "u32", "u64", "i32", "i64" }) |scalar| {
        inline for (.{ "scalar", "nested", "list" }) |target| {
            if (std.mem.eql(u8, mode, scalar ++ "/" ++ target)) break :search @embedFile(scalar ++ "/" ++ target ++ ".zx");
        }
    } else return error.InvalidMode;

    return .{.{ .path = "main.zx", .source = source }};
}
