const std = @import("std");
const node = @import("node.zig");
const Printer = @import("printer.zig");

pub fn render(allocator: std.mem.Allocator, nodes: *@import("node/storage.zig"), declarations: []const node.Declaration) std.mem.Allocator.Error![]u8 {
    return renderStored(allocator, nodes, try nodes.declarations(nodes.allocator, declarations));
}

pub fn renderStored(allocator: std.mem.Allocator, nodes: *@import("node/storage.zig"), selected: @import("node/stored.zig").Declarations) std.mem.Allocator.Error![]u8 {
    if (@import("genz_options").generated) return @import("printer/host.zig").renderStored(allocator, nodes, selected);

    var printer = Printer{ .allocator = allocator, .nodes = nodes };

    defer printer.output.deinit(allocator);

    for (0..selected.len) |index| {
        try printer.declaration(nodes.declaration_rows.get(selected.start + @as(u32, @intCast(index))));
        try printer.write("\n");
    }

    return printer.output.toOwnedSlice(allocator);
}
