const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../../node.zig");
const Lower = @import("../../lower.zig");
const Context = @import("root.zig");
const aggregate = @import("../../aggregate.zig");
const ownership = @import("../../state_value/ownership.zig");
const projection = @import("projection.zig");
const entry = @import("generated_loop_fields_ownership");

pub fn maskBorrowed(self: *Context, lowering: *Lower, body: *std.ArrayList(node.Statement)) Lower.Error!void {
    const masked = try rebuild(self, lowering, body, .{ .value = self.seed }) orelse return;

    self.seed = try aggregate.bind(lowering, body, masked);
}

pub fn qualify(self: *const Context, lowering: *Lower, body: *std.ArrayList(node.Statement), id: ir.ExprId, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    const source = try aggregate.bind(lowering, body, value);

    return (try rebuild(self, lowering, body, .{ .value = source, .origin = id, .layout = self.layout })).?;
}

const Request = struct {
    value: node.ExpressionId,
    origin: ?ir.ExprId = null,
    layout: ?node.ExpressionId = null,
};

fn rebuild(self: *const Context, lowering: *Lower, body: *std.ArrayList(node.Statement), request: Request) Lower.Error!?node.ExpressionId {
    const Input = std.meta.Child(entry.Input);
    const Facts = std.meta.Child(@FieldType(Input, "facts"));
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Facts, "types")), lowering.program.types);

    const facts: Facts = .{
        .types = &types,
        .selected = lowering.state_plan.selected,
        .counts = lowering.slot_counts,
        .first = lowering.plan.slot_first,
        .transfers = lowering.plan.transfers,
    };

    const input: Input = .{
        .facts = &facts,
        .type_id = @backingInt(self.type_id),
        .borrowed = self.borrowed,
        .origin = if (request.origin) |origin| @backingInt(origin) else null,
        .value = @backingInt(request.value),
        .expression_base = @intCast(lowering.builder.nodes.expressions.tags.items.len),
    };

    var scratch = std.heap.ArenaAllocator.init(lowering.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const temporary = memory.allocator();
    const planned = (entry.executeIn(temporary, &input) catch |err| return failure(err)) orelse return null;

    if (!planned.valid) return error.OutOfMemory;

    @import("../../../node/import_rows.zig").appendBorrowed(lowering.allocator, &lowering.builder.nodes.expressions, planned.expressions) catch |err| return failure(err);

    const fields = lowering.program.typeOf(self.type_id).object;
    const values = try temporary.alloc(u32, planned.values.len);
    const origin: ir.ExprId = @fromBackingInt(planned.origin);

    for (values, planned.values, planned.slots, 0..) |*value, raw, slot, index| {
        const child: node.ExpressionId = @fromBackingInt(raw);

        value.* = if (slot) |offset|
            @backingInt(try ownership.projected(lowering, body, origin, fields.at(index).type_id, child, offset))

        else
            raw;
    }

    const layout = request.layout orelse try lowering.layoutExpr(self.type_id);

    return try projection.rebuild(self, lowering, request.value, layout, values);
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => unreachable,
    };
}
