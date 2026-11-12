//! Owns Call inputs for one inference and lowering run. Workers only read the published rows.
const std = @import("std");
const frontend = @import("frontend");
const rx = @import("rx");
const Self = @This();
const Result = frontend.ExpressionInput.Result;
pub const Module = []const ?*const Result;

arena: std.heap.ArenaAllocator,
modules: []Module = &.{},
pub fn parse(self: *Self, attribute: rx.ast.Attribute, owner: []const u8) std.mem.Allocator.Error!*const Result {
    const allocator = self.arena.allocator();
    const result = try allocator.create(Result);
    result.* = try @import("../attribute.zig").parseBorrowed(allocator, attribute, owner);

    return result;
}

pub fn publish(self: *Self, count: usize, index: usize, inputs: Module) std.mem.Allocator.Error!void {
    if (inputs.len == 0) return;

    if (self.modules.len == 0) {
        self.modules = try self.arena.allocator().alloc(Module, count);

        @memset(self.modules, &.{});
    }

    self.modules[index] = inputs;
}

pub fn module(self: *const Self, index: usize) Module {
    return if (self.modules.len != 0) self.modules[index] else &.{};
}

pub fn input(inputs: Module, index: usize) ?*const Result {
    return if (index < inputs.len) inputs[index] else null;
}
