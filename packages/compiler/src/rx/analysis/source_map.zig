const std = @import("std");
const rx = @import("rx");
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
        .location = locateSource(source, offset - self.base(index)),
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

pub fn locateSource(source: rx.ModuleSource, offset: usize) rx.ast.Location {
    if (source.indexedPositions()) |positions| {
        if (positions.attributeAt(offset)) |attribute| {
            return rx.rawAttributeLocation(attribute.raw_value.?, attribute.value_location, offset, false);
        }

        if (offset == source.node.location.offset) return source.node.location;

        return locateTag(source.node, offset) orelse source.node.location;
    }

    return locateNode(source.node, offset) orelse source.node.location;
}

fn locateTag(node: rx.ast.Node, offset: usize) ?rx.ast.Location {
    const child = std.sort.upperBound(rx.ast.Node, node.children, offset, struct {
        fn compare(value: usize, item: rx.ast.Node) std.math.Order {
            return std.math.order(value, item.location.offset);
        }
    }.compare);

    if (child != 0) return locateTag(node.children[child - 1], offset);

    return if (node.location.offset == offset) node.location else null;
}

pub fn locateNode(node: rx.ast.Node, offset: usize) ?rx.ast.Location {
    for (node.attributes) |attribute| {
        const source = attribute.raw_value orelse continue;
        const start = attribute.value_location.offset;

        if (offset < start or offset - start > source.len) continue;

        return rx.rawAttributeLocation(source, attribute.value_location, offset, false);
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
