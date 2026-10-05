const std = @import("std");
const rx = @import("rx");
const analysis = @import("rx_analysis");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    const source = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], allocator, .limited(1024 * 1024));
    const module_source = if (args.len > 3) try std.Io.Dir.cwd().readFileAlloc(init.io, args[3], allocator, .limited(1024 * 1024)) else @embedFile("示例/main.rx");
    var module = try rx.parseXml(allocator, module_source);

    defer module.deinit();

    var store = try rx.parseXml(allocator, @embedFile("示例/state.store.rx"));

    defer store.deinit();

    if (module.value != .node or store.value != .node) return error.InvalidXml;

    var result = try analysis.project.infer(allocator, .{
        .entry = "main.rx",
        .modules = &.{.{ .path = "main.rx", .node = module.value.node }},
        .stores = &.{.{ .path = "state.store.rx", .node = store.value.node }},
        .sources = &.{
            .{ .path = "advance.zx", .source = source },
            .{ .path = "read_index.zx", .source = @embedFile("示例/read_index.zx") },
        },
    });

    defer result.deinit();

    if (result.value == .diagnostic) {
        const issue = result.value.diagnostic;

        std.debug.print("{s}: {s}\n", .{ issue.code, issue.message });

        return error.InvalidApplication;
    }

    try @import("emit_state.zig").write(init, result.value.contract, args[2]);
}
