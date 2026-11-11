const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../../node.zig");
const Lower = @import("../../lower.zig");
const Context = @import("root.zig");
const aggregate = @import("../../aggregate.zig");
const ownership = @import("../../state_value/ownership.zig");

pub fn maskBorrowed(self: *Context, lowering: *Lower, body: *std.ArrayList(node.Statement)) Lower.Error!void {
    const masked = try rebuild(self, lowering, body, .{
        .value = self.seed,
        .origin = @fromBackingInt(std.math.maxInt(u32)),
        .mask = true,
    }) orelse return;

    self.seed = try aggregate.bind(lowering, body, masked);
}

pub fn qualify(self: *const Context, lowering: *Lower, body: *std.ArrayList(node.Statement), id: ir.ExprId, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    const source = try aggregate.bind(lowering, body, value);

    return (try rebuild(self, lowering, body, .{ .value = source, .origin = id })).?;
}

const Request = struct {
    value: node.ExpressionId,
    origin: ir.ExprId,
    mask: bool = false,
};

fn rebuild(self: *const Context, lowering: *Lower, body: *std.ArrayList(node.Statement), request: Request) Lower.Error!?node.ExpressionId {
    var scratch = std.heap.ArenaAllocator.init(lowering.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const temporary = memory.allocator();
    const slots = try plan(self, lowering, temporary, request.mask);

    if (slots.len == 0) return null;

    const fields = lowering.program.typeOf(self.type_id).object;
    const items = try temporary.alloc(node.Field, fields.len + 1);

    for (items[0..fields.len], slots, 0..) |*item, slot, index| {
        const member = fields.at(index);
        const child = try lowering.field(request.value, member.name);

        const value = if (slot) |offset|
            try ownership.projected(lowering, body, request.origin, member.type_id, child, offset)
        else
            child;

        item.* = .{ .name = member.name, .value = value };
    }

    const origin = try @import("../../state_value/origin.zig").name(lowering, self.type_id);
    items[fields.len] = .{ .name = origin, .value = try lowering.field(request.value, origin) };

    const layout = if (request.mask) try lowering.layoutExpr(self.type_id) else self.layout;

    return try lowering.builder.expression(.{ .object = .{ .type_expr = layout, .fields = items } });
}

fn plan(self: *const Context, lowering: *const Lower, temporary: std.mem.Allocator, mask: bool) Lower.Error![]const ?u32 {
    const entry = @import("generated_loop_fields_ownership");
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
        .mask = mask,
    };

    return entry.executeIn(temporary, &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => unreachable,
    };
}
