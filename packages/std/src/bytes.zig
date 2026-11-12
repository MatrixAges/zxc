const std = @import("std");
const fast = @import("bytes_backend");

pub fn join(allocator: std.mem.Allocator, separator: []const u8, values: []const []const u8) std.mem.Allocator.Error![]const u8 {
    return std.mem.join(allocator, separator, values);
}

pub const AtomicRows = @import("bytes/atomic_rows.zig");
pub const atomicRowsCount = AtomicRows.count;
pub const atomicRowLength = AtomicRows.rowLength;
pub const loadAtomicCell = AtomicRows.load;
pub const storeAtomicCell = AtomicRows.store;
pub const fillAtomicRow = AtomicRows.fill;
const writer = @import("bytes/writer.zig");
pub const write = writer.write;
pub const writeMasked = writer.writeMasked;
pub const writeByte = writer.writeByte;
pub const writeU32Le = writer.writeU32Le;
pub const writeU64Le = writer.writeU64Le;
pub const writeU32sLe = writer.writeU32sLe;
pub const writeU64sLe = writer.writeU64sLe;

pub fn repeat(allocator: std.mem.Allocator, count_value: u64, value: u8) std.mem.Allocator.Error![]const u8 {
    const length = std.math.cast(usize, count_value) orelse return error.OutOfMemory;
    const output = try allocator.alloc(u8, length);

    @memset(output, value);

    return output;
}

pub fn fromText(text: []const u8) []const u8 {
    return text;
}

pub fn encodeU64Le(allocator: std.mem.Allocator, value: u64) std.mem.Allocator.Error![]const u8 {
    const output = try allocator.create([@sizeOf(u64)]u8);

    std.mem.writeInt(u64, output, value, .little);

    return output;
}

pub fn count(haystack: []const u8, needle: u8) u64 {
    return std.mem.countScalar(u8, haystack, needle);
}

pub fn indexOfScalar(haystack: []const u8, start: u64, needle: u8) ?u64 {
    if (start >= haystack.len) return null;

    return if (std.mem.indexOfScalarPos(u8, haystack, @intCast(start), needle)) |index| @intCast(index) else null;
}

pub fn lastIndexOfScalar(haystack: []const u8, needle: u8) ?u64 {
    return if (std.mem.lastIndexOfScalar(u8, haystack, needle)) |index| @intCast(index) else null;
}

pub fn indexOfSlice(haystack: []const u8, start: u64, needle: []const u8) ?u64 {
    if (start > haystack.len) return null;

    return if (@import("bytes/find.zig").find(haystack, @intCast(start), needle)) |index| @intCast(index) else null;
}

pub fn indexOfText(haystack: []const u8, start: u64, needle: []const u8) ?u64 {
    return indexOfSlice(haystack, start, needle);
}

pub fn startsWith(haystack: []const u8, start: u64, prefix: []const u8) bool {
    return start <= haystack.len and std.mem.startsWith(u8, haystack[@intCast(start)..], prefix);
}

pub fn startsWithText(haystack: []const u8, start: u64, prefix: []const u8) bool {
    return startsWith(haystack, start, prefix);
}

pub fn startsWithTextIgnoreAsciiCase(haystack: []const u8, prefix: []const u8) bool {
    return prefix.len <= haystack.len and std.ascii.eqlIgnoreCase(haystack[0..prefix.len], prefix);
}

pub const equals = fast.equal;

pub fn lessThan(left: []const u8, right: []const u8) bool {
    return std.mem.lessThan(u8, left, right);
}

pub fn hash(in: []const u8) u64 {
    return fast.hash(0, in);
}

pub fn readU32(in: []const u8, offset: u64, little_endian: bool) error{IndexOutOfBounds}!u32 {
    const width = @sizeOf(u32);

    if (offset > in.len or in.len - offset < width) return error.IndexOutOfBounds;

    const value: *const [width]u8 = in[@intCast(offset)..][0..width];

    return if (little_endian) std.mem.readInt(u32, value, .little) else std.mem.readInt(u32, value, .big);
}

pub fn loadAtomic(in: []const u8, index: u64) error{IndexOutOfBounds}!u8 {
    if (index >= in.len) return error.IndexOutOfBounds;

    return @atomicLoad(u8, &in[@intCast(index)], .monotonic);
}
