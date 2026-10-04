const std = @import("std");
const compiler = @import("compiler");

pub fn link(allocator: std.mem.Allocator, reverse: bool) !compiler.library.Result {
    const sources = [_]compiler.project.Source{
        .{ .path = "main.zx", .source = @embedFile("native/main.zx") },
        .{ .path = "helper.zx", .source = @embedFile("native/helper.zx") },
    };
    const interfaces = [_]compiler.project.NativeInterface{.{
        .specifier = "zig:choice",
        .path = "choice.d.zx",
        .source = @embedFile("native/choice.d.zx"),
        .module = "choice",
    }};
    var main = try compiler.project.analyze(std.heap.page_allocator, &sources, .{ .entry = "main.zx", .root_dir = "/project", .native_interfaces = &interfaces });
    defer main.deinit();
    var helper = try compiler.project.analyze(std.heap.page_allocator, &sources, .{ .entry = "helper.zx", .root_dir = "/project", .native_interfaces = &interfaces });
    defer helper.deinit();
    if (main.value != .ir or helper.value != .ir) return error.InvalidFixture;

    var inputs = [_]compiler.library.Input{
        .{ .name = "alpha", .analysis = &main },
        .{ .name = "beta", .analysis = &helper },
        .{ .name = "repeat", .analysis = &main },
    };
    if (reverse) std.mem.reverse(compiler.library.Input, &inputs);

    return compiler.library.link(allocator, &inputs);
}
