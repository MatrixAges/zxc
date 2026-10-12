const std = @import("std");
const modules = @import("checks").modules;

pub fn main(init: std.process.Init) !void {
    const temporary = init.arena.allocator();
    const args = try init.minimal.args.toSlice(temporary);
    const count = try std.fmt.parseInt(usize, args[3], 10);
    const shared_route = std.mem.eql(u8, args[2], "shared");

    if (!shared_route and !std.mem.eql(u8, args[2], "single")) return error.InvalidRoute;
    if (args.len != count + 6) return error.InvalidOutputCount;

    const program = if (std.mem.eql(u8, args[1], "scalar")) try @import("runtime/scalar.zig").program(temporary, count) else if (std.mem.eql(u8, args[1], "nested")) try @import("buffer_fixture.zig").program(temporary) else return error.InvalidKind;
    const names = try @import("names.zig").create(temporary, program);

    if (program.functions.count() != count) return error.InvalidFunctionCount;

    var output = std.heap.ArenaAllocator.init(std.heap.page_allocator);

    defer output.deinit();

    const allocator = output.allocator();
    const sources = try allocator.alloc([]const u8, count + 2);

    {
        var shared = if (shared_route) try modules.Analysis.create(std.heap.page_allocator, program) else null;

        defer if (shared) |*summary| summary.deinit();

        for (sources, 0..) |*source, index| {
            const unit: modules.Unit = switch (index) {
                0 => .types,
                1 => .entry,
                else => .{ .function = @fromBackingInt(@intCast(index - 2)) },
            };

            source.* = if (shared) |summary| try modules.analyzed(allocator, std.heap.page_allocator, program, names, unit, summary.value) else try modules.prepared(allocator, program, names, unit);
        }
    }

    for (sources, args[4..]) |source, path| try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = path, .data = source });
}
