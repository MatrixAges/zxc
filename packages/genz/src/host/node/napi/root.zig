const std = @import("std");
const zx = @import("zx");
pub const Error = std.mem.Allocator.Error || error{UnsupportedNodeType};

pub fn render(allocator: std.mem.Allocator, types: zx.ir.TypeTable, input_id: zx.ir.TypeId, output_id: zx.ir.TypeId) Error![]u8 {
    if (comptime !@import("genz_options").generated_analysis) return @import("seed/root.zig").render(allocator, types, input_id, output_id);

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const entry = @import("generated_node_napi");
    const Input = std.meta.Child(entry.Input);
    const Bases = std.meta.Child(@FieldType(Input, "bases"));
    const table = zx.ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), types);
    const bases: Bases = .{ .capture = null, .expression_base = 0, .statement_base = 0, .field_base = 0, .serial = 0 };
    const input: Input = .{ .types = &table, .input = @backingInt(input_id), .output = @backingInt(output_id), .bases = &bases };
    const output = zx.columns.invoke(entry.executeValue, arena.allocator(), &input) catch |err| return failure(err);

    if (!output.supported) return error.UnsupportedNodeType;
    if (!output.valid) return error.OutOfMemory;

    return @import("../../../printer/module.zig").render(allocator, arena.allocator(), std.meta.Child(@FieldType(std.meta.Child(entry.Output), "module")), output.module);
}

fn failure(err: anyerror) std.mem.Allocator.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => @panic("invalid N-API module AST"),
    };
}
