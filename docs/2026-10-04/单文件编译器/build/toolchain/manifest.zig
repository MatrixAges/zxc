pub const File = struct { source: []const u8, destination: []const u8 };
pub const Manifest = struct { host: []const u8, files: []const File };
