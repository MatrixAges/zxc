pub const Root = struct { path: []const u8, prefix: []const u8 = "" };
pub const Package = struct { specifier: []const u8, entry: []const u8 };
pub const Interface = struct { specifier: []const u8, path: []const u8, module: []const u8 };

pub const Project = struct {
    roots: []const Root,
    entries: []const @import("entries.zig").Entry,
    packages: []const Package,
    interfaces: []const Interface,
};

pub const interfaces = [_]Interface{};
