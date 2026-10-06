const std = @import("std");
pub const compiler = @import("compiler");
pub const Mode = enum { push, changed, reverse };

pub fn analyze(mode: Mode) !compiler.AnalysisResult {
    const prefix = "export type State = { values: u64[], count: u64 }\n export type Input = { state: State, item: u64 }\n export type Output = State\n export default function (in: Input): Output { return {count: in.state.count + 1, values: in.state.values.";
    const suffix = "[0]} }";

    const leaf = switch (mode) {
        .push => prefix ++ "push(in.item)" ++ suffix,
        .changed => prefix ++ "push(in.item + 1)" ++ suffix,
        .reverse => prefix ++ "reverse()" ++ suffix,
    };

    var result = try compiler.project.analyze(std.testing.allocator, &.{
        .{ .path = "main.zx", .source = @embedFile("main.zx") },
        .{ .path = "step.zx", .source = @embedFile("step.zx") },
        .{ .path = "leaf.zx", .source = leaf },
    }, .{ .entry = "main.zx", .root_dir = "/project" });

    errdefer result.deinit();

    if (result.value == .diagnostic) std.debug.print("{t}: {s}\n", .{ result.value.diagnostic.code, result.value.diagnostic.message });
    try std.testing.expect(result.value == .ir);

    return result;
}
