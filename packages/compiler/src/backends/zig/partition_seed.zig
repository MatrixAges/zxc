const std = @import("std");
const genz = @import("genz");
const node = genz.node;
const Module = @import("partition.zig").Module;

pub fn root(allocator: std.mem.Allocator, modules: []const Module, panic_handler: bool) ![]const u8 {
    const builder = try genz.Builder.init(allocator);
    var declarations: std.ArrayList(node.Declaration) = .empty;

    for (modules) |module| try declarations.append(allocator, .{ .constant = .{
        .name = module.name,
        .exported = true,
        .value = try builder.builtin(.import, &.{try builder.string(module.file)}),
    } });

    if (panic_handler) try declarations.append(allocator, .{ .comptime_scope = try builder.statements(&.{.{
        .expression = try builder.call(try builder.field(try builder.builtin(.import, &.{try builder.string("zxc_bridge")}), "exportPanic"), &.{}),
    }}) });

    return genz.render(allocator, builder.nodes, declarations.items);
}
