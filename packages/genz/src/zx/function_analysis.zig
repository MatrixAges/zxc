const std = @import("std");
const ir = @import("zx").ir;
const buffer = @import("buffer_call/root.zig");
const Self = @This();

value: @import("value_call/analysis.zig").Summary,
buffers: []const []const buffer.Lane,
allocated: []const bool,
transfers: []const []const buffer.transfer_analysis.Capability,
io: []const bool,
process: []const bool,
pub const Owned = struct {
    arena: std.heap.ArenaAllocator,
    value: Self,
    pub fn deinit(self: *Owned) void {
        self.arena.deinit();

        self.* = undefined;
    }
};

pub fn create(backing: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!Owned {
    var scratch = std.heap.ArenaAllocator.init(backing);

    defer scratch.deinit();

    const facts = try analyze(scratch.allocator(), backing, program);
    var arena = std.heap.ArenaAllocator.init(backing);

    errdefer arena.deinit();

    const owned = arena.allocator();
    const transfers = try owned.alloc([]const buffer.transfer_analysis.Capability, facts.transfers.len);

    for (facts.transfers, transfers) |source, *target| target.* = try owned.dupe(buffer.transfer_analysis.Capability, source);

    const value: Self = .{
        .value = .{
            .pure = try owned.dupe(bool, facts.value.pure),
            .local = try owned.dupe(bool, facts.value.local),
            .values = try owned.dupe(bool, facts.value.values),
            .state = .{
                .selected = try owned.dupe(bool, facts.value.state.selected),
                .keys = try owned.dupe([32]u8, facts.value.state.keys),
            },
        },
        .buffers = try @import("function_analysis/lanes.zig").copy(owned, facts.buffers),
        .allocated = try owned.dupe(bool, facts.allocated),
        .transfers = transfers,
        .io = try owned.dupe(bool, facts.io),
        .process = try owned.dupe(bool, facts.process),
    };

    return .{ .arena = arena, .value = value };
}

pub fn analyze(allocator: std.mem.Allocator, workspace: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!Self {
    const value = try @import("value_call/analysis.zig").analyze(allocator, program);
    const buffers = try buffer.analysis.functions(allocator, workspace, program, value.values, value.pure);

    return .{
        .value = value,
        .buffers = buffers,
        .allocated = try @import("iteration_buffer/ownership/allocation.zig").functions(allocator, program, value.pure),
        .transfers = try buffer.transfer_analysis.functions(allocator, program, buffers, value.pure),
        .io = try @import("io.zig").functions(allocator, program),
        .process = try @import("capabilities.zig").functions(allocator, program, .process),
    };
}
