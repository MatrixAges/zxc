const std = @import("std");

pub fn convert(comptime Target: type, source: anytype) Target {
    inline for (@typeInfo(@TypeOf(source)).@"enum".field_names) |name| {
        if (source == @field(@TypeOf(source), name)) return @field(Target, pascal(name));
    }

    unreachable;
}

fn pascal(comptime name: []const u8) []const u8 {
    comptime var result: []const u8 = "";
    comptime var uppercase = true;

    inline for (name) |character| {
        if (character == '_') {
            uppercase = true;
        } else {
            result = result ++ .{if (uppercase) std.ascii.toUpper(character) else character};
            uppercase = false;
        }
    }

    return result;
}
