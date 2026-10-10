const std = @import("std");
const f = @import("fixture.zig");

pub fn decode(allocator: std.mem.Allocator, analysis: f.compiler.AnalysisResult, linked: f.artifact.linker.Result) !f.compiler.library.Result {
    var view = analysis;
    view.value = .{ .ir = linked.program };
    view.nominal_types = linked.nominal_types;
    var published = try f.compiler.library.link(std.heap.page_allocator, &.{.{ .name = "run", .analysis = &view }});

    defer published.deinit();

    const bytes = try f.compiler.library.codec.encode(std.heap.page_allocator, &published);

    defer std.heap.page_allocator.free(bytes);

    const restored = try f.compiler.library.codec.decode(allocator, bytes);

    @memset(bytes, 0xdd);

    return restored;
}

pub fn consume(allocator: std.mem.Allocator, decoded: *const f.compiler.library.Result) !f.compiler.AnalysisResult {
    var result = try f.compiler.analyzeProject(allocator, &.{.{
        .path = "consumer.zx",
        .source = "import run from \"dependency\"\n\nimport type { SharedInput, SharedOutput } from \"./types\"\n\nexport type Input = SharedInput\n\nexport type Output = SharedOutput\n\nexport default function (in: Input): Output {\n    return run(in)\n}\n",
    }, .{
        .path = "types.zx",
        .source = "import type { Input, Output } from \"dependency\"\n\nexport type SharedInput = Input\n\nexport type SharedOutput = Output\n",
    }}, .{
        .entry = "consumer.zx", .root_dir = "/consumer",
        .packages = &.{.{ .specifier = "dependency", .compiled = .{ .instance = "plan@1", .artifact = "plan.zxlib", .name = "run" } }},
        .compiled_libraries = &.{.{ .instance = "plan@1", .artifact = "plan.zxlib", .program = decoded.program, .exports = decoded.exports, .nominal_types = decoded.nominal_types }},
    });

    errdefer result.deinit();

    if (result.value == .diagnostic) std.debug.print("consumer diagnostic {t}: {s}\n", .{ result.value.diagnostic.code, result.value.diagnostic.message });
    try std.testing.expect(result.value == .ir);
    try std.testing.expectEqual(null, try f.compiler.validateIr(allocator, result.value.ir));

    return result;
}
