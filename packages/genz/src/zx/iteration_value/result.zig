const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const consumer = @import("../iteration_consumer.zig");
const planning = @import("result_plan.zig");

pub fn eligible(lowering: *Lower, selected: consumer.Consumer) Lower.Error!bool {
    if (!@import("genz_options").generated_analysis) return @import("result_seed.zig").eligible(lowering, selected);

    var scratch = std.heap.ArenaAllocator.init(lowering.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered_allocator = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const plan = try planning.analyze(buffered_allocator.allocator(), &lowering.program, &lowering.cache, selected, .Eligible, lowering.capture != null);

    return plan.valid;
}

pub fn candidate(allocator: std.mem.Allocator, program: ir.Program, selected: consumer.Consumer) Lower.Error!bool {
    if (!@import("genz_options").generated_analysis) return @import("result_seed.zig").candidate(allocator, program, selected);

    var scratch = std.heap.ArenaAllocator.init(allocator);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered_allocator = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const plan = try planning.analyze(buffered_allocator.allocator(), &program, null, selected, .Candidate, false);

    return plan.valid;
}

pub fn lower(lowering: *Lower, selected: consumer.Consumer, state: node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("result_seed.zig").lower(lowering, selected, state);

    var scratch = std.heap.ArenaAllocator.init(lowering.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered_allocator = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const plan = try planning.analyze(buffered_allocator.allocator(), &lowering.program, &lowering.cache, selected, .Plan, false);

    if (plan.primitive) return consumer.read(lowering, selected, selected.result, state);

    std.debug.assert(plan.valid);

    const projections = std.mem.bytesAsSlice(ir.ExprId, std.mem.sliceAsBytes(plan.projections));

    defer for (projections) |id| {
        _ = lowering.cache.remove(id);
    };

    for (projections) |id| try lowering.cache.put(lowering.allocator, id, try consumer.read(lowering, selected, id, state));

    return if (selected.layout) @import("../value_call/root.zig").expression(lowering, selected.result) else lowering.expr(selected.result);
}

pub fn buffered(context: *@import("root.zig"), body: *std.ArrayList(node.Statement), selected: consumer.Consumer, state: node.ExpressionId) Lower.Error!node.ExpressionId {
    const lowering = context.lowering;
    const projection = @import("projection.zig");

    if (!@import("genz_options").generated_analysis) return @import("result_seed.zig").buffered(context, body, selected, state);

    var scratch = std.heap.ArenaAllocator.init(lowering.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered_allocator = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();
    std.debug.assert(context.inline_lists);

    const temporary = buffered_allocator.allocator();
    const plan = try planning.analyze(temporary, &lowering.program, &lowering.cache, selected, .Buffered, false);

    if (plan.primitive) return projection.read(context, selected, selected.result, state);

    std.debug.assert(plan.valid);

    const projections = std.mem.bytesAsSlice(ir.ExprId, std.mem.sliceAsBytes(plan.projections));

    defer for (projections) |id| {
        _ = lowering.cache.remove(id);
    };

    const transferred = try temporary.alloc(node.ExpressionId, @intCast(plan.transfer_count));
    var count: usize = 0;

    for (plan.transfers, plan.reuses) |raw, reuse| {
        const id: ir.ExprId = @fromBackingInt(raw);
        const value = try projection.read(context, selected, id, state);

        const result = if (reuse) |slot| transferred[@intCast(slot)] else first: {
            const type_id = lowering.program.expression(id).type_id;
            const result = try @import("transfer.zig").lower(context, body, type_id, value);
            transferred[count] = context.transfers.at(context.transfers.len() - 1).value;
            count += 1;

            break :first result;
        };

        try lowering.cache.put(lowering.allocator, id, result);
    }

    for (plan.reads) |raw| {
        const id: ir.ExprId = @fromBackingInt(raw);

        try lowering.cache.put(lowering.allocator, id, try projection.read(context, selected, id, state));
    }

    return if (selected.layout) @import("../value_call/root.zig").expression(lowering, selected.result) else lowering.expr(selected.result);
}
