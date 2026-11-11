const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Error = @import("../../artifact/model.zig").Error;

pub fn admit(allocator: std.mem.Allocator, exports: []const ir.Export, imports: []const ir.Export, count: usize) Error!void {
    if (exports.len == 0 and imports.len == 0) return;

    const generated = @import("generated_artifact_type_admission");
    const aliases = @import("../dependencies/host.zig").aliases;
    var arena = std.heap.ArenaAllocator.init(allocator);
    var buffer: [1024]u8 = undefined;
    var scratch = std.heap.BufferFirstAllocator.init(&buffer, arena.allocator());

    defer arena.deinit();

    const memory = scratch.allocator();
    const exported = try aliases(memory, exports);
    const imported = try aliases(memory, imports);

    const input: std.meta.Child(generated.Input) = .{
        .exports = &exported,
        .imports = &imported,
        .type_count = count,
    };

    const valid = zx.columns.invoke(generated.executeValue, memory, &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory => return error.OutOfMemory,
        else => return error.InvalidModule,
    };

    if (!valid) return error.InvalidModule;
}
