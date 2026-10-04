const std = @import("std");
const f = @import("fixture.zig");
const corrupt = @import("corrupt.zig");
const codec = f.compiler.library.codec;

test "v2 round trip retains exact Store initialization graph and declarations" {
    var original = try f.library(std.testing.allocator, .single);

    defer original.deinit();

    const bytes = try codec.encode(std.testing.allocator, &original);

    defer std.testing.allocator.free(bytes);

    try std.testing.expect(std.mem.startsWith(u8, bytes, "zxc.library.v2\n"));

    var restored = try codec.decode(std.testing.allocator, bytes);

    defer restored.deinit();

    try std.testing.expectEqualDeep(original.program, restored.program);
    try std.testing.expectEqualDeep(original.store_initializers, restored.store_initializers);
    try f.check(&restored, 1);
}

test "decoded Store initialization owns strings and values after input destruction" {
    var restored = block: {
        var original = try f.library(std.testing.allocator, .single);

        defer original.deinit();

        const bytes = try codec.encode(std.testing.allocator, &original);

        defer std.testing.allocator.free(bytes);

        const result = try codec.decode(std.testing.allocator, bytes);

        @memset(bytes, 0);

        break :block result;
    };

    defer restored.deinit();

    try f.check(&restored, 1);
    try std.testing.expectEqualStrings(f.identity, restored.store_initializers[0].identity);
}

test "v1 accepts explicit host Store library without initializer table" {
    var original = try f.library(std.testing.allocator, .omitted);

    defer original.deinit();

    const bytes = try codec.encode(std.testing.allocator, &original);

    defer std.testing.allocator.free(bytes);

    var document = try std.json.parseFromSlice(std.json.Value, std.testing.allocator, f.payload(bytes), .{});

    defer document.deinit();

    try std.testing.expect(document.value.object.swapRemove("store_initializers"));

    const payload = try std.json.Stringify.valueAlloc(std.testing.allocator, document.value, .{});

    defer std.testing.allocator.free(payload);

    const legacy = try f.envelope(payload, true);

    defer std.testing.allocator.free(legacy);

    var restored = try codec.decode(std.testing.allocator, legacy);

    defer restored.deinit();

    try f.check(&restored, 0);
    try std.testing.expectEqualDeep(original.program, restored.program);
}

fn reject(mode: corrupt.Mode) !void {
    const bytes = try corrupt.encode(mode);

    defer std.testing.allocator.free(bytes);

    try std.testing.expectError(error.InvalidLibrary, codec.decode(std.testing.allocator, bytes));
}

test "initializer function reference must be in range" {
    try reject(.out_of_range);
}

test "initializer identity requires a nonempty Store suffix" {
    try reject(.empty_identity);
}

test "initializer identity requires Store prefix" {
    try reject(.prefix);
}

test "initializer identity rejects embedded NUL" {
    try reject(.nul);
}

test "initializer identity must match an existing Store slot" {
    try reject(.orphan);
}

test "initializer identity cannot appear twice in encoded table" {
    try reject(.duplicate);
}

test "public Store reader is not a valid initializer function" {
    try reject(.public_function);
}

test "v1 cannot smuggle nonempty initialization metadata" {
    try reject(.legacy);
}

fn decode(allocator: std.mem.Allocator, bytes: []const u8) !void {
    var result = try codec.decode(allocator, bytes);

    defer result.deinit();

    try f.check(&result, 1);
}

test "initializer decode cleans every partial allocation" {
    var original = try f.library(std.testing.allocator, .single);

    defer original.deinit();

    const bytes = try codec.encode(std.testing.allocator, &original);

    defer std.testing.allocator.free(bytes);

    try std.testing.checkAllAllocationFailures(std.testing.allocator, decode, .{bytes});
}

fn rejectedDecode(allocator: std.mem.Allocator, bytes: []const u8) !void {
    const result = codec.decode(allocator, bytes);

    if (result) |value| {
        var unexpected = value;

        unexpected.deinit();

        return error.ExpectedInvalidLibrary;
    } else |err| {
        if (err == error.OutOfMemory) return err;
        try std.testing.expectEqual(error.InvalidLibrary, err);
    }
}

test "initializer semantic rejection cleans every partial allocation" {
    const bytes = try corrupt.encode(.duplicate);

    defer std.testing.allocator.free(bytes);

    try std.testing.checkAllAllocationFailures(std.testing.allocator, rejectedDecode, .{bytes});
}
