from pathlib import Path
import json

root = Path(__file__).resolve().parents[3]
target = root / 'packages/test/tests/standard/resources/url'

def quote(value):
    return '"' + ''.join({'"': '\\"', '\\': '\\\\', '\n': '\\n', '\r': '\\r', '\t': '\\t'}.get(c, f'\\x{ord(c):02x}' if ord(c) < 32 or ord(c) == 127 else c) for c in value) + '"'

def test(name, body):
    return f'\ntest {quote(name)} {{\n    {body}\n}}\n'

prefix = 'const std = @import("std");\nconst allocation_testing = @import("allocation_testing");\nconst impl = @import("implementation");\n'
printable = ''.join(chr(value) for value in range(32, 127))
sets = {
    'control': '',
    'fragment': ' "<>`',
    'query': ' "#<>',
    'special_query': ' "#<>\'',
    'path': ' "#<>?^`{}',
    'userinfo': ' "#<>?^`{}/:;=@[\\]|',
    'component': ' "#<>?^`{}/:;=@[\\]|$%&+,'
}
percent = prefix + '''
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
        try impl.encode(allocator, "\\x00\\x7f\\x80\\xff中 +%", .component);

    defer allocator.free(output);

    try std.testing.expectEqualStrings(if (decode) "\\x00\\x7f\\x80\\xff中%G1+%" else "%00%7F%80%FF%E4%B8%AD%20%2B%25", output);
}
'''
for name, encoded in sets.items():
    expected = ''.join(f'%{ord(c):02X}' if c in encoded else c for c in printable)
    percent += test('percent printable ASCII ' + name, f'try checkEncode(.{name}, {quote(expected)});')
for name, value, expected in [
 ('empty', '', ''), ('hex case', '%4a%4A', 'JJ'), ('single pass', '%252F', '%2F'),
 ('invalid hex', '%G0%0G%GG', '%G0%0G%GG'), ('trailing escape', 'x%a%', 'x%a%'),
 ('plus unchanged', '+%2B%20', '++ '), ('literal percent', '%%41', '%A'),
 ('unicode', '中%E6%96%87', '中文'), ('NUL', 'a%00b', 'a\x00b'),
 ('WHATWG malformed escapes', '%25%s%1G', '%%s%1G')
]:
    percent += test('percent decode ' + name, f'try checkDecode({quote(value)}, {quote(expected)});')
percent += '''
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
        const encoded = try impl.encode(std.testing.allocator, "\\x00\\x1f\\x7f\\xff中", set);

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
'''
(target / 'percent_test.zig').write_text(percent)

ipv4_valid = [
 ('0', '0.0.0.0'), ('0x', '0.0.0.0'), ('0X', '0.0.0.0'), ('00', '0.0.0.0'),
 ('1', '0.0.0.1'), ('256', '0.0.1.0'), ('65536', '0.1.0.0'), ('16777216', '1.0.0.0'),
 ('4294967295', '255.255.255.255'), ('0xffffffff', '255.255.255.255'), ('037777777777', '255.255.255.255'),
 ('127.1', '127.0.0.1'), ('1.2.3', '1.2.0.3'), ('1.2.65535', '1.2.255.255'), ('1.16777215', '1.255.255.255'),
 ('127.0.0.1.', '127.0.0.1'), ('0177.0.0.1', '127.0.0.1'), ('0x7f.0X0.0x0.0X1', '127.0.0.1'),
 ('255.255.255.255', '255.255.255.255'), ('000000000000000000000000001', '0.0.0.1'),
 ('1.0x', '1.0.0.0'), ('000.000.000.000', '0.0.0.0')
]
ipv4_invalid = ['', '.', '..', '1..2', '1.2.3.4.5', '1.2.3.4..', '256.0.0.1', '1.256.0.1', '1.2.256.1', '1.2.3.256', '1.2.65536', '1.16777216', '4294967296', '0x100000000', '040000000000', '18446744073709551616', '0xFFFFFFFFFFFFFFFFF', '09', '078', '0xg', '1.2.3.-1', '+1', '1_0', '１', '0b10', '1.2.3. 4']
ipv4 = prefix + '''
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
'''
for value, expected in ipv4_valid:
    ipv4 += test('IPv4 parses ' + value, f'try check({quote(value)}, {quote(expected)});')
