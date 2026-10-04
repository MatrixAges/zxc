const std = @import("std");
const Fixture = @import("fixture.zig").Fixture;

test "removed type export invalidates importer interface" {
    var fixture = try Fixture.init(std.testing.allocator);

    defer fixture.deinit();

    fixture.modules[0].exports = &.{};

    try fixture.expectError(error.ConflictingInterface);
}

test "duplicate exported name is invalid" {
    var fixture = try Fixture.init(std.testing.allocator);

    defer fixture.deinit();

    const exports = [_]@TypeOf(fixture.modules[0].exports[0]){ fixture.modules[0].exports[0], fixture.modules[0].exports[0] };
    fixture.modules[0].exports = &exports;

    try fixture.expectError(error.InvalidModule);
}

test "missing imported type binding invalidates interface" {
    var fixture = try Fixture.init(std.testing.allocator);

    defer fixture.deinit();

    fixture.modules[1].type_imports = &.{};

    try fixture.expectError(error.ConflictingInterface);
}

test "function import requires target function body" {
    var fixture = try Fixture.init(std.testing.allocator);

    defer fixture.deinit();

    fixture.modules[2].function = null;

    try fixture.expectError(error.InvalidModule);
}

test "function body path must match its module path" {
    var fixture = try Fixture.init(std.testing.allocator);

    defer fixture.deinit();

    fixture.modules[1].function.?.file_name = "/project/other.zx";

    try fixture.expectError(error.InvalidModule);
}
