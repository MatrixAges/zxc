const std = @import("std");
const allocation_testing = @import("allocation_testing");
const impl = @import("implementation");

fn checkEncode(set: impl.Set, expected: []const u8) !void {
    var input: [95]u8 = undefined;

    for (&input, 32..) |*byte, value| byte.* = @intCast(value);

    const output = try impl.encode(std.testing.allocator, &input, set);

    defer std.testing.allocator.free(output);

    try std.testing.expectEqualStrings(expected, output);
}

fn checkDecode(input: []const u8, expected: []const u8) !void {
    const output = try impl.decode(std.testing.allocator, input);

    defer std.testing.allocator.free(output);

    try std.testing.expectEqualStrings(expected, output);
}

fn checkAllocation(allocator: std.mem.Allocator, decode: bool) !void {
    const output = if (decode)
        try impl.decode(allocator, "%00%7f%80%FF%E4%B8%AD%G1+%")
    else
        try impl.encode(allocator, "\x00\x7f\x80\xff中 +%", .component);

    defer allocator.free(output);

    try std.testing.expectEqualStrings(if (decode) "\x00\x7f\x80\xff中%G1+%" else "%00%7F%80%FF%E4%B8%AD%20%2B%25", output);
}

test "percent printable ASCII control" {
    try checkEncode(.control, " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~");
}

test "percent printable ASCII fragment" {
    try checkEncode(.fragment, "%20!%22#$%&'()*+,-./0123456789:;%3C=%3E?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_%60abcdefghijklmnopqrstuvwxyz{|}~");
}

test "percent printable ASCII query" {
    try checkEncode(.query, "%20!%22%23$%&'()*+,-./0123456789:;%3C=%3E?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~");
}

test "percent printable ASCII special_query" {
    try checkEncode(.special_query, "%20!%22%23$%&%27()*+,-./0123456789:;%3C=%3E?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~");
}

test "percent printable ASCII path" {
    try checkEncode(.path, "%20!%22%23$%&'()*+,-./0123456789:;%3C=%3E%3F@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]%5E_%60abcdefghijklmnopqrstuvwxyz%7B|%7D~");
}

test "percent printable ASCII userinfo" {
    try checkEncode(.userinfo, "%20!%22%23$%&'()*+,-.%2F0123456789%3A%3B%3C%3D%3E%3F%40ABCDEFGHIJKLMNOPQRSTUVWXYZ%5B%5C%5D%5E_%60abcdefghijklmnopqrstuvwxyz%7B%7C%7D~");
}

test "percent printable ASCII component" {
    try checkEncode(.component, "%20!%22%23%24%25%26'()*%2B%2C-.%2F0123456789%3A%3B%3C%3D%3E%3F%40ABCDEFGHIJKLMNOPQRSTUVWXYZ%5B%5C%5D%5E_%60abcdefghijklmnopqrstuvwxyz%7B%7C%7D~");
}

test "percent decode empty" {
    try checkDecode("", "");
}

test "percent decode hex case" {
    try checkDecode("%4a%4A", "JJ");
}

test "percent decode single pass" {
    try checkDecode("%252F", "%2F");
}

test "percent decode invalid hex" {
    try checkDecode("%G0%0G%GG", "%G0%0G%GG");
}

test "percent decode trailing escape" {
    try checkDecode("x%a%", "x%a%");
}

test "percent decode plus unchanged" {
    try checkDecode("+%2B%20", "++ ");
}

test "percent decode literal percent" {
    try checkDecode("%%41", "%A");
}

test "percent decode unicode" {
    try checkDecode("中%E6%96%87", "中文");
}

test "percent decode NUL" {
    try checkDecode("a%00b", "a\x00b");
}

test "percent decode WHATWG malformed escapes" {
    try checkDecode("%25%s%1G", "%%s%1G");
}

test "percent all byte values use uppercase component escapes and roundtrip" {
    var input: [256]u8 = undefined;

    for (&input, 0..) |*byte, value| byte.* = @intCast(value);

    const encoded = try impl.encode(std.testing.allocator, &input, .component);

    defer std.testing.allocator.free(encoded);

    const decoded = try impl.decode(std.testing.allocator, encoded);

    defer std.testing.allocator.free(decoded);

    try std.testing.expectEqualSlices(u8, &input, decoded);
    try std.testing.expect(std.mem.indexOf(u8, encoded, "%7F%80%81") != null);
    try std.testing.expect(std.mem.endsWith(u8, encoded, "%FE%FF"));
}

test "percent controls and high bytes encode for every set" {
    inline for (std.meta.tags(impl.Set)) |set| {
        const encoded = try impl.encode(std.testing.allocator, "\x00\x1f\x7f\xff中", set);

        defer std.testing.allocator.free(encoded);

        try std.testing.expectEqualStrings("%00%1F%7F%FF%E4%B8%AD", encoded);
    }
}

test "percent encode releases partial allocations" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, checkAllocation, .{false});
}

test "percent decode releases partial allocations" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, checkAllocation, .{true});
}
