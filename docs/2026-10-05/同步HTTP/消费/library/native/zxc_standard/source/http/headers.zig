const std = @import("std");
const api = @import("zxc_abi").native.@"std:http";

pub fn prepare(allocator: std.mem.Allocator, input: []const api.Header) ![]std.http.Header {
    const output = try allocator.alloc(std.http.Header, input.len);

    errdefer allocator.free(output);

    for (input, output) |entry, *header| {
        try validate(entry.name, entry.value);

        for ([_][]const u8{ "host", "content-length", "transfer-encoding", "connection", "expect", "upgrade" }) |name| {
            if (std.ascii.eqlIgnoreCase(entry.name, name)) return error.ManagedHttpHeader;
        }

        header.* = .{ .name = entry.name, .value = entry.value };
    }

    return output;
}

pub fn copy(allocator: std.mem.Allocator, head: std.http.Client.Response.Head) ![]const api.Header {
    var output: std.ArrayList(api.Header) = .empty;

    errdefer {
        for (output.items) |entry| release(allocator, entry);

        output.deinit(allocator);
    }

    var iterator = head.iterateHeaders();

    while (iterator.next()) |header| {
        try validate(header.name, header.value);

        const entry = try allocator.create(@typeInfo(api.Header).pointer.child);

        errdefer allocator.destroy(entry);

        const name = try allocator.dupe(u8, header.name);

        errdefer allocator.free(name);

        const value = try allocator.dupe(u8, header.value);

        errdefer allocator.free(value);

        entry.* = .{ .name = name, .value = value };

        try output.append(allocator, entry);
    }

    return output.toOwnedSlice(allocator);
}

pub fn deinit(allocator: std.mem.Allocator, values: []const api.Header) void {
    for (values) |entry| release(allocator, entry);

    allocator.free(values);
}

fn release(allocator: std.mem.Allocator, entry: api.Header) void {
    allocator.free(entry.name);
    allocator.free(entry.value);
    allocator.destroy(entry);
}

fn validate(name: []const u8, value: []const u8) !void {
    if (name.len == 0) return error.InvalidHttpHeader;

    for (name) |byte| {
        if (!std.ascii.isAlphanumeric(byte) and std.mem.indexOfScalar(u8, "!#$%&'*+-.^_`|~", byte) == null) return error.InvalidHttpHeader;
    }

    for (value) |byte| if ((byte < 0x20 and byte != '\t') or byte == 0x7f) return error.InvalidHttpHeader;
}
