const std = @import("std");
const allocation_testing = @import("allocation_testing");
const f = @import("fixture.zig");
const columns = @import("type_column_fixture");

fn encoded() ![]u8 {
    var analysis = try f.compiler.project.analyze(std.testing.allocator, &.{.{ .path = "columns.zx", .source = columns.source }}, .{ .entry = "columns.zx", .root_dir = "/project" });

    defer analysis.deinit();

    try std.testing.expect(analysis.value == .ir);

    var artifact = try f.compiler.project.artifact.extract(std.testing.allocator, &analysis, 0);

    defer artifact.deinit();

    return f.codec.encode(std.testing.allocator, artifact.value, f.context, f.identity);
}

fn corrupt(mode: columns.Mode) ![]u8 {
    const original = try encoded();

    defer std.testing.allocator.free(original);

    var document = try std.json.parseFromSlice(std.json.Value, std.testing.allocator, original[143..], .{});

    defer document.deinit();

    const table = document.value.object.getPtr("module").?.object.getPtr("types").?;

    try columns.corrupt(document.arena.allocator(), table, mode);

    const payload = try std.json.Stringify.valueAlloc(std.testing.allocator, document.value, .{});

    defer std.testing.allocator.free(payload);

    return f.envelope(payload);
}

fn rejected(allocator: std.mem.Allocator, bytes: []const u8) !void {
    const result = f.codec.decode(allocator, bytes, f.identity);

    if (result) |value| {
        var unexpected = value;

        unexpected.result.deinit();

        return error.ExpectedInvalidTypes;
    } else |err| {
        if (err == error.OutOfMemory) return err;
        try std.testing.expectEqual(error.InvalidCache, err);
    }
}

fn check(mode: columns.Mode) !void {
    const bytes = try corrupt(mode);

    defer std.testing.allocator.free(bytes);

    try rejected(std.testing.allocator, bytes);
}

test "cache accepts ordinary mixed columns before mutation" {
    const original = try encoded();

    defer std.testing.allocator.free(original);

    const bytes = try f.envelope(original[143..]);

    defer std.testing.allocator.free(bytes);

    var value = try f.codec.decode(std.testing.allocator, bytes, f.identity);

    defer value.result.deinit();

    try std.testing.expect(value.result.value.types.validStructure());
}

test "cache rejects first length with matching digest" {
    try check(.first_length);
}

test "cache rejects second length with matching digest" {
    try check(.second_length);
}

test "cache rejects labels length with matching digest" {
    try check(.labels_length);
}

test "cache rejects fields length with matching digest" {
    try check(.fields_length);
}

test "cache rejects unknown kind with matching digest" {
    try check(.unknown_kind);
}

test "cache rejects scalar identity with matching digest" {
    try check(.scalar_identity);
}

test "cache rejects scalar second with matching digest" {
    try check(.scalar_second);
}

test "cache rejects illegal label with matching digest" {
    try check(.illegal_label);
}

test "cache rejects optional self with matching digest" {
    try check(.optional_self);
}

test "cache rejects list void with matching digest" {
    try check(.list_void);
}

test "cache rejects tuple self with matching digest" {
    try check(.tuple_self);
}

test "cache rejects object self with matching digest" {
    try check(.object_self);
}

test "cache rejects object void with matching digest" {
    try check(.object_void);
}

test "cache rejects object empty name with matching digest" {
    try check(.object_empty_name);
}

test "cache rejects object unsorted with matching digest" {
    try check(.object_unsorted);
}

test "cache rejects tuple gap with matching digest" {
    try check(.tuple_gap);
}

test "cache rejects tuple overflow with matching digest" {
    try check(.tuple_overflow);
}

test "cache rejects object gap with matching digest" {
    try check(.object_gap);
}

test "cache rejects object overflow with matching digest" {
    try check(.object_overflow);
}

test "cache rejects names gap with matching digest" {
    try check(.names_gap);
}

test "cache rejects names overflow with matching digest" {
    try check(.names_overflow);
}

test "cache rejects enum empty label with matching digest" {
    try check(.enum_empty_label);
}

test "cache rejects enum duplicate with matching digest" {
    try check(.enum_duplicate);
}

test "cache rejects error empty name with matching digest" {
    try check(.error_empty_name);
}

test "cache releases allocations when rejecting an object self reference" {
    const bytes = try corrupt(.object_self);

    defer std.testing.allocator.free(bytes);

    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, rejected, .{bytes});
}
