const std = @import("std");
const parallel = @import("../parallel.zig");
const File = @import("layout.zig").File;
const Scanner = @import("compiler").zig.partition.Scanning;
const Self = @This();
pub const References = Scanner.References;

functions: []const File,
scanner: *const Scanner,
references: []References,
inline_names: [][]const []const u8,
pub fn run(allocator: std.mem.Allocator, arenas: parallel.Arenas, functions: []const File, scanner: *const Scanner) !Self {
    const self = Self{
        .functions = functions,
        .scanner = scanner,
        .references = try allocator.alloc(References, functions.len),
        .inline_names = try allocator.alloc([]const []const u8, functions.len),
    };

    try parallel.each(arenas, functions.len, &self);

    return self;
}

pub fn step(self: *const Self, allocator: std.mem.Allocator, index: usize) !void {
    const result = try self.scanner.scan(allocator, self.functions[index].source);

    self.references[index] = result.references;
    self.inline_names[index] = result.inline_names;
}
