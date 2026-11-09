const std = @import("std");
const node = @import("../node.zig");
const Builder = @import("../builder.zig");

pub fn render(allocator: std.mem.Allocator, modules: []const []const u8) std.mem.Allocator.Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const temporary = arena.allocator();
    const builder = try Builder.init(temporary);
    var declarations: std.ArrayList(node.Declaration) = .empty;
    const fields = try temporary.alloc(node.Field, modules.len);

    for (modules, fields, 0..) |module_name, *field, index| {
        const name = try std.fmt.allocPrint(temporary, "initial_{d}", .{index});
        const module = try builder.expression(.{ .builtin = .{ .name = .import, .arguments = try temporary.dupe(node.ExpressionId, &.{try builder.string(module_name)}) } });
        const output = try builder.expression(.{ .field = .{ .target = try builder.identifier(name), .name = "Output" } });

        try declarations.append(temporary, .{ .constant = .{ .name = name, .value = module } });

        field.* = .{
            .name = try std.fmt.allocPrint(temporary, "store_{d}", .{index}),
            .value = try builder.expression(.{ .optional_type = output }),
            .default_value = try builder.expression(.null_value),
        };
    }

    try declarations.append(temporary, .{ .constant = .{ .name = "zx_pending", .value = try builder.expression(.{ .struct_type = fields }), .exported = true } });

    return @import("../render.zig").render(allocator, builder.nodes, declarations.items);
}
