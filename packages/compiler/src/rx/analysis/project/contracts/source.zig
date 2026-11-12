const std = @import("std");
const rx = @import("rx");
const zx = @import("zx");
const Prepared = @import("../prepare.zig");
const SourceMap = @import("../../source_map.zig");
const target = @import("../../call/target.zig");
const enabled = @import("rx_options").generated_graph;
const Self = @This();
pub const Kind = enum { input, output };

const Entry = struct { module: u64, location: @FieldType(rx.ast.Node, "location"), attribute: rx.ast.Attribute, expression: []const u8 };

allocator: std.mem.Allocator,
text: []const u8 = &.{},
entries: std.MultiArrayList(Entry) = .empty,
names: []const []const u8 = &.{},
ends: []const u64 = &.{},
pub fn collect(self: *Self, modules: []const Prepared.Module) std.mem.Allocator.Error!void {
    for (modules, 0..) |module, index| {
        for (module.source.node.children) |node| {
            if (!std.mem.eql(u8, node.name, "Args")) continue;
            try self.append(index, node, "in");
            try self.append(index, node, "out");
        }
    }

    if (self.entries.len == 0) return;
    if (!enabled) return self.seed();

    const entries = self.entries.slice();
    const generated = @import("generated_rx_args_source");
    const expressions = entries.items(.expression);

    const result = generated.executeValue(self.allocator, &.{
        .owners = entries.items(.module),
        .expressions = expressions,
    }) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.Overflow, error.IntegerOverflow => return error.OutOfMemory,
        else => unreachable,
    };

    const text = try self.allocator.alloc(u8, @intCast(result.ends[entries.len - 1]));
    var writer: std.Io.Writer = .fixed(text);
    var empty = std.heap.FixedBufferAllocator.init(&.{});

    @import("generated_rx_args_render").executeValue(empty.allocator(), &.{
        .writer = @ptrCast(&writer),
        .names = result.names,
        .expressions = expressions,
    }) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    std.debug.assert(writer.end == text.len);

    self.text = text;
    self.names = result.names;
    self.ends = result.ends;
}

fn append(self: *Self, module: usize, node: rx.ast.Node, key: []const u8) std.mem.Allocator.Error!void {
    const attribute = target.attribute(node, key);

    try self.entries.append(self.allocator, .{ .module = module, .location = node.location, .attribute = attribute, .expression = attribute.value });
}

fn seed(self: *Self) std.mem.Allocator.Error!void {
    const entries = self.entries.slice();
    const names = try self.allocator.alloc([]const u8, entries.len);
    const ends = try self.allocator.alloc(u64, entries.len);
    var text: std.ArrayList(u8) = .empty;

    for (entries.items(.module), entries.items(.expression), 0..) |owner, expression, index| {
        const name = try std.fmt.allocPrint(self.allocator, "Rx{s}{d}", .{ if (index % 2 == 0) "Input" else "Output", owner });

        try text.appendSlice(self.allocator, "export type ");
        try text.appendSlice(self.allocator, name);
        try text.appendSlice(self.allocator, " = ");
        try text.appendSlice(self.allocator, expression);
        try text.append(self.allocator, '\n');

        ends[index] = text.items.len;
        names[index] = name;
    }

    self.text = text.items;
    self.names = names;
    self.ends = ends;
}

pub fn valid(self: Self, view: anytype) bool {
    const declarations = view.declarations();

    if (declarations.count() != self.names.len) return false;

    var iterator = declarations.iterator();

    for (self.names) |name| {
        if (!std.mem.eql(u8, iterator.next().?.name.text, name)) return false;
    }

    return true;
}

pub fn span(self: Self, source_map: SourceMap, offset: usize) zx.Span {
    const selected = self.locate(offset);
    const entry = self.entries.slice().get(selected.index);

    const location = if (selected.relative) |relative|
        rx.attributeLocation(entry.attribute, relative) orelse entry.attribute.value_location
    else
        entry.location;

    const start = source_map.base(@intCast(entry.module)) + location.offset;

    return .{ .start = start, .end = start };
}

const Location = struct { index: usize, relative: ?usize };

fn locate(self: Self, offset: usize) Location {
    const expressions = self.entries.items(.expression);

    if (!enabled) {
        for (expressions, self.ends, 0..) |expression, end, index| {
            if (offset >= end) continue;

            const start = end - 1 - expression.len;

            return .{ .index = index, .relative = if (offset >= start) @intCast(offset - start) else null };
        }

        return .{ .index = self.ends.len - 1, .relative = null };
    }

    var empty = std.heap.FixedBufferAllocator.init(&.{});

    const result = @import("generated_rx_args_location").executeValue(empty.allocator(), &.{
        .expressions = expressions,
        .ends = self.ends,
        .offset = offset,
    }) catch unreachable;

    return .{ .index = @intCast(result.entry), .relative = if (result.relative) |relative| @intCast(relative) else null };
}
