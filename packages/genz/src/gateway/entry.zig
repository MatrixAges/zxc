const std = @import("std");
const model = @import("root.zig");
const node = @import("../node.zig");
const Builder = @import("../builder.zig");
const invoke = @import("invoke.zig");
const dispatch = @import("dispatch.zig");
const prelude = @import("prelude.zig");
pub const Options = struct { services: []const model.Service, service_modules: []const []const u8, routes: []const model.Route, listen: []const u8, max_header_bytes: u32, max_body_bytes: u32 };

pub fn render(allocator: std.mem.Allocator, options: Options) std.mem.Allocator.Error![]u8 {
    if (comptime @import("genz_options").generated_analysis) return renderStored(allocator, options);

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

fn renderStored(allocator: std.mem.Allocator, options: Options) std.mem.Allocator.Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const builder = try Builder.init(arena.allocator());
    var prelude_declarations: std.ArrayList(node.Declaration) = .empty;

    try prelude.lower(builder, &prelude_declarations, options);

    const prefix = try builder.nodes.declarations(builder.allocator, prelude_declarations.items);
    var roots: std.ArrayList(u32) = .empty;

    for (0..prefix.len) |index| try roots.append(builder.allocator, prefix.start + @as(u32, @intCast(index)));
    try roots.append(builder.allocator, try dispatch.lowerStored(builder, options.routes));

    for (options.services, 0..) |service, index| {
        if (try model.adapter.lowerStored(builder, service, index)) |root| try roots.append(builder.allocator, root);
        try roots.append(builder.allocator, try invoke.lowerStored(builder, service, index));
    }

    const boundary = try @import("boundary.zig").lowerStored(builder);

    for (0..boundary.len) |index| try roots.append(builder.allocator, boundary.start + @as(u32, @intCast(index)));

    const selected = builder.nodes.selectDeclarations(builder.allocator, roots.items) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => @panic("invalid Gateway declaration roots"),
    };

    return @import("../render.zig").renderStored(allocator, builder.nodes, selected);
}
