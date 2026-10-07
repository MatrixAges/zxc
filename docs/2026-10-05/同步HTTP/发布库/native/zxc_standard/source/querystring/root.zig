const std = @import("std");
const abi = @import("zxc_abi").native.@"std:querystring";
const percent = @import("percent.zig");
pub const escape = percent.encode;

pub fn unescape(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    return percent.decode(allocator, input, false);
}

pub fn parse(allocator: std.mem.Allocator, input: []const u8) ![]const abi.Entry {
    return parseWith(allocator, &.{ .query = input, .separator = "&", .assignment = "=", .max_keys = 1000 });
}

pub const parseWith = @import("parse.zig").parse;

pub fn stringify(allocator: std.mem.Allocator, input: []const abi.Entry) ![]const u8 {
    return stringifyWith(allocator, &.{ .entries = input, .separator = "&", .assignment = "=" });
}

pub const stringifyWith = @import("stringify.zig").stringify;
