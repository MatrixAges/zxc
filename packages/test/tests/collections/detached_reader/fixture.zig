const std = @import("std");
const compiler = @import("compiler");

pub fn sources(mode: []const u8) ![4]compiler.project.Source {
    const step = inline for (.{ "object", "tuple", "optional", "projection", "nested", "concat", "reference", "reverse" }) |name| {
        if (std.mem.eql(u8, mode, name)) break @embedFile("fixtures/" ++ name ++ "_step.zx");
    } else return error.InvalidMode;

    const read = inline for (.{ "object", "tuple", "optional", "projection", "nested", "concat", "reference", "reverse" }) |name| {
        if (std.mem.eql(u8, mode, name)) break @embedFile("fixtures/" ++ name ++ "_read.zx");
    } else return error.InvalidMode;

    return .{
        .{ .path = "main.zx", .source = @embedFile("fixtures/main.zx") },
        .{ .path = "model.zx", .source = @embedFile("fixtures/model.zx") },
        .{ .path = "step.zx", .source = step },
        .{ .path = "read.zx", .source = read },
    };
}
