const std = @import("std");
const allocation_testing = @import("allocation_testing");
const f = @import("fixture.zig");
const compiler = f.compiler;

fn library() !compiler.library.Result {
    var value = try f.analyze("main.zx", f.function);

    defer value.deinit();

    return compiler.library.link(std.testing.allocator, &.{ .{ .name = ".", .analysis = &value }, .{ .name = "./nested/alias", .analysis = &value } });
}

test "unified bundle owns public path names and code after library release" {
    var bundle = block: {
        var value = try library();

        defer value.deinit();

        break :block try compiler.zig.emitLibrary(std.testing.allocator, &value);
    };

    defer bundle.deinit();

    try std.testing.expectEqual(@as(usize, 2), bundle.public_modules.len);
    try std.testing.expectEqualStrings(".", bundle.public_modules[0].name);
    try std.testing.expectEqualStrings("./nested/alias", bundle.public_modules[1].name);

    for (bundle.public_modules) |public| {
        var digest: [32]u8 = undefined;

        std.crypto.hash.sha2.Sha256.hash(public.name, &digest, .{});

        const expected = try std.fmt.allocPrint(std.testing.allocator, "public_{s}", .{std.fmt.bytesToHex(digest, .lower)});

        defer std.testing.allocator.free(expected);

        try std.testing.expectEqualStrings(expected, public.file.name);
        try std.testing.expect(std.mem.indexOf(u8, public.file.source, "pub fn execute") != null);
    }

    try std.testing.expect(bundle.types.len > 0);
}

test "unified bundle cached output owns bytes after generation cache release" {
    var value = try library();

    defer value.deinit();

    var uncached = try compiler.zig.emitLibrary(std.testing.allocator, &value);

    defer uncached.deinit();

    var repeated = block: {
        var cache = compiler.zig.GenerationCache.init(std.testing.allocator);

        defer cache.deinit();

        var first = try compiler.zig.emitLibraryCached(std.testing.allocator, &value, &cache);

        defer first.deinit();

        const generated = cache.generated;
        var second = try compiler.zig.emitLibraryCached(std.testing.allocator, &value, &cache);

        errdefer second.deinit();

        try std.testing.expectEqual(generated, cache.generated);
        try std.testing.expect(cache.reused > 0);

        break :block second;
    };

    defer repeated.deinit();

    try std.testing.expectEqualDeep(uncached.public_modules, repeated.public_modules);
    try std.testing.expectEqualDeep(uncached.modules, repeated.modules);
    try std.testing.expectEqualStrings(uncached.types, repeated.types);
}

fn allocation(allocator: std.mem.Allocator, value: *const compiler.library.Result) !void {
    var result = try compiler.zig.emitLibrary(allocator, value);

    defer result.deinit();

    try std.testing.expectEqual(@as(usize, 2), result.public_modules.len);
}

test "unified bundle allocation failures release public and ABI generation" {
    var value = try library();

    defer value.deinit();

    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, allocation, .{&value});
}

test "unified bundle rejects missing public table before emission" {
    var value = try library();

    defer value.deinit();

    var invalid = value;

    invalid.exports = &.{};

    try std.testing.expectError(error.InvalidLibrary, compiler.zig.emitLibrary(std.testing.allocator, &invalid));
}

test "unified bundle rejects unproved public function contracts" {
    var analyzed = try f.analyze("contract.zx", "export type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output ensures(out == in) {\n  return in\n}\n");

    defer analyzed.deinit();

    var value = try compiler.library.link(std.testing.allocator, &.{.{ .name = ".", .analysis = &analyzed }});

    defer value.deinit();

    try std.testing.expectError(error.UnverifiedContracts, compiler.zig.emitLibrary(std.testing.allocator, &value));
}
