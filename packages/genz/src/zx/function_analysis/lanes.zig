const std = @import("std");
const ir = @import("zx").ir;
const flow = @import("../buffer_call/analysis/flow.zig");

pub fn copy(allocator: std.mem.Allocator, source: []const []const flow.Lane) std.mem.Allocator.Error![]const []const flow.Lane {
    const result = try allocator.alloc([]const flow.Lane, source.len);

    for (source, result) |lanes, *target| {
        const selected = try allocator.dupe(flow.Lane, lanes);

        for (selected) |*lane| {
            lane.input = try allocator.dupe(u32, lane.input);
            lane.output = try allocator.dupe(u32, lane.output);
            lane.appends = try allocator.dupe(ir.ExprId, lane.appends);
            lane.pops = try allocator.dupe(ir.ExprId, lane.pops);
            lane.updates = try allocator.dupe(ir.ExprId, lane.updates);
            lane.calls = try allocator.dupe(flow.Call, lane.calls);

            const iterations = try allocator.dupe(flow.Iteration, lane.iterations);

            for (iterations) |*iteration| iteration.path = try allocator.dupe(u32, iteration.path);

            lane.iterations = iterations;
        }

        target.* = selected;
    }

    return result;
}
