const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../../node.zig");
const Lower = @import("../../lower.zig");
const aggregate = @import("../../aggregate.zig");
const list = @import("../../state_value/list.zig");
const emit = @import("../emit.zig");
const path = @import("path.zig");
const rules = @import("rules.zig");
const seed = @import("seed.zig");
const generated = @import("genz_options").generated_analysis;
const entry = @import("generated_projection_read");

const Plan = if (generated)
    @typeInfo(@typeInfo(@TypeOf(entry.executeValue)).@"fn".return_type.?).error_union.payload

else
    struct { result: seed.Result, dereference: bool };

const Result = @FieldType(Plan, "result");

pub fn field(self: *Lower, id: ir.TypeId, item: ir.Projection) Lower.Error!node.ExpressionId {
    const target_type = typeOf(self, item.target);
    const name = self.program.typeOf(target_type).object.at(item.index).name;

    return member(self, id, item.target, target_type, name, item.index);
}

pub fn tuple(self: *Lower, id: ir.TypeId, item: ir.Projection) Lower.Error!node.ExpressionId {
    if (try @import("../../collections.zig").projection(self, item.target, item.index)) |selected| return selected;

    const name = try std.fmt.allocPrint(self.allocator, "{d}", .{item.index});

    return member(self, id, item.target, typeOf(self, item.target), name, null);
}

pub fn index(self: *Lower, id: ir.TypeId, target: ir.ExprId, key: ir.ExprId) Lower.Error!node.ExpressionId {
    const raw = try path.nested(self, target);
    const source = raw orelse try list.expression(self, target);
    const indexed = try @import("../../intrinsics.zig").index(self, source, try self.expr(key));
    const target_type = typeOf(self, target);
    const read = plan(self, .{ .id = id, .target_type = target_type, .raw = raw != null });

    return finish(self, id, target_type, indexed, read.result);
}

fn member(self: *Lower, id: ir.TypeId, target: ir.ExprId, target_type: ir.TypeId, name: []const u8, position: ?u32) Lower.Error!node.ExpressionId {
    const raw = if (rules.raw(self, target_type, false)) try path.lower(self, target) else null;
    const source = raw orelse try path.anchor(self, target);

    const read = plan(self, .{
        .id = id,
        .target_type = target_type,
        .raw = raw != null,
        .field = .{ .target = target, .name = name, .position = position },
    });

    const value = if (read.dereference) try emit.borrowedField(self, source, name) else try self.field(source, name);

    return finish(self, id, target_type, value, read.result);
}

fn finish(self: *Lower, id: ir.TypeId, target_type: ir.TypeId, value: node.ExpressionId, result: Result) Lower.Error!node.ExpressionId {
    switch (result) {
        .Direct => return value,
        .Borrowed => return list.borrowed(self, id, value),
        .Value, .Element => {},
    }

    var body: std.ArrayList(node.Statement) = .empty;

    const converted = switch (result) {
        .Value => try @import("../../state_value/conversion.zig").convert(self, &body, id, try aggregate.bind(self, &body, value), .value),
        .Element => try @import("../../state_value/elements.zig").read(self, &body, target_type, value),
        else => unreachable,
    };

    return aggregate.finish(self, &body, converted);
}

const Field = struct { target: ir.ExprId, name: []const u8, position: ?u32 };
const Request = struct { id: ir.TypeId, target_type: ir.TypeId, raw: bool, field: ?Field = null };

fn plan(self: *const Lower, request: Request) Plan {
    if (!generated) return .{
        .result = seed.result(self, request.id, request.target_type, request.raw, request.field != null),
        .dereference = if (request.field) |selected| seed.borrowed(self, selected.target, selected.name) else false,
    };

    const Input = std.meta.Child(entry.Input);
    const Value = std.meta.Child(@FieldType(Input, "value"));
    const Borrow = std.meta.Child(std.meta.Child(@FieldType(Input, "projection")));
    const storage = rules.storage(std.meta.Child(@FieldType(Value, "storage")), self);

    const value: Value = .{
        .storage = &storage,
        .type_id = @backingInt(request.id),
        .target = @fromBackingInt(@intCast(@backingInt(self.state_plan.queries[@backingInt(request.target_type)]))),
        .result = @fromBackingInt(@intCast(@backingInt(self.state_plan.queries[@backingInt(request.id)]))),
        .active = self.state_active,
        .raw = request.raw,
        .field = request.field != null,
    };

    var borrowed: Borrow = undefined;

    const projection = if (self.loop_fields) |context| selected: {
        const selected = request.field orelse break :selected null;
        const position = selected.position orelse break :selected null;

        borrowed = .{
            .states = context.states,
            .borrowed = context.borrowed,
            .target = @backingInt(selected.target),
            .member = position,
        };

        break :selected &borrowed;
    } else null;

    const input: Input = .{ .value = &value, .projection = projection };
    var memory = std.heap.FixedBufferAllocator.init(&.{});

    return zx.columns.invoke(entry.executeValue, memory.allocator(), &input) catch unreachable;
}

fn typeOf(self: *const Lower, id: ir.ExprId) ir.TypeId {
    return @fromBackingInt(self.program.expressions.types[@backingInt(id)]);
}
