const std = @import("std");
const Flow = @import("../flow.zig");
const Call = @import("../../module.zig").Call;
pub const Kind = enum { Call, Parallel, Return, Task, Selection };
pub const Publish = enum { None, Evaluate, Constant };

const Step = struct {
    kind: Kind,
    output: Publish = .None,
    getters: u32 = 0,
    first: u32 = 0,
    count: u32 = 0,
    exhaustive: bool = false,
};

const Unit = struct { first: u32, count: u32, block: bool };
const Self = @This();
const Error = std.mem.Allocator.Error;

steps: std.MultiArrayList(Step) = .{},
units: std.MultiArrayList(Unit) = .{},
cases: std.ArrayList(u32) = .empty,
pub fn collect(allocator: std.mem.Allocator, sequence: []const Flow.Step, calls: []const Call) Error!Self {
    var result: Self = .{};
    _ = try result.unit(allocator, sequence, calls, true);

    return result;
}

pub fn child(self: *const Self, owner: u32, index: usize) u32 {
    const first = self.units.items(.first)[owner];

    return self.steps.items(.first)[@as(usize, first) + index];
}

fn unit(self: *Self, allocator: std.mem.Allocator, sequence: []const Flow.Step, calls: []const Call, block: bool) Error!u32 {
    const first = try narrow(self.steps.len);
    const count = try narrow(sequence.len);
    const end = @as(u64, first) + count;

    if (end > std.math.maxInt(u32)) return error.OutOfMemory;
    try self.steps.resize(allocator, @intCast(end));

    for (sequence, @as(usize, first)..) |*step, position| {
        const row: Step = switch (step.*) {
            .call => |index| .{
                .kind = .Call,
                .output = if (calls[index].out != null) .Constant else .Evaluate,
                .getters = try narrow(calls[index].getters.len),
            },
            .parallel => |indices| parallel: {
                var getters: usize = 0;

                for (indices) |index| getters = std.math.add(usize, getters, calls[index].getters.len) catch return error.OutOfMemory;

                break :parallel .{ .kind = .Parallel, .getters = try narrow(getters), .count = try narrow(indices.len) };
            },
            .result => .{ .kind = .Return },
            .task => |task| .{
                .kind = .Task,
                .first = try self.unit(allocator, task.body, calls, false),
                .output = if (task.output) |output| if (output.name == null) .Evaluate else .Constant else .None,
            },
            .selection => |selection| branch: {
                const start = try narrow(self.cases.items.len);
                const size = try narrow(selection.cases.len);
                const limit = @as(u64, start) + size;

                if (limit > std.math.maxInt(u32)) return error.OutOfMemory;

                try self.cases.resize(allocator, @intCast(limit));

                for (selection.cases, @as(usize, start)..) |*entry, slot| {
                    const id = try self.unit(allocator, entry.body, calls, true);

                    self.cases.items[slot] = id;
                }

                break :branch .{ .kind = .Selection, .first = start, .count = size, .exhaustive = selection.exhaustive };
            },
        };

        self.steps.set(position, row);
    }

    const id = try narrow(self.units.len);

    try self.units.append(allocator, .{ .first = first, .count = count, .block = block });

    return id;
}

fn narrow(value: usize) Error!u32 {
    return std.math.cast(u32, value) orelse error.OutOfMemory;
}
