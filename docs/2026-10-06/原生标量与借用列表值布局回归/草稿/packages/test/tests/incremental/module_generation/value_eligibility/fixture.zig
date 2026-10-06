const std = @import("std");
pub const compiler = @import("compiler");
pub const Mode = enum { pure, changed, native, native_object };

pub fn analyze(mode: Mode) !compiler.AnalysisResult {
    const prefix = "import native from \"zig:predicate\"\n export type Input = u64\n export type Output = bool\n export default function (in: Input): Output { return ";

    const predicate = switch (mode) {
        .pure => prefix ++ "in > 0 }",
        .changed => prefix ++ "in > 1 }",
        .native => prefix ++ "native.check(in) }",
        .native_object => prefix ++ "native.checkObject({ value: in }) }",
    };

    var result = try compiler.project.analyze(std.testing.allocator, &.{
        .{ .path = "main.zx", .source = @embedFile("main.zx") },
        .{ .path = "step.zx", .source = @embedFile("step.zx") },
        .{ .path = "predicate.zx", .source = predicate },
    }, .{
        .entry = "main.zx",
        .root_dir = "/project",
        .native_interfaces = &.{.{ .specifier = "zig:predicate", .path = "predicate.d.zx", .source = "export declare function check(in: u64): bool\nexport declare function checkObject(in: { value: u64 }): bool\n", .module = "predicate" }},
    });

    errdefer result.deinit();

    if (result.value == .diagnostic) std.debug.print("{t}: {s}\n", .{ result.value.diagnostic.code, result.value.diagnostic.message });
    try std.testing.expect(result.value == .ir);

    return result;
}
