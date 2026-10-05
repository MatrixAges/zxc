const std = @import("std");
const allocation_testing = @import("allocation_testing");
const impl = @import("implementation");

fn check(input: []const u8, expected: []const u8) !void {
    const address = try impl.parse(input);
    const serialized = try impl.serialize(std.testing.allocator, address);

    defer std.testing.allocator.free(serialized);

    try std.testing.expectEqualStrings(expected, serialized);
    try std.testing.expectEqual(address, try impl.parse(serialized));
}

fn checkAllocation(allocator: std.mem.Allocator) !void {
    const serialized = try impl.serialize(allocator, 0x0102feff);

    defer allocator.free(serialized);

    try std.testing.expectEqualStrings("1.2.254.255", serialized);
}

test "IPv4 parses 0" {
    try check("0", "0.0.0.0");
}

test "IPv4 parses 0x" {
    try check("0x", "0.0.0.0");
}

test "IPv4 parses 0X" {
    try check("0X", "0.0.0.0");
}

test "IPv4 parses 00" {
    try check("00", "0.0.0.0");
}

test "IPv4 parses 1" {
    try check("1", "0.0.0.1");
}

test "IPv4 parses 256" {
    try check("256", "0.0.1.0");
}

test "IPv4 parses 65536" {
    try check("65536", "0.1.0.0");
}

test "IPv4 parses 16777216" {
    try check("16777216", "1.0.0.0");
}

test "IPv4 parses 4294967295" {
    try check("4294967295", "255.255.255.255");
}

test "IPv4 parses 0xffffffff" {
    try check("0xffffffff", "255.255.255.255");
}

test "IPv4 parses 037777777777" {
    try check("037777777777", "255.255.255.255");
}

test "IPv4 parses 127.1" {
    try check("127.1", "127.0.0.1");
}

test "IPv4 parses 1.2.3" {
    try check("1.2.3", "1.2.0.3");
}

test "IPv4 parses 1.2.65535" {
    try check("1.2.65535", "1.2.255.255");
}

test "IPv4 parses 1.16777215" {
    try check("1.16777215", "1.255.255.255");
}

test "IPv4 parses 127.0.0.1." {
    try check("127.0.0.1.", "127.0.0.1");
}

test "IPv4 parses 0177.0.0.1" {
    try check("0177.0.0.1", "127.0.0.1");
}

test "IPv4 parses 0x7f.0X0.0x0.0X1" {
    try check("0x7f.0X0.0x0.0X1", "127.0.0.1");
}

test "IPv4 parses 255.255.255.255" {
    try check("255.255.255.255", "255.255.255.255");
}

test "IPv4 parses 000000000000000000000000001" {
    try check("000000000000000000000000001", "0.0.0.1");
}

test "IPv4 parses 1.0x" {
    try check("1.0x", "1.0.0.0");
}

test "IPv4 parses 000.000.000.000" {
    try check("000.000.000.000", "0.0.0.0");
}

test "IPv4 rejects empty" {
    try std.testing.expectError(error.InvalidIpv4, impl.parse(""));
}

test "IPv4 rejects ." {
    try std.testing.expectError(error.InvalidIpv4, impl.parse("."));
}

test "IPv4 rejects .." {
    try std.testing.expectError(error.InvalidIpv4, impl.parse(".."));
}

test "IPv4 rejects 1..2" {
    try std.testing.expectError(error.InvalidIpv4, impl.parse("1..2"));
}

test "IPv4 rejects 1.2.3.4.5" {
    try std.testing.expectError(error.InvalidIpv4, impl.parse("1.2.3.4.5"));
}

test "IPv4 rejects 1.2.3.4.." {
    try std.testing.expectError(error.InvalidIpv4, impl.parse("1.2.3.4.."));
}

test "IPv4 rejects 256.0.0.1" {
    try std.testing.expectError(error.InvalidIpv4, impl.parse("256.0.0.1"));
}

test "IPv4 rejects 1.256.0.1" {
    try std.testing.expectError(error.InvalidIpv4, impl.parse("1.256.0.1"));
}

test "IPv4 rejects 1.2.256.1" {
    try std.testing.expectError(error.InvalidIpv4, impl.parse("1.2.256.1"));
}

test "IPv4 rejects 1.2.3.256" {
    try std.testing.expectError(error.InvalidIpv4, impl.parse("1.2.3.256"));
}

