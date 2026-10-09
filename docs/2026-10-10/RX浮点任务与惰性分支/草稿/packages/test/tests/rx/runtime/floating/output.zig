const std = @import("std");
const compiler = @import("compiler");
const Output = @import("library_output").Output;

pub fn emit(init: std.process.Init, program: compiler.ir.Program, directory: []const u8) !void {
    const allocator = init.arena.allocator();

    if (try compiler.validateIr(allocator, program) != null) return error.InvalidIr;

    const bundle = try compiler.zig.emitBundle(allocator, program);

    defer bundle.deinit(allocator);

    var output = Output{ .io = init.io, .allocator = allocator, .directory = directory };

    try output.module("program", bundle.source, &.{});
    try output.file("types.zig", bundle.types);
    try output.file("native.json", "[]\n");
    try output.file("modules.json", try std.json.Stringify.valueAlloc(allocator, output.modules.items, .{}));
}
