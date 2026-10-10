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
    const function = lowering.program.functions.at(@backingInt(call.function));
    const argument = lowering.program.expression(call.argument);

    if (!lowering.value_functions[@backingInt(call.function)]) return null;
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
    const function = lowering.program.functions.at(@backingInt(call.function));

    self.call = id;
    self.previous = lowering.buffer_calls.get(id);

    var columns = try Capacity.Group.init(lowering, body, "state_columns");

    for (lowering.buffer_functions[@backingInt(call.function)], 0..) |lane, index| {
        if (lane.rejection != null or !std.mem.eql(u32, lane.input, lane.output)) continue;
        if (lane.appends.len == 0 and lane.updates.len == 0 and lane.calls.len == 0) continue;
        if (self.previous) |slots| if (slots[index] != null) continue;

        var selected = function.output_type;

        for (lane.output) |part| selected = switch (lowering.program.typeOf(selected)) {
            .object => |items| items.at(part).type_id,
            .tuple => |items| items.at(part),
            else => unreachable,
        };

        const element = lowering.program.typeOf(selected).list;
        const capacity = try Capacity.member(lowering, &columns, lowering.types[@backingInt(element)]);

        try self.fields.append(lowering.allocator, .{ .path = lane.output, .element = element, .capacity = capacity });
        try @import("root.zig").bind(lowering, id, index, .{ .buffer = capacity.buffer, .started = capacity.started });
    }

    try columns.seal(lowering, body, .always);

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

            const symbol = scope.bindings.at(0).symbol orelse return null;
            const result = program.expression(scope.result).value;

            if (result != .reference or result.reference != symbol) return null;

            id = scope.bindings.at(0).value;
        },
        else => return null,
    };
}

pub fn finish(self: Self, body: *std.ArrayList(node.Statement), state: *const node.Expression, type_id: ir.TypeId) Lower.Error!void {
    const lowering = self.lowering;
    const batch = @import("../object_reduce/append/writeback/batch.zig");
    var changes: std.ArrayList(batch.Change) = .empty;
    var owned_group = try Capacity.Group.init(lowering, body, "state_owned");

    for (self.fields.items) |field| {
        const writeback = @import("../object_reduce/append/writeback.zig");
        const source = try writeback.project(lowering, type_id, state, field.path);
        const owned = try field.capacity.take(lowering, body, &owned_group, source, lowering.types[@backingInt(field.element)]);

        if (lowering.capture == null) {
            try changes.append(lowering.allocator, .{ .path = field.path, .value = owned, .started = field.capacity.started });

            continue;
        }

        try body.append(lowering.allocator, .{ .branch = .{
            .condition = field.capacity.started,
            .yes = try writeback.assignLayout(lowering, type_id, state, field.path, owned),
            .no = &.{},
        } });
    }

    try owned_group.seal(lowering, body, .on_error);
    try batch.apply(lowering, body, type_id, state, changes.items);
}

pub fn restore(self: *Self) void {
    const id = self.call orelse return;

    if (self.previous) |previous| self.lowering.buffer_calls.put(self.lowering.allocator, id, previous) catch unreachable else _ = self.lowering.buffer_calls.remove(id);

    self.call = null;
}
