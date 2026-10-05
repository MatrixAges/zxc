const std = @import("std");
const compiler = @import("compiler");
pub const helper = "export type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  return in + 1\n}\n";
pub const identity = "export type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  return in\n}\n";

pub fn main(allocator: std.mem.Allocator, reference: []const u8) ![]const u8 {
    return std.fmt.allocPrint(allocator, "import helper from \"{s}\"\n\n{s}", .{ reference, identity });
}

pub fn expectFailure(sources: []const compiler.project.Source, options: compiler.project.Options, message: []const u8) !void {
    var result = try compiler.project.analyze(std.testing.allocator, sources, options);

    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);
    try std.testing.expectEqual(.module, result.value.diagnostic.code);
    try std.testing.expectEqualStrings(message, result.value.diagnostic.message);
}
