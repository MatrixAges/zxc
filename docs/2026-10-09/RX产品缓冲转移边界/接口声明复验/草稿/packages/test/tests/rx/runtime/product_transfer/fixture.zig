const std = @import("std");
const compiler = @import("compiler");
pub const modes = @import("catalog.zig").modes;
pub const slots = @import("catalog.zig").slots;

pub fn entry(mode: []const u8) ![]const u8 {
    inline for (.{ "nested", "retained_target", "retained_parent", "duplicate" }) |name| {
        if (std.mem.eql(u8, mode, name)) return @embedFile("fixtures/entries/" ++ name ++ ".rx");
    }

    for (modes) |name| if (std.mem.eql(u8, mode, name)) return @embedFile("fixtures/entries/object.rx");

    return error.InvalidMode;
}

pub fn sources(mode: []const u8) ![3]compiler.project.Source {
    const factory = inline for (.{ "nested", "shared", "borrowed", "branch" }) |name| {
        if (std.mem.eql(u8, mode, name)) break @embedFile("fixtures/factories/" ++ name ++ ".zx");
    } else @embedFile("fixtures/factories/independent.zx");

    const step = if (std.mem.eql(u8, mode, "nested")) @embedFile("fixtures/steps/nested.zx") else if (std.mem.eql(u8, mode, "growth")) @embedFile("fixtures/steps/growth.zx") else @embedFile("fixtures/steps/columns.zx");

    return .{
        .{ .path = "model.zx", .source = @embedFile("fixtures/model.zx") },
        .{ .path = "create.zx", .source = factory },
        .{ .path = "patch.zx", .source = step },
    };
}
