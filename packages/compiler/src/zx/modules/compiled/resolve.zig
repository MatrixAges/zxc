const std = @import("std");
const zx = @import("zx");
const compiled = @import("../compiled.zig");
const registry = @import("../project/target/registry.zig");

pub const Result = union(enum) { found: usize, missing, conflict };

pub fn library(allocator: std.mem.Allocator, libraries: []const compiled.Library, root: []const u8, target: compiled.Target) std.mem.Allocator.Error!Result {
    const match = registry.select(libraries, "instance", target.instance, true);
    var buffer: [512]u8 = undefined;
    var scratch = std.heap.BufferFirstAllocator.init(&buffer, allocator);
    const temporary = scratch.allocator();

    const registered = if (match.first != null and !match.duplicate)
        try std.fs.path.resolve(temporary, &.{ root, libraries[match.first.?].artifact })
    else
        null;

    defer if (registered) |path| temporary.free(path);

    if (comptime @import("parser_options").generated_parser) {
        const rule = @import("generated_compiled_import_resolution");
        const input: std.meta.Child(rule.Input) = .{ .duplicate = match.duplicate, .registered = registered, .requested = target.artifact };
        var empty = std.heap.FixedBufferAllocator.init(&.{});

        return switch (zx.columns.invoke(rule.executeValue, empty.allocator(), &input) catch unreachable) {
            .Found => .{ .found = match.first.? },
            .Missing => .missing,
            .Conflict => .conflict,
        };
    }

    const index = match.first orelse return .missing;
    const path = registered orelse return .conflict;

    return if (zx.bytes.equal(path, target.artifact)) .{ .found = index } else .conflict;
}
