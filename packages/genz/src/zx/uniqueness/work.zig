const std = @import("std");
const ir = @import("zx").ir;
const creating = @import("generated_uniqueness_work_create");
const filling = @import("generated_uniqueness_work_fill");
const pushing = @import("generated_uniqueness_work_push");
const popping = @import("generated_uniqueness_work_pop");
const State = @typeInfo(@typeInfo(@TypeOf(creating.executeState)).@"fn".return_type.?).error_union.payload;
const FillParameter = @typeInfo(@TypeOf(filling.executeState)).@"fn".param_types[1].?;
const indirect_fill = @typeInfo(FillParameter) == .pointer;
const Fill = if (indirect_fill) std.meta.Child(FillParameter) else FillParameter;
const Self = @This();

arena: std.heap.ArenaAllocator,
state: State,
pub fn init(allocator: std.mem.Allocator, size: usize) std.mem.Allocator.Error!Self {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const state = creating.executeState(arena.allocator(), size) catch |err| return failure(err);

    return .{ .arena = arena, .state = state };
}

pub fn deinit(self: *Self) void {
    self.arena.deinit();
}

pub fn fill(self: *Self, program: ir.Program) std.mem.Allocator.Error!void {
    const input: Fill = .{
        .state = self.state,
        .native_modules = .{ .items = program.functions.native_modules, .storage = .plain },
        .type_only = program.type_only,
    };

    self.state = filling.executeState(self.arena.allocator(), if (indirect_fill) &input else input) catch |err| return failure(err);
}

pub fn push(self: *Self, index: usize) std.mem.Allocator.Error!void {
    self.state = pushing.executeState(self.arena.allocator(), .{ .state = self.state, .index = index }) catch |err| return failure(err);
}

pub fn pop(self: *Self) std.mem.Allocator.Error!?usize {
    const output = popping.executeState(self.arena.allocator(), self.state) catch |err| return failure(err);

    self.state = output.state;

    return if (output.index) |index| @intCast(index) else null;
}

pub fn window(self: *const Self, size: usize) []const u64 {
    const start: usize = @intCast(self.state.head);
    const end: usize = @intCast(self.state.tail);

    return self.state.buffer.items[start..@min(end, start + size)];
}

fn failure(err: anyerror) std.mem.Allocator.Error {
    if (err == error.OutOfMemory) return error.OutOfMemory;

    std.debug.panic("work state failed: {s}", .{@errorName(err)});
}
