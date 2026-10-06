const std = @import("std");
const node = @import("../node.zig");
const Builder = @import("../builder.zig");
const Object = @import("../zx/state.zig").Object;

pub fn render(allocator: std.mem.Allocator, objects: []const Object) std.mem.Allocator.Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const temporary = arena.allocator();
    const builder = Builder{ .allocator = temporary };
    var declarations: std.ArrayList(node.Declaration) = .empty;
    const fields = try temporary.alloc(node.Field, objects.len);

    for (objects, fields, 0..) |object, *field, index| {
        const name = try std.fmt.allocPrint(temporary, "initial_{d}", .{index});
        const module = try builder.expression(.{ .builtin = .{ .name = .import, .arguments = try temporary.dupe(*const node.Expression, &.{try builder.string(object.module_name)}) } });
        const output = try builder.expression(.{ .field = .{ .target = try builder.identifier(name), .name = "Output" } });

        try declarations.append(temporary, .{ .constant = .{ .name = name, .value = module } });

        field.* = .{
            .name = try std.fmt.allocPrint(temporary, "store_{d}", .{index}),
            .value = try builder.expression(.{ .optional_type = output }),
            .default_value = try builder.expression(.null_value),
        };
    }

    try declarations.append(temporary, .{ .constant = .{ .name = "zx_pending", .value = try builder.expression(.{ .struct_type = fields }), .exported = true } });

    return @import("../render.zig").render(allocator, declarations.items);
}
