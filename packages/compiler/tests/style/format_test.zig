const std = @import("std");
const compiler = @import("compiler");

fn stripWhitespace(allocator: std.mem.Allocator, text: []const u8) ![]u8 {
    var result: std.ArrayList(u8) = .empty;

    for (text) |byte| if (!std.ascii.isWhitespace(byte)) {
        try result.append(allocator, byte);
    };

    return result.toOwnedSlice(allocator);
}

test "style: formatting is idempotent and preserves comments and tokens" {
    const input = "export type Input = u64\nexport type Output = u64\nexport default function (in: Input): Output {\n\n const first = in // keep this comment\n\n const second = first + 1\n return second\n\n}\n";
    const first = try compiler.format(std.testing.allocator, input, "format.zx");

    defer first.deinit(std.testing.allocator);

    try std.testing.expect(first == .source);

    const second = try compiler.format(std.testing.allocator, first.source, "format.zx");

    defer second.deinit(std.testing.allocator);

    try std.testing.expectEqualStrings(first.source, second.source);

    const original = try stripWhitespace(std.testing.allocator, input);

    defer std.testing.allocator.free(original);

    const formatted = try stripWhitespace(std.testing.allocator, first.source);

    defer std.testing.allocator.free(formatted);

    try std.testing.expectEqualStrings(original, formatted);
    try std.testing.expect(std.mem.indexOf(u8, first.source, "// keep this comment") != null);
}

test "style: a pure type file does not need an extra blank line at EOF" {
    const source = "export type Value = u64\n";
    const result = try compiler.format(std.testing.allocator, source, "types.zx");

    defer result.deinit(std.testing.allocator);

    try std.testing.expectEqualStrings(source, result.source);
}

test "style: naming checks reach callback and destructuring bindings" {
    for ([_][]const u8{
        "return loop(in, {while: BadName => false, next: current => current})\n",
        "const values = in.clone()\n const [BadName, _] = values.pop()\n return BadName\n",
    }) |body| {
        const source = try std.fmt.allocPrint(std.testing.allocator, "export type Input = u64[]\n export type Output = u64[]\n export default function (in: Input): Output {{ {s} }}", .{body});

        defer std.testing.allocator.free(source);

        const result = try compiler.compile(std.testing.allocator, source, "naming.zx");

        defer result.deinit(std.testing.allocator);

        try std.testing.expect(result == .diagnostic);
        try std.testing.expectEqualStrings("naming", @tagName(result.diagnostic.code));
    }
}

fn compileAllocationFailures(allocator: std.mem.Allocator) !void {
    const result = try compiler.compile(allocator, "export type Input = u64[]\n\nexport type Output = u64[]\n\nexport default function (in: Input): Output {\n    const values: u64[] = []\n\n    return loop({\n        source: in,\n        index: 0,\n        values\n    }, {\n        while: current => current.index < current.source.length,\n        next: current => {\n            current.values = current.values.push(current.source[current.index] + 1)[0]\n            current.index += 1\n        },\n        return: current => current.values\n    })\n}\n", "memory.zx");

    defer result.deinit(allocator);

    try std.testing.expect(result == .source);
}

test "integration: compilation frees all allocations at every failure point" {
    var vtable = std.testing.allocator.vtable.*;
    vtable.resize = std.mem.Allocator.noResize;
    vtable.remap = std.mem.Allocator.noRemap;
    const allocator: std.mem.Allocator = .{ .ptr = std.testing.allocator.ptr, .vtable = &vtable };

    try std.testing.checkAllAllocationFailures(allocator, compileAllocationFailures, .{});
}
