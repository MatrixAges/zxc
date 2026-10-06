const std = @import("std");
pub const Requirements = struct { io: bool = false, process: bool = false };
pub const Object = struct { module_name: []const u8, writable: bool, independent: bool = false };

pub fn render(allocator: std.mem.Allocator, objects: []const Object) std.mem.Allocator.Error![]u8 {
    return renderWithIo(allocator, objects, false);
}

pub fn renderWithIo(allocator: std.mem.Allocator, objects: []const Object, needs_io: bool) std.mem.Allocator.Error![]u8 {
    return renderWithCapabilities(allocator, objects, .{ .io = needs_io });
}

pub fn renderWithCapabilities(allocator: std.mem.Allocator, objects: []const Object, requirements: Requirements) std.mem.Allocator.Error![]u8 {
    return renderConfigured(allocator, objects, requirements, true);
}

pub fn renderStorage(allocator: std.mem.Allocator, objects: []const Object) std.mem.Allocator.Error![]u8 {
    return renderConfigured(allocator, objects, .{}, false);
}

fn renderConfigured(allocator: std.mem.Allocator, objects: []const Object, requirements: Requirements, execute: bool) std.mem.Allocator.Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const temporary = arena.allocator();
    const builder = @import("../builder.zig"){ .allocator = temporary };
    var declarations: std.ArrayList(@import("../node.zig").Declaration) = .empty;

    try @import("state/storage.zig").lower(builder, &declarations, objects);
    try @import("state/lifecycle.zig").lower(builder, &declarations, objects);
    try @import("state/request.zig").lower(builder, &declarations, objects, requirements, execute);

    return @import("../render.zig").render(allocator, declarations.items);
}
