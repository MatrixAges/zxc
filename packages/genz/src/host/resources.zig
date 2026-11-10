const std = @import("std");
const zx = @import("zx");

pub const Options = struct {
    digest: []const u8,
    resources_digest: []const u8,
    zig_digest: []const u8,
    zig_version: []const u8,
    zig_host: []const u8,
    zig_directory: []const u8,
    zig_format: enum { zip, xz },
};

pub fn render(allocator: std.mem.Allocator, options: Options) std.mem.Allocator.Error![]u8 {
    if (comptime !@import("genz_options").generated_analysis) return @import("resources_seed.zig").render(allocator, options);

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const entry = @import("generated_host_resources");
    const input = zx.columns.view(std.meta.Child(entry.Input), options);

    const output = zx.columns.invoke(entry.executeValue, arena.allocator(), &input) catch |err| return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => @panic("invalid host metadata AST"),
    };

    if (!output.valid) return error.OutOfMemory;

    return @import("../printer/module.zig").render(allocator, arena.allocator(), std.meta.Child(entry.Output), output);
}
