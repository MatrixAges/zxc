const std = @import("std");
const f = @import("fixture.zig");

test "native namespace rejects empty members at every path position" {
    try f.invalid("");
}

test "native namespace rejects embedded NUL at every path position" {
    try f.invalid("api\x00hidden");
}

test "native namespace rejects truncated UTF8 sequences at every path position" {
    for ([_][]const u8{ "\xc2", "\xe2\x82", "\xf0\x9f\x99" }) |bytes| try f.invalid(bytes);
}

test "native namespace rejects stray and invalid continuation bytes" {
    for ([_][]const u8{ "\x80", "\xbf", "\xe2a\xac" }) |bytes| try f.invalid(bytes);
}

test "native namespace rejects overlong UTF8 encodings" {
    for ([_][]const u8{ "\xc0\xaf", "\xe0\x80\xaf", "\xf0\x80\x80\xaf" }) |bytes| try f.invalid(bytes);
}

test "native namespace rejects UTF8 surrogate code points" {
    for ([_][]const u8{ "\xed\xa0\x80", "\xed\xbf\xbf" }) |bytes| try f.invalid(bytes);
}

test "native namespace rejects code points beyond the Unicode limit" {
    for ([_][]const u8{ "\xf4\x90\x80\x80", "\xf5\x80\x80\x80", "\xff" }) |bytes| try f.invalid(bytes);
}

test "native namespace accepts the empty member path" {
    try f.check(std.testing.allocator, .{});
}

test "native namespace accepts nested ASCII members" {
    try f.check(std.testing.allocator, .{ .namespace = &.{ "outer", "middle", "inner" } });
}

test "native namespace accepts two byte UTF8 member names" {
    try f.check(std.testing.allocator, .{ .namespace = &.{"\xc2\xa2"} });
}

test "native namespace accepts three byte UTF8 member names" {
    try f.check(std.testing.allocator, .{ .namespace = &.{"\xe4\xb8\xad"} });
}

test "native namespace accepts four byte UTF8 member names" {
    try f.check(std.testing.allocator, .{ .namespace = &.{"\xf0\x9f\x99\x82"} });
}

test "native namespace accepts punctuation as one quoted member" {
    try f.check(std.testing.allocator, .{ .namespace = &.{ "with space", "dotted.name", "api-unit" } });
}

test "native namespace accepts escaped quote and control characters without NUL" {
    try f.check(std.testing.allocator, .{ .namespace = &.{ "quoted\"name", "line\nbreak", "tab\tmember" } });
}

test "type only native namespaces accept valid Unicode metadata" {
    try f.check(std.testing.allocator, .{ .namespace = &.{ "outer", "\xf0\x9f\x99\x82" }, .type_only = true });
}
