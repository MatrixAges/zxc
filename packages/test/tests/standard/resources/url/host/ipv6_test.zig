const std = @import("std");
const impl = @import("implementation");

fn check(input: []const u8, expected: []const u8) !void {
    const address = try impl.parse(input);
    const serialized = try impl.serialize(std.testing.allocator, address);

    defer std.testing.allocator.free(serialized);

    try std.testing.expectEqualStrings(expected, serialized);
    try std.testing.expectEqualSlices(u16, &address, &(try impl.parse(serialized)));
}

fn checkAllocation(allocator: std.mem.Allocator) !void {
    const serialized = try impl.serialize(allocator, .{ 0x1234, 0, 0, 0xabcd, 0, 0, 0, 1 });

    defer allocator.free(serialized);

    try std.testing.expectEqualStrings("1234:0:0:abcd::1", serialized);
}

test "IPv6 parses ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff" {
    try check("ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff", "ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff");
}

test "IPv6 parses ffff:ffff:ffff:ffff:ffff:ffff:255.255.255.255" {
    try check("ffff:ffff:ffff:ffff:ffff:ffff:255.255.255.255", "ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff");
}

test "IPv6 parses ::" {
    try check("::", "::");
}

test "IPv6 parses ::1" {
    try check("::1", "::1");
}

test "IPv6 parses 1::" {
    try check("1::", "1::");
}

test "IPv6 parses 1:2:3:4:5:6:7:8" {
    try check("1:2:3:4:5:6:7:8", "1:2:3:4:5:6:7:8");
}

test "IPv6 parses 0001:0002:0003:0004:0005:0006:0007:0008" {
    try check("0001:0002:0003:0004:0005:0006:0007:0008", "1:2:3:4:5:6:7:8");
}

test "IPv6 parses FFFF:ABCD:0:0:0:0:0:1" {
    try check("FFFF:ABCD:0:0:0:0:0:1", "ffff:abcd::1");
}

test "IPv6 parses 1:0:0:2:0:0:3:4" {
    try check("1:0:0:2:0:0:3:4", "1::2:0:0:3:4");
}

test "IPv6 parses 1:0:0:2:0:0:0:3" {
    try check("1:0:0:2:0:0:0:3", "1:0:0:2::3");
}

test "IPv6 parses 0:0:1:2:3:4:5:6" {
    try check("0:0:1:2:3:4:5:6", "::1:2:3:4:5:6");
}

test "IPv6 parses 1:2:3:4:5:6:0:0" {
    try check("1:2:3:4:5:6:0:0", "1:2:3:4:5:6::");
}

test "IPv6 parses 1:2:3:0:4:5:6:7" {
    try check("1:2:3:0:4:5:6:7", "1:2:3:0:4:5:6:7");
}

test "IPv6 parses 1:2:3::4:5:6:7" {
    try check("1:2:3::4:5:6:7", "1:2:3:0:4:5:6:7");
}

test "IPv6 parses ::ffff:192.0.2.128" {
    try check("::ffff:192.0.2.128", "::ffff:c000:280");
}

test "IPv6 parses 1:2:3:4:5:6:192.0.2.1" {
    try check("1:2:3:4:5:6:192.0.2.1", "1:2:3:4:5:6:c000:201");
}

test "IPv6 parses ::0.0.0.0" {
    try check("::0.0.0.0", "::");
}

test "IPv6 parses ::255.255.255.255" {
    try check("::255.255.255.255", "::ffff:ffff");
}

test "IPv6 parses ::ffff:0:192.0.2.1" {
    try check("::ffff:0:192.0.2.1", "::ffff:0:c000:201");
}

test "IPv6 rejects empty" {
    try std.testing.expectError(error.InvalidIpv6, impl.parse(""));
}

test "IPv6 rejects :" {
    try std.testing.expectError(error.InvalidIpv6, impl.parse(":"));
}

test "IPv6 rejects :::" {
    try std.testing.expectError(error.InvalidIpv6, impl.parse(":::"));
}

test "IPv6 rejects 1::2::3" {
    try std.testing.expectError(error.InvalidIpv6, impl.parse("1::2::3"));
}

