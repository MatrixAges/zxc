const std = @import("std");
const abi = @import("zxc_abi").native.@"std:zlib";
const compress = @import("compress.zig").compress;
const decompress = @import("decompress.zig").decompress;

pub fn gzip(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    return gzipWith(allocator, &.{ .data = input, .level = -1 });
}

pub fn deflate(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    return deflateWith(allocator, &.{ .data = input, .level = -1 });
}

pub fn deflateRaw(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    return deflateRawWith(allocator, &.{ .data = input, .level = -1 });
}

pub fn gzipWith(allocator: std.mem.Allocator, input: abi.CompressOptions) ![]const u8 {
    return compress(allocator, input, .gzip);
}

pub fn deflateWith(allocator: std.mem.Allocator, input: abi.CompressOptions) ![]const u8 {
    return compress(allocator, input, .zlib);
}

pub fn deflateRawWith(allocator: std.mem.Allocator, input: abi.CompressOptions) ![]const u8 {
    return compress(allocator, input, .raw);
}

pub fn gunzip(allocator: std.mem.Allocator, input: abi.DecompressOptions) ![]const u8 {
    return decompress(allocator, input, .gzip);
}

pub fn inflate(allocator: std.mem.Allocator, input: abi.DecompressOptions) ![]const u8 {
    return decompress(allocator, input, .zlib);
}

pub fn inflateRaw(allocator: std.mem.Allocator, input: abi.DecompressOptions) ![]const u8 {
    return decompress(allocator, input, .raw);
}

pub fn zstdDecompress(allocator: std.mem.Allocator, input: abi.ZstdDecompressOptions) ![]const u8 {
    return @import("zstd/decompress.zig").decompress(allocator, input);
}
