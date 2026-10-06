const std = @import("std");
const f = @import("fixture.zig");
const types = @import("types.zig");
const mutation = @import("mutation.zig");

fn rejected(mode: mutation.Mode) !void {
    var value = try types.library(std.testing.allocator);

    defer value.deinit();

    try types.inspect(&value);

    const valid = try f.compiler.library.codec.encode(std.testing.allocator, &value);

    defer std.testing.allocator.free(valid);

    try mutation.apply(&value, mode);
    try mutation.rejected(std.testing.allocator, &value);
}

test "native reference codec rejects missing nominal metadata despite a valid digest" {
    try rejected(.missing_nominal);
}

test "native reference codec rejects a source origin despite a valid digest" {
    try rejected(.source_origin);
}

test "native reference codec rejects an origin inconsistent with the native owner" {
    try rejected(.other_origin);
}

test "native reference codec rejects a renamed nominal type despite a valid digest" {
    try rejected(.nominal_name);
}

test "native reference codec rejects repeated nominal metadata despite a valid digest" {
    try rejected(.duplicate_nominal);
}

test "native reference codec rejects a missing native declaration binding" {
    try rejected(.missing_binding);
}

test "native reference codec rejects a native alias without the original declaration name" {
    try rejected(.renamed_binding);
}

test "native reference codec rejects two owner keys for the same type" {
    try rejected(.distinct_owner);
}
