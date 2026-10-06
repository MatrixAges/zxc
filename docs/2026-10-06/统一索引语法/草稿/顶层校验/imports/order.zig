const std = @import("std");

pub fn category(item: anytype) u8 {
    const path = item.path;
    const kind: u8 = if (std.mem.startsWith(u8, path, "std:")) 0 else if (std.mem.startsWith(u8, path, "zig:")) 1 else if (std.mem.startsWith(u8, path, "c:")) 2 else if (std.mem.startsWith(u8, path, "@/")) 4 else if (std.mem.startsWith(u8, path, "./") or std.mem.startsWith(u8, path, "../")) 6 else 3;

    return kind + (if (item.kind == .type_only) @as(u8, 7) else 0);
}

pub fn group(item: anytype) u8 {
    const value = category(item);

    return if (value >= 7) 3 else if (value >= 6) 2 else if (value >= 4) 1 else 0;
}

pub fn lessThan(_: void, left: anytype, right: @TypeOf(left)) bool {
    const a = category(left);
    const b = category(right);

    if (a != b) return a < b;

    return switch (std.mem.order(u8, left.path, right.path)) {
        .lt => true,
        .gt => false,
        .eq => left.span.start < right.span.start,
    };
}
