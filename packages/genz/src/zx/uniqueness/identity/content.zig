const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const generated = @import("generated_uniqueness_content_identity");
const Input = std.meta.Child(generated.Input);

pub fn build(symbols: ir.SymbolTable, expressions: ir.ExpressionTable, block: ir.Block, input_type: ir.TypeId, output_type: ir.TypeId) [32]u8 {
    var hash: zx.Sha256 = undefined;
    const borrowed_symbols = zx.columns.borrow(std.meta.Child(@FieldType(Input, "symbols")), &symbols);
    const borrowed_expressions = zx.columns.borrow(std.meta.Child(@FieldType(Input, "expressions")), &expressions);
    const control = zx.columns.borrow(std.meta.Child(@FieldType(Input, "control")), block.control);

    const input: Input = .{
        .hash = @ptrCast(&hash),
        .symbols = &borrowed_symbols,
        .expressions = &borrowed_expressions,
        .control = &control,
        .first = block.first,
        .count = block.len,
        .input_type = @backingInt(input_type),
        .output_type = @backingInt(output_type),
    };

    var memory = std.heap.FixedBufferAllocator.init(&.{});

    generated.executeIn(memory.allocator(), &input) catch |err| std.debug.panic("content identity failed: {s}", .{@errorName(err)});

    return hash.finalResult();
}
