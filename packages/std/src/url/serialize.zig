const std = @import("std");
const Url = @import("model.zig").Url;

pub fn serialize(allocator: std.mem.Allocator, url: Url, exclude_fragment: bool) ![]const u8 {
    var output: std.ArrayList(u8) = .empty;

    errdefer output.deinit(allocator);

    try output.appendSlice(allocator, url.scheme);
    try output.append(allocator, ':');

    if (url.host) |host| {
        try output.appendSlice(allocator, "//");

        if (url.username.len != 0 or url.password.len != 0) {
            try output.appendSlice(allocator, url.username);

            if (url.password.len != 0) {
                try output.append(allocator, ':');
                try output.appendSlice(allocator, url.password);
            }

            try output.append(allocator, '@');
        }

        try output.appendSlice(allocator, host);

        if (url.port) |port| {
            var buffer: [6]u8 = undefined;

            try output.appendSlice(allocator, try std.fmt.bufPrint(&buffer, ":{d}", .{port}));
        }
    } else if (url.opaque_path == null and url.path.len > 1 and url.path[0].len == 0) {
        try output.appendSlice(allocator, "/.");
    }

    try appendPath(allocator, &output, url);

    if (url.query) |query| {
        try output.append(allocator, '?');
        try output.appendSlice(allocator, query);
    }

    if (!exclude_fragment) {
        if (url.fragment) |fragment| {
            try output.append(allocator, '#');
            try output.appendSlice(allocator, fragment);
        }
    }

    return output.toOwnedSlice(allocator);
}

pub fn path(allocator: std.mem.Allocator, url: Url) ![]const u8 {
    var output: std.ArrayList(u8) = .empty;

    errdefer output.deinit(allocator);

    try appendPath(allocator, &output, url);

    return output.toOwnedSlice(allocator);
}

fn appendPath(allocator: std.mem.Allocator, output: *std.ArrayList(u8), url: Url) !void {
    if (url.opaque_path) |value| {
        try output.appendSlice(allocator, value);
    } else {
        for (url.path) |segment| {
            try output.append(allocator, '/');
            try output.appendSlice(allocator, segment);
        }
    }
}
