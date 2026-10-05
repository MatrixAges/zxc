const std = @import("std");
const allocation_testing = @import("allocation_testing");
const f = @import("fixture.zig");

test "library codec round trip retains full program exports and nominal origins" {
    var original = try f.library();

    defer original.deinit();

    const bytes = try f.codec.encode(std.testing.allocator, &original);

    defer std.testing.allocator.free(bytes);

    var restored = try f.codec.decode(std.testing.allocator, bytes);

    defer restored.deinit();

    try std.testing.expectEqualDeep(original.program, restored.program);
    try std.testing.expectEqualDeep(original.exports, restored.exports);
    try std.testing.expectEqualDeep(original.nominal_types, restored.nominal_types);

    const second = try f.codec.encode(std.testing.allocator, &restored);

    defer std.testing.allocator.free(second);

    try std.testing.expectEqualStrings(bytes, second);
}

test "library decoder owns names and IR after source library and encoded bytes disappear" {
    var restored = block: {
        const bytes = try f.encoded();

        defer std.testing.allocator.free(bytes);

        const result = try f.codec.decode(std.testing.allocator, bytes);

        @memset(bytes, 0);

        break :block result;
    };

    defer restored.deinit();

    try std.testing.expectEqualStrings("run", restored.exports[0].name);
    try std.testing.expectEqualStrings("/project/types.zx", restored.exports[1].path);
    try std.testing.expectEqualStrings("Mode", restored.nominal_types[0].name);
    for (0..restored.exports.len) |index| try std.testing.expect(try f.compiler.validateIr(std.testing.allocator, try restored.module(index)) == null);
}

fn encode(allocator: std.mem.Allocator, library: *const f.compiler.library.Result) !void {
    const bytes = try f.codec.encode(allocator, library);

    defer allocator.free(bytes);
}

fn decode(allocator: std.mem.Allocator, bytes: []const u8) !void {
    var value = try f.codec.decode(allocator, bytes);

    defer value.deinit();

    try std.testing.expectEqual(@as(usize, 2), value.exports.len);
}

test "library encoding allocation failures release temporary JSON" {
    var library = try f.library();

    defer library.deinit();

    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, encode, .{&library});
}

test "library decoding allocation failures release partially parsed programs" {
    const bytes = try f.encoded();

    defer std.testing.allocator.free(bytes);

    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, decode, .{bytes});
}

test "library digest and truncation failures reject without accepting partial data" {
    const bytes = try f.encoded();

    defer std.testing.allocator.free(bytes);

    for (0..bytes.len) |length| try std.testing.expectError(error.InvalidLibrary, f.codec.decode(std.testing.allocator, bytes[0..length]));

    for ([_]usize{ 0, 14, 77, bytes.len - 1 }) |offset| {
        const previous = bytes[offset];

        bytes[offset] ^= 1;

        try std.testing.expectError(error.InvalidLibrary, f.codec.decode(std.testing.allocator, bytes));

        bytes[offset] = previous;
    }
}
