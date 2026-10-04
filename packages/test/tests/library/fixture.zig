const std = @import("std");
pub const compiler = @import("compiler");
pub const function = "export type Input = u64\nexport type Output = u64\nexport default function (in: Input): Output { return in + 1 }\n";
pub const declaration = "export enum Mode { First, Second }\nexport type Maybe = Mode?\nexport type Items = Mode[]\n";

pub fn analyze(path: []const u8, source: []const u8) !compiler.AnalysisResult {
    var result = try compiler.project.analyze(std.testing.allocator, &.{.{ .path = path, .source = source }}, .{ .entry = path, .root_dir = "/project" });
    errdefer result.deinit();
    try std.testing.expect(result.value == .ir);

    return result;
}

pub fn exportedType(result: *const compiler.library.Result, index: usize, name: []const u8) !usize {
    for (result.exports[index].types) |item| {
        if (std.mem.eql(u8, item.name, name)) return @intFromEnum(item.type_id);
    }

    return error.MissingExport;
}
