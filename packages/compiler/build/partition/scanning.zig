const std = @import("std");
const signature = @import("signature.zig");
const File = @import("layout.zig").File;
const Self = @This();

/// One reference `@import("callee").variant` in generated source, by the callee's index among the planned functions.
pub const Reference = struct { callee: u32, variant: []const u8 };

const import_prefix = "@import(\"zxc_module_";

functions: []const File,
indices: *const std.StringHashMapUnmanaged(u32),
references: [][]const Reference,
inline_names: [][]const []const u8,
arenas: []std.heap.ArenaAllocator,
next: std.atomic.Value(usize) = .init(0),
failure: std.atomic.Value(u16) = .init(0),

/// Scans the references and inline functions of every function file on all cores; the results live in per-thread
/// arenas until `deinit`.
pub fn run(allocator: std.mem.Allocator, functions: []const File, indices: *const std.StringHashMapUnmanaged(u32)) !Self {
    const threads = try allocator.alloc(std.Thread, @min(std.Thread.getCpuCount() catch 1, @max(functions.len, 1)) - 1);
    var self = Self{
        .functions = functions,
        .indices = indices,
        .references = try allocator.alloc([]const Reference, functions.len),
        .inline_names = try allocator.alloc([]const []const u8, functions.len),
        .arenas = try allocator.alloc(std.heap.ArenaAllocator, threads.len + 1),
    };

    for (self.arenas) |*arena| arena.* = .init(std.heap.smp_allocator);

    errdefer self.deinit();

    var started: usize = 0;

    for (threads, self.arenas[1..]) |*thread, *arena| {
        thread.* = std.Thread.spawn(.{}, work, .{ &self, arena }) catch break;
        started += 1;
    }

    work(&self, &self.arenas[0]);

    for (threads[0..started]) |thread| thread.join();
    if (self.failure.load(.monotonic) != 0) return @errorCast(@errorFromInt(self.failure.load(.monotonic)));

    return self;
}

pub fn deinit(self: *Self) void {
    for (self.arenas) |*arena| arena.deinit();
}

fn work(self: *Self, arena: *std.heap.ArenaAllocator) void {
    while (self.failure.load(.monotonic) == 0) {
        const index = self.next.fetchAdd(1, .monotonic);

        if (index >= self.functions.len) return;

        self.step(arena.allocator(), index) catch |err| {
            _ = self.failure.cmpxchgStrong(0, @intFromError(err), .monotonic, .monotonic);

            return;
        };
    }
}

fn step(self: *Self, allocator: std.mem.Allocator, index: usize) !void {
    const source = self.functions[index].source;

    self.references[index] = try scan(allocator, source, self.indices);
    self.inline_names[index] = try signature.inlineNames(allocator, source);
}

/// The function references in `source`, in order.
pub fn scan(allocator: std.mem.Allocator, source: []const u8, indices: *const std.StringHashMapUnmanaged(u32)) ![]const Reference {
    var result: std.ArrayList(Reference) = .empty;
    var cursor: usize = 0;

    while (@import("search.zig").find(source, cursor, import_prefix)) |at| {
        const name_start = at + "@import(\"".len;
        const quote = std.mem.indexOfScalarPos(u8, source, name_start, '"') orelse return error.UnterminatedImport;
        var member = quote + 1;

        while (member < source.len and source[member] == ')') member += 1;

        if (member >= source.len or source[member] != '.') return error.UnsupportedFunctionReference;

        const variant_start = member + 1;
        var variant_end = variant_start;

        while (variant_end < source.len and (std.ascii.isAlphanumeric(source[variant_end]) or source[variant_end] == '_')) variant_end += 1;

        cursor = variant_end;

        const callee = indices.get(source[name_start..quote]) orelse return error.MissingFunctionFile;

        try result.append(allocator, .{ .callee = callee, .variant = source[variant_start..variant_end] });
    }

    return result.items;
}
