const std = @import("std");

pub fn parse(input: []const u8) ![8]u16 {
    var result: [8]u16 = @splat(0);

    if (std.mem.indexOf(u8, input, "::")) |split| {
        if (std.mem.indexOf(u8, input[split + 2 ..], "::") != null) return error.InvalidIpv6;

        const left = try pieces(input[0..split], &result, false);
        var tail: [8]u16 = undefined;
        const right = try pieces(input[split + 2 ..], &tail, true);

        if (left + right >= result.len) return error.InvalidIpv6;

        @memcpy(result[result.len - right ..], tail[0..right]);
    } else if (try pieces(input, &result, true) != result.len) return error.InvalidIpv6;

    return result;
}

pub fn serialize(allocator: std.mem.Allocator, address: [8]u16) std.mem.Allocator.Error![]const u8 {
    var best_start: usize = 0;
    var best_length: usize = 0;
    var index: usize = 0;

    while (index < address.len) {
        const start = index;

        while (index < address.len and address[index] == 0) : (index += 1) {}

        if (index - start > best_length) {
            best_start = start;
            best_length = index - start;
        }

        if (index == start) index += 1;
    }

    var buffer: [8 * 4 + 7]u8 = undefined;
    var output: std.Io.Writer = .fixed(&buffer);
    index = 0;

    while (index < address.len) : (index += 1) {
        if (best_length >= 2 and index == best_start) {
            output.writeAll("::") catch unreachable;

            index += best_length - 1;

            continue;
        }

        if (index != 0 and !(best_length >= 2 and index == best_start + best_length)) output.writeByte(':') catch unreachable;

        output.print("{x}", .{address[index]}) catch unreachable;
    }

    return allocator.dupe(u8, output.buffered());
}

fn pieces(input: []const u8, output: *[8]u16, allow_ipv4: bool) !usize {
    if (input.len == 0) return 0;

    var parts = std.mem.splitScalar(u8, input, ':');
    var count: usize = 0;

    while (parts.next()) |part| {
        if (count == output.len or part.len == 0) return error.InvalidIpv6;

        if (std.mem.indexOfScalar(u8, part, '.') != null) {
            if (!allow_ipv4 or count > 6 or parts.next() != null) return error.InvalidIpv6;

            var bytes: [4]u8 = undefined;
            var dotted = std.mem.splitScalar(u8, part, '.');

            for (&bytes) |*byte| {
                const digits = dotted.next() orelse return error.InvalidIpv6;

                if (digits.len == 0 or digits.len > 3 or (digits.len > 1 and digits[0] == '0')) return error.InvalidIpv6;
                for (digits) |digit| if (!std.ascii.isDigit(digit)) return error.InvalidIpv6;

                byte.* = std.fmt.parseInt(u8, digits, 10) catch return error.InvalidIpv6;
            }

            if (dotted.next() != null) return error.InvalidIpv6;

            output[count] = @as(u16, bytes[0]) << 8 | bytes[1];
            output[count + 1] = @as(u16, bytes[2]) << 8 | bytes[3];

            return count + 2;
        }

        if (part.len > 4) return error.InvalidIpv6;
        for (part) |digit| if (!std.ascii.isHex(digit)) return error.InvalidIpv6;

        output[count] = std.fmt.parseInt(u16, part, 16) catch return error.InvalidIpv6;
        count += 1;
    }

    return count;
}
