const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");

pub fn lower(self: *Lower, symbol: ir.SymbolId, type_id: ir.TypeId) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("reference_seed.zig").lower(self, symbol, type_id);

    self.used[@backingInt(symbol)] = true;

    const generated = @import("generated_reference_access");
    const Input = std.meta.Child(generated.Input);
    const Output = std.meta.Child(generated.Output);
    const stack = self.stack_symbols.view(std.meta.Child(@FieldType(Input, "stack")));
    const state = self.state_symbols.view(std.meta.Child(@FieldType(Input, "state")));

    const input: Input = .{
        .name = self.names[@backingInt(symbol)],
        .symbol = @backingInt(symbol),
        .stack = &stack,
        .state = &state,
        .active = self.state_active,
        .public_value_output = self.public_value_output,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
    };

    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.FixedBufferAllocator.init(&buffer);
    const output = zx.columns.invoke(generated.executeValue, memory.allocator(), @as(*const Input, &input)) catch |err| return failure(err);

    if (!output.valid) return error.OutOfMemory;

    const nodes = zx.columns.view(std.meta.Child(@FieldType(Output, "nodes")), output.nodes);
    @import("../../node/import_rows.zig").appendBorrowed(self.allocator, &self.builder.nodes.expressions, &nodes) catch |err| return failure(err);

    const root: node.ExpressionId = @fromBackingInt(output.root);

    if (output.result == .Direct) return root;

    var body: std.ArrayList(node.Statement) = .empty;
    const converted = try @import("../state_value/conversion.zig").convert(self, &body, type_id, root, if (output.result == .ViewValue) .view_value else .value);

    return @import("../aggregate.zig").finish(self, &body, converted);
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow => error.OutOfMemory,
        else => unreachable,
    };
}
