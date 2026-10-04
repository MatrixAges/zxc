const std = @import("std");
const compiler = @import("compiler");
const Input = struct { sources: []const compiler.project.Source, options: compiler.project.Options };

pub fn main(init: std.process.Init) !void {
    var heap: std.heap.DebugAllocator(.{}) = .init;

    defer std.debug.assert(heap.deinit() == .ok);

    const temporary = init.arena.allocator();
    const args = try init.minimal.args.toSlice(temporary);
    const source = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], temporary, .limited(1024 * 1024));
    const input = try std.json.parseFromSliceLeaky(Input, temporary, source, .{});
    var result = try compiler.project.analyze(heap.allocator(), input.sources, input.options);

    defer result.deinit();

    const json = switch (result.value) {
        .ir => |program| try std.json.Stringify.valueAlloc(temporary, .{
            .kind = "ir",
            .valid = (try compiler.validateIr(heap.allocator(), program)) == null,
        }, .{}),
        .diagnostic => |issue| try std.json.Stringify.valueAlloc(temporary, .{
            .kind = "diagnostic",
            .code = issue.code,
            .message = issue.message,
        }, .{}),
    };

    std.debug.print("{s}\n", .{json});
}
