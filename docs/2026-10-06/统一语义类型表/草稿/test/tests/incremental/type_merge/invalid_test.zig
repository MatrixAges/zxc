const std = @import("std");
const f = @import("fixture.zig");

test "enum without declaration origin is rejected" {
    var source = try f.extract("main.zx", f.declaration);

    defer source.deinit();

    source.value.nominal_types = &.{};

    try std.testing.expectError(error.MissingNominalOrigin, f.artifact.type_link.merge(std.testing.allocator, &.{source.value}));
}

test "duplicate nominal metadata is rejected" {
    var source = try f.extract("main.zx", f.declaration);

    defer source.deinit();

    const origins = [_]@TypeOf(source.value.nominal_types[0]){ source.value.nominal_types[0], source.value.nominal_types[0] };
    source.value.nominal_types = &origins;

    try std.testing.expectError(error.InvalidModule, f.artifact.type_link.merge(std.testing.allocator, &.{source.value}));
}

test "origin name must match local enum name" {
    var source = try f.extract("main.zx", f.declaration);

    defer source.deinit();

    var origin = source.value.nominal_types[0];
    origin.name = "Other";
    source.value.nominal_types = (&origin)[0..1];

    try std.testing.expectError(error.InvalidModule, f.artifact.type_link.merge(std.testing.allocator, &.{source.value}));
}

test "self referenced container type is rejected before remapping" {
    var source = try f.extract("main.zx", f.structural);

    defer source.deinit();

    const index = try f.exportIndex(source.value, "Maybe");
    const first = try std.testing.allocator.dupe(u32, source.value.types.first);

    defer std.testing.allocator.free(first);

    first[index] = @intCast(index);
    source.value.types.first = first;

    try std.testing.expectError(error.InvalidModule, f.artifact.type_link.merge(std.testing.allocator, &.{source.value}));
}
