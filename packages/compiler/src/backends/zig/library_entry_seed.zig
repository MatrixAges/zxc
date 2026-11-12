const std = @import("std");
const ir = @import("zx").ir;
const Library = @import("../../library/root.zig").Result;

pub fn create(allocator: std.mem.Allocator, library: *const Library, index: usize) (std.mem.Allocator.Error || error{InvalidModule})!ir.Program {
    var program = try library.module(index);
    const function = library.exports[index].function orelse return program;

    if (program.stores.count() != 0) return program;
    try @import("frontend").writeExternalEntry(allocator, &program, function);

    program.contracts = .{};

    return program;
}
