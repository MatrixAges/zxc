const std = @import("std");
const model = @import("root.zig");
const node = @import("../node.zig");
const Builder = @import("../builder.zig");
const invoke = @import("invoke.zig");
const dispatch = @import("dispatch.zig");

pub const Options = struct { services: []const model.Service, routes: []const model.Route, listen: []const u8, max_header_bytes: u32, max_body_bytes: u32 };

pub fn render(allocator: std.mem.Allocator, options: Options) std.mem.Allocator.Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const builder = try Builder.init(arena.allocator());
    var declarations: std.ArrayList(node.Declaration) = .empty;

    try declarations.appendSlice(builder.allocator, &.{
        .{ .constant = .{ .name = "std", .value = try builder.builtin(.import, &.{try builder.string("std")}) } },
        .{ .constant = .{ .name = "State", .value = try builder.builtin(.import, &.{try builder.string("zxc_gateway_state")}), .exported = true } },
        .{ .constant = .{ .name = "listen", .value = try builder.string(options.listen), .exported = true } },
        .{ .constant = .{ .name = "max_header_bytes", .value = try builder.integer(options.max_header_bytes), .exported = true } },
        .{ .constant = .{ .name = "max_body_bytes", .value = try builder.integer(options.max_body_bytes), .type_expr = try builder.expression(.{ .primitive = .usize }) } },
    });

    for (options.services, 0..) |service, index| {
        try declarations.append(builder.allocator, .{ .constant = .{
            .name = try std.fmt.allocPrint(builder.allocator, "service_{d}", .{index}),
            .value = try builder.builtin(.import, &.{try builder.string(service.module_name)}),
        } });
    }

    try declarations.append(builder.allocator, try dispatch.lower(builder, options.routes));

    for (options.services, 0..) |service, index| {
        if (try model.adapter.lower(builder, service, index)) |declaration| try declarations.append(builder.allocator, declaration);
        try declarations.append(builder.allocator, try invoke.lower(builder, service, index));
    }

    try declarations.appendSlice(builder.allocator, &try @import("boundary.zig").lower(builder));

    return @import("../render.zig").render(allocator, builder.nodes, declarations.items);
}
