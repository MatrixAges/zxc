const std = @import("std");
const ir = @import("zx").ir;
const Module = @import("artifact/model.zig").Module;
const Types = @import("link/types.zig");
const Origins = @import("nominal_origins.zig");
pub const Error = Types.Error;

pub const Result = struct {
    arena: std.heap.ArenaAllocator,
    types: []const ir.Type,
    nominal_types: []const Origins.Item,
    mappings: []const []const ir.TypeId,
    pub fn deinit(self: *Result) void {
        self.arena.deinit();

        self.* = undefined;
    }
};

pub fn merge(allocator: std.mem.Allocator, modules: []const Module) Error!Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    var temporary = std.heap.ArenaAllocator.init(allocator);

    defer temporary.deinit();

    var types = try Types.init(arena.allocator());
    const mappings = try arena.allocator().alloc([]const ir.TypeId, modules.len);

    for (modules, mappings) |module, *mapping| {
        mapping.* = try types.append(temporary.allocator(), module);
        _ = temporary.reset(.retain_capacity);
    }

    return .{ .arena = arena, .types = types.items.items, .nominal_types = types.origins.items.items, .mappings = mappings };
}
