const std = @import("std");
const api = @import("observed");
const Fixture = @import("fixture.zig");
const io = std.testing.io;

test "backend resolves all dependency prefixes and converges on repeated response" {
    var fixture = try Fixture.init();

    defer fixture.deinit();

    const allocator = fixture.result.response.arena.allocator();
    var roots: [4][]const u8 = undefined;

    for ([_][]const u8{ "cwd", "library", "local", "global" }, 0..) |name, index| {
        try fixture.temporary.dir.createDirPath(io, name);

        const file = try std.fs.path.join(allocator, &.{ name, "unit" });

        try fixture.temporary.dir.writeFile(io, .{ .sub_path = file, .data = name });

        roots[index] = try std.fs.path.join(allocator, &.{ fixture.root, name });
    }

    fixture.result.response.inputs = &.{
        .{ .prefix = .cwd, .path = "unit" },
        .{ .prefix = .zig_lib, .path = "unit" },
        .{ .prefix = .local_cache, .path = "unit" },
        .{ .prefix = .global_cache, .path = "unit" },
    };

    const cache: api.Observed.Cache = .{ .cwd = roots[0], .local = roots[2], .global = roots[3] };

    for (0..2) |round| {
        fixture.result = try api.Observed.resolve(io, &fixture.result.response, cache, roots[1], fixture.options, &fixture.inputs);

        try std.testing.expectEqual(round == 0, fixture.result.new_inputs);
        try std.testing.expectEqual(@as(usize, 4), fixture.result.input_paths.len);

        for (roots, fixture.result.input_paths) |root, actual| {
            const expected = try std.fs.path.join(std.testing.allocator, &.{ root, "unit" });

            defer std.testing.allocator.free(expected);

            try std.testing.expectEqualStrings(expected, actual);
            try std.testing.expect(fixture.inputs.entries.contains(actual));
        }
    }

    try std.testing.expectEqual(@as(u32, 5), fixture.inputs.entries.count());
}

test "backend normalizes equivalent dependency paths without new inputs" {
    var fixture = try Fixture.init();

    defer fixture.deinit();

    fixture.result.response.inputs = &.{ .{ .prefix = .cwd, .path = "input" }, .{ .prefix = .cwd, .path = "folder/../input" } };

    const cache: api.Observed.Cache = .{ .cwd = fixture.root, .local = fixture.root, .global = fixture.root };

    fixture.result = try api.Observed.resolve(io, &fixture.result.response, cache, fixture.root, fixture.options, &fixture.inputs);

    try std.testing.expect(!fixture.result.new_inputs);
    try std.testing.expectEqual(@as(u32, 1), fixture.inputs.entries.count());
    try std.testing.expectEqualStrings(fixture.options.input, fixture.result.input_paths[0]);
    try std.testing.expectEqualStrings(fixture.options.input, fixture.result.input_paths[1]);
}

test "backend digest paths follow requested executable target and assembly option" {
    for ([_][]const u8{ "x86_64-linux", "x86_64-windows" }, [_][]const u8{ "application", "application.exe" }) |target, name| {
        var fixture = try Fixture.init();

        defer fixture.deinit();

        fixture.options.target = target;
        fixture.result.response.digest = @as([std.Build.Cache.bin_digest_len]u8, @splat(0xa5));

        const cache: api.Observed.Cache = .{ .cwd = fixture.root, .local = fixture.root, .global = fixture.root };

        fixture.result = try api.Observed.resolve(io, &fixture.result.response, cache, fixture.root, fixture.options, &fixture.inputs);

        const directory = "o/" ++ "a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5";
        const expected = try std.fs.path.join(std.testing.allocator, &.{ fixture.root, directory, name });

        defer std.testing.allocator.free(expected);

        const assembly = try std.fs.path.join(std.testing.allocator, &.{ fixture.root, directory, "application.s" });

        defer std.testing.allocator.free(assembly);

        try std.testing.expectEqualStrings(expected, fixture.result.binary.?);
        try std.testing.expectEqualStrings(assembly, fixture.result.assembly.?);

        fixture.options.assembly = null;
        fixture.result = try api.Observed.resolve(io, &fixture.result.response, cache, fixture.root, fixture.options, &fixture.inputs);

        try std.testing.expect(fixture.result.assembly == null);
        try std.testing.expectEqualStrings(expected, fixture.result.binary.?);
    }
}

test "backend failed response records dependencies without artifact paths" {
    var fixture = try Fixture.init();

    defer fixture.deinit();

    fixture.result.response.succeeded = false;
    fixture.result.response.inputs = &.{.{ .prefix = .cwd, .path = "input" }};

    const cache: api.Observed.Cache = .{ .cwd = fixture.root, .local = fixture.root, .global = fixture.root };

    fixture.result = try api.Observed.resolve(io, &fixture.result.response, cache, fixture.root, fixture.options, &fixture.inputs);

    try std.testing.expect(fixture.result.binary == null and fixture.result.assembly == null);
    try std.testing.expectEqualStrings(fixture.options.input, fixture.result.input_paths[0]);
    try std.testing.expect(!try fixture.publish());
    try fixture.expectOutputs("old-bin", "old-asm");
}
