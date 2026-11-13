const std = @import("std");
const ir = @import("zx").ir;
const Record = @import("../module_record.zig");
const Error = @import("model.zig").Error;

pub const Result = struct {
    arena: std.heap.ArenaAllocator,
    needed: []const bool,
    pub fn deinit(self: *Result) void {
        self.arena.deinit();
    }
};

pub fn collect(allocator: std.mem.Allocator, program: ir.Program, record: Record) Error!Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const needed = try @import("roots/seed.zig").collect(arena.allocator(), program, record);

    return .{ .arena = arena, .needed = needed };
}