test "IPv6 rejects 1:2:3:4:5:6:7" {
    try std.testing.expectError(error.InvalidIpv6, impl.parse("1:2:3:4:5:6:7"));
}

test "IPv6 rejects 1:2:3:4:5:6:7:8:9" {
    try std.testing.expectError(error.InvalidIpv6, impl.parse("1:2:3:4:5:6:7:8:9"));
}

test "IPv6 rejects 1:2:3:4:5:6:7:8::" {
    try std.testing.expectError(error.InvalidIpv6, impl.parse("1:2:3:4:5:6:7:8::"));
}

test "IPv6 rejects ::1:2:3:4:5:6:7:8" {
    try std.testing.expectError(error.InvalidIpv6, impl.parse("::1:2:3:4:5:6:7:8"));
}

test "IPv6 rejects 12345::" {
    try std.testing.expectError(error.InvalidIpv6, impl.parse("12345::"));
}

test "IPv6 rejects gggg::" {
    try std.testing.expectError(error.InvalidIpv6, impl.parse("gggg::"));
}

test "IPv6 rejects :1:2:3:4:5:6:7" {
    try std.testing.expectError(error.InvalidIpv6, impl.parse(":1:2:3:4:5:6:7"));
}

test "IPv6 rejects 1:2:3:4:5:6:7:" {
    try std.testing.expectError(error.InvalidIpv6, impl.parse("1:2:3:4:5:6:7:"));
}

test "IPv6 rejects [::1]" {
    try std.testing.expectError(error.InvalidIpv6, impl.parse("[::1]"));
}

test "IPv6 rejects fe80::1%eth0" {
    try std.testing.expectError(error.InvalidIpv6, impl.parse("fe80::1%eth0"));
}

test "IPv6 rejects ::192.168.00.1" {
    try std.testing.expectError(error.InvalidIpv6, impl.parse("::192.168.00.1"));
}

test "IPv6 rejects ::192.168.0.256" {
    try std.testing.expectError(error.InvalidIpv6, impl.parse("::192.168.0.256"));
}

test "IPv6 rejects ::192.168.1" {
    try std.testing.expectError(error.InvalidIpv6, impl.parse("::192.168.1"));
}

test "IPv6 rejects ::192.168.1.1.1" {
    try std.testing.expectError(error.InvalidIpv6, impl.parse("::192.168.1.1.1"));
}

test "IPv6 rejects ::0x7f.0.0.1" {
    try std.testing.expectError(error.InvalidIpv6, impl.parse("::0x7f.0.0.1"));
}

test "IPv6 rejects ::+1.0.0.1" {
    try std.testing.expectError(error.InvalidIpv6, impl.parse("::+1.0.0.1"));
}

test "IPv6 rejects 192.0.2.1::" {
    try std.testing.expectError(error.InvalidIpv6, impl.parse("192.0.2.1::"));
}

test "IPv6 rejects 1:2:3:4:5:6:7:192.0.2.1" {
    try std.testing.expectError(error.InvalidIpv6, impl.parse("1:2:3:4:5:6:7:192.0.2.1"));
}

test "IPv6 rejects ::192.0.2.1:1" {
    try std.testing.expectError(error.InvalidIpv6, impl.parse("::192.0.2.1:1"));
}

test "IPv6 rejects ::1.2..4" {
    try std.testing.expectError(error.InvalidIpv6, impl.parse("::1.2..4"));
}

test "IPv6 rejects ::1.2.3.-1" {
    try std.testing.expectError(error.InvalidIpv6, impl.parse("::1.2.3.-1"));
}

test "IPv6 rejects ::１" {
    try std.testing.expectError(error.InvalidIpv6, impl.parse("::１"));
}

test "IPv6 rejects  ::1" {
    try std.testing.expectError(error.InvalidIpv6, impl.parse(" ::1"));
}

test "IPv6 serialization allocation cleanup" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkAllocation, .{});
}

test "IPv6 every zero placement agrees with independent URL oracle" {
    for (@import("ipv6_masks.zig").cases) |entry| try check(entry.input, entry.expected);
}
