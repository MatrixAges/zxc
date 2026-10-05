const std = @import("std");
const Transport = @This();

response: []const u8 = @import("fixture.zig").empty_response,
position: usize = 0,
chunk: usize = 11,
request: [32768]u8 = undefined,
request_len: usize = 0,
lookups: usize = 0,
connections: usize = 0,
closed: usize = 0,
refuse: bool = false,
read_failure: bool = false,
read_fail_after: ?usize = null,
write_failure: bool = false,
vtable: std.Io.VTable = undefined,
pub fn io(self: *Transport) std.Io {
    self.vtable = std.Io.failing.vtable.*;
    self.vtable.netLookup = lookup;
    self.vtable.netConnectIp = connect;
    self.vtable.netRead = read;
    self.vtable.netWrite = write;
    self.vtable.netClose = close;

    return .{ .userdata = self, .vtable = &self.vtable };
}

fn lookup(data: ?*anyopaque, host: std.Io.net.HostName, queue: *std.Io.Queue(std.Io.net.HostName.LookupResult), options: std.Io.net.HostName.LookupOptions) std.Io.net.HostName.LookupError!void {
    const self: *Transport = @ptrCast(@alignCast(data.?));

    defer queue.close(.{ .userdata = self, .vtable = &self.vtable });

    self.lookups += 1;

    std.debug.assert(std.mem.eql(u8, host.bytes, "127.0.0.1"));

    const address = std.Io.net.IpAddress.parse("127.0.0.1", options.port) catch unreachable;

    queue.putOneUncancelable(.{ .userdata = self, .vtable = &self.vtable }, .{ .address = address }) catch unreachable;
}

fn connect(data: ?*anyopaque, address: *const std.Io.net.IpAddress, _: std.Io.net.IpAddress.ConnectOptions) std.Io.net.IpAddress.ConnectError!std.Io.net.Socket {
    const self: *Transport = @ptrCast(@alignCast(data.?));

    if (self.refuse) return error.ConnectionRefused;

    self.connections += 1;

    return .{ .handle = 42, .address = address.* };
}

fn read(data: ?*anyopaque, _: std.Io.net.Socket.Handle, buffers: [][]u8) std.Io.net.Stream.Reader.Error!usize {
    const self: *Transport = @ptrCast(@alignCast(data.?));

    if (self.read_failure) return error.ConnectionResetByPeer;
    if (self.read_fail_after) |limit| if (self.position >= limit) return error.ConnectionResetByPeer;

    var count: usize = 0;

    for (buffers) |buffer| {
        const length = @min(buffer.len, self.chunk - count, self.response.len - self.position);

        @memcpy(buffer[0..length], self.response[self.position..][0..length]);

        self.position += length;
        count += length;

        if (count == self.chunk or self.position == self.response.len) break;
    }

    return count;
}

fn write(data: ?*anyopaque, _: std.Io.net.Socket.Handle, header: []const u8, buffers: []const []const u8, splat: usize) std.Io.net.Stream.Writer.Error!usize {
    const self: *Transport = @ptrCast(@alignCast(data.?));

    if (self.write_failure) return error.ConnectionResetByPeer;

    var count = self.append(header, 0);

    for (buffers, 0..) |bytes, index| {
        const repetitions = if (index + 1 == buffers.len) splat else 1;

        for (0..repetitions) |_| {
            count += self.append(bytes, count);

            if (count == self.chunk) return count;
        }
    }

    return count;
}

fn append(self: *Transport, bytes: []const u8, written: usize) usize {
    const length = @min(bytes.len, self.chunk - written);

    @memcpy(self.request[self.request_len..][0..length], bytes[0..length]);

    self.request_len += length;

    return length;
}

fn close(data: ?*anyopaque, handles: []const std.Io.net.Socket.Handle) void {
    const self: *Transport = @ptrCast(@alignCast(data.?));

    self.closed += handles.len;
}
