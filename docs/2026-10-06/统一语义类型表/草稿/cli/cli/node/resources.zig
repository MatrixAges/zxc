const std = @import("std");
pub const File = @import("napi_resources").File;

pub const Result = struct {
    arena: std.heap.ArenaAllocator,
    files: [3]File,
    napi: [2]File,
    pub fn deinit(self: *Result) void {
        self.arena.deinit();
    }
};

pub fn create(allocator: std.mem.Allocator, stateful: bool, types: @import("zx").ir.TypeTable, input: @import("zx").ir.TypeId, output: @import("zx").ir.TypeId) !Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const context = try @import("compiler").zig.host.node.context(arena.allocator(), stateful);
    const task = try @import("compiler").zig.host.node.task(arena.allocator(), stateful);
    const enqueue = try @import("compiler").zig.host.node.enqueue(arena.allocator(), stateful);
    const napi = try @import("compiler").zig.host.node.napi.render(arena.allocator(), types, input, output);

    return .{ .arena = arena, .files = .{
        .{ .path = "context.zig", .source = context },
        .{ .path = "task.zig", .source = task },
        .{ .path = "enqueue.zig", .source = enqueue },
    }, .napi = .{ .{ .path = "root.zig", .source = napi }, @import("napi_resources").files[0] } };
}
