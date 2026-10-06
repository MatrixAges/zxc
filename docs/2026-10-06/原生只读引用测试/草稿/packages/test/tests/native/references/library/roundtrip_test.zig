const std = @import("std");
const f = @import("fixture.zig");
const types = @import("types.zig");
const mutation = @import("mutation.zig");
const roundtrip = @import("roundtrip.zig");

test "type-only compiled exports retain the original native reference identity" {
    var value = try types.library(std.testing.allocator);

    defer value.deinit();

    try types.inspect(&value);
}

test "native reference codec permits an alias binding alongside its original owner name" {
    const allocator = std.testing.allocator;
    var value = try types.library(allocator);

    defer value.deinit();

    try types.inspect(&value);
    try mutation.apply(&value, .same_owner_alias);

    const bytes = try f.compiler.library.codec.encode(allocator, &value);

    defer allocator.free(bytes);

    var decoded = try f.compiler.library.codec.decode(allocator, bytes);

    defer decoded.deinit();

    try types.inspect(&decoded);

    const bindings = decoded.program.native_modules[0].types;

    try std.testing.expectEqual(@as(usize, 2), bindings.len);
    try std.testing.expectEqualStrings("Node", bindings[0].name);
    try std.testing.expectEqualStrings("Alias", bindings[1].name);
    try std.testing.expectEqual(bindings[0].type_id, bindings[1].type_id);
}

test "decoded native reference metadata owns bytes after provider and encoded input release" {
    const allocator = std.testing.allocator;

    var decoded = block: {
        var value = try types.library(allocator);

        defer value.deinit();

        const bytes = try f.compiler.library.codec.encode(allocator, &value);

        defer allocator.free(bytes);

        const restored = try f.compiler.library.codec.decode(allocator, bytes);

        @memset(bytes, 0xdd);

        break :block restored;
    };

    defer decoded.deinit();

    try types.inspect(&decoded);

    const bytes = try f.compiler.library.codec.encode(allocator, &decoded);

    defer allocator.free(bytes);

    var restored = try f.compiler.library.codec.decode(allocator, bytes);

    defer restored.deinit();

    try types.inspect(&restored);
}

test "compiled native reference aliases preserve one owner through consumption and republishing" {
    try roundtrip.run(std.testing.allocator, false);
}

test "compiled native reference instances preserve distinct owners through republished consumption" {
    try roundtrip.run(std.testing.allocator, true);
}
