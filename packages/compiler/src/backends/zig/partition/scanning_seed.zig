const std = @import("std");
const References = @import("scanning.zig").References;
const import_prefix = "@import(\"zxc_module_";

pub fn references(allocator: std.mem.Allocator, source: []const u8, indices: *const @import("zx").bytes.Map(u32)) !References {
    var callees: std.ArrayList(u32) = .empty;
    var variants: std.ArrayList([]const u8) = .empty;
    var cursor: usize = 0;

    while (@import("../search.zig").find(source, cursor, import_prefix)) |at| {
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

        try callees.append(allocator, callee);
        try variants.append(allocator, source[variant_start..variant_end]);
    }

    return .{ .callees = callees.items, .variants = variants.items };
}

pub fn inlineNames(allocator: std.mem.Allocator, source: []const u8) ![]const []const u8 {
    const marker = "pub inline fn ";
    var names: std.ArrayList([]const u8) = .empty;
    var cursor: usize = 0;

    while (@import("../search.zig").find(source, cursor, marker)) |at| {
        cursor = at + marker.len;

        if (at != 0 and source[at - 1] != '\n') continue;

        const end = std.mem.indexOfScalarPos(u8, source, cursor, '(') orelse break;

        try names.append(allocator, source[cursor..end]);
    }

    return names.items;
}
