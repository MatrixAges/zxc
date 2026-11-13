const std = @import("std");
const zx = @import("zx");
const enabled = @import("parser_options").generated_parser;

pub fn version(cached_source: *const [32]u8, source: *const [32]u8, cached_context: *const [32]u8, context: *const [32]u8) bool {
    if (comptime enabled) {
        const generated = @import("generated_semantic_cache_entry_version");

        const input: std.meta.Child(generated.Input) = .{
            .cached_source = cached_source,
            .source = source,
            .cached_context = cached_context,
            .context = context,
        };

        var empty = std.heap.FixedBufferAllocator.init(&.{});

        return zx.columns.invoke(generated.executeValue, empty.allocator(), &input) catch unreachable;
    }

    return std.mem.eql(u8, cached_source, source) and std.mem.eql(u8, cached_context, context);
}
