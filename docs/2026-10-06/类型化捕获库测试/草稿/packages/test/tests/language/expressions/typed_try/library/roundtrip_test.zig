const std = @import("std");
const f = @import("fixture.zig");
const compiler = f.compiler;

fn roundtrip(case: f.Case, members: []const []const u8, narrowed: bool) !void {
    var value = try f.library(std.testing.allocator, case);

    defer value.deinit();

    const bytes = try compiler.library.codec.encode(std.testing.allocator, &value);

    defer std.testing.allocator.free(bytes);

    var decoded = try compiler.library.codec.decode(std.testing.allocator, bytes);

    defer decoded.deinit();

    try f.inspect(decoded.program, members, narrowed);

    var consumer = try f.consume(std.testing.allocator, &decoded, case.output);

    defer consumer.deinit();

    try std.testing.expect(consumer.value == .ir);
    try f.inspect(consumer.value.ir, members, narrowed);

    var published = try compiler.library.link(std.testing.allocator, &.{.{ .name = "again", .analysis = &consumer }});

    defer published.deinit();

    const republished = try compiler.library.codec.encode(std.testing.allocator, &published);

    defer std.testing.allocator.free(republished);

    var restored = try compiler.library.codec.decode(std.testing.allocator, republished);

    defer restored.deinit();

    try f.inspect(restored.program, members, narrowed);
}

test "compiled captures preserve finite errors and success branch proofs after republishing" {
    try roundtrip(.{}, f.members, true);
}

test "compiled captures preserve early failure return refinement after republishing" {
    try roundtrip(.{ .body = "const [err, res] = try native.apply(in)\nif (err != null) { return 0 }\nreturn res" }, f.members, true);
}

test "compiled captures preserve conditional success refinement after republishing" {
    try roundtrip(.{ .body = "const [err, res] = try native.apply(in)\nreturn err == null ? res : 0" }, f.members, true);
}

test "compiled nullable capture keeps the original optional within the success wrapper" {
    try roundtrip(.{ .output = "u64?", .body = "const [err, res] = try native.apply(in)\nif (err == null) { return res } else { return null }", .declaration = "export declare function apply(input: u64): u64? throws { ZetaFailure, AlphaFailure }\n" }, f.members, true);
}

test "compiled void capture preserves effect invocation and discarded value slot" {
    try roundtrip(.{ .body = "const [err, _] = try native.apply(in)\nreturn in", .declaration = "export declare function apply(input: u64): void throws { ZetaFailure, AlphaFailure }\n" }, f.members, false);
}

test "compiled infallible capture preserves its empty finite error set" {
    try roundtrip(.{ .declaration = "export declare function apply(input: u64): u64\n" }, &.{}, true);
}
