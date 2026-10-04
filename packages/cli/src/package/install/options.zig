const std = @import("std");
const Options = @This();
pub const usage = "zxc pkg install [pkg.yaml] [--index index.json] [--offline] [--frozen-lockfile]\n";

path: []const u8 = "pkg.yaml",
index: ?[]const u8 = null,
offline: bool = false,
frozen: bool = false,
pub fn parse(args: []const []const u8) !Options {
    var result: Options = .{};
    var has_path = false;
    var index: usize = 0;

    while (index < args.len) : (index += 1) {
        const arg = args[index];

        if (std.mem.eql(u8, arg, "--offline")) {
            if (result.offline) return error.InvalidArguments;

            result.offline = true;
        } else if (std.mem.eql(u8, arg, "--frozen-lockfile")) {
            if (result.frozen) return error.InvalidArguments;

            result.frozen = true;
        } else if (std.mem.eql(u8, arg, "--index")) {
            if (result.index != null or index + 1 == args.len) return error.InvalidArguments;

            index += 1;
            result.index = args[index];

            if (result.index.?.len == 0 or std.mem.startsWith(u8, result.index.?, "--")) return error.InvalidArguments;
        } else {
            if (has_path or arg.len == 0 or std.mem.startsWith(u8, arg, "--")) return error.InvalidArguments;

            has_path = true;
            result.path = arg;
        }
    }

    return result;
}
