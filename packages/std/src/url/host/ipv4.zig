const std = @import("std");

pub fn endsInNumber(input: []const u8) bool {
    const text = if (std.mem.endsWith(u8, input, ".")) input[0 .. input.len - 1] else input;
    const start = if (std.mem.lastIndexOfScalar(u8, text, '.')) |index| index + 1 else 0;
    const last = text[start..];

    if (last.len == 0) return false;

    for (last) |byte| {
        if (!std.ascii.isDigit(byte)) break;
    } else return true;

    return digits(last) != null;
}

pub fn parse(input: []const u8) !u32 {
    const text = if (std.mem.endsWith(u8, input, ".")) input[0 .. input.len - 1] else input;
    var parts = std.mem.splitScalar(u8, text, '.');
    var values: [4]u64 = undefined;
    var count: usize = 0;

    while (parts.next()) |part| {
        if (count == values.len) return error.InvalidIpv4;

        values[count] = try number(part);
        count += 1;
    }

    for (values[0 .. count - 1]) |value| {
        if (value > 255) return error.InvalidIpv4;
    }

    const bits: u6 = @intCast(8 * (5 - count));

    if (values[count - 1] >= @as(u64, 1) << bits) return error.InvalidIpv4;

    var result = values[count - 1];

    for (values[0 .. count - 1], 0..) |value, index| {
        result += value << @as(u6, @intCast(8 * (3 - index)));
    }

    return @intCast(result);
}

pub fn serialize(allocator: std.mem.Allocator, address: u32) ![]const u8 {
    return std.fmt.allocPrint(allocator, "{d}.{d}.{d}.{d}", .{ address >> 24, (address >> 16) & 255, (address >> 8) & 255, address & 255 });
}

const Digits = struct { text: []const u8, radix: u8 };

fn digits(input: []const u8) ?Digits {
    if (input.len == 0) return null;

    var result = Digits{ .text = input, .radix = 10 };

    if (input.len >= 2 and input[0] == '0') {
        if (input[1] == 'x' or input[1] == 'X') {
            result = .{ .text = input[2..], .radix = 16 };
        } else result = .{ .text = input[1..], .radix = 8 };
    }

    for (result.text) |byte| {
        _ = std.fmt.charToDigit(byte, result.radix) catch return null;
    }

    return result;
}

fn number(input: []const u8) !u64 {
    const parsed = digits(input) orelse return error.InvalidIpv4;
    var result: u64 = 0;

    for (parsed.text) |byte| {
        const digit = std.fmt.charToDigit(byte, parsed.radix) catch unreachable;
        const multiplied = @mulWithOverflow(result, parsed.radix);
        const added = @addWithOverflow(multiplied[0], digit);

        if (multiplied[1] != 0 or added[1] != 0) return error.InvalidIpv4;

        result = added[0];
    }

    return result;
}
