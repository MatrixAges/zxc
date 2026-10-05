const std = @import("std");
const f = @import("fixture.zig");
const mutation = @import("mutation.zig");
const compiler = f.compiler;

fn reject(mode: mutation.Mode) !void {
    var value = try f.library(std.testing.allocator, .{});

    defer value.deinit();

    try f.inspect(value.program, f.members, true);
    try mutation.apply(&value, mode);

    const issue = (try compiler.validateIr(std.testing.allocator, value.program)).?;

    try std.testing.expectEqual(.contract, issue.code);
    try std.testing.expectEqualStrings("invalid ZX IR version, structure, types or bindings", issue.message);
    try std.testing.expectError(error.InvalidLibrary, compiler.library.codec.encode(std.testing.allocator, &value));

    const bytes = try mutation.envelope(std.testing.allocator, &value);

    defer std.testing.allocator.free(bytes);

    try std.testing.expectError(error.InvalidLibrary, compiler.library.codec.decode(std.testing.allocator, bytes));
}

test "IR and library reject a capture missing an actual native error despite valid digest" {
    try reject(.missing);
}

test "IR and library reject a capture containing an unproduced error despite valid digest" {
    try reject(.extra);
}

test "IR and library reject a capture with renamed native error despite valid digest" {
    try reject(.renamed);
}

test "IR and library reject unwrapping a captured result in the error branch despite valid digest" {
    try reject(.guard);
}
