const std = @import("std");
const syntax = @import("syntax.zig");
const Allocator = std.mem.Allocator;

pub fn Module(comptime windows: bool, comptime api: type) type {
    return struct {
        pub const Parts = api.Parts;

        pub fn isAbsolute(path: []const u8) bool {
            return syntax.root(windows, path).absolute;
        }
        pub fn basename(path: []const u8) []const u8 {
            return syntax.base(windows, path);
        }
        pub fn dirname(path: []const u8) []const u8 {
            return syntax.directory(windows, path);
        }
        pub fn extname(path: []const u8) []const u8 {
            return syntax.extension(basename(path));
        }
        pub fn parse(allocator: Allocator, path: []const u8) !Parts {
            const root = syntax.root(windows, path);
            const base = if (path.len <= root.end) "" else basename(path);
            const extension = syntax.extension(base);
            const base_start = if (base.len == 0) root.end else @intFromPtr(base.ptr) - @intFromPtr(path.ptr);
            const directory_end = @max(root.end, base_start -| 1);
            const output = try allocator.create(api.parse.OutputValue);
            output.* = .{ .root = path[0..root.end], .dir = path[0..directory_end], .base = base, .ext = extension, .name = base[0 .. base.len - extension.len] };

            return output;
        }
        pub fn format(allocator: Allocator, parts: Parts) ![]const u8 {
            const directory = if (parts.dir.len != 0) parts.dir else parts.root;
            const base = if (parts.base.len != 0) try allocator.dupe(u8, parts.base) else try std.fmt.allocPrint(allocator, "{s}{s}{s}", .{ parts.name, if (parts.ext.len != 0 and parts.ext[0] != '.') "." else "", parts.ext });

            defer allocator.free(base);

            return std.fmt.allocPrint(allocator, "{s}{s}{s}", .{ directory, if (directory.len == 0 or std.mem.eql(u8, directory, parts.root)) "" else if (windows) "\\" else "/", base });
        }
        pub fn normalize(allocator: Allocator, path: []const u8) ![]const u8 {
            return @import("normalize.zig").normalize(allocator, windows, path);
        }
        pub fn resolve(allocator: Allocator, input: api.resolve.Input) ![]const u8 {
            return @import("resolve.zig").resolve(allocator, windows, input.cwd, input.paths);
        }
        pub fn relative(allocator: Allocator, input: api.relative.Input) ![]const u8 {
            return @import("resolve.zig").relative(allocator, windows, input.cwd, input.from, input.to);
        }
        pub fn join(allocator: Allocator, paths: []const []const u8) ![]const u8 {
            var output: std.Io.Writer.Allocating = .init(allocator);

            defer output.deinit();

            var allow_unc = false;

            for (paths) |path| {
                if (path.len == 0) continue;

                if (output.written().len != 0) {
                    try output.writer.writeByte(if (windows) '\\' else '/');
                } else allow_unc = windows and path.len > 2 and syntax.separator(true, path[0]) and syntax.separator(true, path[1]) and !syntax.separator(true, path[2]);

                try output.writer.writeAll(path);
            }

            const combined = output.written();
            var start: usize = 0;

            if (windows and !allow_unc) {
                while (start + 1 < combined.len and syntax.separator(true, combined[start]) and syntax.separator(true, combined[start + 1])) : (start += 1) {}
            }

            return normalize(allocator, combined[start..]);
        }
    };
}
