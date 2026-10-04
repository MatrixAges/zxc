const std = @import("std");
const rx = @import("rx");
const zx = @import("zx");
const Self = @This();
const Range = struct { start: usize, end: usize };

pub const Origin = struct { source_index: usize, path: []const u8, location: rx.ast.Location };

sources: []const rx.ModuleSource,
ranges: []const Range,
pub fn init(allocator: std.mem.Allocator, sources: []const rx.ModuleSource) error{ OutOfMemory, SourceTooLarge }!Self {
    const ranges = try allocator.alloc(Range, sources.len);

    errdefer allocator.free(ranges);

    var start: usize = 0;

    for (sources, ranges) |source, *range| {
        const length = try add(try extent(source.node), 1);
        const end = try add(start, length);
        range.* = .{ .start = start, .end = end };
        start = end;
    }

    return .{ .sources = sources, .ranges = ranges };
}

pub fn base(self: Self, source_index: usize) usize {
    return self.ranges[source_index].start;
}

pub fn locate(self: Self, offset: usize) ?Origin {
    var low: usize = 0;
    var high = self.ranges.len;

    while (low < high) {
        const index = low + (high - low) / 2;
        const range = self.ranges[index];

        if (offset < range.start) {
            high = index;
        } else if (offset >= range.end) {
            low = index + 1;
        } else {
            const source = self.sources[index];

            return .{
                .source_index = index,
                .path = source.path,
                .location = locateNode(source.node, offset - range.start) orelse source.node.location,
            };
        }
    }

    return null;
}

pub fn locateNode(node: rx.ast.Node, offset: usize) ?rx.ast.Location {
    for (node.attributes) |attribute| {
        const source = attribute.raw_value orelse continue;
        const start = attribute.value_location.offset;

        if (offset < start or offset - start > source.len) continue;

        const position = zx.source.locate(source, offset - start);

        return .{ .offset = offset, .line = attribute.value_location.line + position.line - 1, .column = if (position.line == 1) attribute.value_location.column + position.column - 1 else position.column };
    }

    for (node.children) |child| {
        if (locateNode(child, offset)) |location| return location;
    }

    if (offset == node.location.offset) return node.location;

    return null;
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
