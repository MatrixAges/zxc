const std = @import("std");

pub fn encode(allocator: std.mem.Allocator, input: []const u21) ![]const u8 {
    var output: std.ArrayList(u8) = .empty;

    errdefer output.deinit(allocator);

    for (input) |point| {
        if (!scalar(point)) return error.InvalidPunycode;
        if (point < 128) try output.append(allocator, @intCast(point));
    }

    const basic = output.items.len;
    var handled: u64 = basic;
    var next: u64 = 128;
    var delta: u64 = 0;
    var bias: u64 = 72;

    if (basic != 0) try output.append(allocator, '-');

    while (handled < input.len) {
        var minimum: u64 = 0x110000;

        for (input) |point| {
            if (point >= next) minimum = @min(minimum, point);
        }

        delta = try add(delta, try multiply(minimum - next, handled + 1));
        next = minimum;

        for (input) |point| {
            if (point < next) delta = try add(delta, 1);
            if (point != next) continue;

            var remaining = delta;
            var weight: u64 = 36;

            while (true) : (weight += 36) {
                const threshold = limit(weight, bias);

                if (remaining < threshold) break;
                try output.append(allocator, digit(threshold + (remaining - threshold) % (36 - threshold)));

                remaining = (remaining - threshold) / (36 - threshold);
            }

            try output.append(allocator, digit(remaining));

            bias = adapt(delta, handled + 1, handled == basic);
            delta = 0;
            handled += 1;
        }

        delta = try add(delta, 1);
        next += 1;
    }

    return output.toOwnedSlice(allocator);
}

pub fn decode(allocator: std.mem.Allocator, input: []const u8) ![]const u21 {
    var output: std.ArrayList(u21) = .empty;

    errdefer output.deinit(allocator);

    var position: usize = 0;

    if (std.mem.lastIndexOfScalar(u8, input, '-')) |delimiter| {
        for (input[0..delimiter]) |byte| {
            if (byte >= 128) return error.InvalidPunycode;
            try output.append(allocator, byte);
        }

        position = delimiter + 1;
    }

    var next: u64 = 128;
    var index: u64 = 0;
    var bias: u64 = 72;

    while (position < input.len) {
        const previous = index;
        var factor: u64 = 1;
        var weight: u64 = 36;

        while (true) : (weight += 36) {
            if (position == input.len) return error.InvalidPunycode;

            const value = std.fmt.charToDigit(input[position], 36) catch return error.InvalidPunycode;
            const decoded: u64 = if (value < 10) value + 26 else value - 10;
            position += 1;
            index = try add(index, try multiply(decoded, factor));

            const threshold = limit(weight, bias);

            if (decoded < threshold) break;

            factor = try multiply(factor, 36 - threshold);
        }

        const length = try add(output.items.len, 1);

        bias = adapt(index - previous, length, previous == 0);
        next = try add(next, index / length);
        index %= length;

        if (!scalar(next)) return error.InvalidPunycode;

        try output.insert(allocator, @intCast(index), @intCast(next));

        index += 1;
    }

    return output.toOwnedSlice(allocator);
}

fn scalar(point: u64) bool {
    return point <= 0x10ffff and (point < 0xd800 or point > 0xdfff);
}

fn limit(weight: u64, bias: u64) u64 {
    if (weight <= bias) return 1;

    return @min(weight - bias, 26);
}

fn adapt(original: u64, points: u64, first: bool) u64 {
    var delta = original / @as(u64, if (first) 700 else 2);

    delta += delta / points;

    var weight: u64 = 0;

    while (delta > 455) {
        delta /= 35;
        weight += 36;
    }

    return weight + 36 * delta / (delta + 38);
}

fn digit(value: u64) u8 {
    return @intCast(if (value < 26) 'a' + value else '0' + value - 26);
}

fn add(left: u64, right: u64) !u64 {
    return std.math.add(u64, left, right) catch error.InvalidPunycode;
}

fn multiply(left: u64, right: u64) !u64 {
    return std.math.mul(u64, left, right) catch error.InvalidPunycode;
}
