const std = @import("std");
const abi = @import("zxc_abi").native.@"std:url/search_params";
const query = @import("query.zig");
const edit = @import("edit.zig");
pub const parse = @import("parse.zig").parse;
pub const stringify = @import("stringify.zig").stringify;
pub const get = query.get;
pub const getAll = query.getAll;
pub const has = query.has;
pub const append = edit.append;
pub const set = edit.set;
pub const remove = edit.remove;
pub const sort = @import("sort.zig").sort;

pub fn size(input: []const abi.Entry) u64 {
    return @intCast(input.len);
}

pub fn keys(allocator: std.mem.Allocator, input: []const abi.Entry) ![]const []const u8 {
    return fields(allocator, input, "key");
}

pub fn values(allocator: std.mem.Allocator, input: []const abi.Entry) ![]const []const u8 {
    return fields(allocator, input, "value");
}

fn fields(allocator: std.mem.Allocator, input: []const abi.Entry, comptime name: []const u8) ![]const []const u8 {
    const output = try allocator.alloc([]const u8, input.len);

    for (input, output) |entry, *value| value.* = @field(entry, name);

    return output;
}
