const std = @import("std");
const zx = @import("zx");
const source_index = @import("../../../source_index.zig");
const enabled = @import("parser_options").generated_parser;
const Self = @This();

const State = if (enabled) union(enum) {
    empty,
    spans: []u64,
    names: source_index.Map,
} else union(enum) {
    empty,
    names: source_index.Map,
};

state: State = .empty,
claimed: usize = 0,
pub fn claim(self: *Self, allocator: std.mem.Allocator, item: anytype) std.mem.Allocator.Error!?zx.ast.Name {
    const count = item.nameCount();

    if (item.exported or count == 0) return null;

    if (comptime enabled and @hasField(@TypeOf(item.header), "storage")) {
        if (self.state == .empty) self.state = .{ .spans = try @import("../../../source_index/fixed.zig").bucketsFor(allocator, item.header.importBindingCount()) };

        const buckets = self.state.spans;
        const generated = @import("generated_project_import_claim");
        const Input = std.meta.Child(generated.Input);
        const row = item.header.storage.imports[item.index];

        const input: Input = .{
            .source = item.header.source,
            .names = zx.columns.slice(@FieldType(Input, "names"), item.header.storage.import_names),
            .first = row.first,
            .count = row.count,
            .buckets = @ptrCast(&buckets),
            .capacity = buckets.len,
        };

        var empty = std.heap.FixedBufferAllocator.init(&.{});
        const duplicate = zx.columns.invoke(generated.executeValue, empty.allocator(), &input) catch unreachable;

        return if (duplicate) |offset| item.nameAt(@intCast(offset)) else null;
    }

    if (self.state == .empty) self.state = .{ .names = try source_index.Map.init(allocator, item.header.importBindingCount()) };

    for (0..count) |offset| {
        const name = item.nameAt(offset);

        if (!self.state.names.claim(self.claimed, name.text)) return name;

        self.claimed += 1;
    }

    return null;
}

pub fn deinit(self: Self, allocator: std.mem.Allocator) void {
    if (comptime enabled) {
        if (self.state == .spans) {
            allocator.free(self.state.spans);

            return;
        }
    }

    if (self.state == .names) self.state.names.deinit(allocator);
}
