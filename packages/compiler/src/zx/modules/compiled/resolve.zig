const std = @import("std");
const zx = @import("zx");
const compiled = @import("../compiled.zig");
const generated = @import("parser_options").generated_parser;

pub const Result = union(enum) { found: usize, missing, conflict };

pub fn library(allocator: std.mem.Allocator, libraries: []const compiled.Library, root: []const u8, target: compiled.Target) std.mem.Allocator.Error!Result {
    const match = if (comptime generated) find(libraries, target.instance) else findSeed(libraries, target.instance);
    const index = match.first orelse return .missing;

    if (match.duplicate) return .conflict;

    const path = try std.fs.path.resolve(allocator, &.{ root, libraries[index].artifact });

    defer allocator.free(path);

    return if (zx.bytes.equal(path, target.artifact)) .{ .found = index } else .conflict;
}

const Match = struct { first: ?usize = null, duplicate: bool = false };

fn find(libraries: []const compiled.Library, instance: []const u8) Match {
    const rule = @import("generated_project_package_select");
    const Input = std.meta.Child(rule.Input);
    const batch_size = @import("../package_scope.zig").lookup_batch_size;
    var keys: [batch_size][]const u8 = undefined;
    var scratch = std.heap.FixedBufferAllocator.init(&.{});
    var result: Match = .{};
    var offset: usize = 0;

    while (offset < libraries.len) {
        const batch = libraries[offset..][0..@min(keys.len, libraries.len - offset)];

        for (batch, keys[0..batch.len]) |*candidate, *key| key.* = candidate.instance;

        const input: Input = .{ .specifiers = keys[0..batch.len], .name = instance, .offset = offset, .first = result.first };
        const selection = zx.columns.invoke(rule.executeValue, scratch.allocator(), &input) catch unreachable;

        result = .{ .first = selection.first, .duplicate = selection.duplicate };

        if (result.duplicate) break;

        offset += batch.len;
    }

    return result;
}

fn findSeed(libraries: []const compiled.Library, instance: []const u8) Match {
    var result: Match = .{};

    for (libraries, 0..) |*candidate, index| {
        if (!zx.bytes.equal(candidate.instance, instance)) continue;

        if (result.first != null) {
            result.duplicate = true;

            break;
        }

        result.first = index;
    }

    return result;
}
