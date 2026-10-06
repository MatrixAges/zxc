const std = @import("std");
const compiler = @import("compiler");

pub fn sources(mode: []const u8) ![6]compiler.project.Source {
    const main = inline for (.{ "simple", "branch", "switch", "chain", "bounds", "effects", "nested", "escaping", "changed" }) |name| {
        if (std.mem.eql(u8, mode, name)) break @embedFile("fixtures/" ++ name ++ ".zx");
    } else return error.InvalidMode;

    const step = inline for (.{ "simple", "branch", "switch", "chain", "bounds", "effects", "nested", "escaping", "changed" }) |name| {
        if (std.mem.eql(u8, mode, name)) break @embedFile("fixtures/" ++ name ++ "_step.zx");
    } else return error.InvalidMode;

    return .{
        .{ .path = "main.zx", .source = main },
        .{ .path = "step.zx", .source = step },
        .{ .path = "condition.zx", .source = @embedFile("fixtures/condition.zx") },
        .{ .path = "model.zx", .source = @embedFile("fixtures/model.zx") },
        .{ .path = "value.zx", .source = @embedFile("fixtures/value.zx") },
        .{ .path = "inner_step.zx", .source = @embedFile("fixtures/inner_step.zx") },
    };
}
