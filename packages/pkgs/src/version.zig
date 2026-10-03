const std = @import("std");
const Partial = @import("version/partial.zig");
const Version = std.SemanticVersion;

pub fn matches(text: []const u8, version: Version) error{InvalidRange}!bool {
    var alternatives = std.mem.splitSequence(u8, text, "||");
    var matched = false;

    while (alternatives.next()) |clause| {
        const result = try matchesSet(std.mem.trim(u8, clause, " \t\r\n"), version);

        matched = matched or result;
    }

    return matched;
}

fn matchesSet(text: []const u8, version: Version) error{InvalidRange}!bool {
    if (text.len == 0) return error.InvalidRange;

    var tokens = std.mem.tokenizeAny(u8, text, " \t\r\n");
    const first = tokens.next().?;
    var probe = tokens;

    if (probe.next()) |second| {
        if (std.mem.eql(u8, second, "-")) {
            const right = try Partial.parse(probe.next() orelse return error.InvalidRange);
            const left = try Partial.parse(first);

            if (probe.next() != null) return error.InvalidRange;

            const lower = left.parts == 0 or version.order(left.version) != .lt;
            const upper = right.parts == 0 or if (right.parts == 3) version.order(right.version) != .gt else version.order(try right.upper(right.parts)) == .lt;

            return lower and upper and (version.pre == null or left.allowsPrerelease(version) or right.allowsPrerelease(version));
        }
    }

    tokens.reset();

    var matched = true;
    var prerelease = version.pre == null;

    while (tokens.next()) |token| {
        const end = for (token, 0..) |byte, index| {
            if (std.mem.indexOfScalar(u8, "<>=~^", byte) == null) break index;
        } else token.len;

        const operator = token[0..end];
        const operand = if (end == token.len) tokens.next() orelse return error.InvalidRange else token[end..];
        const partial = try Partial.parse(operand);
        const result = try compare(operator, partial, version);
        matched = matched and result;
        prerelease = prerelease or partial.allowsPrerelease(version);
    }

    return matched and prerelease;
}

fn compare(operator: []const u8, partial: Partial, version: Version) error{InvalidRange}!bool {
    const order = version.order(partial.version);

    if (operator.len == 0 or std.mem.eql(u8, operator, "=")) {
        return partial.parts == 0 or if (partial.parts == 3) order == .eq else order != .lt and version.order(try partial.upper(partial.parts)) == .lt;
    }

    if (std.mem.eql(u8, operator, ">=")) return partial.parts == 0 or order != .lt;

    if (std.mem.eql(u8, operator, "<")) {
        var limit = partial.version;

        if (partial.parts < 3) limit.pre = "0";

        return partial.parts != 0 and version.order(limit) == .lt;
    }

    if (std.mem.eql(u8, operator, ">")) {
        if (partial.parts == 0) return false;
        if (partial.parts == 3) return order == .gt;

        var limit = try partial.upper(partial.parts);

        limit.pre = null;

        return version.order(limit) != .lt;
    }

    if (std.mem.eql(u8, operator, "<=")) return partial.parts == 0 or if (partial.parts == 3) order != .gt else version.order(try partial.upper(partial.parts)) == .lt;

    if (std.mem.eql(u8, operator, "~") or std.mem.eql(u8, operator, "^")) {
        if (partial.parts == 0) return true;

        const component: u2 = if (operator[0] == '~') @min(partial.parts, 2) else if (partial.version.major != 0 or partial.parts == 1) 1 else if (partial.version.minor != 0 or partial.parts == 2) 2 else 3;

        return order != .lt and version.order(try partial.upper(component)) == .lt;
    }

    return error.InvalidRange;
}
