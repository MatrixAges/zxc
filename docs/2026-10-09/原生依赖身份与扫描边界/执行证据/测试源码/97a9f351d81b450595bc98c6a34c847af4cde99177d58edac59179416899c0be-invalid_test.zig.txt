const std = @import("std");
const f = @import("fixture.zig");

test "enum without declaration origin is rejected" {
    var source = try f.extract("main.zx", f.declaration);

    defer source.deinit();

    source.value.nominal_types = .{};

    try std.testing.expectError(error.MissingNominalOrigin, f.artifact.type_link.merge(std.testing.allocator, &.{source.value}));
}

test "duplicate nominal metadata is rejected" {
    var source = try f.extract("main.zx", f.declaration);

    defer source.deinit();

    inline for (@typeInfo(@TypeOf(source.value.nominal_types)).@"struct".field_names) |name| {
        const column = @field(source.value.nominal_types, name);

        @field(source.value.nominal_types, name) = try source.arena.allocator().dupe(@TypeOf(column[0]), &.{ column[0], column[0] });
    }

    try std.testing.expectError(error.InvalidModule, f.artifact.type_link.merge(std.testing.allocator, &.{source.value}));
}

test "origin name must match local enum name" {
    var source = try f.extract("main.zx", f.declaration);

    defer source.deinit();

    source.value.nominal_types.names = &.{"Other"};

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
