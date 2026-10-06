const std = @import("std");
const Builder = @import("../builder.zig");
pub const node = @import("node/root.zig");
pub const wasm = @import("wasm/root.zig").render;
pub const catalog = @import("catalog.zig");
pub const resources = @import("resources.zig");
pub const library = @import("library/root.zig");
pub const gateway = @import("gateway/root.zig").render;
pub const cli = @import("cli/root.zig").render;

pub fn result(allocator: std.mem.Allocator, emit: bool) std.mem.Allocator.Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const builder = Builder{ .allocator = arena.allocator() };

    return @import("../render.zig").render(allocator, &.{.{ .constant = .{ .name = "emit", .value = try builder.expression(.{ .boolean = emit }), .exported = true } }});
}

pub fn cAdapter(allocator: std.mem.Allocator) std.mem.Allocator.Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const builder = Builder{ .allocator = arena.allocator() };

    return @import("../render.zig").render(allocator, &.{.{ .constant = .{ .name = "c", .value = try builder.builtin(.import, &.{try builder.string("zxc_c")}), .exported = true } }});
}
