const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const Capacity = @import("../iteration_buffer/capacity.zig");
const Builder = @import("../object_reduce/append/builder.zig");
const Self = @This();
const Field = struct { path: []const u32, element: ir.TypeId, capacity: Capacity };

lowering: *Lower,
fields: std.ArrayList(Field) = .empty,
call: ?ir.ExprId = null,
previous: ?[]const ?Builder = null,

pub fn candidate(lowering: *Lower, iteration: ir.Iteration) Lower.Error!?ir.ExprId {
    const id = forwardedCall(lowering.program, iteration.body) orelse return null;
    const expression = lowering.program.expression(id);
    const call = expression.value.call;
    const function = lowering.program.functions[@backingInt(call.function)];
    const argument = lowering.program.expression(call.argument);

    if (!lowering.pure_functions[@backingInt(call.function)]) return null;
    if (lowering.program.typeOf(function.output_type) != .object) return null;
    if (function.input_type != function.output_type or argument.value != .reference or argument.value.reference != iteration.parameter) return null;
    if (!try @import("../iteration_layout.zig").condition(lowering.allocator, lowering.program, iteration, lowering.pure_functions)) return null;

    return id;
}

pub fn init(lowering: *Lower, selected_call: ?ir.ExprId, body: *std.ArrayList(node.Statement)) Lower.Error!Self {
    var self = Self{ .lowering = lowering };

    errdefer self.restore();

    const id = selected_call orelse return self;
    const call = lowering.program.expression(id).value.call;
    const function = lowering.program.functions[@backingInt(call.function)];

    self.call = id;
    self.previous = lowering.buffer_calls.get(id);

    for (lowering.buffer_functions[@backingInt(call.function)], 0..) |lane, index| {
        if (lane.rejection != null or !std.mem.eql(u32, lane.input, lane.output)) continue;
        if (lane.appends.len == 0 and lane.calls.len == 0) continue;
        if (self.previous) |slots| if (slots[index] != null) continue;

        var selected = function.output_type;

        for (lane.output) |part| selected = switch (lowering.program.typeOf(selected)) {
            .object => |items| items.at(part).type_id,
            .tuple => |items| items.at(part),
            else => unreachable,
        };

        const element = lowering.program.typeOf(selected).list;
        const capacity = try Capacity.create(lowering, body, lowering.types[@backingInt(element)]);

        try self.fields.append(lowering.allocator, .{ .path = lane.output, .element = element, .capacity = capacity });
        try @import("root.zig").bind(lowering, id, index, .{ .buffer = capacity.buffer, .started = capacity.started });
    }

    return self;
}

fn forwardedCall(program: ir.Program, root: ir.ExprId) ?ir.ExprId {
    var id = root;

    while (true) switch (program.expression(id).value) {
        .call => return id,
        .scope => |scope| {
            if (scope.bindings.len == 0) {
                id = scope.result;

                continue;
            }

            if (scope.bindings.len != 1) return null;

            const symbol = scope.bindings[0].symbol orelse return null;
            const result = program.expression(scope.result).value;

            if (result != .reference or result.reference != symbol) return null;

            id = scope.bindings[0].value;
        },
        else => return null,
    };
}

pub fn finish(self: Self, body: *std.ArrayList(node.Statement), state: *const node.Expression, type_id: ir.TypeId) Lower.Error!void {
    const lowering = self.lowering;

    for (self.fields.items) |field| {
        const source = try @import("../object_reduce/append/writeback.zig").project(lowering, type_id, state, field.path);
        const owned = try field.capacity.take(lowering, body, source, lowering.types[@backingInt(field.element)]);
        const updated = try @import("../object_reduce/append/writeback.zig").replaceLayout(lowering, type_id, state, field.path, owned);

        try body.append(lowering.allocator, .{ .branch = .{
            .condition = field.capacity.started,
            .yes = try lowering.allocator.dupe(node.Statement, &.{.{ .assignment = .{ .target = state, .value = updated } }}),
            .no = &.{},
        } });
    }
}

pub fn restore(self: *Self) void {
    const id = self.call orelse return;

    if (self.previous) |previous| self.lowering.buffer_calls.put(self.lowering.allocator, id, previous) catch unreachable else _ = self.lowering.buffer_calls.remove(id);

    self.call = null;
}
