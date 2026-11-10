const std = @import("std");
const zx = @import("zx");

pub fn render(allocator: std.mem.Allocator, stateful: bool, output: @import("../json_output.zig").Output) std.mem.Allocator.Error![]u8 {
    if (comptime !@import("genz_options").generated_analysis) return @import("seed/root.zig").render(allocator, stateful, output);

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const entry = @import("generated_wasm_host");
    const Input = std.meta.Child(entry.Input);
    const table = zx.ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), output.types);
    const input: Input = .{ .stateful = stateful, .types = &table, .output_type = @backingInt(output.id) };
    const result = zx.columns.invoke(entry.executeValue, arena.allocator(), &input) catch |err| return failure(err);

    if (!result.valid) return error.OutOfMemory;

    return @import("../../printer/module.zig").render(allocator, arena.allocator(), std.meta.Child(@FieldType(std.meta.Child(entry.Output), "module")), result.module);
}

fn failure(err: anyerror) std.mem.Allocator.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => @panic("invalid WASM host AST"),
    };
}
