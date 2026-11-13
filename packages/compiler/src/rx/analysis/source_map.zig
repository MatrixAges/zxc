const std = @import("std");
const rx = @import("rx");
const zx = @import("zx");
const Self = @This();
const generated = @import("rx_options").generated_graph;

pub const Origin = struct { source_index: usize, path: []const u8, location: rx.ast.Location };

sources: []const rx.ModuleSource,
ends: []const u64,
pub fn init(allocator: std.mem.Allocator, sources: []const rx.ModuleSource) error{ OutOfMemory, SourceTooLarge }!Self {
    const ends = try allocator.alloc(u64, sources.len);

    errdefer allocator.free(ends);

    var start: usize = 0;

    for (sources, ends) |source, *entry| {
        const last = source.indexedExtent() orelse try extent(source.node);
        const length = try add(last, 1);
        const end = try add(start, length);

        entry.* = end;
        start = end;
    }

    return .{ .sources = sources, .ends = ends };
}

pub fn deinit(self: Self, allocator: std.mem.Allocator) void {
    allocator.free(self.ends);
}

pub fn base(self: Self, source_index: usize) usize {
    return if (source_index == 0) 0 else @intCast(self.ends[source_index - 1]);
}

pub fn locate(self: Self, offset: usize) ?Origin {
    const index = self.moduleAt(offset);

    if (index == self.ends.len) return null;

    const source = self.sources[index];

    return .{
        .source_index = index,
        .path = source.path,
        .location = locateNode(source.node, offset - self.base(index)) orelse source.node.location,
    };
}

fn moduleAt(self: Self, offset: usize) usize {
    if (generated) {
        var empty = std.heap.FixedBufferAllocator.init(&.{});

        return @intCast(@import("generated_rx_source_module").executeValue(empty.allocator(), &.{
            .ends = self.ends,
            .offset = offset,
        }) catch unreachable);
    }

    var low: usize = 0;
    var high = self.ends.len;

    while (low < high) {
        const index = low + (high - low) / 2;

        if (offset < self.ends[index]) {
            high = index;
        } else {
            low = index + 1;
        }
    }

    return low;
}

pub fn locateNode(node: rx.ast.Node, offset: usize) ?rx.ast.Location {
    for (node.attributes) |attribute| {
        const source = attribute.raw_value orelse continue;
        const start = attribute.value_location.offset;

        if (offset < start or offset - start > source.len) continue;

        return position(source, attribute.value_location, offset);
    }

    for (node.children) |child| {
        if (locateNode(child, offset)) |location| return location;
    }

    if (offset == node.location.offset) return node.location;

    return null;
}

fn position(raw: []const u8, start: rx.ast.Location, offset: usize) rx.ast.Location {
    if (offset == start.offset) return start;

    if (generated) {
        var result: [2]u64 = undefined;
        const destination: []u64 = &result;
        var buffer: [@sizeOf([8]u64) + @alignOf(u64)]u8 = undefined;
        var scratch = std.heap.FixedBufferAllocator.init(&buffer);

        @import("generated_rx_source_position").executeValue(scratch.allocator(), &.{
            .raw = raw,
            .count = offset - start.offset,
            .line = start.line,
            .column = start.column,
            .position = @ptrCast(&destination),
        }) catch unreachable;

        return .{ .offset = offset, .line = @intCast(result[0]), .column = @intCast(result[1]) };
    }

    const location = zx.source.locate(raw, offset - start.offset);

    return .{ .offset = offset, .line = start.line + location.line - 1, .column = if (location.line == 1) start.column + location.column - 1 else location.column };
}

fn extent(node: rx.ast.Node) error{SourceTooLarge}!usize {
    var end = try add(node.location.offset, node.name.len);

    for (node.attributes) |attribute| {
        end = @max(end, try add(attribute.location.offset, attribute.name.len));
        end = @max(end, try add(attribute.value_location.offset, (attribute.raw_value orelse attribute.value).len));
    }

    for (node.text) |text| end = @max(end, try add(text.location.offset, text.value.len));
    for (node.children) |child| end = @max(end, try extent(child));

    return end;
}

fn add(left: usize, right: usize) error{SourceTooLarge}!usize {
    return std.math.add(usize, left, right) catch error.SourceTooLarge;
}
