const std = @import("std");
const compiler = @import("compiler");
const Fixture = @import("fixture.zig").Fixture;
const linker = compiler.project.artifact.linker;

test "empty module set rejects absent entry" {
    try std.testing.expectError(error.MissingModule, linker.link(std.testing.allocator, &.{}, "/project/main.zx"));
}

test "unknown entry is not silently replaced" {
    var fixture = try Fixture.init(std.testing.allocator);

    defer fixture.deinit();

    try std.testing.expectError(error.MissingModule, linker.link(std.testing.allocator, &fixture.modules, "/project/absent.zx"));
}

test "empty module path is rejected" {
    var fixture = try Fixture.init(std.testing.allocator);

    defer fixture.deinit();

    fixture.modules[0].path = "";

    try fixture.expectError(error.InvalidModule);
}

test "duplicate module path is rejected" {
    var fixture = try Fixture.init(std.testing.allocator);

    defer fixture.deinit();

    fixture.modules[0].path = fixture.modules[1].path;

    try fixture.expectError(error.InvalidModule);
}

test "missing shared type dependency is rejected" {
    var fixture = try Fixture.init(std.testing.allocator);

    defer fixture.deinit();

    try std.testing.expectError(error.MissingModule, linker.link(std.testing.allocator, fixture.modules[1..], "/project/main.zx"));
}

test "missing imported but uncalled function is rejected" {
    var fixture = try Fixture.init(std.testing.allocator);

    defer fixture.deinit();

    const modules = [_]compiler.project.artifact.Module{ fixture.modules[0], fixture.modules[1], fixture.modules[3] };

    try std.testing.expectError(error.MissingModule, linker.link(std.testing.allocator, &modules, "/project/main.zx"));
}

test "self dependency is rejected before linking bodies" {
    var fixture = try Fixture.init(std.testing.allocator);

    defer fixture.deinit();

    var dependency = fixture.modules[1].dependencies[0];
    dependency.target = .{ .source = fixture.modules[1].path };
    fixture.modules[1].dependencies = (&dependency)[0..1];

    try fixture.expectError(error.CyclicDependency);
}

test "transitive cycle through entry is rejected" {
    var fixture = try Fixture.init(std.testing.allocator);

    defer fixture.deinit();

    var dependency = fixture.modules[1].dependencies[0];
    dependency.target = .{ .source = fixture.modules[3].path };
    fixture.modules[0].dependencies = (&dependency)[0..1];

    try fixture.expectError(error.CyclicDependency);
}

test "type only entry excludes unrelated broken dependency graph" {
    var fixture = try Fixture.init(std.testing.allocator);

    defer fixture.deinit();

    var dependency = fixture.modules[1].dependencies[0];
    dependency.target = .{ .source = "/project/absent.zx" };
    fixture.modules[3].dependencies = (&dependency)[0..1];

    var result = try linker.link(std.testing.allocator, &fixture.modules, "/project/shared.zx");

    defer result.deinit();

    try std.testing.expect(result.program.type_only);
    try std.testing.expectEqual(@as(usize, 0), result.program.functions.len);
    try std.testing.expectEqual(@as(usize, 2), result.program.exports.len);
    try std.testing.expect(try compiler.validateIr(std.testing.allocator, result.program) == null);
}
