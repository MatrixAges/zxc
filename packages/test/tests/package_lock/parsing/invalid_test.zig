const std = @import("std");
const cases = @import("cases.zig");

test "lock parser rejects missing version" {
    try cases.check(std.testing.allocator, .missing_version);
}

test "lock parser rejects unknown root" {
    try cases.check(std.testing.allocator, .unknown_root);
}

test "lock parser rejects duplicate field" {
    try cases.check(std.testing.allocator, .duplicate_field);
}

test "lock parser rejects missing name" {
    try cases.check(std.testing.allocator, .missing_name);
}

test "lock parser rejects unknown package" {
    try cases.check(std.testing.allocator, .unknown_package);
}

test "lock parser rejects empty" {
    try cases.check(std.testing.allocator, .empty);
}

test "lock parser rejects version" {
    try cases.check(std.testing.allocator, .version);
}

test "lock parser rejects root path" {
    try cases.check(std.testing.allocator, .root_path);
}

test "lock parser rejects root archive" {
    try cases.check(std.testing.allocator, .root_archive);
}

test "lock parser rejects uppercase digest" {
    try cases.check(std.testing.allocator, .uppercase_digest);
}

test "lock parser rejects short digest" {
    try cases.check(std.testing.allocator, .short_digest);
}

test "lock parser rejects archive newline" {
    try cases.check(std.testing.allocator, .archive_newline);
}

test "lock parser rejects duplicate archive" {
    try cases.check(std.testing.allocator, .duplicate_archive);
}

test "lock parser rejects duplicate identity" {
    try cases.check(std.testing.allocator, .duplicate_identity);
}

test "lock parser rejects range" {
    try cases.check(std.testing.allocator, .range);
}

test "lock parser rejects target name" {
    try cases.check(std.testing.allocator, .target_name);
}

test "lock parser rejects archive development" {
    try cases.check(std.testing.allocator, .archive_development);
}

test "lock parser rejects archive workspace" {
    try cases.check(std.testing.allocator, .archive_workspace);
}

test "lock parser rejects cycle" {
    try cases.check(std.testing.allocator, .cycle);
}

test "lock parser rejects truncated" {
    try cases.check(std.testing.allocator, .truncated);
}
