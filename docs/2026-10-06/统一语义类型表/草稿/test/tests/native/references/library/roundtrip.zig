const std = @import("std");
const f = @import("fixture.zig");
const compiler = f.compiler;

pub fn run(allocator: std.mem.Allocator, distinct: bool) !void {
    var value = try f.library(allocator);

    defer value.deinit();

    const bytes = try compiler.library.codec.encode(allocator, &value);

    defer allocator.free(bytes);

    var decoded = try compiler.library.codec.decode(allocator, bytes);

    defer decoded.deinit();

    var consumer = try f.consume(allocator, &decoded, .{ .distinct = distinct });

    defer consumer.deinit();

    try std.testing.expect(consumer.value == .ir);
    try f.inspect(allocator, consumer.value.ir, distinct);

    var published = try compiler.library.link(allocator, &.{.{ .name = "again", .analysis = &consumer }});

    defer published.deinit();

    const republished = try compiler.library.codec.encode(allocator, &published);

    defer allocator.free(republished);

    var restored = try compiler.library.codec.decode(allocator, republished);

    defer restored.deinit();

    try std.testing.expectEqual(@as(usize, if (distinct) 2 else 1), restored.nominal_types.count());
    try f.inspect(allocator, try restored.module(0), distinct);

    const source = "import run from \"again\"\n\nimport type { Contract } from \"./contract\"\n\nexport type Input = Contract\n\nexport type Output = Input\n\nexport default function (in: Input): Output {\n  return run(in)\n}\n";

    var final = try compiler.analyzeProject(allocator, &.{ .{ .path = "final.zx", .source = source }, .{ .path = "contract.zx", .source = "import type { Input } from \"again\"\n\nexport type Contract = Input\n" } }, .{
        .entry = "final.zx",
        .root_dir = "/final",
        .packages = &.{.{ .specifier = "again", .compiled = .{ .instance = "republished@1", .artifact = "again.zxlib", .name = "again" } }},
        .compiled_libraries = &.{.{ .instance = "republished@1", .artifact = "again.zxlib", .program = restored.program, .exports = restored.exports, .nominal_types = restored.nominal_types }},
    });

    defer final.deinit();

    if (final.value == .diagnostic) std.debug.print("unexpected republished reference diagnostic {t}: {s}\n", .{ final.value.diagnostic.code, final.value.diagnostic.message });
    try std.testing.expect(final.value == .ir);
    try f.inspect(allocator, final.value.ir, distinct);
}
