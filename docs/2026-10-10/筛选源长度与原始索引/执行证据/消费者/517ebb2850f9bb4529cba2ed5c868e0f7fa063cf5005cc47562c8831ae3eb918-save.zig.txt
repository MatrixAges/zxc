const std = @import("std");
const Module = struct { name: []const u8, imports: []const []const u8 };

pub const Output = struct {
    io: std.Io,
    allocator: std.mem.Allocator,
    directory: []const u8,
    modules: std.ArrayList(Module) = .empty,
    contents: std.StringHashMapUnmanaged([]const u8) = .empty,

    pub fn module(self: *Output, name: []const u8, source: []const u8, imports: []const []const u8) !void {
        const path = try std.fmt.allocPrint(self.allocator, "{s}.zig", .{name});
        if (self.contents.contains(path)) {
            try self.file(path, source);
            return;
        }

        const owned_imports = try self.allocator.alloc([]const u8, imports.len);
        for (imports, owned_imports) |item, *owned| owned.* = try self.allocator.dupe(u8, item);
        try self.modules.append(self.allocator, .{ .name = try self.allocator.dupe(u8, name), .imports = owned_imports });
        try self.file(path, source);
    }

    pub fn file(self: *Output, name: []const u8, source: []const u8) !void {
        if (self.contents.get(name)) |existing| {
            if (!std.mem.eql(u8, existing, source)) return error.ConflictingGeneratedFile;
            return;
        }

        try self.contents.put(self.allocator, try self.allocator.dupe(u8, name), try self.allocator.dupe(u8, source));
        const path = try std.fs.path.join(self.allocator, &.{ self.directory, name });
        var output = try std.Io.Dir.cwd().createFileAtomic(self.io, path, .{ .make_path = true, .replace = true });
        defer output.deinit(self.io);
        try output.file.writeStreamingAll(self.io, source);
        try output.replace(self.io);
    }
};
