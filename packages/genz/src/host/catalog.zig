const std = @import("std");
const zx = @import("zx");

pub const Module = struct {
    specifier: []const u8,
    path: []const u8,
    source: []const u8,
    text: ?[]const u8 = null,
    module: []const u8,
    namespace: []const []const u8,
    implementation_path: []const u8,
};

pub fn render(allocator: std.mem.Allocator, modules: []const Module) std.mem.Allocator.Error![]u8 {
    if (comptime !@import("genz_options").generated_analysis) return @import("catalog_seed.zig").render(allocator, modules);

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const entry = @import("generated_host_catalog");
    const Input = entry.Input;
    const Row = std.meta.Child(std.meta.Child(Input));
    const headers = try arena.allocator().alloc(Row, modules.len);
    const pointers = try arena.allocator().alloc(*const Row, modules.len);

    for (modules, headers, pointers) |module, *header, *pointer| {
        header.* = zx.columns.view(Row, module);
        pointer.* = header;
    }

    const input: Input = pointers;

    const output = entry.executeValue(arena.allocator(), input) catch |err| return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => @panic("invalid host metadata AST"),
    };

    if (!output.valid) return error.OutOfMemory;

    return @import("../printer/module.zig").render(allocator, arena.allocator(), std.meta.Child(entry.Output), output);
}
