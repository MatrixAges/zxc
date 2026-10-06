const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Self = @This();
pub const Source = @import("source.zig");
pub const Reader = Source.Reader;
pub const Columns = @import("named_view");
pub const Operation = enum(u8) { name, finish_name, node, finish_wrap, tuple_next, object_next };

pub const Frame = struct {
    operation: Operation,
    value: Reader.Ref = .{ .node = 0 },
    name: zx.ast.Name = .{ .text = "", .span = .{ .start = 0, .end = 0 } },
    visiting: bool = false,
    declaration: zx.ast.Name = .{ .text = "", .span = .{ .start = 0, .end = 0 } },
    waiting: bool = false,
    position: usize = 0,
    index: usize = 0,
    list: bool = false,
    children: []ir.TypeId = &.{},
    columns: Columns = .{ .names = &.{}, .types = null },
};

pub const State = struct {
    frames: std.ArrayList(Frame) = .empty,
    result: ir.TypeId = @fromBackingInt(0),
};

allocator: std.mem.Allocator,
reporter: *zx.Reporter,
reader: Reader,
items: *ir.TypeStorage,
resolved: *std.StringHashMapUnmanaged(ir.TypeId),
visiting: *std.StringHashMapUnmanaged(void),
aliases: []const ir.Export,
native_interface: bool,
state: *State,
pub fn deinit(self: *const Self) void {
    for (self.state.frames.items) |frame| {
        if (frame.visiting) _ = self.visiting.remove(frame.name.text);
    }

    self.state.frames.deinit(self.allocator);
}

pub fn current(self: *const Self) *Frame {
    return &self.state.frames.items[self.state.frames.items.len - 1];
}

pub fn push(self: *const Self, frame: Frame) std.mem.Allocator.Error!void {
    try self.state.frames.append(self.allocator, frame);
}

pub fn pop(self: *const Self) void {
    std.debug.assert(!self.current().visiting);

    _ = self.state.frames.pop().?;
}

pub fn enter(self: *const Self) std.mem.Allocator.Error!void {
    const frame = self.current();

    std.debug.assert(!frame.visiting and !self.visiting.contains(frame.name.text));

    try self.visiting.put(self.allocator, frame.name.text, {});

    frame.visiting = true;
}

pub fn leave(self: *const Self) void {
    const frame = self.current();

    std.debug.assert(frame.visiting);

    _ = self.visiting.remove(frame.name.text);
    frame.visiting = false;
}

pub fn allocateChildren(self: *const Self, count: usize) std.mem.Allocator.Error!void {
    self.current().children = try self.allocator.alloc(ir.TypeId, count);
}

pub fn allocateFields(self: *const Self, count: usize) std.mem.Allocator.Error!void {
    const names = try self.allocator.alloc([]const u8, count);

    errdefer self.allocator.free(names);
    self.current().columns = .{ .names = names, .types = try self.allocator.alloc(u32, count) };
}

pub fn allocateMembers(self: *const Self, count: usize) std.mem.Allocator.Error!void {
    self.current().columns = .{ .names = try self.allocator.alloc([]const u8, count), .types = null };
}
