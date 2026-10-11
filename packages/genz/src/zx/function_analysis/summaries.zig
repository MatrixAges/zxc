const std = @import("std");
const ir = @import("zx").ir;
const flow = @import("../buffer_call/analysis/flow.zig");
const abi = @import("abi.zig");

/// Converts host lane summaries into the generated list layout.
pub fn summaries(comptime Slice: type, allocator: std.mem.Allocator, source: []const []const flow.Lane) std.mem.Allocator.Error!Slice {
    const Outer = abi.List(Slice);
    var outer = try Outer.init(allocator, source.len);

    for (source, outer.values) |lanes, *target| target.* = try list(Outer.Value, allocator, lanes);

    return outer.finish(allocator);
}

pub fn calls(comptime Slice: type, allocator: std.mem.Allocator, source: []const flow.Call) std.mem.Allocator.Error!Slice {
    const Calls = abi.List(Slice);
    var result = try Calls.init(allocator, source.len);

    for (source, result.values) |call, *target| target.* = .{ .expression = @backingInt(call.expression), .lane = call.lane };

    return result.finish(allocator);
}

fn list(comptime Slice: type, allocator: std.mem.Allocator, source: []const flow.Lane) std.mem.Allocator.Error!Slice {
    const Lanes = abi.List(Slice);
    const Lane = Lanes.Value;
    var result = try Lanes.init(allocator, source.len);

    for (source, result.values) |lane, *target| {
        const Iterations = abi.List(@FieldType(Lane, "iterations"));
        var iterations = try Iterations.init(allocator, lane.iterations.len);

        for (lane.iterations, iterations.values) |iteration, *item| item.* = .{ .expression = @backingInt(iteration.expression), .path = iteration.path };

        target.* = .{
            .input = lane.input,
            .output = lane.output,
            .appends = @ptrCast(lane.appends),
            .pops = @ptrCast(lane.pops),
            .updates = @ptrCast(lane.updates),
            .iterations = try iterations.finish(allocator),
            .calls = try calls(@FieldType(Lane, "calls"), allocator, lane.calls),
            .rejected = lane.rejection != null,
        };
    }

    return result.finish(allocator);
}
