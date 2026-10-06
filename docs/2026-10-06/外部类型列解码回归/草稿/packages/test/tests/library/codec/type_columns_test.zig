const std = @import("std");
const allocation_testing = @import("allocation_testing");
const f = @import("fixture.zig");
const columns = @import("type_column_fixture");

fn encoded() ![]u8 {
    var analysis = try f.compiler.project.analyze(std.testing.allocator, &.{.{ .path = "columns.zx", .source = columns.source }}, .{ .entry = "columns.zx", .root_dir = "/project" });

    defer analysis.deinit();

    try std.testing.expect(analysis.value == .ir);

    var library = try f.compiler.library.link(std.testing.allocator, &.{.{ .name = "columns", .analysis = &analysis }});

    defer library.deinit();

    return f.codec.encode(std.testing.allocator, &library);
}

fn corrupt(mode: columns.Mode) ![]u8 {
    const original = try encoded();

    defer std.testing.allocator.free(original);

    var document = try std.json.parseFromSlice(std.json.Value, std.testing.allocator, f.payload(original), .{});

    defer document.deinit();

    const table = document.value.object.getPtr("program").?.object.getPtr("types").?;

    try columns.corrupt(document.arena.allocator(), table, mode);

    const payload = try std.json.Stringify.valueAlloc(std.testing.allocator, document.value, .{});

    defer std.testing.allocator.free(payload);

    return f.envelope(payload);
}

fn rejected(allocator: std.mem.Allocator, bytes: []const u8) !void {
    const result = f.codec.decode(allocator, bytes);

    if (result) |value| {
        var unexpected = value;

        unexpected.deinit();

        return error.ExpectedInvalidTypes;
    } else |err| {
        if (err == error.OutOfMemory) return err;
        try std.testing.expectEqual(error.InvalidLibrary, err);
    }
}

fn check(mode: columns.Mode) !void {
    const bytes = try corrupt(mode);

    defer std.testing.allocator.free(bytes);

    try rejected(std.testing.allocator, bytes);
}

test "library accepts ordinary mixed columns before mutation" {
    const original = try encoded();

    defer std.testing.allocator.free(original);

    const bytes = try f.envelope(f.payload(original));

    defer std.testing.allocator.free(bytes);

    var value = try f.codec.decode(std.testing.allocator, bytes);

    defer value.deinit();

    try std.testing.expect(value.program.types.validStructure());
}

test "library rejects first length with matching digest" {
    try check(.first_length);
}

test "library rejects second length with matching digest" {
    try check(.second_length);
}

test "library rejects labels length with matching digest" {
    try check(.labels_length);
}

test "library rejects fields length with matching digest" {
    try check(.fields_length);
}

test "library rejects unknown kind with matching digest" {
    try check(.unknown_kind);
}

test "library rejects scalar identity with matching digest" {
    try check(.scalar_identity);
}

test "library rejects scalar second with matching digest" {
    try check(.scalar_second);
}

test "library rejects illegal label with matching digest" {
    try check(.illegal_label);
}

test "library rejects optional self with matching digest" {
    try check(.optional_self);
}

test "library rejects list void with matching digest" {
    try check(.list_void);
}

test "library rejects tuple self with matching digest" {
    try check(.tuple_self);
}

test "library rejects object self with matching digest" {
    try check(.object_self);
}

test "library rejects object void with matching digest" {
    try check(.object_void);
}

test "library rejects object empty name with matching digest" {
    try check(.object_empty_name);
}

test "library rejects object unsorted with matching digest" {
    try check(.object_unsorted);
}

test "library rejects tuple gap with matching digest" {
    try check(.tuple_gap);
}

test "library rejects tuple overflow with matching digest" {
    try check(.tuple_overflow);
}

test "library rejects object gap with matching digest" {
    try check(.object_gap);
}

test "library rejects object overflow with matching digest" {
    try check(.object_overflow);
}

test "library rejects names gap with matching digest" {
    try check(.names_gap);
}

test "library rejects names overflow with matching digest" {
    try check(.names_overflow);
}

test "library rejects enum empty label with matching digest" {
    try check(.enum_empty_label);
}

test "library rejects enum duplicate with matching digest" {
    try check(.enum_duplicate);
}

test "library rejects error empty name with matching digest" {
    try check(.error_empty_name);
}

test "library releases allocations when rejecting an object self reference" {
    const bytes = try corrupt(.object_self);

    defer std.testing.allocator.free(bytes);

    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, rejected, .{bytes});
}