for value in ipv4_invalid:
    ipv4 += test('IPv4 rejects ' + (value or 'empty'), f'try std.testing.expectError(error.InvalidIpv4, impl.parse({quote(value)}));')
for value in ['example.1', 'example.09', 'example.0x', 'example.0XFF.', '1', '0x', 'foo.0xffffffffffffffffffffffffffffffffffff']:
    ipv4 += test('IPv4 numeric suffix ' + value, f'try std.testing.expect(impl.endsInNumber({quote(value)}));')
for value in ['', 'foo.', 'foo..', 'foo.0xg', 'foo.1e2', 'foo.0b1', 'foo.+1', 'foo.１']:
    ipv4 += test('IPv4 nonnumeric suffix ' + (value or 'empty'), f'try std.testing.expect(!impl.endsInNumber({quote(value)}));')
ipv4 += test('IPv4 serialization allocation cleanup', 'try allocation_testing.checkAllAllocationFailures(std.testing.allocator, checkAllocation, .{});')
(target / 'host/ipv4_test.zig').write_text(ipv4)

ipv6_valid = [
 ('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff', 'ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff'),
 ('ffff:ffff:ffff:ffff:ffff:ffff:255.255.255.255', 'ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff'),
 ('::', '::'), ('::1', '::1'), ('1::', '1::'), ('1:2:3:4:5:6:7:8', '1:2:3:4:5:6:7:8'),
 ('0001:0002:0003:0004:0005:0006:0007:0008', '1:2:3:4:5:6:7:8'),
 ('FFFF:ABCD:0:0:0:0:0:1', 'ffff:abcd::1'), ('1:0:0:2:0:0:3:4', '1::2:0:0:3:4'),
 ('1:0:0:2:0:0:0:3', '1:0:0:2::3'), ('0:0:1:2:3:4:5:6', '::1:2:3:4:5:6'),
 ('1:2:3:4:5:6:0:0', '1:2:3:4:5:6::'), ('1:2:3:0:4:5:6:7', '1:2:3:0:4:5:6:7'),
 ('1:2:3::4:5:6:7', '1:2:3:0:4:5:6:7'), ('::ffff:192.0.2.128', '::ffff:c000:280'),
 ('1:2:3:4:5:6:192.0.2.1', '1:2:3:4:5:6:c000:201'), ('::0.0.0.0', '::'),
 ('::255.255.255.255', '::ffff:ffff'), ('::ffff:0:192.0.2.1', '::ffff:0:c000:201')
]
ipv6_invalid = ['', ':', ':::','1::2::3', '1:2:3:4:5:6:7', '1:2:3:4:5:6:7:8:9', '1:2:3:4:5:6:7:8::', '::1:2:3:4:5:6:7:8', '12345::', 'gggg::', ':1:2:3:4:5:6:7', '1:2:3:4:5:6:7:', '[::1]', 'fe80::1%eth0', '::192.168.00.1', '::192.168.0.256', '::192.168.1', '::192.168.1.1.1', '::0x7f.0.0.1', '::+1.0.0.1', '192.0.2.1::', '1:2:3:4:5:6:7:192.0.2.1', '::192.0.2.1:1', '::1.2..4', '::1.2.3.-1', '::１', ' ::1']
ipv6 = prefix + '''
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
'''
for value, expected in ipv6_valid:
    ipv6 += test('IPv6 parses ' + value, f'try check({quote(value)}, {quote(expected)});')
for value in ipv6_invalid:
    ipv6 += test('IPv6 rejects ' + (value or 'empty'), f'try std.testing.expectError(error.InvalidIpv6, impl.parse({quote(value)}));')
ipv6 += test('IPv6 serialization allocation cleanup', 'try allocation_testing.checkAllAllocationFailures(std.testing.allocator, checkAllocation, .{});')
ipv6 += test('IPv6 every zero placement agrees with independent URL oracle', 'for (@import("ipv6_masks.zig").cases) |entry| try check(entry.input, entry.expected);')
(target / 'host/ipv6_test.zig').write_text(ipv6)
Path(__file__).with_name('IP预期.json').write_text(json.dumps({'ipv4': ipv4_valid, 'ipv4_invalid': ipv4_invalid, 'ipv6': ipv6_valid, 'ipv6_invalid': ipv6_invalid}, ensure_ascii=False, indent=2) + '\n')
