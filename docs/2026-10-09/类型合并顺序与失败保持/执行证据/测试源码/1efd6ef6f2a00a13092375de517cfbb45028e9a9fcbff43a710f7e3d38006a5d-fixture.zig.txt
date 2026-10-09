const std = @import("std");
const compiler = @import("compiler");
pub const main = "import helper from \"./helper\"\nimport { Mode } from \"./shared\"\nimport unused from \"./unused\"\n\nexport type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  return helper(in)\n}\n";
pub const helper = "import type { Count } from \"./shared\"\n\nexport type Input = Count\n\nexport type Output = Count\n\nexport default function (in: Input): Output {\n  return in + 1\n}\n";
pub const shared = "export enum Mode { First, Second }\n\nexport type Count = u64\n";
pub const unused = "export type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  return in\n}\n";
pub const detached = "export enum Hidden { Value }\n";

pub const sources = [_]compiler.project.Source{
    .{ .path = "main.zx", .source = main },
    .{ .path = "unreachable.zx", .source = detached },
    .{ .path = "unused.zx", .source = unused },
    .{ .path = "helper.zx", .source = helper },
    .{ .path = "shared.zx", .source = shared },
};

pub fn analyze(allocator: std.mem.Allocator) !compiler.AnalysisResult {
    return compiler.project.analyze(allocator, &sources, .{ .entry = "main.zx", .root_dir = "/project" });
}

pub fn check(result: compiler.AnalysisResult) !void {
    try std.testing.expect(result.value == .ir);
    try std.testing.expectEqual(@as(usize, 4), result.modules.len);

    for ([_][]const u8{ "/project/shared.zx", "/project/helper.zx", "/project/unused.zx", "/project/main.zx" }, result.modules) |expected, record| {
        try std.testing.expectEqualStrings(expected, record.path);
    }
}
