const std = @import("std");
const allocation_testing = @import("allocation_testing");
const f = @import("fixture.zig");
const Mode = enum { version, program_version, empty_exports, duplicate, function, path, input_type, origins, nominal_index };

fn corrupt(mode: Mode) ![]u8 {
    const bytes = try f.encoded();

    defer std.testing.allocator.free(bytes);

    var document = try std.json.parseFromSlice(std.json.Value, std.testing.allocator, f.payload(bytes), .{});

    defer document.deinit();

    const root = &document.value.object;
    const exports = root.getPtr("exports").?;
    const first = &exports.array.items[0].object;

    try std.testing.expect(first.get("function").? == .integer);

    const input = &first.getPtr("types").?.array.items[0].object;

    try std.testing.expectEqualStrings("Input", input.get("name").?.string);
    try std.testing.expect(input.get("type_id").? == .integer);
    try std.testing.expect(root.getPtr("nominal_types").?.array.items[0].object.get("type_id").? == .integer);

    switch (mode) {
        .version => root.getPtr("ir_version").?.* = .{ .integer = 999 },
        .program_version => root.getPtr("program").?.object.getPtr("version").?.* = .{ .integer = 999 },
        .empty_exports => exports.array.items.len = 0,
        .duplicate => exports.array.items[1].object.getPtr("name").?.* = first.get("name").?,
        .function => first.getPtr("function").?.* = .{ .integer = 999999 },
        .path => first.getPtr("path").?.* = .{ .string = "/project/wrong.zx" },
        .input_type => first.getPtr("types").?.array.items[0].object.getPtr("type_id").?.* = .{ .integer = 0 },
        .origins => root.getPtr("nominal_types").?.array.items.len = 0,
        .nominal_index => root.getPtr("nominal_types").?.array.items[0].object.getPtr("type_id").?.* = .{ .integer = 999999 },
    }

    const payload = try std.json.Stringify.valueAlloc(std.testing.allocator, document.value, .{});

    defer std.testing.allocator.free(payload);

    return f.envelope(payload);
}

fn check(mode: Mode) !void {
    const bytes = try corrupt(mode);

    defer std.testing.allocator.free(bytes);

    const expected = if (mode == .version or mode == .program_version) error.IncompatibleLibraryVersion else error.InvalidLibrary;

    try std.testing.expectError(expected, f.codec.decode(std.testing.allocator, bytes));
}

test "library rejects payload IR version with correct digest" {
    try check(.version);
}

test "library rejects program IR version with correct digest" {
    try check(.program_version);
}

test "library rejects empty public export table with correct digest" {
    try check(.empty_exports);
}

test "library rejects duplicate public names with correct digest" {
    try check(.duplicate);
}

test "library rejects out of range public function ID with correct digest" {
    try check(.function);
}

test "library rejects public path inconsistent with function origin" {
    try check(.path);
}

test "library rejects public Input type inconsistent with callable signature" {
    try check(.input_type);
}

test "library rejects missing enum nominal origins" {
    try check(.origins);
}

test "library rejects out of range nominal origin type" {
    try check(.nominal_index);
}

fn rejectedAllocation(allocator: std.mem.Allocator, bytes: []const u8) !void {
    const result = f.codec.decode(allocator, bytes);

    if (result) |value| {
        var unexpected = value;

        unexpected.deinit();

        return error.ExpectedInvalidLibrary;
    } else |err| {
        if (err == error.OutOfMemory) return err;
        try std.testing.expectEqual(error.InvalidLibrary, err);
    }
}

test "library semantic rejection cleans allocations after complete JSON parse" {
    const bytes = try corrupt(.duplicate);

    defer std.testing.allocator.free(bytes);

    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, rejectedAllocation, .{bytes});
}

test "library rejects malformed JSON and excessive depth despite valid digest" {
    for ([_][]const u8{ "{", "{}", "[]", "null" }) |payload| {
        const bytes = try f.envelope(payload);

        defer std.testing.allocator.free(bytes);

        try std.testing.expectError(error.InvalidLibrary, f.codec.decode(std.testing.allocator, bytes));
    }

    var payload: [4100]u8 = undefined;

    @memset(payload[0..2050], '[');
    @memset(payload[2050..], ']');

    const bytes = try f.envelope(&payload);

    defer std.testing.allocator.free(bytes);

    try std.testing.expectError(error.InvalidLibrary, f.codec.decode(std.testing.allocator, bytes));
}
