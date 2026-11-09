const std = @import("std");
const model = @import("root.zig");
const node = @import("../node.zig");
const Builder = @import("../builder.zig");
const invoke = @import("invoke.zig");
const dispatch = @import("dispatch.zig");
const prelude = @import("prelude.zig");
pub const Options = struct { services: []const model.Service, service_modules: []const []const u8, routes: []const model.Route, listen: []const u8, max_header_bytes: u32, max_body_bytes: u32 };

pub fn render(allocator: std.mem.Allocator, options: Options) std.mem.Allocator.Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const builder = try Builder.init(arena.allocator());
    var declarations: std.ArrayList(node.Declaration) = .empty;

    try prelude.lower(builder, &declarations, options);
    try declarations.append(builder.allocator, try dispatch.lower(builder, options.routes));

    for (options.services, 0..) |service, index| {
        if (try model.adapter.lower(builder, service, index)) |declaration| try declarations.append(builder.allocator, declaration);
        try declarations.append(builder.allocator, try invoke.lower(builder, service, index));
    }

    try declarations.appendSlice(builder.allocator, &try @import("boundary.zig").lower(builder));

    return @import("../render.zig").render(allocator, builder.nodes, declarations.items);
}
