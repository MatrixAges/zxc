const std = @import("std");
const rx = @import("rx");

pub fn main(init: std.process.Init) !void {
    var heap: std.heap.DebugAllocator(.{}) = .init;

    defer std.debug.assert(heap.deinit() == .ok);

    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    const sources = try allocator.alloc(rx.TextSource, args.len - 1);

    for (args[1..], sources) |path, *source| source.* = .{ .path = path, .source = try std.Io.Dir.cwd().readFileAlloc(init.io, path, allocator, .limited(16 * 1024 * 1024)) };

    var result = try rx.parseModules(heap.allocator(), sources);

    defer result.deinit();

    if (result.value == .diagnostic) {
        std.debug.print("{s}\n", .{try std.json.Stringify.valueAlloc(allocator, result.value.diagnostic, .{})});

        return;
    }

    const paths = try allocator.alloc([]const u8, result.value.data.len);
    const ordered = try allocator.alloc([]const u8, result.dependency_order.len);

    for (result.value.data, paths) |module, *path| path.* = module.path;
    for (result.dependency_order, ordered) |index, *path| path.* = result.value.data[index].path;

    std.debug.print("{s}\n", .{try std.json.Stringify.valueAlloc(allocator, .{ .source_order = paths, .dependency_order = ordered }, .{ .whitespace = .indent_2 })});
}
