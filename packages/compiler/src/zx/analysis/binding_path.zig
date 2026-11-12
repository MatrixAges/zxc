const std = @import("std");
const zx = @import("zx");
const syntax = zx.syntax.borrow;
const enabled = @import("parser_options").generated_parser;
const seed = @import("binding_path/seed.zig");

pub const Path = struct {
    text: []const u8,
    allocated: bool = false,
    pub fn release(self: Path, allocator: std.mem.Allocator) void {
        if (self.allocated) allocator.free(self.text);
    }
    pub fn rooted(self: Path, name: []const u8) bool {
        return name.len <= self.text.len and overlaps(name, self.text);
    }
};

pub fn valid(name: []const u8) bool {
    if (!enabled) return seed.valid(name);

    var empty = std.heap.FixedBufferAllocator.init(&.{});

    return @import("generated_binding_path_valid").executeIn(empty.allocator(), name) catch |err| switch (err) {
        error.InvalidUtf8 => false,
        else => unreachable,
    };
}

pub fn overlaps(left: []const u8, right: []const u8) bool {
    if (!enabled) return seed.overlaps(left, right);

    var empty = std.heap.FixedBufferAllocator.init(&.{});

    return @import("generated_binding_path_overlaps").executeIn(empty.allocator(), &.{ .left = left, .right = right }) catch unreachable;
}

pub fn matches(expression: anytype, name: []const u8) bool {
    if (comptime !enabled or @TypeOf(expression) == *const zx.ast.Expression) return seed.matches(expression, name);

    return relation(expression, name, false);
}

pub fn rooted(expression: anytype, name: []const u8) bool {
    if (comptime !enabled or @TypeOf(expression) == *const zx.ast.Expression) return seed.rooted(expression, name);

    return relation(expression, name, true);
}

fn relation(expression: anytype, name: []const u8, prefix: bool) bool {
    const context = expression.context;
    const nodes = context.storage.expressions.nodes;
    const node = nodes[expression.index];

    if (node.kind != .Identifier and node.kind != .Field) return false;

    var empty = std.heap.FixedBufferAllocator.init(&.{});

    return @import("generated_binding_path_match").executeIn(empty.allocator(), &.{
        .source = context.source,
        .nodes = nodes,
        .native_names = null,
        .node = expression.index,
        .path = name,
        .rooted = prefix,
    }) catch unreachable;
}

/// A contiguous indexed path borrows the parsed expression source.
pub fn path(allocator: std.mem.Allocator, expression: anytype) std.mem.Allocator.Error!?[]const u8 {
    const result = try view(allocator, expression) orelse return null;

    if (comptime !enabled or @TypeOf(expression) == *const zx.ast.Expression) {
        if (!result.allocated) return try allocator.dupe(u8, result.text);
    }

    return result.text;
}

/// Identifiers and contiguous indexed paths borrow the parsed expression source.
pub fn view(allocator: std.mem.Allocator, expression: anytype) std.mem.Allocator.Error!?Path {
    if (comptime enabled and @TypeOf(expression) != *const zx.ast.Expression) {
        const context = expression.context;
        const node = context.storage.expressions.nodes[expression.index];

        if (node.kind == .Identifier) return .{ .text = context.text(node.name) };
        if (node.kind != .Field) return null;

        var empty = std.heap.FixedBufferAllocator.init(&.{});

        const layout = (@import("generated_binding_path_layout").executeValue(empty.allocator(), &.{
            .nodes = context.storage.expressions.nodes,
            .node = expression.index,
        }) catch unreachable) orelse return null;

        if (layout.contiguous) return .{ .text = context.source[@intCast(layout.start)..][0..@intCast(layout.length)] };

        return .{ .text = try copy(allocator, expression, @intCast(layout.length)), .allocated = true };
    }

    const value = syntax.value(expression);

    if (value == .identifier) return .{ .text = value.identifier.text };

    return .{ .text = try copy(allocator, expression, seed.pathLength(expression) orelse return null), .allocated = true };
}

fn copy(allocator: std.mem.Allocator, expression: anytype, length: usize) std.mem.Allocator.Error![]const u8 {
    const result = try allocator.alloc(u8, length);

    writePath(expression, result);

    return result;
}

fn writePath(expression: anytype, output: []u8) void {
    const value = syntax.value(expression);

    if (value == .identifier) {
        @memcpy(output, value.identifier.text);

        return;
    }

    const name = value.field.name.text;
    const separator = output.len - name.len - 1;

    writePath(value.field.target, output[0..separator]);

    output[separator] = '.';

    @memcpy(output[separator + 1 ..], name);
}
