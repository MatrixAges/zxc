const std = @import("std");
const Shape = @import("shape.zig");
const Plan = @import("plan.zig");
const Counts = Plan.Counts;
const Error = @import("../builder.zig").Error;
const Exit = enum(u32) { Continue, Return, Unreachable };

pub fn plan(shape: *const Shape, rows: []Plan.Row, capture_count: usize, void_output: bool) Error!Plan {
    for (rows, shape.units.items(.first), shape.units.items(.count)) |*row, first, count| {
        row.* = try summarize(shape, rows, first, count);
    }

    const exit: Exit = @fromBackingInt(@intCast(rows[rows.len - 1].tag));

    if (exit == .Unreachable) return error.UnreachableFlow;
    if (exit == .Continue and !void_output) return error.IncompleteFlow;

    var size: Counts = .{};
    var blocks: u32 = 0;

    for (rows, shape.units.items(.block)) |*row, block| {
        if (block) {
            const next = try size.plus(row.first);

            row.* = .{ .first = size, .tag = blocks };
            size = next;
            blocks += 1;
        } else row.tag = std.math.maxInt(u32);
    }

    size = try size.plus(.{
        .constants = std.math.cast(u32, capture_count) orelse return error.OutOfMemory,
        .results = @intFromBool(exit == .Continue),
    });

    if (size.statements() > std.math.maxInt(u32)) return error.OutOfMemory;

    return .{ .rows = rows, .size = size, .blocks = blocks, .implicit_return = exit == .Continue };
}

fn summarize(shape: *const Shape, rows: []const Plan.Row, first: u32, count: u32) Error!Plan.Row {
    var exit: Exit = .Continue;
    var size: Counts = .{};

    for (first..@as(usize, first) + count) |index| {
        if (exit != .Continue) {
            exit = .Unreachable;

            break;
        }

        const step = shape.steps.get(index);

        switch (step.kind) {
            .Call => size = try size.plus(.{ .constants = step.getters }),
            .Parallel => size = try size.plus(.{ .constants = step.getters, .parallels = 1, .invocations = step.count }),
            .Return => {
                size = try size.plus(.{ .results = 1 });
                exit = .Return;
            },
            .Task => {
                const child = rows[step.first];
                const end: Exit = @fromBackingInt(@intCast(child.tag));

                size = try size.plus(child.first);

                if (step.output == .None or end == .Unreachable) exit = end;
            },
            .Selection => {
                size = try size.plus(.{ .selections = 1, .cases = step.count });
                exit = if (step.exhaustive) .Return else .Continue;

                for (shape.cases.items[step.first..][0..step.count]) |id| {
                    const end: Exit = @fromBackingInt(@intCast(rows[id].tag));

                    if (end == .Unreachable) {
                        exit = end;

                        break;
                    }

                    if (end == .Continue) exit = end;
                }
            },
        }

        size = try size.plus(.{
            .evaluations = @intFromBool(step.output == .Evaluate),
            .constants = @intFromBool(step.output == .Constant),
        });
    }

    return .{ .first = size, .tag = @backingInt(exit) };
}
