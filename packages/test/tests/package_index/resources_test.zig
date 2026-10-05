const std = @import("std");
const allocation_testing = @import("allocation_testing");
const Index = @import("pkgs").Index;
const digest = "a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1";
const release = "{\"version\":\"1.2.3\",\"archive\":\"archives/sample.tar.gz\",\"sha256\":\"" ++ digest ++ "\"}";
const previous = "{\"version\":\"0.9.0\",\"archive\":\"archives/old.tar.gz\",\"sha256\":\"" ++ digest ++ "\"}";
const package = "{\"name\":\"sample\",\"versions\":[" ++ previous ++ "," ++ release ++ "]}";
const source = "{\"format_version\":1,\"packages\":[" ++ package ++ ",{\"name\":\"other\",\"versions\":[" ++ release ++ "]}]}";
const Failure = enum { format, duplicate, digest, truncated, unknown };

test "package index owns strings and releases every partial allocation" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, checkSuccess, .{});
}

test "package index cleans parsed data after format validation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, checkFailure, .{Failure.format});
}

test "package index cleans parsed data after duplicate package failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, checkFailure, .{Failure.duplicate});
}

test "package index cleans parsed data after digest validation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, checkFailure, .{Failure.digest});
}

test "package index cleans nested values after truncated JSON" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, checkFailure, .{Failure.truncated});
}

test "package index cleans parsed data after unknown field" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, checkFailure, .{Failure.unknown});
}

fn checkSuccess(allocator: std.mem.Allocator) !void {
    const input = try allocator.dupe(u8, source);

    defer allocator.free(input);

    const parsed = try Index.parse(allocator, input);

    defer parsed.deinit();

    @memset(input, '_');

    try std.testing.expectEqual(@as(usize, 2), parsed.value.packages.len);
    try std.testing.expectEqualStrings("sample", parsed.value.packages[0].name);
    try std.testing.expectEqualStrings("other", parsed.value.packages[1].name);

    for ([_][]const u8{ "sample", "other" }) |name| {
        const selected = (try parsed.value.select(name, "^1.0.0")).?;

        try std.testing.expectEqualStrings("1.2.3", selected.version);
        try std.testing.expectEqualStrings("archives/sample.tar.gz", selected.archive);
        try std.testing.expectEqualStrings(digest, selected.sha256);
    }

    try std.testing.expectEqual(null, try parsed.value.select("absent", "*"));
}

fn checkFailure(allocator: std.mem.Allocator, failure: Failure) !void {
    const input = switch (failure) {
        .format => "{\"format_version\":2,\"packages\":[" ++ package ++ "]}",
        .duplicate => "{\"format_version\":1,\"packages\":[" ++ package ++ "," ++ package ++ "]}",
        .digest => "{\"format_version\":1,\"packages\":[" ++ package ++ ",{\"name\":\"bad\",\"versions\":[{\"version\":\"1.0.0\",\"archive\":\"a\",\"sha256\":\"bad\"}]}]}",
        .truncated => source[0 .. source.len - 1],
        .unknown => source[0 .. source.len - 1] ++ ",\"unknown\":true}",
    };

    const expected: anyerror = switch (failure) {
        .format => error.UnsupportedIndexVersion,
        .duplicate => error.DuplicatePackage,
        .digest => error.InvalidArchiveDigest,
        .truncated => error.UnexpectedEndOfInput,
        .unknown => error.UnknownField,
    };

    const parsed = Index.parse(allocator, input) catch |err| {
        if (err == error.OutOfMemory) return err;

        try std.testing.expectEqual(expected, err);

        return;
    };

    defer parsed.deinit();

    return error.TestExpectedError;
}
