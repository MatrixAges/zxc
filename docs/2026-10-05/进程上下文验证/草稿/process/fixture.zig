const std = @import("std");
pub const api = @import("standard").process;
pub const allocator = std.testing.allocator;

pub fn context(args: []const [*:0]const u8, environ: [:null]const ?[*:0]const u8) !std.process.Init.Minimal {
    if (comptime std.process.Args.Vector != []const [*:0]const u8 or std.process.Environ.Block != std.process.Environ.PosixBlock) {
        return error.SkipZigTest;
    } else {
        return .{ .args = .{ .vector = args }, .environ = .{ .block = .{ .slice = environ } } };
    }
}

pub fn freeArgs(gpa: std.mem.Allocator, args: []const []const u8) void {
    for (args) |value| gpa.free(value);

    gpa.free(args);
}

pub const Path = struct {
    value: []const u8 = "/controlled/目录 🌿",
    failure: bool = false,
    calls: usize = 0,
    pub fn io(self: *Path, vtable: *std.Io.VTable) std.Io {
        vtable.* = std.testing.io.vtable.*;
        vtable.processCurrentPath = current;

        return .{ .userdata = self, .vtable = vtable };
    }

    fn current(data: ?*anyopaque, buffer: []u8) std.process.CurrentPathError!usize {
        const self: *Path = @ptrCast(@alignCast(data.?));

        self.calls += 1;

        if (self.failure) return error.Canceled;
        if (self.value.len > buffer.len) return error.NameTooLong;

        @memcpy(buffer[0..self.value.len], self.value);

        return self.value.len;
    }
};
