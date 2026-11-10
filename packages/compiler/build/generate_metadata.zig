const std = @import("std");
const host = @import("genz").host;

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    if (args.len != 4) return error.InvalidArguments;

    const manifest = try std.Io.Dir.cwd().readFileAlloc(init.io, args[2], allocator, .unlimited);

    const source = if (std.mem.eql(u8, args[1], "--catalog")) catalog: {
        const modules = try std.json.parseFromSliceLeaky([]const host.catalog.Module, allocator, manifest, .{});

        break :catalog try host.catalog.render(allocator, modules);
    } else if (std.mem.eql(u8, args[1], "--resources")) resources: {
        const options = try std.json.parseFromSliceLeaky(host.resources.Options, allocator, manifest, .{});

        break :resources try host.resources.render(allocator, options);
    } else return error.UnknownCommand;

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[3], .data = source });
}
