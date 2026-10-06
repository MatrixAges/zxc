const std = @import("std");
const compiler = @import("compiler");
pub const source = "export type Input = i64\n\nexport type Output = i64\n\nexport default function (in: Input): Output {\n  return )\n}\n";
pub const repaired = "export type Input = i64\n\nexport type Output = i64\n\nexport default function (in: Input): Output {\n  return in\n}\n";
pub const options: compiler.project.Options = .{ .entry = "main.zx", .root_dir = "/project" };

pub fn check(issue: compiler.Diagnostic, source_index: ?usize) !void {
    try std.testing.expectEqual(.syntax, issue.code);
    try std.testing.expectEqual(@as(usize, 106), issue.span.start);
    try std.testing.expectEqual(@as(usize, 107), issue.span.end);
    try std.testing.expectEqual(source_index, issue.source_index);
    try std.testing.expectEqualStrings("expected an identifier", issue.message);
}
