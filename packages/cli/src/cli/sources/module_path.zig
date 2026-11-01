const std = @import("std");
const compiler = @import("compiler");
const Inputs = @import("../watch/inputs.zig");

const Known = struct {
    io: std.Io,
    inputs: ?*Inputs,
    pub fn has(self: Known, path: []const u8) !bool {
        if (self.inputs) |inputs| try inputs.add(self.io, path);

        const stat = std.Io.Dir.cwd().statFile(self.io, path, .{}) catch |err| switch (err) {
            error.FileNotFound, error.NotDir => return false,
            else => return err,
        };

        return stat.kind == .file;
    }
};

pub fn select(io: std.Io, allocator: std.mem.Allocator, candidate: []const u8, inputs: ?*Inputs) ![]const u8 {
    return compiler.project.module_path.select(allocator, candidate, Known{ .io = io, .inputs = inputs });
}

pub fn entry(io: std.Io, allocator: std.mem.Allocator, path: []const u8, inputs: ?*Inputs) ![]const u8 {
    if (compiler.project.module_path.directoryReference(path)) return compiler.project.module_path.directory(allocator, path);
    if (std.fs.path.extension(path).len != 0) return path;

    const known = Known{ .io = io, .inputs = inputs };

    if (try known.has(path)) return path;

    const candidate = try std.fmt.allocPrint(allocator, "{s}.zx", .{path});

    return select(io, allocator, candidate, inputs);
}
