const std = @import("std");
const compiler = @import("compiler");

pub const main = "import helper from \"./helper.zx\"\n\nexport type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  return helper(in)\n}\n";
pub const helper = "export type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  return in + 1\n}\n";
pub const changed = "export type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  return in + 2\n}\n";
pub const invalid = "export type Input = \n";

pub fn run(allocator: std.mem.Allocator, cache: *compiler.project.ParseCache, source: []const u8) !compiler.AnalysisResult {
    return compiler.analyzeProjectWithCache(allocator, &.{
        .{ .path = "main.zx", .source = main },
        .{ .path = "helper.zx", .source = source },
    }, .{ .entry = "main.zx", .root_dir = "/project" }, cache);
}

pub fn check(result: compiler.AnalysisResult) !void {
    try std.testing.expect(result.value == .ir);
    try std.testing.expect(try compiler.validateIr(std.testing.allocator, result.value.ir) == null);
}

pub fn increment(result: compiler.AnalysisResult, expected: u64) !void {
    var count: usize = 0;

    for (result.value.ir.functions) |function| {
        for (function.expressions) |expression| {
            if (expression.value == .integer) {
                try std.testing.expectEqual(expected, expression.value.integer);
                count += 1;
            }
        }
    }

    try std.testing.expectEqual(@as(usize, 1), count);
}
