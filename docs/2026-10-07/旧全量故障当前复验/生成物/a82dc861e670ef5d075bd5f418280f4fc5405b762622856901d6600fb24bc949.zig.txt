const std = @import("std");
const catalog = @import("genz").host.catalog;

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    const manifest = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], allocator, .unlimited);
    const modules = try std.json.parseFromSliceLeaky([]const catalog.Module, allocator, manifest, .{});
    const source = try catalog.render(allocator, modules);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[2], .data = source });
}
