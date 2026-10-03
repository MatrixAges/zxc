const std = @import("std");
const Version = std.SemanticVersion;
const Partial = @This();

version: Version,
parts: u2,
pub fn parse(text: []const u8) error{InvalidRange}!Partial {
    if (text.len == 0) return error.InvalidRange;

    const end = std.mem.indexOfAny(u8, text, "-+") orelse text.len;
    var components = std.mem.splitScalar(u8, text[0..end], '.');
    var numbers = [_]usize{ 0, 0, 0 };
    var count: usize = 0;
    var parts: u2 = 0;
    var wildcard = false;

    while (components.next()) |component| {
        if (count == numbers.len or component.len == 0) return error.InvalidRange;

        if (std.mem.eql(u8, component, "*") or std.mem.eql(u8, component, "x") or std.mem.eql(u8, component, "X")) {
            wildcard = true;
        } else {
            if (wildcard or (component.len > 1 and component[0] == '0')) return error.InvalidRange;
            for (component) |byte| if (!std.ascii.isDigit(byte)) return error.InvalidRange;

            numbers[count] = std.fmt.parseUnsigned(usize, component, 10) catch return error.InvalidRange;
            parts += 1;
        }

        count += 1;
    }

    if (parts == 3) return .{ .version = Version.parse(text) catch return error.InvalidRange, .parts = 3 };
    if (end != text.len) return error.InvalidRange;

    return .{ .version = .{ .major = numbers[0], .minor = numbers[1], .patch = numbers[2] }, .parts = parts };
}

pub fn upper(self: Partial, component: u2) error{InvalidRange}!Version {
    var version = self.version;

    version.pre = "0";
    version.build = null;

    switch (component) {
        1 => {
            version.major = std.math.add(usize, version.major, 1) catch return error.InvalidRange;
            version.minor = 0;
            version.patch = 0;
        },
        2 => {
            version.minor = std.math.add(usize, version.minor, 1) catch return error.InvalidRange;
            version.patch = 0;
        },
        3 => version.patch = std.math.add(usize, version.patch, 1) catch return error.InvalidRange,
        0 => return error.InvalidRange,
    }

    return version;
}

pub fn allowsPrerelease(self: Partial, version: Version) bool {
    return self.version.pre != null and self.version.major == version.major and self.version.minor == version.minor and self.version.patch == version.patch;
}
