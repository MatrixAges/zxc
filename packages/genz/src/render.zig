const std = @import("std");
const node = @import("node.zig");
const Printer = @import("printer.zig");

pub fn render(allocator: std.mem.Allocator, nodes: *@import("node/storage.zig"), declarations: []const node.Declaration) std.mem.Allocator.Error![]u8 {
    if (@import("genz_options").generated) return @import("printer/host.zig").render(allocator, nodes, declarations);

    var printer = Printer{ .allocator = allocator, .nodes = nodes };

    defer printer.output.deinit(allocator);

    const stored = try nodes.declarations(nodes.allocator, declarations);

    for (0..stored.len) |index| {
        try printer.declaration(nodes.declaration_rows.get(stored.start + @as(u32, @intCast(index))));
        try printer.write("\n");
    }

    return printer.output.toOwnedSlice(allocator);
}