test "IPv4 rejects 1.2.65536" {
    try std.testing.expectError(error.InvalidIpv4, impl.parse("1.2.65536"));
}

test "IPv4 rejects 1.16777216" {
    try std.testing.expectError(error.InvalidIpv4, impl.parse("1.16777216"));
}

test "IPv4 rejects 4294967296" {
    try std.testing.expectError(error.InvalidIpv4, impl.parse("4294967296"));
}

test "IPv4 rejects 0x100000000" {
    try std.testing.expectError(error.InvalidIpv4, impl.parse("0x100000000"));
}

test "IPv4 rejects 040000000000" {
    try std.testing.expectError(error.InvalidIpv4, impl.parse("040000000000"));
}

test "IPv4 rejects 18446744073709551616" {
    try std.testing.expectError(error.InvalidIpv4, impl.parse("18446744073709551616"));
}

test "IPv4 rejects 0xFFFFFFFFFFFFFFFFF" {
    try std.testing.expectError(error.InvalidIpv4, impl.parse("0xFFFFFFFFFFFFFFFFF"));
}

test "IPv4 rejects 09" {
    try std.testing.expectError(error.InvalidIpv4, impl.parse("09"));
}

test "IPv4 rejects 078" {
    try std.testing.expectError(error.InvalidIpv4, impl.parse("078"));
}

test "IPv4 rejects 0xg" {
    try std.testing.expectError(error.InvalidIpv4, impl.parse("0xg"));
}

test "IPv4 rejects 1.2.3.-1" {
    try std.testing.expectError(error.InvalidIpv4, impl.parse("1.2.3.-1"));
}

test "IPv4 rejects +1" {
    try std.testing.expectError(error.InvalidIpv4, impl.parse("+1"));
}

test "IPv4 rejects 1_0" {
    try std.testing.expectError(error.InvalidIpv4, impl.parse("1_0"));
}

test "IPv4 rejects １" {
    try std.testing.expectError(error.InvalidIpv4, impl.parse("１"));
}

test "IPv4 rejects 0b10" {
    try std.testing.expectError(error.InvalidIpv4, impl.parse("0b10"));
}

test "IPv4 rejects 1.2.3. 4" {
    try std.testing.expectError(error.InvalidIpv4, impl.parse("1.2.3. 4"));
}

test "IPv4 numeric suffix example.1" {
    try std.testing.expect(impl.endsInNumber("example.1"));
}

test "IPv4 numeric suffix example.09" {
    try std.testing.expect(impl.endsInNumber("example.09"));
}

test "IPv4 numeric suffix example.0x" {
    try std.testing.expect(impl.endsInNumber("example.0x"));
}

test "IPv4 numeric suffix example.0XFF." {
    try std.testing.expect(impl.endsInNumber("example.0XFF."));
}

test "IPv4 numeric suffix 1" {
    try std.testing.expect(impl.endsInNumber("1"));
}

test "IPv4 numeric suffix 0x" {
    try std.testing.expect(impl.endsInNumber("0x"));
}

test "IPv4 numeric suffix foo.0xffffffffffffffffffffffffffffffffffff" {
    try std.testing.expect(impl.endsInNumber("foo.0xffffffffffffffffffffffffffffffffffff"));
}

test "IPv4 nonnumeric suffix empty" {
    try std.testing.expect(!impl.endsInNumber(""));
}

test "IPv4 nonnumeric suffix foo." {
    try std.testing.expect(!impl.endsInNumber("foo."));
}

test "IPv4 nonnumeric suffix foo.." {
    try std.testing.expect(!impl.endsInNumber("foo.."));
}

test "IPv4 nonnumeric suffix foo.0xg" {
    try std.testing.expect(!impl.endsInNumber("foo.0xg"));
}

test "IPv4 nonnumeric suffix foo.1e2" {
    try std.testing.expect(!impl.endsInNumber("foo.1e2"));
}

test "IPv4 nonnumeric suffix foo.0b1" {
    try std.testing.expect(!impl.endsInNumber("foo.0b1"));
}

test "IPv4 nonnumeric suffix foo.+1" {
    try std.testing.expect(!impl.endsInNumber("foo.+1"));
}

test "IPv4 nonnumeric suffix foo.１" {
    try std.testing.expect(!impl.endsInNumber("foo.１"));
}

test "IPv4 serialization allocation cleanup" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, checkAllocation, .{});
}
