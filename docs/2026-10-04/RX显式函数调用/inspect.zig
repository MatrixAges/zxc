const std = @import("std");
const frontend = @import("frontend");
const rx = @import("rx");
const analysis = @import("analysis");

pub fn main(init: std.process.Init) !void {
    var heap: std.heap.DebugAllocator(.{}) = .init;

    defer std.debug.assert(heap.deinit() == .ok);

    const temporary = init.arena.allocator();
    const args = try init.minimal.args.toSlice(temporary);

    if (args.len < 2) return error.MissingRxPath;

    const source = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], temporary, .limited(16 * 1024 * 1024));
    const sources = try temporary.alloc(frontend.project.Source, args.len - 2);

    for (args[2..], sources) |path, *item| item.* = .{ .path = path, .source = try std.Io.Dir.cwd().readFileAlloc(init.io, path, temporary, .limited(16 * 1024 * 1024)) };

    var parsed = try rx.parseXml(heap.allocator(), source);

    defer parsed.deinit();

    if (parsed.value == .diagnostic) {
        std.debug.print("{s}\n", .{try std.json.Stringify.valueAlloc(temporary, parsed.value.diagnostic, .{})});

        return;
    }

    var result = try analysis.module.infer(heap.allocator(), .{ .owner = args[1], .module = parsed.value.node, .sources = sources });

    defer result.deinit();

    const json = switch (result.value) {
        .contract => |contract| try std.json.Stringify.valueAlloc(temporary, .{
            .kind = "contract",
            .types = contract.types,
            .input = contract.input_type,
            .output = contract.output_type,
            .calls = contract.calls.len,
        }, .{}),
        .diagnostic => |issue| try std.json.Stringify.valueAlloc(temporary, .{ .kind = "diagnostic", .issue = issue }, .{}),
    };

    std.debug.print("{s}\n", .{json});
}
