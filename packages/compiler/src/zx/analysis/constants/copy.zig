const std = @import("std");
const ir = @import("zx").ir;

pub fn copy(allocator: std.mem.Allocator, source: ir.Constant) std.mem.Allocator.Error!ir.Constant {
    var result = source;
    result.name = try allocator.dupe(u8, source.name);

    if (source.value == .string) result.value.string = try allocator.dupe(u8, source.value.string);

    return result;
}
