const std = @import("std");
const rx = @import("rx");
const zx = @import("zx");
const target = @import("../call/target.zig");
const generated = @import("rx_options").generated_graph;
const Self = @This();

fragments: []const rx.ast.Node,
offsets: []const usize,
fields: []const *const rx.ast.Node,
expressions: []const []const u8,
starts: []const u32,
next: []const ?u32,
names: []const []const u8,
ends: []const u64,
text: []const u8,
pub fn build(allocator: std.mem.Allocator, store: rx.ast.Node, groups: ?rx.store.Groups) std.mem.Allocator.Error!Self {
    const grouping = groups orelse try @import("layout/seed.zig").group(allocator, store.children);
    const fragments = store.children[grouping.first..];
    const offsets = try allocator.alloc(usize, fragments.len + 1);
    var count: usize = 0;

    for (fragments, offsets[0..fragments.len]) |fragment, *offset| {
        offset.* = count;
        count = std.math.add(usize, count, fragment.children.len) catch return error.OutOfMemory;
    }

    offsets[fragments.len] = count;

    const fields = try allocator.alloc(*const rx.ast.Node, count);
    const expressions = try allocator.alloc([]const u8, count);

    for (fragments, offsets[0..fragments.len]) |fragment, offset| {
        for (fragment.children, offset..) |*field, index| {
            fields[index] = field;
            expressions[index] = target.attribute(field.*, "type").value;
        }
    }

    const columns: Columns = if (comptime generated)
        try source(allocator, expressions)
    else
        try @import("layout/seed.zig").plan(allocator, expressions);

    return .{
        .fragments = fragments,
        .offsets = offsets,
        .fields = fields,
        .expressions = expressions,
        .starts = grouping.starts,
        .next = grouping.next,
        .names = columns.names,
        .ends = columns.ends,
        .text = columns.text,
    };
}

pub const Columns = struct {
    names: []const []const u8,
    ends: []const u64,
    text: []const u8,
};

fn source(allocator: std.mem.Allocator, expressions: []const []const u8) std.mem.Allocator.Error!Columns {
    const rule = @import("generated_rx_store_layout");
    const input: std.meta.Child(rule.Input) = .{ .expressions = expressions };

    const planned = zx.columns.invoke(rule.executeValue, allocator, &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.Overflow, error.IntegerOverflow => return error.OutOfMemory,
        else => unreachable,
    };

    const length = std.math.cast(usize, planned.ends[expressions.len - 1]) orelse return error.OutOfMemory;
    const text = try allocator.alloc(u8, length);
    var writer: std.Io.Writer = .fixed(text);
    var empty = std.heap.FixedBufferAllocator.init(&.{});

    @import("generated_rx_args_render").executeValue(empty.allocator(), &.{
        .writer = @ptrCast(&writer),
        .names = planned.names,
        .expressions = expressions,
    }) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    std.debug.assert(writer.end == text.len);

    return .{ .names = planned.names, .ends = planned.ends, .text = text };
}

pub fn typeStart(self: Self, index: usize) usize {
    return self.typeEnd(index) - self.expressions[index].len;
}

pub fn typeEnd(self: Self, index: usize) usize {
    return @as(usize, @intCast(self.ends[index])) - 1;
}

pub fn nameStart(self: Self, index: usize) usize {
    const base: usize = if (index == 0) 0 else @intCast(self.ends[index - 1]);

    return base + "export type ".len;
}
