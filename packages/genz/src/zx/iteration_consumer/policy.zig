const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Lower = @import("../lower.zig");
const Consumer = @import("../iteration_consumer.zig").Consumer;
const generated = @import("genz_options").generated_analysis;
const entry = if (generated) @import("generated_consumer_decision") else struct {};
const Input = if (generated) std.meta.Child(entry.Input) else void;
pub const Phase = if (generated) @FieldType(Input, "phase") else enum { Initial, AfterSimd, Fallback };

const Action = if (generated) @typeInfo(@typeInfo(@TypeOf(entry.executeValue)).@"fn".return_type.?).error_union.payload else void;

pub fn decide(self: *const Lower, selected: Consumer, value: ir.ExprId, phase: Phase) Lower.Error!Action {
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), self.program.types);
    const cache = self.cache.view(std.meta.Child(@FieldType(Input, "cache")));

    const input: Input = .{
        .types = &types,
        .table = zx.columns.pointer(@FieldType(Input, "table"), &self.program.expressions),
        .cache = &cache,
        .symbol = @backingInt(selected.symbol),
        .value = @backingInt(value),
        .result = @backingInt(selected.result),
        .transaction = self.transaction(),
        .capture = self.capture != null,
        .phase = phase,
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    return zx.columns.invoke(entry.executeValue, buffered.allocator(), &input) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => @panic("invalid iteration consumer decision"),
    };
}

pub fn projection(program: *const ir.Program, result: ir.ExprId, symbol: ir.SymbolId) bool {
    const query = @import("generated_consumer_projection");
    const Arguments = std.meta.Child(query.Input);

    const input: Arguments = .{
        .table = zx.columns.pointer(@FieldType(Arguments, "table"), &program.expressions),
        .result = @backingInt(result),
        .symbol = @backingInt(symbol),
    };

    return invoke(query, &input);
}

pub fn independent(program: *const ir.Program, id: ir.ExprId, symbol: ir.SymbolId) bool {
    const query = @import("generated_consumer_independent");
    const Arguments = std.meta.Child(query.Input);

    const input: Arguments = .{
        .table = zx.columns.pointer(@FieldType(Arguments, "table"), &program.expressions),
        .id = @backingInt(id),
        .symbol = @backingInt(symbol),
    };

    return invoke(query, &input);
}

fn invoke(comptime query: type, input: anytype) bool {
    var fixed = std.heap.FixedBufferAllocator.init(&.{});

    return zx.columns.invoke(query.executeValue, fixed.allocator(), input) catch @panic("invalid iteration consumer projection");
}
