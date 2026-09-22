const std = @import("std");
const node = @import("node.zig");
const Printer = @import("printer.zig");

pub fn render(allocator: std.mem.Allocator, declarations: []const node.Declaration) std.mem.Allocator.Error![]u8 {
    var printer = Printer{ .allocator = allocator };

    defer printer.output.deinit(allocator);

    for (declarations) |declaration| {
        try printer.declaration(declaration);
        try printer.write("\n");
    }

    return printer.output.toOwnedSlice(allocator);
}
