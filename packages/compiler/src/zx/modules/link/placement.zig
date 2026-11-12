const std = @import("std");
const zx = @import("zx");
pub const Action = enum { Skip, Append, Invalid };

pub fn select(stores: usize, has_body: bool) Action {
    if (comptime !@import("parser_options").generated_parser) return if (stores != 0) .Invalid else if (has_body) .Append else .Skip;

    const generated = @import("generated_artifact_placement");
    const Input = std.meta.Child(generated.Input);
    const input: Input = .{ .stores = stores, .has_body = has_body };
    var empty = std.heap.FixedBufferAllocator.init(&.{});

    return switch (zx.columns.invoke(generated.executeValue, empty.allocator(), &input) catch unreachable) {
        .Skip => .Skip,
        .Append => .Append,
        .Invalid => .Invalid,
    };
}
