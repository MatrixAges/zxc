const std = @import("std");
pub const api = @import("standard").process;
pub const allocator = std.testing.allocator;

pub const Stream = struct {
    input: []const u8 = "",
    position: usize = 0,
    chunk: usize = 1024,
    fail_after: ?usize = null,
    canceled: bool = false,
    calls: usize = 0,
    stdout: [32768]u8 = undefined,
    stderr: [32768]u8 = undefined,
    stdout_len: usize = 0,
    stderr_len: usize = 0,
    pub fn io(self: *Stream, vtable: *std.Io.VTable) std.Io {
        vtable.* = std.testing.io.vtable.*;
        vtable.operate = operate;
        vtable.fileClose = close;

        return .{ .userdata = self, .vtable = vtable };
    }

    fn close(_: ?*anyopaque, _: []const std.Io.File) void {
        @panic("standard stream API must not close caller handles");
    }
    fn operate(data: ?*anyopaque, operation: std.Io.Operation) std.Io.Cancelable!std.Io.Operation.Result {
        const self: *Stream = @ptrCast(@alignCast(data.?));

        self.calls += 1;

        if (self.canceled) return error.Canceled;

        return switch (operation) {
            .file_read_streaming => |args| .{ .file_read_streaming = self.read(args) },
            .file_write_streaming => |args| .{ .file_write_streaming = self.write(args) },
            else => @panic("unexpected IO operation"),
        };
    }

    fn read(self: *Stream, args: std.Io.Operation.FileReadStreaming) std.Io.Operation.FileReadStreaming.Result {
        std.debug.assert(args.file.handle == std.Io.File.stdin().handle);

        if (self.fail_after) |limit| if (self.position >= limit) return error.InputOutput;
        if (self.position == self.input.len) return error.EndOfStream;

        var count: usize = 0;

        for (args.data) |buffer| {
            const length = @min(buffer.len, self.chunk - count, self.input.len - self.position);

            @memcpy(buffer[0..length], self.input[self.position..][0..length]);

            self.position += length;
            count += length;

            if (count == self.chunk or self.position == self.input.len) break;
        }

        return count;
    }
    fn write(self: *Stream, args: std.Io.Operation.FileWriteStreaming) std.Io.Operation.FileWriteStreaming.Result {
        const is_stdout = args.file.handle == std.Io.File.stdout().handle;

        std.debug.assert(is_stdout or args.file.handle == std.Io.File.stderr().handle);

        const length = if (is_stdout) &self.stdout_len else &self.stderr_len;
        const buffer = if (is_stdout) &self.stdout else &self.stderr;

        if (self.fail_after) |limit| if (length.* >= limit) return error.InputOutput;

        var count = self.append(buffer, length, args.header, 0);

        for (args.data, 0..) |bytes, index| {
            const repetitions = if (index + 1 == args.data.len) args.splat else 1;

            for (0..repetitions) |_| {
                count += self.append(buffer, length, bytes, count);

                if (count == self.chunk) return count;
            }
        }

        return count;
    }
    fn append(self: *Stream, buffer: []u8, length: *usize, bytes: []const u8, written: usize) usize {
        const count = @min(bytes.len, self.chunk - written);

        @memcpy(buffer[length.*..][0..count], bytes[0..count]);

        length.* += count;

        return count;
    }
};
