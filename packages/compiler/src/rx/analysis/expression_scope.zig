const std = @import("std");
const frontend = @import("frontend");
const zx = @import("zx");
const Binding = frontend.expressions.Binding;
const Result = frontend.ExpressionInput.Result;
const generated = @import("rx_options").generated_graph;

pub const Selection = struct {
    bindings: []const Binding,
    positions: ?[]const u32 = null,
};

pub fn select(allocator: std.mem.Allocator, parsed: *const Result, bindings: []const Binding, facts: []const []const u8) std.mem.Allocator.Error!Selection {
    if (bindings.len < 2 or parsed.diagnostic() != null) return .{ .bindings = bindings };

    const positions = switch (parsed.*) {
        .native => |result| try native(allocator, result.value.parsed.expression, bindings, facts),
        .indexed => |result| if (frontend.ExpressionInput.indexed_enabled) block: {
            if (comptime generated) break :block try indexed(allocator, result, bindings, facts);

            const view = try result.view(allocator);

            break :block try indexSeed(allocator, view, bindings, facts);
        } else unreachable,
    };

    if (positions.len == bindings.len) return .{ .bindings = bindings };

    const selected = try allocator.alloc(Binding, positions.len);

    for (selected, positions) |*slot, index| slot.* = bindings[index];

    return .{ .bindings = selected, .positions = positions };
}

fn indexed(allocator: std.mem.Allocator, input: frontend.ExpressionInput.Indexed, bindings: []const Binding, facts: []const []const u8) std.mem.Allocator.Error![]const u32 {
    const names = try allocator.alloc([]const u8, bindings.len);

    for (names, bindings) |*name, binding| name.* = binding.name;

    const rule = @import("generated_rx_expression_scope");

    return rule.executeValue(allocator, &.{ .source = input.source, .nodes = input.output.expressions.nodes, .names = names, .facts = facts }) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => unreachable,
    };
}

fn native(allocator: std.mem.Allocator, expression: *const zx.ast.Expression, bindings: []const Binding, facts: []const []const u8) std.mem.Allocator.Error![]const u32 {
    var selected: std.ArrayList(u32) = .empty;

    for (bindings, 0..) |binding, index| {
        if (@import("expression_scope/seed.zig").includes(expression, facts, binding.name)) try selected.append(allocator, @intCast(index));
    }

    return selected.items;
}

fn indexSeed(allocator: std.mem.Allocator, view: frontend.ExpressionInput.View, bindings: []const Binding, facts: []const []const u8) std.mem.Allocator.Error![]const u32 {
    var selected: std.ArrayList(u32) = .empty;
    const paths = frontend.binding_path;

    for (bindings, 0..) |binding, index| {
        const found = for (0..view.storage.expressions.nodes.len) |node| {
            if (paths.matches(view.expression(node), binding.name)) break true;
        } else for (facts) |fact| {
            if (binding.name.len <= fact.len and paths.overlaps(binding.name, fact)) break true;
        } else false;

        if (found) try selected.append(allocator, @intCast(index));
    }

    return selected.items;
}
