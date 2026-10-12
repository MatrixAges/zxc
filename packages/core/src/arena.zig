//! A bump allocator owned by one thread. `std.heap.ArenaAllocator` is shared safely between threads, which costs an
//! atomic read-modify-write on every allocation; generated code allocates in small pieces from the arena its host
//! hands it, so a host that keeps the arena on one thread allocates here with a pointer bump instead. Memory comes from
//! `child` in chunks that grow by half each time and is released all at once.
const std = @import("std");
const Self = @This();

child: std.mem.Allocator,
/// The oldest chunk; the chunks follow in the order they were made.
first: ?*Chunk = null,
/// The chunk allocated from. A reset starts again from the first chunk, and the later ones are used again in order
/// before a new chunk is made.
current: ?*Chunk = null,
/// Bytes used in the current chunk.
end: usize = 0,
const Chunk = struct { next: ?*Chunk, size: usize };
const header = std.mem.alignForward(usize, @sizeOf(Chunk), 16);
/// The first chunk, with its header, fills one page.
const smallest = 4 << 10;

pub fn init(child: std.mem.Allocator) Self {
    return .{ .child = child };
}

/// Starts with one chunk of `size` bytes, for a caller that knows how much it will allocate.
pub fn initCapacity(child: std.mem.Allocator, size: usize) std.mem.Allocator.Error!Self {
    const memory = child.rawAlloc(header + size, .of(Chunk), @returnAddress()) orelse return error.OutOfMemory;
    const chunk: *Chunk = @ptrCast(@alignCast(memory));
    chunk.* = .{ .next = null, .size = size };

    return .{ .child = child, .first = chunk, .current = chunk };
}

pub fn deinit(self: *Self) void {
    self.release(self.first);

    self.* = undefined;
}

/// Releases everything allocated so far but keeps the chunks, up to `limit` bytes of them, so a run that needs as much
/// again neither asks `child` for memory nor touches pages for the first time.
pub fn reset(self: *Self, limit: usize) void {
    var total: usize = 0;
    var link = &self.first;

    while (link.*) |chunk| : (link = &chunk.next) {
        total += chunk.size;

        if (total > limit) {
            self.release(chunk);

            link.* = null;

            break;
        }
    }

    self.current = self.first;
    self.end = 0;
}

pub fn allocator(self: *Self) std.mem.Allocator {
    return .{ .ptr = self, .vtable = &.{ .alloc = alloc, .resize = resize, .remap = remap, .free = free } };
}

fn release(self: *Self, from: ?*Chunk) void {
    var next = from;

    while (next) |chunk| {
        next = chunk.next;

        self.child.rawFree(bytes(chunk), .of(Chunk), @returnAddress());
    }
}

fn bytes(chunk: *Chunk) []u8 {
    return @as([*]u8, @ptrCast(chunk))[0 .. header + chunk.size];
}

fn base(chunk: *Chunk) usize {
    return @intFromPtr(chunk) + header;
}

fn alloc(context: *anyopaque, len: usize, alignment: std.mem.Alignment, _: usize) ?[*]u8 {
    const self: *Self = @ptrCast(@alignCast(context));

    while (self.current) |chunk| {
        const start = alignment.forward(base(chunk) + self.end);

        if (start + len <= base(chunk) + chunk.size) {
            self.end = start + len - base(chunk);

            return @ptrFromInt(start);
        }

        self.current = chunk.next orelse break;
        self.end = 0;
    }

    const previous = if (self.current) |chunk| chunk.size else 0;
    const size = @max(len + alignment.toByteUnits(), previous + previous / 2, smallest - header);
    const memory = self.child.rawAlloc(header + size, .of(Chunk), @returnAddress()) orelse return null;
    const chunk: *Chunk = @ptrCast(@alignCast(memory));

    chunk.* = .{ .next = null, .size = size };

    if (self.current) |tail| tail.next = chunk else self.first = chunk;

    self.current = chunk;

    const start = alignment.forward(base(chunk));

    self.end = start + len - base(chunk);

    return @ptrFromInt(start);
}

/// Whether `memory` is the last allocation of the current chunk, which alone can change size.
fn last(self: *const Self, memory: []u8) bool {
    const chunk = self.current orelse return false;

    return @intFromPtr(memory.ptr) + memory.len == base(chunk) + self.end;
}

fn resize(context: *anyopaque, memory: []u8, _: std.mem.Alignment, new_len: usize, _: usize) bool {
    const self: *Self = @ptrCast(@alignCast(context));

    if (!self.last(memory)) return new_len <= memory.len;

    const chunk = self.current.?;
    const start = @intFromPtr(memory.ptr) - base(chunk);

    if (start + new_len > chunk.size) return false;

    self.end = start + new_len;

    return true;
}

fn remap(context: *anyopaque, memory: []u8, alignment: std.mem.Alignment, new_len: usize, return_address: usize) ?[*]u8 {
    return if (resize(context, memory, alignment, new_len, return_address)) memory.ptr else null;
}

fn free(context: *anyopaque, memory: []u8, _: std.mem.Alignment, _: usize) void {
    const self: *Self = @ptrCast(@alignCast(context));

    if (self.last(memory)) self.end -= memory.len;
}
