const std = @import("std");
const f = @import("fixture.zig");

test "shared native enum and function are unified across source modules" {
    var fixture = try f.Fixture.init();

    defer fixture.deinit();

    var result = try f.artifact.linker.link(std.testing.allocator, &fixture.modules, "/project/main.zx");

    defer result.deinit();

    try f.check(result);
}

test "reverse input and destroyed artifacts preserve native metadata and generation" {
    var result = block: {
        var fixture = try f.Fixture.init();

        defer fixture.deinit();

        break :block try f.artifact.linker.link(std.testing.allocator, &.{ fixture.modules[1], fixture.modules[0] }, "/project/main.zx");
    };

    defer result.deinit();

    try f.check(result);
    try std.testing.expectEqualStrings("choice", result.program.native_modules[0].import_name);

    const generated = try f.compiler.zig.emitBundle(std.testing.allocator, result.program);

    defer generated.deinit(std.testing.allocator);

    try std.testing.expect(std.mem.indexOf(u8, generated.source, "flip") != null);
}

test "conflicting native type namespace is rejected" {
    var fixture = try f.Fixture.init();

    defer fixture.deinit();

    var native = fixture.modules[1].native_modules[0];
    native.type_namespace = &.{"Other"};
    fixture.modules[1].native_modules = (&native)[0..1];

    try std.testing.expectError(error.ConflictingInterface, f.artifact.linker.link(std.testing.allocator, &fixture.modules, "/project/main.zx"));
}

test "conflicting native function fallibility is rejected" {
    var fixture = try f.Fixture.init();

    defer fixture.deinit();

    const functions = try std.testing.allocator.dupe(@TypeOf(fixture.modules[1].functions[0]), fixture.modules[1].functions);

    defer std.testing.allocator.free(functions);

    for (functions) |*function| {
        if (function.external) |*external| external.fallible = !external.fallible;
    }

    fixture.modules[1].functions = functions;

    try std.testing.expectError(error.ConflictingInterface, f.artifact.linker.link(std.testing.allocator, &fixture.modules, "/project/main.zx"));
}
