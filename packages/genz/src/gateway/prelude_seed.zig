const std = @import("std");
const node = @import("../node.zig");
const Builder = @import("../builder.zig");
const Options = @import("entry.zig").Options;

pub fn lower(builder: Builder, declarations: *std.ArrayList(node.Declaration), options: Options) std.mem.Allocator.Error!void {
    try declarations.appendSlice(builder.allocator, &.{
        .{ .constant = .{ .name = "std", .value = try builder.builtin(.import, &.{try builder.string("std")}) } },
        .{ .constant = .{ .name = "State", .value = try builder.builtin(.import, &.{try builder.string("zxc_gateway_state")}), .exported = true } },
        .{ .constant = .{ .name = "listen", .value = try builder.string(options.listen), .exported = true } },
        .{ .constant = .{ .name = "max_header_bytes", .value = try builder.integer(options.max_header_bytes), .exported = true } },
        .{ .constant = .{ .name = "max_body_bytes", .value = try builder.integer(options.max_body_bytes), .type_expr = try builder.expression(.{ .primitive = .usize }) } },
    });

    for (options.service_modules, 0..) |module_name, index| {
        try declarations.append(builder.allocator, .{ .constant = .{
            .name = try std.fmt.allocPrint(builder.allocator, "service_{d}", .{index}),
            .value = try builder.builtin(.import, &.{try builder.string(module_name)}),
        } });
    }
}
