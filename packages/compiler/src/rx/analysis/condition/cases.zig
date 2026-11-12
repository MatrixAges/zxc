const std = @import("std");
const frontend = @import("frontend");
const rx = @import("rx");
const Case = @import("../project/flow.zig").Case;
const condition = @import("../condition.zig");
const Result = frontend.ExpressionInput.Result;
const boolean_domain_size = 2;
const enabled = @import("rx_options").generated_graph;
const rule = if (enabled) @import("generated_rx_condition_coverage") else void;
const Coverage = if (enabled) std.meta.Child(rule.Output) else struct { stopped: bool, remaining: ?bool };
const Self = @This();

allocator: std.mem.Allocator,
owner: []const u8,
pending: std.ArrayList(Result) = .empty,
taken: usize = 0,
coverage: Coverage = .{ .stopped = false, .remaining = null },
pub fn deinit(self: *Self) void {
    for (self.pending.items[self.taken..]) |*parsed| parsed.deinit();

    self.pending.deinit(self.allocator);
}

pub fn label(self: *Self, attribute: rx.ast.Attribute) std.mem.Allocator.Error!Result {
    if (self.taken == self.pending.items.len) return @import("../attribute.zig").parse(self.allocator, attribute, self.owner);

    const parsed = self.pending.items[self.taken];

    self.taken += 1;

    return parsed;
}

pub fn observe(self: *Self, truth: ?bool) void {
    if (self.coverage.stopped) return;

    self.coverage = record(self.coverage, truth);
}

/// Look ahead only while every explicit label may exclude the same boolean value.
/// Retain a boolean domain's worth of labels for normal analysis in source order.
/// A run of repeated labels can still be scanned without retaining its syntax.
pub fn remaining(self: *Self, rest: []const Case) std.mem.Allocator.Error!?bool {
    for (rest) |case| {
        if (self.coverage.stopped) break;

        const attribute = case.value orelse continue;
        const retain = self.pending.items.len < boolean_domain_size;

        if (retain) try self.pending.ensureTotalCapacityPrecise(self.allocator, boolean_domain_size);

        var parsed = try @import("../attribute.zig").parse(self.allocator, attribute, self.owner);

        self.observe(condition.boolean(&parsed));

        if (retain) {
            self.pending.appendAssumeCapacity(parsed);
        } else {
            parsed.deinit();
        }
    }

    const truth = self.coverage.remaining;

    self.coverage.stopped = true;

    return truth;
}

fn record(coverage: Coverage, truth: ?bool) Coverage {
    if (comptime !enabled) {
        const next = !(truth orelse return .{ .stopped = true, .remaining = null });

        if (coverage.remaining) |previous| {
            if (previous != next) return .{ .stopped = true, .remaining = null };
        }

        return .{ .stopped = false, .remaining = next };
    }

    var empty = std.heap.FixedBufferAllocator.init(&.{});
    const result = rule.executeValue(empty.allocator(), &.{ .remaining = coverage.remaining, .label = truth }) catch unreachable;

    return .{ .stopped = result.stopped, .remaining = result.remaining };
}
