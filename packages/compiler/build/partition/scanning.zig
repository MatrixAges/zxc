const std = @import("std");
const parallel = @import("../parallel.zig");
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

/// Scans the references and inline functions of every function file on all cores; the results live in `arenas`.
pub fn run(allocator: std.mem.Allocator, arenas: parallel.Arenas, functions: []const File, indices: *const std.StringHashMapUnmanaged(u32)) !Self {
    const self = Self{
        .functions = functions,
        .indices = indices,
        .references = try allocator.alloc([]const Reference, functions.len),
        .inline_names = try allocator.alloc([]const []const u8, functions.len),
    };

    try parallel.each(arenas, functions.len, &self);

    return self;
}

pub fn step(self: *const Self, allocator: std.mem.Allocator, index: usize) !void {
    const source = self.functions[index].source;

    self.references[index] = try scan(allocator, source, self.indices);
    self.inline_names[index] = try signature.inlineNames(allocator, source);
}

/// The function references in `source`, in order.
pub fn scan(allocator: std.mem.Allocator, source: []const u8, indices: *const std.StringHashMapUnmanaged(u32)) ![]const Reference {
    var result: std.ArrayList(Reference) = .empty;
    var cursor: usize = 0;

    while (@import("compiler").zig.search.find(source, cursor, import_prefix)) |at| {
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
